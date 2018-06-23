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

apply_template!