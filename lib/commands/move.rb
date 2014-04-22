module P4Tools
  class Move
    include CommandUtils

    def self.run(arguments)
      Move.new(arguments).run
    end

    def self.set_options(opts)
      opts.set do
        arg :workspace, 'Name of the new workspace.', :short => '-w', :type => :string
        arg :switch, 'Switch between workspaces, only 2 workspace name allowed.', :short => '-i', :type => :strings
        arg :changelist, 'Changelist number.', :short => '-c', :type => :int, :required => true
        arg :revert, 'Revert before move.', :short => '-r'
        arg :shelve, 'Shelve before move.', :short => '-s'
      end
    end


    def initialize(args)
      @args = args
      @p4 = P4Tools.connection
      @changelist = @args[:changelist]
      @is_not_empty = !empty_changelist?(@changelist)
    end

    def run
      shelve
      revert

      changelist_spec = @p4.fetch_change(@changelist)
      changelist_spec['Client'] = get_workspace(changelist_spec)
      @p4.save_change(changelist_spec)
    end


    private

    def shelve
      if @args[:shelve] && @is_not_empty
        @p4.run_shelve('-f', '-c', @changelist)
      end
    end

    def revert
      if @args[:revert] && @is_not_empty && all_files_shelved?(@changelist, true)
        @p4.run_revert('-w', '-c', @changelist, '//...')
      end
    end

    def get_workspace(changelist_spec)
      if @args[:switch]
        current = changelist_spec['Client']
        workspaces = @args[:switch]

        validate_workspaces(workspaces, current)

        workspaces.delete(current)
        workspaces.first
      else
        @args[:workspace]
      end
    end

    def validate_workspaces(workspaces, current)
      if workspaces.length != 2
        raise(ArgumentError, 'The switch parameter need to contains 2 workspace names exactly!')
      end

      unless workspaces.include?(current)
        raise(ArgumentError, "The switch parameter does not contains the currently active workspace: #{current}!")
      end
    end
  end
end