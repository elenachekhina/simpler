module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :params

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
      end

      def match?(method, path)
        @method == method && (path =~ Regexp.new(@path.gsub(/:(\w+)/, '\w+'))) == 0
      end

      def set_params(path)
        @params = path.match(Regexp.new(@path.gsub(/:(\w+)/, '(?<\1>.+)'))).named_captures.transform_keys!(&:to_sym)
      end

    end
  end
end
