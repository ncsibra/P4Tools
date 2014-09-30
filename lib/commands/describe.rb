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
        find_pending
      elsif !@pending.nil?
        find_submitted
      end
    end

    def find_submitted
      @p4.run_describe('-s', '-O', @pending).each { |data|
        p "pending: #{data['oldChange']}, submitted: #{data['change']}"
      }
    end

    def find_pending
      @p4.run_describe('-s', @submitted).each { |data|
        p "pending: #{data['oldChange']}, submitted: #{data['change']}"
      }
    end

  end
end