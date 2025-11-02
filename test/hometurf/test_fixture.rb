# frozen_string_literal: true

require 'pathname'
require 'singleton'
require_relative '../../lib/hometurf/utils/println'
require_relative 'test_files_utils'

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
      TestFileUtils.create_file @directory, name
    end

    def create_link to, linkname = to.basename
      link = @directory + linkname
      TestFileUtils.create_link link, to
    end
  end

  class TestFixture
    include Println

    attr_reader :home, :project, :elsewhere

    def initialize
      @test_dir = Pathname.new "/tmp/ht-test"
      @test_dir.mkpath unless @test_dir.exist?

      project_dir = @test_dir + "proj"
      project_dir.rmtree if project_dir.exist?
      project_dir.mkpath

      @home = create_test_dir "proj/home"
      @project = create_test_dir "proj/homefiles"
      @elsewhere = create_test_dir "proj/elsewhere"

      @home.create_file ".a-not-linked"

      b = @project.create_file ".b-linked"
      @home.create_link b
      c = @elsewhere.create_file ".c-linked"
      @home.create_link c

      @project.create_file ".d-not-linked"
      @project.create_file "dot.e-not-linked"

      f_dir = @project.create_dir ".f-linked"
      TestFileUtils.create_file f_dir, "g-file"
      @home.create_link f_dir

      h_dir = @elsewhere.create_dir ".h"
      TestFileUtils.create_file h_dir, "h-file"
      @home.create_link h_dir

      i_dir = @home.create_dir ".i"
      TestFileUtils.create_file i_dir, "i-file"

      j_dir = @project.create_dir ".j-not-linked"
      TestFileUtils.create_file j_dir, "j-file"

      o_file = @project.create_file "dot.o"
      @home.create_link o_file, ".o-linked"

      @project.create_dir ".git"
    end

    def locations
      Locations.new(files: @project.directory, home: @home.directory)
    end

    def create_test_dir name
      dir = TestFileUtils.create_dir @test_dir, name
      TestFixtureDirectory.new dir
    end
  end
end
