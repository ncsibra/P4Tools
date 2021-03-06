module P4Tools
  class Move

    def self.run(arguments)
      Move.new(arguments).run
    end

    def self.set_options(opts)
      opts.set do
        help 'Move a pending changelist from one workspace to another, optionally shelve and delete them before.'
        help 'The changelist need to be empty to move(only shelved files allowed)!'
        help ''
        help 'Options:'
        help ''
        arg :workspace, "Name of the new workspace. If 'switch' option provided, this will be ignored.", :short => '-w', :type => :string
        arg :switch, 'Switch between workspaces, only 2 workspace name allowed.', :short => '-i', :type => :strings
        arg :changelists, 'Changelist numbers to move.', :short => '-c', :type => :ints, :required => true
        arg :revert, 'Revert before move.', :short => '-r'
        arg :shelve, 'Shelve before move.', :short => '-s'
      end
    end


    def initialize(args)
      @workspace = args[:workspace]
      @switch = args[:switch]
      @changelists = args[:changelists]
      @revert = args[:revert]
      @shelve = args[:shelve]

      @p4 = P4Tools.connection
    end

    def run
      prepare_workspaces
      move_changelists
    end

    def prepare_workspaces
      if @switch
        validate_workspaces(@switch)

        @workspaces = Hash[@switch.permutation.to_a]
      end
    end

    def move_changelists
      @changelists.each do |changelist|
        @changelist = changelist
        @is_not_empty = !CommandUtils.empty_changelist?(@changelist)

        shelve
        revert

        changelist_spec = @p4.fetch_change(@changelist)
        changelist_spec['Client'] = get_workspace(changelist_spec)
        @p4.save_change(changelist_spec)
      end
    end

    def shelve
      if @shelve && @is_not_empty
        @p4.run_shelve('-f', '-c', @changelist)
      end
    end

    def revert
      if @revert && @is_not_empty && CommandUtils.changelist_shelved?(@changelist)
        @p4.run_revert('-w', '-c', @changelist, '//...')
      end
    end

    def get_workspace(changelist_spec)
      if @workspaces
        current = changelist_spec['Client']
        validate_current(current)

        @workspaces[current]
      else
        @workspace
      end
    end

    def validate_current(current_workspace)
      unless @workspaces.include?(current_workspace)
        raise(ArgumentError, "The switch parameter does not contains the currently active workspace: #{current_workspace}!")
      end
    end

    def validate_workspaces(workspaces)
      if workspaces.length != 2
        raise(ArgumentError, 'The switch parameter need to contains 2 workspace names exactly!')
      end
    end
  end
end