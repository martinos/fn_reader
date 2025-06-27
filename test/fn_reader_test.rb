require "test_helper"

module MyFns
  fn_reader :id
  @@id = ->a { a }
end

module TestModuleOne
  fn_reader :multiply
  @@multiply = ->a { a * 3 }
end

module TestModuleTwo
  fn_reader :add_five
  @@add_five = ->a { a + 5 }
end

module TestModuleThree
  fn_reader :double
  @@double = ->a { a * 2 }
end

class FnReaderTest < Minitest::Test
  include MyFns

  def test_that_it_has_a_version_number
    refute_nil ::FnReader::VERSION
  end

  def test_included_module
    assert_equal 1, id.(1)
  end

  def test_module_function
    assert_equal 1, MyFns.id.(1)
  end

  def test_context_method
    # Test that context allows access to module methods without including the module
    result = FnReader.context(TestModuleOne) do
      multiply.(7)
    end
    assert_equal 21, result

    # Test that the method is not available outside the context
    assert_raises(NameError) do
      multiply.(7)
    end
  end

  def test_context_method_with_multiple_modules
    # Test context with multiple modules
    result = FnReader.context(TestModuleTwo, TestModuleThree) do
      double.(add_five.(3))
    end
    assert_equal 16, result
  end

  def test_context_method_isolation
    # Test that context method returns the result of the block
    result = FnReader.context(TestModuleOne) do
      multiply.(4)
    end
    assert_equal 12, result

    # Test that variables inside context don't leak out
    context_result = FnReader.context(TestModuleOne) do
      local_var = multiply.(2)
      local_var
    end
    assert_equal 6, context_result

    # Verify local_var is not accessible outside context
    assert_raises(NameError) do
      local_var
    end
  end

  def test_context_method_with_existing_module
    # Test that context works with the existing MyFns module too
    result = FnReader.context(MyFns) do
      id.(99)
    end
    assert_equal 99, result
  end
end
