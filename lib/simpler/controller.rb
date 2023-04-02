require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action, params)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action
      @request.env['simpler.params'] = params

      set_default_headers
      send(action)
      write_response

      @response.finish
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    def set_header(key, value)
      @response[key] = value
    end

    def set_status(code)
      @response.status = code
    end

    def set_render_params(**options)
      set_header('Content-Type', options[:content_type]) if options.has_key? :content_type
      set_status(options[:status]) if options.has_key? :status
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def params
      @request.params.merge(@request.env['simpler.params'])
    end

    def render(*args, **options)
      set_render_params(**options)
      @request.env['simpler.template'] = if args.length.zero?
                                           options.except(:content_type, :status)
                                         else
                                           { erb: args }
                                         end
    end

  end
end
