module P4Tools
  module Shelve

    def self.run(arguments)
      Shelver.new(arguments).shelve
    end

    def self.set_options(opts)
      opts.set do
        arg :files, 'The absolute path of the files to shelve.', :short => '-f', :type => :strings, :required => true
        arg :changelist, 'The changelist number to shelve, if not given, then create a new one.', :short => '-c', :type => :int
      end
    end

    class Shelver
      include CommandUtils

      def initialize(args)
        @files = args[:files]
        @shelve_changelist = args[:changelist] || create_new_changelist("Shelve container for files: #{@files.to_s}")
        @p4 = P4Tools.connection
      end

      def shelve
        current_changelist = get_current_changelist

        move_to(@shelve_changelist)
        shelve_all
        move_to(current_changelist)
      end


      private

      def get_current_changelist
        file_info = @p4.run_opened('-u', @p4.user, @files.first).first
        file_info['change']
      end

      def shelve_all
        @p4.run_shelve('-f', '-c', @shelve_changelist, @files)
      end

      def move_to(changelist)
        @p4.run_reopen('-c', changelist, @files)
      end

    end

  end
end