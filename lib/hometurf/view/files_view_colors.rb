require 'hometurf/files'
require 'hometurf/view/files_view'

module Hometurf
  class FilesViewColors < FilesView
    def render
      projfiles = @files.project.elements
      homefiles = @files.home.elements

      homefiles.sort_by { |it| it.file.basename }.each do |homefile|
        if homefile.link
          if homefile.link&.realpath.parent == @files.project.dir
            print_color_home_project_linked homefile.file, homefile.link&.realpath
          else
            print_color_home_elsewhere_linked homefile.file, homefile.link&.realpath
          end
        else
          print_color_home_not_linked homefile.file
        end
      end
      puts

      projfiles.sort.each do |projfile|
        unless homefiles.detect { |x| x.link&.realpath == projfile }
          print_color_project_not_linked projfile
        end
      end
    end

    def print_lhs_rhs lhs, lcolor, rhs, rcolor
      width = 50
      dots = "." * (width - lhs.to_s.length - 3)
      printf "\e[38;5;#{lcolor}m%s\e[0m #{dots} \e[38;5;#{rcolor}m%s\e[0m\n", lhs, rhs
    end

    def print_color_home_project_linked homefile, link
      print_lhs_rhs homefile, 25, link, 35
    end

    def print_color_home_elsewhere_linked homefile, link
      print_lhs_rhs homefile, 45, link, 55
    end

    def print_color_home_not_linked homefile
      print_lhs_rhs homefile, 65, "", 75
    end

    def print_color_project_not_linked projfile
      print_lhs_rhs "", 85, projfile, 95
    end
  end
end