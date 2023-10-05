require_relative 'item'

module Workflow
  class Runner
    def initialize(workflow)
      workflow.items.each do |item|
        case item
        when LetItem
          value = instance_eval(&item.block)
          instance_variable_set "@#{item.name}", value
          define_singleton_method item.name do
            instance_variable_get("@#{item.name}")
          end
        when EachItem
          source = instance_variable_get("@#{item.source}")
          source.each do |value|
            instance_exec value, &item.block
          end
        when MapItem
          source = instance_variable_get("@#{item.source}")
          values = source.map do |value|
            instance_exec value, &item.block
          end
          instance_variable_set "@#{item.destination}", values
          define_singleton_method item.destination do
            instance_variable_get("@#{item.destination}")
          end
        end
      end
    end
  end
end
