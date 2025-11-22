# frozen_string_literal: true

require 'hometurf/view/color_string'
require 'test_helper'

module Hometurf
  class ColorsTest < Test::Unit::TestCase
    test "foreground color" do
      result = ColorString.with_foreground("color: 66", 66)
      assert_equal "\e[38;5;66mcolor: 66\e[0m", result
    end

    test "background color" do
      result = ColorString.with_background("color: 66", 66)
      assert_equal "\e[48;5;66mcolor: 66\e[0m", result
    end
  end
end
