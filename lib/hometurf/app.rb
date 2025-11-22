require 'hometurf/locations'
require 'hometurf/home_file'
require 'hometurf/files'
require 'hometurf/view/files_view'
require 'hometurf/view/files_view_brief'
require 'hometurf/view/files_view_colors'
require 'hometurf/utils/println'

module Hometurf
  class App
    include Println

    def initialize locations
      @locations = locations
    end

    def add_link file
      println "add link"
      println "file", file
      println "file.parent", file.parent
      files = Files.new @locations
      if file.parent == files.home.dir
        println "home"
      elsif file.parent == files.away.dir
        println "project"
      else
        println "elsewhere"
      end
    end

    def add_home_link projfile, homefile = nil
      println "add home link"
      println "projfile", projfile
      println "projfile.parent", projfile.parent
      files = Files.new @locations
      if projfile.parent == files.away.dir
        println "project"
        files.home.add_link projfile, homefile
      else
        raise "not a project file: #{projfile}"
      end
    end

    def set_link file
      puts "set link: #{file}"
    end

    def status
      puts "status"
      files = Files.new @locations
      view = FilesViewColors.new files
      view.render
    end

    def update
      puts "update"
      files = Files.new @locations
      files.update_home_from_project
    end

    def update_file file
      puts "update file: #{file}"
      files = Files.new @locations
      files.update_home_from_project_file file
    end

    def copy_to_project file
      puts "copy to project: #{file}"
      files = Files.new @locations
      files.copy_to_project file, files.away.element(file.basename)
    end

    def move_to_project file
      puts "move to project: #{file}"
      files = Files.new @locations
      files.move_and_link file
    end

    def sync_file file
      puts "sync file: #{file}"
      files = Files.new @locations
      files.sync_file file
    end
  end
end
