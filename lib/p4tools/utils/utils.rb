module P4Tools
  module Utils
    # @param [String] string
    # @return [String]
    def self.classify(string)
      string.gsub(/(^|_)(.)/) { $2.upcase }
    end

    # @param [String] string
    def self.require_original(file)
      require COMMANDS_ROOT + File::SEPARATOR + File.basename(file)
    end

  end
end
