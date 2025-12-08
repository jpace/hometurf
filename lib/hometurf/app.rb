require 'hometurf/locations'
require 'hometurf/home_file'
require 'hometurf/files'
require 'hometurf/view/files_view'
require 'hometurf/view/files_view_brief'
require 'hometurf/view/files_view_colors'
require 'hometurf/utils/println'
require 'hometurf/exec/actual_executor'
require 'hometurf/exec/dry_run_executor'

module Hometurf
  class App
    include Println

    def initialize locations, dry_run
      @locations = locations
      @dry_run = dry_run
    end

    def new_files_instance
      executor = @dry_run ? DryRunExecutor.new : ActualExecutor.new
      println "executor: #{executor.class}"
      Files.new @locations, executor
    end

    def add_link file
      println "add link"
      println "file", file
      println "file.parent", file.parent
      files = new_files_instance
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
      files = new_files_instance
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
      files = new_files_instance
      view = FilesViewColors.new files
      view.render
    end

    def update
      puts "update"
      files = new_files_instance
      files.update_home_from_project
    end

    def update_file file
      puts "update file: #{file}"
      files = new_files_instance
      files.update_home_from_project_file file
    end

    def copy_to_project file
      puts "copy to project: #{file}"
      files = new_files_instance
      projfile = files.away.dir + "common" + file.basename
      files.copy_to_project file, projfile
    end

    def move_to_project file, dry_run: false
      puts "move to project: #{file}"
      files = new_files_instance
      files.move_and_link file
    end

    def sync_file file, dry_run: false
      puts "sync file: #{file}"
      files = new_files_instance
      files.sync_file file
    end
  end
end
