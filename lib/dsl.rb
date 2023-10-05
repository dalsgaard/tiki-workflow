require_relative 'item'
require_relative 'plugin'

module Workflow
  class Dsl
    attr_reader :uses, :plugins

    def initialize(&block)
      @uses = []
      @plugins = []
      @items = []
      @pres = []
      @posts = []
      instance_eval(&block) if block
    end

    def use(name)
      @uses << name
      Plugin.apply_dsl_plugin self, name
    end

    def let(name, value = nil, &block)
      source_items << LetItem.new(name, value = nil, &block)
    end

    def each(source, &block)
      source_items << EachItem.new(source, &block)
    end

    def map(source, destination, &block)
      source_items << MapItem.new(source, destination, &block)
    end

    def map!(name, &block)
      source_items << MapItem.new(name, name, &block)
    end

    def pre(&block)
      @source_mode = :pre
      instance_eval &block
      @source_mode = nil
    end

    def post(&block)
      @source_mode = :post
      instance_eval &block
      @source_mode = nil
    end

    def workflow(name = nil, &block)
      instance_eval &block
    end

    def items()
      @pres + @items + @posts
    end

    def add_pres(*blocks)
      blocks.flatten.each do |block|
        pre &block
      end
    end

    def add_posts(*blocks)
      blocks.flatten.each do |block|
        post &block
      end
    end

    def add_plugin(name)
      @plugins << name
    end

    def plugin?(name)
      @plugins.include? name
    end

    private

    def source_items()
      case @source_mode
      when :pre then @pres
      when :post then @posts
      else @items
      end
    end
  end
end
