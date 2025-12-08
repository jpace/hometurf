require 'hometurf/utils/println'

class Executor
  include Println

  def make_link from, to
    raise "not implemented"
  end

  def copy from, to, abort_on_exists: true
    raise "not implemented"
  end
end
