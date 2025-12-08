require 'hometurf/exec/executor'

class DryRunExecutor < Executor
  def make_link from, to
    println "(would be) creating link #{from} -> #{to}"
    if from.exist?
      puts "(would error) link exists: #{from}"
    elsif from.symlink?
      puts "(would error) link is already a symlink: #{from}"
    else
      println "(would) create link #{from} -> #{to}"
      from.make_symlink to
    end
  end

  def copy from, to, abort_on_exists: true
    println "(would be) copying #{from} -> #{to}"
    if to.exist?
      msg = "destination exists: #{to}"
      if abort_on_exists
        puts "(would error) #{msg}, aborting"
      else
        puts "(would warn) #{msg}, overwriting"
      end
    else
      println "(would be) mkpath #{to}"
      to.parent.mkpath
    end
    println "(would) copy #{from} -> #{to}"
    ::FileUtils.cp_r from, to
  end
end
