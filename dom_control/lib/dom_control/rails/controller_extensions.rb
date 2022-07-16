module DomControl::Rails::ControllerExtensions
  extend ActiveSupport::Concern

  included do
    helper DomControl::Rails::ViewHelpers
  end

  class_methods do
    def dom_control_check_multi(&block)
      before_action do
        request.env['dom_control.check_multi'] = ->(checks) do
          instance_exec(checks, &block)
        end
      end
    end

    def dom_control_check(&block)
      before_action do
        request.env['dom_control.check'] = ->(check) do
          instance_exec(check, &block)
        end
      end
    end
  end
end