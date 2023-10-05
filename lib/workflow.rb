require_relative 'dsl'
require_relative 'runner'
require_relative 'plugin'

module Workflow
  def self.workflow(file: nil, &block)
    workflow = if file
      content = File.read file
      workflow = Dsl.new
      workflow.instance_eval content
      workflow
    else
      Dsl.new(&block)
    end
    runner_class = Class.new Runner
    Workflow::Plugin.apply_runner_plugins runner_class, workflow.uses
    runner = runner_class.new(workflow)
  end
end
