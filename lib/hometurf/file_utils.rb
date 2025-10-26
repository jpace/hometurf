require 'pathname'

module Hometurf
  class FileUtils
    class << self
      def dotfile?(file)
        file.basename.to_s.start_with? "."
      end

      def under_directory?(dir, file)
        path = file.expand_path
        until path.root?
          if path == dir
            return true
          else
            path = path.parent
          end
        end
        false
      end
    end
  end
end
