module Workflow
  module Plugin
    extend self

    @plugins = {}

    def add(plugin)
      @plugins[plugin.name] = plugin
    end

    def apply_dsl_plugin(dsl, name)
      unless dsl.plugin?(name)
        plugin = @plugins[name]
        plugin.uses.each do |dep|
          apply_dsl_plugin(dsl, dep)
        end
        dsl.extend plugin.dsl if plugin.dsl?
        dsl.add_pres plugin.pres
        dsl.add_posts plugin.posts
        dsl.add_plugin name
      end
    end
    
    def apply_runner_plugins(runner_class, *names)
      names.flatten.each do |name|
        plugin = @plugins[name]
        runner_class.prepend plugin.runner if plugin.runner?
      end
    end

    class Plugin
      attr_reader :pres, :posts, :uses

      def initialize(name = nil)
        @name = name
        @uses = []
        @pres = []
        @posts = []
      end

      def name(name = nil)
        @name = name if name
        @name
      end

      def use(*plugins)
        @uses += plugins
      end

      def dsl(&block)
        if block
          @dsl = Module.new
          @dsl.module_eval &block
        end
        @dsl
      end

      def runner(&block)
        if block
          @runner = Module.new
          @runner.module_eval &block
        end
        @runner
      end

      def dsl?()
        !!@dsl
      end

      def runner?()
        !!@runner
      end

      def pre(&block)
        @pres << block
      end

      def post(&block)
        @posts << block
      end
    end
  end

  def self.plugin(name = nil, &block)
    plugin = Plugin::Plugin.new(name)
    plugin.instance_eval &block
    Plugin.add plugin
  end
end
