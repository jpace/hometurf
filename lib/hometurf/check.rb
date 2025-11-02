module Hometurf
  class Check
    include Println

    def check_for_link_home_to_project homefile, projfile
      if homefile.exist?
        raise "home file exists: #{homefile}"
      elsif !projfile.exist?
        raise "project file does not exist: #{projfile}"
      else
        true
      end
    end
  end
end
