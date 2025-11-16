require 'hometurf/files'
require 'hometurf/view/files_view'

module Hometurf
  class FilesViewBrief < FilesView
    def render
      projfiles = @files.away.elements
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
      width = 50
      dots = "." * (width - lhs.to_s.length - 3)
      printf "%s #{dots} %s\n", lhs, rhs
    end
  end
end