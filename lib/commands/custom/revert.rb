module PerforceTools
  Utils.require_original_module __FILE__

  module Revert
    def self.run(arguments)
      p "dummy revert #{arguments}"
    end
  end
end