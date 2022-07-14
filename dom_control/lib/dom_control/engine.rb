class DomControl::Engine < ::Rails::Engine
  initializer "dom_control.rack_middleware" do |app|
    app.middleware.use DomControl::Middleware
  end
end
