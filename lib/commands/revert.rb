module P4Tools
  class Revert

    def self.run(arguments)
      Revert.new(arguments).run
    end

    def self.set_options(opts)
      opts.set do
        help 'Revert the given files or all file in the changelist and optionally delete the added files from the disk too.'
        help ''
        help 'Options:'
        help ''
        arg :delete_added_files, 'Delete added files.', :short => '-d'
        arg :check_shelve, 'Check if all files shelved, before revert them.', :short => '-s'
        arg :changelists, 'Changelist numbers.', :short => '-c', :type => :ints
        arg :files, 'The absolute path of the files to delete.', :short => '-f', :type => :strings
      end
    end


    def initialize(args)
      @delete_added_files = args[:delete_added_files]
      @check_shelve = args[:check_shelve]
      @changelists = args[:changelists]
      @files = args[:files]

      @p4 = P4Tools.connection
    end

    def run
      if !@changelists.nil?
        revert_changelists
      elsif !@files.nil?
        revert_files
      end
    end

    def revert_files
      check_shelved_files(@files)

      parameters = []
      if @delete_added_files
        parameters.push('-w')
      end

      parameters.push(*@files)
      @p4.run_revert(parameters)
    end

    def revert_changelists
      @changelists.each do |changelist|
        check_shelved_changelist(changelist)

        if @delete_added_files
          @p4.run_revert('-w', '-c', changelist, '//...')
        else
          @p4.run_revert('-c', changelist, '//...')
        end
      end
    end

    def check_shelved_changelist(changelist)
      if @check_shelve && !CommandUtils.changelist_shelved?(changelist)
        raise(StandardError, "Not all files are shelved in changelist: #{changelist}")
      end
    end

    def check_shelved_files(files)
      if @check_shelve && !CommandUtils.files_shelved?(files)
        raise(StandardError, "Not all files are shelved from list: #{files}")
      end
    end

  end
end