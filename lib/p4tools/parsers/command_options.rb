module P4Tools
  class CommandOptions

    attr_reader :show_help

    def initialize(parser)
      @parser = parser
      @show_help = true
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

    def allow_empty_args
      @show_help = false
    end

    def set(&opts)
      self.instance_eval &opts
    end

  end
end