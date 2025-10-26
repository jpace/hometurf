# frozen_string_literal: true

require 'pathname'
require_relative '../utils/println'
require_relative 'test_files_utils'

module Hometurf
  class TestFixture
    include Println

    attr_reader :home_dir, :project_dir, :elsewhere_dir

    def initialize
      @test_dir = Pathname.new "/tmp/ht-test"
    end

    def add_home_file name
      TestFileUtils.create_file @home_dir, name
    end

    def add_home_link_to_project_file name
      TestFileUtils.create_file_and_link @project_dir, @home_dir, name
    end

    def add_home_link_to_elsewhere_file name
      TestFileUtils.create_file_and_link @elsewhere_dir, @home_dir, name
    end

    def add_home_link to
      h_link = @home_dir + to.basename
      TestFileUtils.create_link h_link, to
    end

    def add_project_dir name
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

    def create_test_environment
      @test_dir.mkpath unless @test_dir.exist?

      project_dir = @test_dir + "proj"
      puts "project_dir: #{project_dir}"
      puts "project_dir.exist?: #{project_dir.exist?}"
      project_dir.rmtree if project_dir.exist?
      project_dir.mkpath

      @home_dir = create_test_dir"proj/home"
      @project_dir = create_test_dir "proj/homefiles"
      @elsewhere_dir = create_test_dir "proj/elsewhere"

      add_home_file ".a-not-linked"

      add_home_link_to_project_file ".b-linked"
      add_home_link_to_elsewhere_file ".c-linked"

      create_project_file ".d-not-linked"
      create_project_file "dot.e-not-linked"

      f_dir = add_project_dir".f-linked"
      TestFileUtils.create_file f_dir, "g-file"
      f_link = @home_dir + ".f-linked"
      TestFileUtils.create_link f_link, f_dir

      h_dir = TestFileUtils.create_dir @elsewhere_dir, ".h"
      TestFileUtils.create_file h_dir, "h-file"
      add_home_link h_dir

      i_dir = TestFileUtils.create_dir home_dir, ".i"
      TestFileUtils.create_file i_dir, "i-file"

      j_dir = add_project_dir".j-not-linked"
      TestFileUtils.create_file j_dir, "j-file"
    end
  end
end
