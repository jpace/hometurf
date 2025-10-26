# frozen_string_literal: true

require 'pathname'

module Hometurf
  class TestFileUtils
    class << self
      def create_dir(dir, name)
        (dir + name).tap do |pn|
          pn.mkpath unless pn.exist?
        end
      end

      def create_file(dir, name, content = name.sub(%r{^\.}, ''))
        (dir + name).tap do |pn|
          unless pn.exist?
            pn.write("#{content}\n")
          end
        end
      end

      def create_link(from, to)
        unless from.exist?
          from.make_symlink to
        end
      end

      def create_file_and_link(filedir, linkdir, name)
        file = create_file filedir, name
        link = linkdir + name
        create_link link, file
      end
    end
  end
end
