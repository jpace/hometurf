# frozen_string_literal: true

require 'pathname'
require 'singleton'
require_relative '../../lib/hometurf/utils/println'
require_relative 'test_files_utils'

module Hometurf
  class TestFixture
    include Println

    attr_reader :home_dir, :project_dir, :elsewhere_dir

    def initialize
      @test_dir = Pathname.new "/tmp/ht-test"
      @test_dir.mkpath unless @test_dir.exist?

      project_dir = @test_dir + "proj"
      project_dir.rmtree if project_dir.exist?
      project_dir.mkpath

      @home_dir = create_test_dir"proj/home"
      @project_dir = create_test_dir "proj/homefiles"
      @elsewhere_dir = create_test_dir "proj/elsewhere"

      create_home_file ".a-not-linked"

      b = create_project_file ".b-linked"
      add_home_link b
      c = create_elsewhere_file ".c-linked"
      add_home_link c

      create_project_file ".d-not-linked"
      create_project_file "dot.e-not-linked"

      f_dir = create_project_dir".f-linked"
      TestFileUtils.create_file f_dir, "g-file"
      add_home_link f_dir

      h_dir = TestFileUtils.create_dir @elsewhere_dir, ".h"
      TestFileUtils.create_file h_dir, "h-file"
      add_home_link h_dir

      i_dir = TestFileUtils.create_dir home_dir, ".i"
      TestFileUtils.create_file i_dir, "i-file"

      j_dir = create_project_dir".j-not-linked"
      TestFileUtils.create_file j_dir, "j-file"

      o_file = create_project_file"dot.o"
      o_link = @home_dir + ".o"
      TestFileUtils.create_link o_link, o_file
    end

    def locations
      Locations.new(files: @project_dir, home: @home_dir)
    end

    def add_home_link to
      h_link = @home_dir + to.basename
      TestFileUtils.create_link h_link, to
    end

    def create_project_dir name
      TestFileUtils.create_dir @project_dir, name
    end

    def create_test_dir name
      TestFileUtils.create_dir @test_dir, name
    end

    def create_project_file name
      TestFileUtils.create_file @project_dir, name
    end

    def create_elsewhere_file name
      TestFileUtils.create_file @elsewhere_dir, name
    end

    def create_home_file name
      TestFileUtils.create_file @home_dir, name
    end
  end
end
