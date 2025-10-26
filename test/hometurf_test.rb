# frozen_string_literal: true

require "test_helper"

class HometurfTest < Test::Unit::TestCase
  test "VERSION" do
    assert do
      ::Hometurf.const_defined?(:VERSION)
    end
  end
end
