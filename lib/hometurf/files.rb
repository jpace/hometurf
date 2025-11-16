require 'hometurf/home_files'
require 'hometurf/away_files'
require 'hometurf/locations'
require 'hometurf/utils/println'
require 'fileutils'

module Hometurf
  class Files
    include Println

    attr_reader :home, :away

    def initialize locations
      @home = HomeFiles.new locations.home
      @away = AwayFiles.new locations.files
    end

    def copy_to_project fd, dest
      executor = Executor.new
      executor.copy fd, dest
    end

    def add_link projfile
      @home.add_link projfile
    end

    def backup homefile
      timestamp = Time.now.strftime("%Y%m%d%H%M%S")
      backup_file = homefile.parent + "#{homefile.basename}-ht-#{timestamp}"
      executor = Executor.new
      executor.copy homefile, backup_file
    end

    def move_and_link homefile
      backup homefile
      projfile = away.element homefile.basename
      copy_to_project homefile, projfile
      if homefile.directory?
        homefile.rmtree
      else
        homefile.unlink
      end
      add_link projfile
    end

    def update_home_from_project
      @away.dir.children.sort.each do |file|
        update_home_from_project_file file
      end
    end

    def update_home_from_project_file file
      if @away.ignored? file
        println "ignored", file
      elsif @home.element(file.basename).exist?
        println "home exists", file
      else
        println "adding symlink", file
        @home.add_link file
      end
    end
  end
end
