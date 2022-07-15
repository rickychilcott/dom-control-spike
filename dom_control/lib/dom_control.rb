module DomControl
  autoload :Middleware, 'dom_control/middleware'
  autoload :Processor,  'dom_control/processor'
  autoload :Config,     'dom_control/config'

  if defined?(Rails)
    require 'dom_control/engine'
  end
endif defined?(Rails)
if defined?(Rails)
  require 'dom_control/rails'
end
