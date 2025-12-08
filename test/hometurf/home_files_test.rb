# frozen_string_literal: true

require 'hometurf/files'
require 'hometurf/fixture/test_fixture'

module Hometurf
  class HomeFilesTest < Test::Unit::TestCase
    def setup
      # Do nothing
    end

    def teardown
      # Do nothing
    end

    def test_ignored
      obj = HomeFiles.new nil, nil
      pn = Pathname.new(File.expand_path('~/.ssh'))
      arg = HomeFile.new pn
      assert obj.ignored?(arg)
    end
  end
end
