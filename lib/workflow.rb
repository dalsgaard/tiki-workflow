class Runner
  def initialize(workflow)
    workflow.lets.each do |name, value|
      value = instance_eval(&value) if value.instance_of?(Proc)
      instance_variable_set "@#{name}", value
      define_singleton_method name do
        instance_variable_get("@#{name}")
      end
    end

    workflow.runs.each do |type, data|
      case type
      when :each
        list, block = data
        instance_variable_get("@#{list}").each do |item|
          instance_exec item, &block
        end
      end
    end
  end
end

class Workflow
  attr_reader :lets, :runs

  def initialize(&block)
    @lets = []
    @runs = []
    instance_eval(&block)
  end

  def let(name, value = nil, &block)
    @lets << [name, block || value]
  end

  def each(list, &block)
    @runs << [:each, [list, block]]
  end

  def map(source, destination, &block)
    @runs << [:map, [source, destination, block]]
  end
end

def workflow(&block)
  workflow = Workflow.new(&block)
  runner = Runner.new(workflow)
end

workflow do
  let :foo do
    [1, 3, 5, 7, 9]
  end

  let :bar do
    foo.map { |i| i * i }
  end

  let :baz do
    13
  end

  each :bar do |item|
    puts item + baz
  end
end
