require 'hometurf/home_file'
require 'hometurf/home'
require 'hometurf/project'
require 'hometurf/locations'
require 'hometurf/utils/println'
require 'fileutils'

module Hometurf
  class Files
    include Println

    attr_reader :home, :project

    def initialize locations
      @home = HomeFiles.new locations.home
      @project = ProjectFiles.new locations.files
    end

    def linked_to_project?(link)
      @project.under_directory? link
    end

    def copy_to_project fd, dest
      pn = Pathname.new fd
      raise "project directory exists: #{dest}" if dest.exist?
      ::FileUtils.cp_r pn, dest
    end

    def add_link projfile
      @home.add_link projfile
    end

    def move_and_link homefile
      projfile = project.element homefile.basename
      copy_to_project homefile, projfile
      homefile.unlink
      add_link projfile
    end
  end
end
