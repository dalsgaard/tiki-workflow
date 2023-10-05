module Workflow
  class Item
    attr_reader :id, :block

    def initialize(id = nil)
      @id = id
    end
  end

  class LetItem < Item
    attr_reader :name

    def initialize(name, value = nil, id: nil, &block)
      super(id)
      @name = name
      @block = block || -> { value }
    end
  end

  class EachItem < Item
    attr_reader :source

    def initialize(source, id: nil, &block)
      super id
      @source = source
      @block = block
    end
  end

  class MapItem < Item
    attr_reader :source, :destination

    def initialize(source, destination = nil, id: nil, &block)
      super id
      @source = source
      @destination = destination || source
      @block = block
    end
  end
end
