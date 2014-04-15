module PerforceTools
  module Move
    def self.run(arguments, perforce)
      changelist = arguments[:changelist]

      if arguments[:shelve]
        perforce.run_shelve('-f', '-c', changelist)
      end

      if arguments[:revert]
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