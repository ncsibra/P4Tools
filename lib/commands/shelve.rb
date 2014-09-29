module P4Tools
  class Shelve

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
        arg :changelist, 'The changelist to shelve.', :short => '-c', :type => :int
        arg :tochangelist, 'The changelist number to shelve, if not given, then create a new one.', :short => '-t', :type => :int
        arg :checkfiles, 'Check that all files are shelved.', :short => '-i', :type => :strings
        arg :checkcls, 'Check that all files are shelved.', :short => '-l', :type => :ints
      end
    end


    def initialize(args)
      @files = args[:files]
      @current_changelist = args[:changelist]
      @shelve_changelist = args[:tochangelist]
      @checkfiles = args[:checkfiles]
      @checkcls = args[:checkcls]

      @p4 = P4Tools.connection
    end

    def run
      if !@files.nil?
        shelve_to_cl
      elsif !@changelist.nil?
        @files = CommandUtils.opened_files(args[:changelist])
        shelve_to_cl
      elsif !@checkfiles.nil?
        check_files(@checkfiles)
      elsif !@checkcls.nil?
        check_changelists(@checkcls)
      end
    end

    def check_files(files)
      puts CommandUtils.files_shelved?(files, true)
    end

    def check_changelists(changelists)
      changelists.each { |cl|
        shelved = CommandUtils.changelist_shelved?(cl, true)
        puts "#{cl}: #{shelved}"
      }
    end

    def shelve_to_cl
      @current_changelist ||= CommandUtils.pending_changelist_for_file(@files.first)
      @shelve_changelist ||= CommandUtils.create_new_changelist("Shelve container for files:\n\n#{@files.join("\n")}")

      move_to(@shelve_changelist)
      shelve
      move_to(@current_changelist)
    end

    def shelve
      @p4.run_shelve('-f', '-c', @shelve_changelist, @files)
    end

    def move_to(changelist)
      @p4.run_reopen('-c', changelist, @files)
    end

  end

end