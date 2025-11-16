module Hometurf
  class IgnoreFile
    def initialize patterns
      @patterns = patterns.collect(&:strip).collect { _1.end_with?("*") ? Regexp.new(_1.sub('*', '.*')) : _1 }
    end

    def ignored? pn
      @patterns.detect { pn.basename.to_s.index(_1) } || false
    end
  end
end