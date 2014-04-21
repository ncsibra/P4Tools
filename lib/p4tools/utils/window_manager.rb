module P4Tools
  module WindowManager
    def self.refresh
      try_require

      window = RAutomation::Window.new(:title => /Perforce P4V/i)
      window.send_keys(:f5) if window.exist?
    end

    def self.try_require
      begin
        require 'rautomation'
      rescue
        raise(LoadError, "To use this module please install the 'rautomation' gem, version '0.14.1'. It might not work with other versions. Use command: 'gem install rautomation -v 0.14.1'")
      end
    end
  end
end