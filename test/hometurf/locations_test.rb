# frozen_string_literal: true

require 'test/unit'

module Hometurf
  class LocationsTest < Test::Unit::TestCase
    def setup
      # Do nothing
    end

    def teardown
      # Do nothing
    end

    def test_foobar
      called_foobar_1
      called_foobar_2("arg")
      called_foobar_3(arg: "arg")
    end

    def called_foobar_1
      puts "called foobar 1"
    end

    def called_foobar_2(arg)
      puts "called foobar 2 - arg: #{arg}"
    end

    def called_foobar_3(arg: nil)
      puts "called foobar 3 - arg: #{arg}"
    end
  end
end
