class ReactGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)
    argument :controller_name, type: :string, default: false
    argument :action_name, type: :string, default: false
    attr_accessor :controller_path
  
    def set_up
      @controller_path = "app/controllers/#{controller_name}_controller.rb"
      @jsx_path = "app/javascript/components/#{controller_name}/#{action_name.capitalize}.jsx"
    end
  
    def generate_controller
      unless File.exists?(@controller_path)
        generate "controller", "#{controller_name} #{action_name} --skip-template-engine"
      end
    end
  
    def generate_action
      if "#{controller_name.classify}Controller".constantize.methods.include?(action_name)
        ap "You should add 'to_react' with props into your already existing #{action_name} action of #{controller_name} controller."
      else
        inject_into_file @controller_path, after: "def #{action_name}" do
  <<-RUBY
      \n
      data = {
        helloReact: "Hello React from #{@jsx_path}"
      }
    
      to_react(data)
  RUBY
        end
      end
    end
  
    def generate_react
      template 'page.js.erb', @jsx_path
    end
  
  end
  