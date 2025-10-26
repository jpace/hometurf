require 'hometurf/processor'
require 'hometurf/home_file'
require 'hometurf/file_utils'
require 'fileutils'

module Hometurf
  class Files < Processor
    def home_files
      @home_files ||= homedir.children.collect { |file| HomeFile.new file }
    end

    def project_files
      @project_files ||= filesdir.children
    end

    def linked_to_homefiles?(homefile)
      FileUtils.under_directory? filesdir, homefile.link
    end

    def copy_to_project fd, dest
      pn = Pathname.new fd
      puts "dest: #{dest}"
      raise "project directory exists: #{dest}" if dest.exist?
      ::FileUtils.cp_r pn, dest
    end

    def add_link(projfile)
      puts "projfile: #{projfile}"
      puts "projfile.exist?: #{projfile.exist?}"
      link = homedir + projfile.basename
      puts "link: #{link}"
      puts "link.exist?: #{link.exist?}"
      puts "link.symlink?: #{link.symlink?}"
      puts "link.projfile?: #{link.file?}"
      if link.exist?
        puts "link exists: #{link}"
      elsif link.symlink?
        puts "link is already a symlink: #{link}"
      else
        puts "setting link"
        link.make_symlink projfile
      end
    end

    def home_file file
      homedir + file.basename
    end

    def project_file file
      filesdir + file.basename
    end

    def move_and_link homefile
      projfile = filesdir + homefile.basename
      copy_to_project homefile, projfile
      homefile.unlink
      add_link projfile
    end
  end
end
