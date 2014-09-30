module P4Tools
  class Describe

    def self.run(arguments)
      Describe.new(arguments).run
    end

    def self.set_options(opts)
      opts.set do
        help 'Provides information about changelists and the changelists files.'
        help ''
        help 'Options:'
        help ''
        arg :submitted, 'Find pending CL number, based on submitted CL number.', :short => '-s', :type => :ints
        arg :pending, 'Find submitted CL number, based on pending CL number.', :short => '-p', :type => :ints
      end
    end


    def initialize(args)
      @pending = args[:pending]
      @submitted = args[:submitted]

      @p4 = P4Tools.connection
    end

    def run
      if !@submitted.nil?
        numbers = find_pending
        report(numbers)
      elsif !@pending.nil?
        numbers = find_submitted
        report(numbers)
      end
    end

    def find_submitted
      @p4.run_describe('-s', '-O', @pending)
    end

    def find_pending
      @p4.run_describe('-s', @submitted)
    end

    def report(numbers)
      numbers.each { |num|
        p "pending: #{num['oldChange']}, submitted: #{num['change']}"
      }
    end

  end
end