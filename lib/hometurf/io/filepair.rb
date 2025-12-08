require 'hometurf/exec/executor'
require 'hometurf/io/backup_file'

module Hometurf
  class FilePair
    attr_reader :x, :y

    def initialize x, y, executor
      @x = x
      @y = y
      @executor = executor
    end

    def backup
      if @y.exist?
        BackupFile.new(@y, @executor).write_backup
      end
    end

    def copy_x_to_y
      @executor.copy @x, @y, abort_on_exists: false
    end

    def identical?
      @x.size == @y.size && @x.read == @y.read
    end

    def x_more_recent?
      @x.mtime > @y.mtime
    end

    def sync
      # we're assuming sync from the project (y) file to the home (x) file
      if @y.exist?
        if identical?
          puts "identical files, skipping"
        elsif x_more_recent?
          backup_and_copy
        else
          swapped = FilePair.new @y, @x, @executor
          swapped.backup_and_copy
        end
      else
        copy_x_to_y
      end
    end

    def backup_and_copy
      backup
      copy_x_to_y
    end
  end
end
