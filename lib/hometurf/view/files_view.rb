require 'hometurf/files'

module Hometurf
  class FilesView
    def initialize files
      @files = files
    end

    def render
      print_home_files
      puts
      print_project_files
    end

    def print_home_files
      @files.home.elements.sort_by { |it| it.file.basename }.each do |homefile|
        next if @files.home.ignored? homefile
        print_home_file homefile
      end
    end

    def print_home_file homefile
      if homefile.link
        if homefile.link&.realpath&.parent == @files.away.dir
          print_home_project_linked homefile.file, homefile.link&.realpath
        else
          print_home_elsewhere_linked homefile.file, homefile.link&.realpath
        end
      else
        print_home_not_linked homefile.file
      end
    end

    def print_project_files
      @files.away.elements.sort.each do |projfile|
        next if @files.away.ignored? projfile
        next if @files.home.elements.detect { |x| x.link&.realpath == projfile }
        print_project_not_linked projfile
      end
    end
  end
end
