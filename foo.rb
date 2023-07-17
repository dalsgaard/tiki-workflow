class Foo
  def foo
    5
  end
end

bar = Foo.new
res = bar.instance_eval do
  foo
end
puts res + 3
