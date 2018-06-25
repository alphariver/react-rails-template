require "fileutils"
require "shellwords"
require "tmpdir"

RAILS_REQUIREMENT = "~> 5.2.0".freeze

def apply_template!
    assert_minimum_rails_version
    assert_postgresql
    add_template_repository_to_source_path

    template "Gemfile.tt", force: true

    if apply_capistrano?
        copy_file "Capfile"
    end

    if apply_devise?
        insert_into_file 'Gemfile', "gem 'devise'\n", after: /'fast_jsonapi'\n/
        insert_into_file 'Gemfile', "gem 'devise-i18n'\n", after: /'fast_jsonapi'\n/
    end

    copy_file "gitignore", ".gitignore", force: true
    template "ruby-version.tt", ".ruby-version", force: true

    apply 'app/template.rb'
    apply 'config/template.rb'

    run  "gem install bundler --no-document --conservative"
    run  "bundle install"
    run  "bin/yarn install" if File.exist?("yarn.lock")

    setup_gems
    setup_npm_packages
    setup_react

    run "bundle binstubs bundler --force"
    run 'rails db:drop db:create db:migrate'

    setup_git
end

def apply_capistrano?
    return @apply_capistrano if defined?(@apply_capistrano)
    @apply_capistrano = \
      ask_with_default("Use Capistrano for deployment?", :blue, "no") \
      =~ /^y(es)?/i
end

def apply_devise?
    return @apply_devise if defined?(@apply_devise)
    @apply_devise = \
      ask_with_default("Use Devise for user authentication?", :blue, "no") \
      =~ /^y(es)?/i
end

def capistrano_app_name
    app_name.gsub(/[^a-zA-Z0-9_]/, "_")
end

def production_hostname
    @production_hostname ||= ask_with_default("Production hostname?", :blue, "127.0.0.1")
end

def app_domain
    @app_domain ||= ask_with_default("What is the app domain for this project?", :blue, "example.com")
end

def ubuntu_user
    @ubuntu_user ||= ask_with_default("What is the name of the ubuntu user?", :blue, "ubuntu")
end

def git_repo_url
    @git_repo_url ||= ask_with_default("What is the git remote URL for this project?", :blue, "skip")
end

def git_repo_specified?
    git_repo_url != "skip" && !git_repo_url.strip.empty?
end

def preexisting_git_repo?
    @preexisting_git_repo ||= (File.exist?(".git") || :nope)
    @preexisting_git_repo == true
end

def any_local_git_commits?
    system("git log &> /dev/null")
end

def ask_with_default(question, color, default)
    return default unless $stdin.tty?
    question = (question.split("?") << " [#{default}]?").join
    answer = ask(question, color)
    answer.to_s.strip.empty? ? default : answer
end

def setup_npm_packages
    run 'yarn add axios bootstrap reactstrap json-api-normalizer'
end
  
def setup_gems
    setup_bullet
    setup_erd
    setup_devise if apply_devise?
end

def setup_bullet
    inject_into_file 'config/environments/development.rb', before: /^end/ do
      <<-RUBY
        Bullet.enable = true
        Bullet.alert = true
      RUBY
    end
end

def setup_react
    rails_command "webpacker:install"
    rails_command "webpacker:install:react"
    generate "react:install"
    setup_demo
end

def setup_demo
    generate "controller", "home index"
    inject_into_file 'app/controllers/home_controller.rb', after: "def index" do
        "\n    to_react"
    end
    generate "react:component", "home/index"
    inject_into_file 'app/javascript/components/home/Index.js', after: "<React.Fragment>" do
        "\n        <h1>Hello React, from app/javascript/components/home/Index.js</h1>"
    end
end

def setup_erd
    generate "erd:install"
    append_to_file '.gitignore', 'erd.pdf'
end

def setup_devise
    generate "devise:install"
    generate "devise:i18n:views"
    insert_into_file 'config/initializers/devise.rb', "  config.secret_key = Rails.application.credentials.secret_key_base\n", before: /^end/
    generate "devise", "User"
    insert_into_file 'app/controllers/application_controller.rb', "  before_action :authenticate_user!\n", after: /exception\n/
end

def setup_git
    git :init unless preexisting_git_repo?

    unless any_local_git_commits?
        git add: "-A ."
        git commit: "-n -m 'Project initalized'"
        if git_repo_specified?
          git remote: "add origin #{git_repo_url.shellescape}"
          git remote: "add upstream #{git_repo_url.shellescape}"
          git push: "-u origin --all"
        end
    end
end

def assert_minimum_rails_version
    requirement = Gem::Requirement.new(RAILS_REQUIREMENT)
    rails_version = Gem::Version.new(Rails::VERSION::STRING)
    return if requirement.satisfied_by?(rails_version)
  
    prompt = "This template requires Rails #{RAILS_REQUIREMENT}. "\
             "You are using #{rails_version}. Continue anyway?"
    exit 1 if no?(prompt)
end

def assert_postgresql
    return if IO.read("Gemfile") =~ /^\s*gem ['"]pg['"]/
    fail Rails::Generators::Error,
         "This template requires PostgreSQL, "\
         "but the pg gem isn’t present in your Gemfile."
end

def add_template_repository_to_source_path
    if __FILE__ =~ %r{\Ahttps?://}
      source_paths.unshift(tempdir = Dir.mktmpdir("rails-template-"))
      at_exit { FileUtils.remove_entry(tempdir) }
      git :clone => [
        "--quiet",
        "https://github.com/astrocket/react-rails-template",
        tempdir
      ].map(&:shellescape).join(" ")
    else
      source_paths.unshift(File.dirname(__FILE__))
    end
end

def gemfile_requirement(name)
    @original_gemfile ||= IO.read("Gemfile")
    req = @original_gemfile[/gem\s+['"]#{name}['"]\s*(,[><~= \t\d\.\w'"]*)?.*$/, 1]
    req && req.gsub("'", %(")).strip.sub(/^,\s*"/, ', "')
end

def run_bundle 
    run 'bin/spring stop'
    p "Template setted." 
    return
end

apply_template!