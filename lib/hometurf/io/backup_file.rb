require 'hometurf/exec/executor'
require 'pathname'

module Hometurf
  class BackupFile
    def initialize file, executor
      @file = file
      @executor = executor
    end

    def write_backup
      timestamp = Time.now.strftime("%Y%m%d%H%M%S")
      backup_file = @file.parent + "#{@file.basename}-ht-#{timestamp}"
      @executor.copy @file, backup_file, abort_on_exists: true
    end
  end
end
