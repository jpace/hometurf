# frozen_string_literal: true

require 'pathname'
require 'singleton'
require 'hometurf/utils/println'
require 'hometurf/test_files_utils'

module Hometurf
  class TestFixtureDirectory
    attr_reader :directory

    def initialize directory
      @directory = directory
    end

    def create_dir name
      TestFileUtils.create_dir @directory, name
    end

    def create_file name
      fullname = @directory + name
      dir = fullname.parent
      dir.mkpath unless dir.exist?
      TestFileUtils.create_file @directory, name
    end

    def create_link to, linkname = to.basename
      link = @directory + linkname
      TestFileUtils.create_link link, to
    end

    def file file
      @directory + file
    end
  end

  class TestFixture
    include Println

    attr_reader :home, :away, :elsewhere, :windows

    def initialize test_dir
      raise "invalid test dir #{test_dir}" unless test_dir.start_with? "/tmp/ht-test-"
      @test_dir = Pathname.new test_dir
      @test_dir.rmtree if @test_dir.exist?
      @test_dir.mkpath

      @home = create_test_dir "home"
      @away = create_test_dir "away"
      @elsewhere = create_test_dir "elsewhere"
      @windows = create_test_dir "windows"

      @home.create_file ".a"

      b = @away.create_file ".b"
      @home.create_link b
      c = @elsewhere.create_file ".c"
      @home.create_link c

      @away.create_file ".d"
      @away.create_file "dot.e"

      f_dir = @away.create_dir ".f"
      TestFileUtils.create_file f_dir, "g-file"
      @home.create_link f_dir

      h_dir = @elsewhere.create_dir ".h"
      TestFileUtils.create_file h_dir, "h-file"
      @home.create_link h_dir

      i_dir = @home.create_dir ".i"
      TestFileUtils.create_file i_dir, "i-file"

      j_dir = @away.create_dir ".j"
      TestFileUtils.create_file j_dir, "j-file"

      o_file = @away.create_file "dot.o"
      @home.create_link o_file, ".o-linked"

      @away.create_dir ".git"
      @away.create_dir ".idea"
      @away.create_dir "synced"
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
