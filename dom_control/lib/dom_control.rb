module DomControl
  autoload :Middleware, 'dom_control/middleware'
  autoload :Processor,  'dom_control/processor'
  autoload :Config,     'dom_control/config'

  def self.config
    @config ||= DomControl::Config.new
  end

  def self.configure
    yield config
  end


  def self.resource_id(object)
    return object      if object.is_a?(String)
    return object.to_s if object.is_a?(Symbol)

    if object.is_a?(ActiveRecord::Base)
      return ActionView::RecordIdentifier.dom_id(object) if config.serialize_resource_as == :dom_id
      return object.to_gid.to_s                          if config.serialize_resource_as == :gid
      return object.to_param                             if config.serialize_resource_as == :param
    end

    object.to_s
  end
end

if defined?(Rails)
  require 'dom_control/rails'
end
