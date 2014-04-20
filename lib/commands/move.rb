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

      change_spec = perforce.fetch_change(changelist)
      change_spec['Client'] = arguments[:workspace]
      perforce.save_change(change_spec)
    end

    def self.set_options(opts)
      opts.set do
        arg :workspace, 'Name of the new workspace.', :short => '-w', :type => :string
        arg :changelist, 'Changelist number.', :short => '-c', :type => :int, :required => true
        arg :revert, 'Revert before move.', :short => '-r'
        arg :shelve, 'Shelve before move.', :short => '-s'
      end
    end
  end
end