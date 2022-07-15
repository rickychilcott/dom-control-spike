module DomControl::Rails::ControllerExtensions
  extend ActiveSupport::Concern


  class_methods do
    def dom_control_check(&block)
      before_action do
        request.env['dom_control.check'] = ->(key, subject) do
          instance_exec(key, subject, &block)
        end
      end
    end
  end
end