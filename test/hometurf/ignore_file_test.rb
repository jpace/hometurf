# frozen_string_literal: true

require 'test/unit'
require 'hometurf/ignore_file'
require 'pathname'

module Hometurf
  class IgnoreFileTest < Test::Unit::TestCase
    def setup
      # Do nothing
    end

    def teardown
      # Do nothing
    end

    def test_ignored
      obj = IgnoreFile.new [ '.lesshst' ]
      assert obj.ignored?(Pathname.new('.lesshst'))
      assert_false obj.ignored?(Pathname.new('.zshrc'))
    end
  end
end
