# frozen_string_literal: true

require 'pathname'
require 'singleton'
require 'hometurf/utils/println'
require 'hometurf/test_files_utils'
require 'hometurf/fixture/test_fixture_directory'

module Hometurf
  class TestFixture
    include Println

    attr_reader :home, :away, :elsewhere, :windows, :awayhome, :common

    def initialize test_dir
      raise "invalid test dir #{test_dir}" unless test_dir.start_with? "/tmp/ht-test-"
      @test_dir = Pathname.new test_dir
      @test_dir.rmtree if @test_dir.exist?
      @test_dir.mkpath

      @home = create_test_dir "home-directory"
      @away = create_test_dir "away-project"
      @common = create_test_dir "away-project/common"
      @elsewhere = create_test_dir "elsewhere"
      @windows = create_test_dir "away-project/windows"

      home.create_file ".a"
      b, _ = common.create_file ".b"
      home.create_links b
      c, _ = elsewhere.create_file ".c"
      home.create_links c

      away.create_file "common/.d"
      away.create_file "common/dot.e"

      f_dir, _ = away.create_dir ".f"
      home.create_links f_dir
      TestFileUtils.create_file f_dir, "g-file"

      h_dir, _ = elsewhere.create_dir ".h"
      home.create_links h_dir
      TestFileUtils.create_file h_dir, "h-file"

      home.create_directory_and_files ".i", "i-file"
      away.create_directory_and_files ".j", "j-file"

      o_file = away.create_file "common/dot.o"
      home.create_link o_file, ".o-linked"

      %w{ .git .idea synced }.each { |it| @away.create_dir it }
    end

    def locations
      Locations.new(files: @away.directory, home: @home.directory)
    end

    def create_test_dir name
      dir = TestFileUtils.create_dir @test_dir, name
      TestFixtureDirectory.new dir
    end
  end
end