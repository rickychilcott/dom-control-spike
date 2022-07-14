class DomControl::Middleware
  def initialize(app)
    @app = app
  end

  attr_reader :app

  def call(env = {})
    response = app.call(env)
    DomControl::Processor.process_response(response)
  end
end