require 'hometurf/home_files'
require 'hometurf/away_files'
require 'hometurf/locations'
require 'hometurf/utils/println'
require 'hometurf/io/filepair'
require 'fileutils'

module Hometurf
  class Files
    include Println

    attr_reader :home, :away

    def initialize locations
      @home = HomeFiles.new locations.home
      @away = AwayFiles.new locations.files
    end

    def copy_to_project homefile, projfile
      println "copying #{homefile} to #{projfile}"
      if projfile.exist?
        raise "destination exists: #{projfile}"
      end
      files = FilePair.new homefile, projfile
      files.copy_x_to_y
    end

    def add_link projfile
      @home.add_link projfile
    end

    def move_and_link homefile
      projfile = away.element homefile.basename
      files = FilePair.new homefile, projfile
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

    def sync_file file
      println "file #{file}"
      println "file.expand_path #{file.expand_path}"
      println "@away.dir #{@away.dir}"
      path = @away.dir + "synced"
      println "path #{path}"
      other = file.sub path.to_s, ""
      println "other #{other}"
      println "syncing #{file} and #{other}"
      filepair = FilePair.new file, other
      filepair.sync
    end

    def back_up_and_copy from, to
      files = FilePair.new from, to
      files.backup
      files.copy_x_to_y
    end
  end
end
