require 'hometurf/home_file'
require 'hometurf/location'
require 'hometurf/utils/println'
require 'hometurf/exec/executor'

module Hometurf
  class HomeFiles < Location
    include Println

    IGNORED = <<~EOF.split
      .git .lesshst .bash_history .bash_profile .cache .config
      .gem .gemrc .inputrc .lesskey .profile .viminfo .cups .local .m2 .ssh .gnupg
      .gradle .irb_history .java* .zcompdump*
    EOF

    def initialize dir
      super dir, IGNORED
    end

    def elements
      @elements ||= dir.children.select { _1.basename.to_s.start_with?('.') }.collect { HomeFile.new _1 }
    end

    def add_link projfile, link = nil
      link ||= element(projfile.basename)
      executor = Executor.new
      executor.make_link link, projfile
    end

    def ignored? homefile
      super homefile.file
    end
  end
end