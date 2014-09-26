module P4Tools
  class Shelve
    include CommandUtils

    def self.run(arguments)
      Shelve.new(arguments).run
    end

    def self.set_options(opts)
      opts.set do
        help 'Shelve all files to the given changelist or create a new one if not provided.'
        help ''
        help 'Options:'
        help ''
        arg :files, 'The absolute path of the files to shelve.', :short => '-f', :type => :strings
        arg :changelist, 'The changelist number to shelve, if not given, then create a new one.', :short => '-c', :type => :int
      end
    end


    def initialize(args)
      @files = args[:files]
      @shelve_changelist = args[:changelist] || create_new_changelist("Shelve container for files:\n\n#{@files.join("\n")}")
      @p4 = P4Tools.connection
    end

    def run
      current_changelist = get_current_changelist

      move_to(@shelve_changelist)
      shelve
      move_to(current_changelist)
    end


    private

    def get_current_changelist
      file_info = @p4.run_opened('-u', @p4.user, @files.first).first
      file_info['change']
    end

    def shelve
      @p4.run_shelve('-f', '-c', @shelve_changelist, @files)
    end

    def move_to(changelist)
      @p4.run_reopen('-c', changelist, @files)
    end

  end

end