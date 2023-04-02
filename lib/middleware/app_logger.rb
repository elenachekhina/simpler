require 'logger'

class AppLogger
  def initialize(app, **options)
    @logger = Logger.new(Simpler.root.join('log/app.log'))
    @app = app
  end

  def call(env)
    @response = @app.call(env)
    @logger.info(request(env))
    @logger.info(handler(env))
    @logger.info(parameters(env))
    @logger.info(response(env))

    @response
  end

  private

  def request(env)
    "Request: #{env['REQUEST_METHOD']} #{env['PATH_INFO']}"
  end

  def handler(env)
    "Handler: #{env['simpler.controller'].class.name}##{env['simpler.action']}"
  end

  def parameters(env)
    "Parameters: #{env['simpler.params']}"
  end

  def response(env)
    "Response: #{@response[0]} [#{@response[1]['Content-Type']}] #{env['simpler.template_path']}"
  end

end
