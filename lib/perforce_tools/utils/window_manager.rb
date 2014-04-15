module PerforceTools
  module WindowManager
    def self.refresh
      require 'rautomation'

      window = RAutomation::Window.new(:title => /Perforce P4V/i)
      window.send_keys(:f5)
    end
  end
end