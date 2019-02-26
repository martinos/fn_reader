require "test_helper"

module MyFns
  fn_reader :id
  @@id = -> a { a }
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
end
