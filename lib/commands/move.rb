module PerforceTools
  module Move
    extend CommandUtils

    def self.run(arguments)
      perforce = PerforceTools.connection
      changelist = arguments[:changelist]
      is_not_empty = empty_changelist?(changelist)

      if arguments[:shelve] && is_not_empty
        perforce.run_shelve('-f', '-c', changelist)
      end

      if arguments[:revert] && is_not_empty && all_files_shelved?(changelist, true)
        perforce.run_revert('-w', '-c', changelist, '//...')
      end

      if arguments[:switch]
        workspaces = arguments[:switch]

        if workspaces.length != 2
          raise(ArgumentError, 'The switch parameter need to contains 2 workspace names exactly!')
        end

        current = p4.client
        unless workspaces.delete(current)
          raise(ArgumentError, "The switch parameter does not contains the currently active workspace: #{current}!")
        end

        new_workspace = workspaces[0]
      else
        new_workspace = arguments[:workspace]
      end

      change_spec = perforce.fetch_change(changelist)
      change_spec['Client'] = new_workspace
      perforce.save_change(change_spec)
    end

    def self.set_options(opts)
      opts.set do
        arg :workspace, 'Name of the new workspace.', :short => '-w', :type => :string
        arg :switch, 'Switch between workspaces, only 2 workspace name allowed.', :short => '-i', :type => :strings, :multi => true
        arg :changelist, 'Changelist number.', :short => '-c', :type => :int, :required => true
        arg :revert, 'Revert before move.', :short => '-r'
        arg :shelve, 'Shelve before move.', :short => '-s'
      end
    end
  end
end