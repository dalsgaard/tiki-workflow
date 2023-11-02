workflow do
  plugin :foo

  let :baz, 5

  map :foo, :bar do |i|
    i * i
  end
end
