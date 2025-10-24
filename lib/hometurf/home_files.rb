require 'hometurf/locations'
require 'pathname'

module Hometurf
  class HomeFiles
    def suggest_links
      puts "Scanning home directory for files..."
      dir = Pathname.new(ENV["HOME"])
      puts "Looking in: #{dir}"
      dir.children.sort.each do |kid|
        if kid.file?
          puts "  file: #{kid.basename}"
          if kid.symlink?
            puts "   is a link: #{kid}"
          end
        end
      end
      puts "Done scanning directory."
    end

    def from
    end
  end
end
