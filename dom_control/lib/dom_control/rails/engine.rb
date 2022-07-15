class DomControl::Rails::Engine < ::Rails::Engine
  initializer "dom_control.rack_middleware" do |app|
    app.middleware.use DomControl::Middleware
  end

  initializer "dom_control.extensions" do |app|
    # TODO: couldn't seem to get ActiveSupport.on_load working, so jamming things in...
    # ActiveSupport.on_load(:action_controller)

    ActionController::Base.send(:include, DomControl::Rails::ControllerExtensions)
  end

  initializer "dom_control.logging" do |app|
    ActiveSupport::Notifications.subscribe "dom_control.process_html" do |name, started, finished, unique_id, data|
      duration = finished - started
      puts "#{name} -> #{duration} seconds"
    end
  end
end