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
      elsif file.parent == files.project.dir
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
      if projfile.parent == files.project.dir
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
      files.project.dir.each_child do |file|
        if files.project.ignored? file
          println "ignored", file
        elsif files.home.element(file.basename).exist?
          println "home exists", file
        else
          files.home.add_link file
        end
      end
    end
  end
end
