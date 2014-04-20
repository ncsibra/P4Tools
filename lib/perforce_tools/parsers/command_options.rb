module PerforceTools
  class CommandOptions

    def initialize(parser)
      @parser = parser
    end

    # @param [String] text
    def help(text)
      @parser.banner(text)
    end

    # @param [Symbol] name
    # @param [String] desc
    # @param [Hash<Symbol, Object>] options
    def arg(name, desc='', options={})
      @parser.opt(name, desc, options)
    end

    def set(&opts)
      self.instance_eval &opts
    end

  end
end