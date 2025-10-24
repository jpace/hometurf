require 'hometurf/statuses'

module Hometurf
  class StatusView
    def initialize statuses
      @statuses = statuses
    end

    def render
      projfiles = @statuses.project_files
      projfiles.each do |file|
        puts "file: #{file}"
      end

      homefiles = @statuses.home_files
      homefiles.each do |status|
        puts "status: #{status.homefile}"
      end

      basenames = projfiles.map(&:basename) | homefiles.map(&:homefile).map(&:basename)
      basenames.sort.each do |bn|
        homefile = homefiles.find { |x| x.homefile.basename == bn }
        projfile = projfiles.find { |x| x.basename == bn }
        if homefile
          show_status_short homefile
        else
          show_projfile_status_short projfile
        end
      end
    end

    def show_status_short(status)
      width = 40
      rhs = if status.link
              formatted = format_file(status.link)
              if @statuses.linked_to_homefiles? status
                "&> #{formatted}"
              else
                "!> #{formatted}"
              end
            else
              "?>"
            end
      width = width - 4
      lhs = format "%-#{width}.#{width}s (%1s)", status.homefile, file_type_string(status.homefile)
      printf "%s %s\n", lhs, rhs
    end

    def file_type_string(file)
      if file.file?
        "."
      elsif file.directory?
        "/"
      elsif file.symlink?
        "+"
      end
    end

    def format_file(file)
      type = file_type_string file
      "#{file} (#{type})"
    end

    def show_projfile_status_short(projfile)
      print_line "", format_file(projfile)
    end

    def print_line lhs, rhs
      width = 40
      printf "%-#{width}.#{width}s -> %s\n", lhs, rhs
    end
  end
end