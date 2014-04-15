class DummyPerforce
  def method_missing(m, *args)
    "You called the '#{m}' method with arguments: #{args}"
  end
end