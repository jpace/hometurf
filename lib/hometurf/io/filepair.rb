require 'hometurf/exec/executor'
require 'hometurf/io/backup_file'

module Hometurf
  class FilePair
    attr_reader :x, :y

    def initialize x, y
      @x = x
      @y = y
    end

    def backup
      if @y.exist?
        BackupFile.new(@y).write_backup
      end
    end

    def copy_x_to_y
      executor = Executor.new
      executor.copy @x, @y, abort_on_exists: false
    end

    def identical?
      @x.size == @y.size && @x.read == @y.read
    end

    def x_more_recent?
      @x.mtime > @y.mtime
    end

    def sync
      # we're assuming sync from the project (y) file to the x file
      if @y.exist?
        if identical?
          puts "identical files, skipping"
          return
        end
        if x_more_recent?
          backup_and_copy
        else
          swapped = FilePair.new @y, @x
          swapped.backup_and_copy
        end
      else
        backup_and_copy
      end
    end

    def backup_and_copy
      backup
      copy_x_to_y
    end
  end
end
