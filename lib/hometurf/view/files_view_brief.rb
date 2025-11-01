require 'hometurf/files'
require 'hometurf/view/files_view'

module Hometurf
  class FilesViewBrief < FilesView
    def render
      projfiles = @files.project.elements
      homefiles = @files.home.elements

      homefiles.sort_by { |it| it.file.basename }.each do |homefile|
        print_line homefile.file, homefile.link&.realpath
      end
      puts

      projfiles.sort.each do |projfile|
        unless homefiles.detect { |x| x.link&.realpath == projfile }
          print_line "", projfile
        end
      end
    end

    def print_line lhs, rhs
      width = 40
      printf "%-#{width}.#{width}s -> %s\n", lhs, rhs
    end
  end
end