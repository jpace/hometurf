require 'hometurf/home_file'
require 'hometurf/location'
require 'hometurf/utils/println'

module Hometurf
  class HomeFiles < Location
    include Println

    IGNORED = <<~EOF.split.collect(&:strip).collect { _1.end_with?("*") ? Regexp.new(_1.sub('*', '.*')) : _1 }
      .git .lesshst .bash_history .bash_profile .cache .config .gem .gemrc .inputrc .lesskey .profile .viminfo .cups .local .m2 .ssh .gnupg
      .gradle
      .irb_history
      .java*
      .zcompdump*
    EOF

    def elements
      @elements ||= dir.children.select { _1.basename.to_s.start_with?('.') }.collect { HomeFile.new _1 }
    end

    def add_link projfile, link = nil
      link ||= element(projfile.basename)
      if link.exist?
        raise "link exists: #{link}"
      elsif link.symlink?
        raise "link is already a symlink: #{link}"
      else
        println "link", link
        link.make_symlink projfile
      end
    end

    def ignored? homefile
      puts "IGNORED: #{IGNORED}"
      IGNORED.detect { homefile.file.basename.to_s.index(_1) }
    end
  end
end