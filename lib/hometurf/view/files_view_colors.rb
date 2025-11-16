require 'hometurf/view/files_view'

module Hometurf
  class FilesViewColors < FilesView
    def print_lhs_rhs lhs, lcolor, rhs, rcolor
      width = 50
      dots = "." * (width - lhs.to_s.length - 3)
      printf "\e[38;5;#{lcolor}m%s\e[0m #{dots} \e[38;5;#{rcolor}m%s\e[0m\n", lhs, rhs
    end

    def print_home_project_linked homefile, link
      print_lhs_rhs homefile, 42, link, 42
    end

    def print_home_elsewhere_linked homefile, link
      print_lhs_rhs homefile, 138, link, 138
    end

    def print_home_not_linked homefile
      print_lhs_rhs homefile, 214, "", 0
    end

    def print_project_not_linked projfile
      print_lhs_rhs "", 0, projfile, 196
    end
  end
end