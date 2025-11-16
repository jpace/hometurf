require 'hometurf/utils/println'

class Executor
  include Println

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

  def copy from, to
    println "copying #{from} -> #{to}"
    raise "destination exists: #{to}" if to.exist?
    ::FileUtils.cp_r from, to
  end
end
