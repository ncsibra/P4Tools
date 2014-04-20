module PerforceTools
  module Revert
    def self.run(arguments)
      perforce = PerforceTools.connection

      perforce.run_revert(%W{ #{arguments[:delete_added_files]} -c #{arguments[:changelist]} //... })
    end

    def self.set_options(opts)
      opts.set do
        arg :delete_added_files, 'Delete added files.', :short => '-d'
        arg :changelist, 'Changelist number.', :short => '-c', :type => :int, :required => true
      end
    end
  end
end