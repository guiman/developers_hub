class NullDeveloper
  def method_missing(*args, &block)
    nil
  end
end
