# frozen_string_literal: true

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

    def create_links *fds
      fds.each { |fd| create_link fd }
    end

    def file file
      @directory + file
    end

    def create_files * names
      names.collect { |it| create_file it }
    end

    def create_directory_and_files directory, *files
      create_dir(directory).tap do |dir|
        files.each { |it| create_file "#{dir}/#{it}" }
      end
    end
  end
end