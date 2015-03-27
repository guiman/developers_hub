class NullDeveloper
  def method_missing(*args, &block)
    self
  end
end
