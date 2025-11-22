require 'hometurf/home_files'
require 'hometurf/away_files'
require 'hometurf/locations'
require 'hometurf/utils/println'
require 'fileutils'

module Hometurf
  class Files
    include Println

    attr_reader :home, :away

    def initialize locations
      @home = HomeFiles.new locations.home
      @away = AwayFiles.new locations.files
    end

    def copy_to_project fd, dest
      executor = Executor.new
      executor.copy fd, dest, abort_on_exists: true
    end

    def add_link projfile
      @home.add_link projfile
    end

    def backup homefile
      timestamp = Time.now.strftime("%Y%m%d%H%M%S")
      backup_file = homefile.parent + "#{homefile.basename}-ht-#{timestamp}"
      executor = Executor.new
      executor.copy homefile, backup_file, abort_on_exists: true
    end

    def move_and_link homefile
      backup homefile
      projfile = away.element homefile.basename
      copy_to_project homefile, projfile
      if homefile.directory?
        homefile.rmtree
      else
        homefile.unlink
      end
      add_link projfile
    end

    def update_home_from_project
      @away.dir.children.sort.each do |file|
        update_home_from_project_file file
      end
    end

    def update_home_from_project_file file
      if @away.ignored? file
        println "ignored", file
      elsif @home.element(file.basename).exist?
        println "home exists", file
      else
        println "adding symlink", file
        @home.add_link file
      end
    end

    def sync_file file
      println "file #{file}"
      println "file.expand_path #{file.expand_path}"
      println "@away.dir #{@away.dir}"
      path = @away.dir + "synced"
      println "path #{path}"
      other = file.sub path.to_s, ""
      println "other #{other}"
      println "syncing #{file} and #{other}"
      if other.exist?
        println "other exists"
        if file.size == other.size && file.read == other.read
          puts "identical files, skipping"
          return
        end
        xtime = file.mtime
        ytime = other.mtime
        println "xtime #{xtime}, ytime #{ytime}"
        if xtime > ytime
          back_up_and_copy file, other
        elsif xtime < ytime
          back_up_and_copy other, file
        end
      else
        executor = Executor.new
        executor.copy file, other, abort_on_exists: false
      end
    end

    def back_up_and_copy from, to
      backup to
      executor = Executor.new
      executor.copy from, to, abort_on_exists: false
    end
  end
end
