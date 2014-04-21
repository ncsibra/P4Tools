module P4Tools
  module Shelve

    def self.run(arguments)
      ShelveHelper.new(arguments).shelve
    end

    def self.set_options(opts)
      opts.set do
        arg :files, 'The absolute path of the files to shelve.', :short => '-f', :type => :strings, :required => true
        arg :changelist, 'The changelist number to shelve, if not given, then create a new one.', :short => '-c', :type => :int
      end
    end

    class ShelveHelper
      include CommandUtils

      def initialize(args)
        @files = args[:files]
        @shelve_changelist = args[:changelist] || create_new_changelist("Shelve container for files: #{@files.to_s}")
      end

      def shelve
        current_changelist = get_current(@files.first)
      end


      private

      def get_current(file)

      end


    end

  end
end