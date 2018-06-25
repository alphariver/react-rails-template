class ApplicationController < ActionController::Base
  
    def to_react(data = nil, component = "#{controller_name}/#{action_name.classify}")
          props = {data: data, header: {headers: {'X-CSRF-Token': form_authenticity_token}}}
          props = props.merge!(
              {currentUser: current_user || User.new
              }) if (defined? current_user) && current_user.present?
  
          render component: component, props: props
    end

end