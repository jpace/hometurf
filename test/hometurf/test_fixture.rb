# frozen_string_literal: true

require 'pathname'
require_relative '../utils/println'

module Hometurf
  class TestFixture
    attr_reader :home_dir, :home_files_dir, :elsewhere_dir
    include Println

    def initialize
      @test_dir = Pathname.new "/tmp/ht-test"
    end

    def create_dir(dir, name)
      (dir + name).tap do |pn|
        pn.mkpath unless pn.exist?
      end
    end

    def create_file(dir, name, content = name.sub(%r{^\.}, ''))
      (dir + name).tap do |pn|
        unless pn.exist?
          pn.write("#{content}\n")
        end
      end
    end

    def create_link(from, to)
      unless from.exist?
        from.make_symlink to
      end
    end

    def create_file_and_link(filedir, homedir, name)
      file = create_file filedir, name
      link = homedir + name
      create_link link, file
    end

    def create_test_environment
      @test_dir.mkpath unless @test_dir.exist?

      project_dir = @test_dir + "proj"
      project_dir.rmtree if project_dir.exist?
      project_dir.mkpath

      @home_dir = create_dir @test_dir, "proj/home"
      @home_files_dir = create_dir @test_dir, "proj/homefiles"
      @elsewhere_dir = create_dir @test_dir, "proj/elsewhere"

      afile = create_file @home_dir, ".a-not-linked"

      bfile = create_file_and_link @home_files_dir, @home_dir, ".b-linked"
      cfile = create_file_and_link @elsewhere_dir, @home_dir, ".c-linked"

      dfile = create_file @home_files_dir, ".d-not-linked"
      efile = create_file @home_files_dir, "dot.e-not-linked"

      f_dir = create_dir @home_files_dir, ".f-linked"
      gfile = create_file f_dir, "g-file"
      f_link = @home_dir + ".f-linked"
      create_link f_link, f_dir

      h_dir = create_dir @elsewhere_dir, ".h"
      h_file = create_file h_dir, "h-file"
      h_link = home_dir + ".h"
      create_link h_link, h_dir

      i_dir = create_dir home_dir, ".i"
      i_file = create_file i_dir, "i-file"

      j_dir = create_dir @home_files_dir, ".j-not-linked"
      j_file = create_file j_dir, "j-file"
    end
  end
end
