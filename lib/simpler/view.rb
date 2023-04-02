require 'erb'
require 'json'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze
    VIEW_TYPES = %i[erb plain json inline].freeze

    def initialize(env)
      @env = env
      @view_type = @env['simpler.template'].nil? ? :erb : set_view_type
      @view_body = @env['simpler.template'].nil? ? nil : @env['simpler.template'][@view_type]
    end

    def set_view_type
      available_types = @env['simpler.template'].keys.intersection(VIEW_TYPES)
      available_types.nil? ? :erb : available_types[0]
    end

    def render(binding)
      @binding = binding

      send @view_type
    end

    private

    def erb
      template = File.read(template_path)
      ERB.new(template).result(@binding)
    end

    def plain
      @view_body
    end

    def json
      @view_body.to_json
    end

    def inline
      ERB.new(@env['simpler.template'][@view_type]).result(@binding)
    end

    def controller
      @env['simpler.controller']
    end

    def action
      @env['simpler.action']
    end

    def template
      @view_body
    end

    def template_path
      @env['simpler.template_path'] = path = template || [controller.name, action].join('/')

      Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
    end

  end
end
