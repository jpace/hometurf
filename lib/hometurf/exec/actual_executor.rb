require 'hometurf/exec/executor'

class ActualExecutor < Executor
  def make_link from, to
    println "creating link #{from} -> #{to}"
    if from.exist?
      raise "link exists: #{from}"
    elsif from.symlink?
      raise "link is already a symlink: #{from}"
    else
      from.make_symlink to
    end
  end

  def copy from, to, abort_on_exists: true
    println "copying #{from} -> #{to}"
    if to.exist?
      msg = "destination exists: #{to}"
      if abort_on_exists
        raise "#{msg}, aborting"
      else
        puts "#{msg}, overwriting"
      end
    else
      to.parent.mkpath
    end
    ::FileUtils.cp_r from, to
  end
end
