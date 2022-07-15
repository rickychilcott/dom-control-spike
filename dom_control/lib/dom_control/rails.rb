module DomControl::Rails
  autoload :Engine,               'dom_control/rails/engine'
  autoload :ControllerExtensions, 'dom_control/rails/controller_extensions'
end

DomControl::Rails::Engine # force autoload