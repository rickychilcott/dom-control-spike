module DomControl::Rails
  autoload :Engine,               'dom_control/rails/engine'
  autoload :ControllerExtensions, 'dom_control/rails/controller_extensions'
  autoload :ViewHelpers,          'dom_control/rails/view_helpers'
end

DomControl::Rails::Engine # force autoload