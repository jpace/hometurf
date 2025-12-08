require 'hometurf/home_files'
require 'hometurf/away_files'
require 'hometurf/locations'
require 'hometurf/utils/println'
require 'hometurf/io/filepair'
require 'fileutils'
require 'hometurf/exec/actual_executor'

module Hometurf
  class Files
    include Println

    attr_reader :home, :away

    def initialize locations, executor
      @executor = executor
      @home = HomeFiles.new locations.home, @executor
      @away = AwayFiles.new locations.files, @executor
    end

    def copy_to_project homefile, projfile
      println "copying #{homefile} to #{projfile}"
      if projfile.exist?
        raise "destination exists: #{projfile}"
      end

      files = create_file_pair homefile, projfile
      files.copy_x_to_y
    end

    def add_link projfile
      @home.add_link projfile
    end

    def move_and_link homefile
      println "homefile", homefile
      println "homefile.class", homefile.class
      projfile = away.dir + "common" + homefile.basename.to_s
      println "projfile", projfile
      println "projfile.class", projfile.class
      files = create_file_pair homefile, projfile
      files.backup
      files.copy_x_to_y
      if homefile.directory?
        homefile.rmtree
      else
        homefile.unlink
      end
      add_link projfile
    end

    def update_home_from_project
      common = @away.dir + "common"
      common.children.sort.each do |file|
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

    def sync_file file
      path = @away.dir + "synced"
      println "path", path
      other = file.sub path.to_s, ""
      println "other", other
      println "syncing #{file} and #{other}"
      filepair = create_file_pair file, other
      filepair.sync
    end

    def back_up_and_copy from, to
      files = create_file_pair from, to
      files.backup
      files.copy_x_to_y
    end

    def create_file_pair x, y
      FilePair.new x, y, @executor
    end
  end
end
