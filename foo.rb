workflow do
  use :foo

  map :foo, :bar do |i|
    i * i
  end
end
