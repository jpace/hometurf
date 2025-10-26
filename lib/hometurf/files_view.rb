require 'hometurf/files'

module Hometurf
  class FilesView
    def initialize files
      @files = files
    end

    def render
      projfiles = @files.project_files
      projfiles.each do |file|
        puts "file: #{file}"
      end

      homefiles = @files.home_files
      homefiles.each do |status|
        puts "status: #{status.file}"
      end

      basenames = projfiles.map(&:basename) | homefiles.map(&:file).map(&:basename)
      basenames.sort.each do |bn|
        file = homefiles.find { |x| x.file.basename == bn }
        projfile = projfiles.find { |x| x.basename == bn }
        if file
          show_status_short file
        else
          show_projfile_status_short projfile
        end
      end
    end

    def show_status_short(status)
      width = 40
      rhs = if status.link
              formatted = format_file(status.link)
              if @files.linked_to_homefiles? status
                "&> #{formatted}"
              else
                "!> #{formatted}"
              end
            else
              "?>"
            end
      width = width - 4
      lhs = format "%-#{width}.#{width}s (%1s)", status.file, file_type_string(status.file)
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