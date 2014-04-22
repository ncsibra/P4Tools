module P4Tools
  class P4Delegate

    def self.run(arguments)
      @p4 = P4Tools.connection
      @p4.run(arguments[:raw])
    end

    def self.set_options(opts)
    end

  end
end