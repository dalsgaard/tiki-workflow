Workflow.plugin :foo do
  depends :baz

  dsl do
    def foo
      let :foo do
        [1, 3, 5, 7, 9]
      end
    end
  end

  runner do
    def output(content)
      puts content
    end
  end

  pre do
    foo
  end

  post do
    each :bar do |item|
      output item + baz
    end
  end
end
