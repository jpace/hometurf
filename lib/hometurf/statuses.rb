require 'hometurf/processor'

module Hometurf
  class Status
    attr_reader :homefile
    attr_reader :link

    def initialize(homefile, link)
      @homefile = homefile
      @link = link
    end

    def to_s
      "homefile: #{homefile}, link: #{link}"
    end
  end

  class Statuses < Processor
    def get_home_file_status(homefile)
      if homefile.symlink?
        link = homefile.readlink
        Status.new homefile, link
      else
        Status.new homefile, nil
      end
    end

    def home_files
      @home_files ||= begin
                        homedir.children.collect do |homefile|
                          get_home_file_status homefile
                        end
                      end
    end

    def project_files
      @project_files ||= filesdir.children
    end

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

    def linked_to_homefiles?(status)
      under_directory? filesdir, status.link
    end
  end
end
