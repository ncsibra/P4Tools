module PerforceTools
  module Revert
    def self.run(arguments)
      perforce = PerforceTools.connection

      args = []
      args.push('-w') if arguments[:delete_added_files]
      args.push('-c')
      args.push(arguments[:changelist])
      args.push('//...')

      perforce.run_revert(args)
    end

    def self.set_options(opts)
      opts.set do
        arg :delete_added_files, 'Delete added files.', :short => '-d'
        arg :changelist, 'Changelist number.', :short => '-c', :type => :int, :required => true
      end
    end
  end
end