module PerforceTools
  module Utils

    def self.classify(string)
      string.gsub(/(^|_)(.)/) { $2.upcase }
    end

    def self.require_original_module(file)
      require COMMANDS_ROOT + File::SEPARATOR + File.basename(file)
    end

  end
end
