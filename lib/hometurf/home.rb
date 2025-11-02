require 'hometurf/home_file'
require 'hometurf/location'
require 'hometurf/utils/println'

module Hometurf
  class HomeFiles < Location
    include Println

    def elements
      @elements ||= dir.children.collect { |file| HomeFile.new file }
    end

    def add_link projfile, link = nil
      link ||= element(projfile.basename)
      if link.exist?
        raise "link exists: #{link}"
      elsif link.symlink?
        raise "link is already a symlink: #{link}"
      else
        println "link", link
        link.make_symlink projfile
      end
    end
  end
end
