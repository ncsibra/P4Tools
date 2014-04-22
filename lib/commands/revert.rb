module P4Tools
  class Revert
    def self.run(arguments)
      p4 = P4Tools.connection
      parameters = []
      parameters.push('-w') if arguments[:delete_added_files]

      if arguments[:changelist]
        parameters.push('-c').push(arguments[:changelist]).push('//...')
      else
        parameters.push(*arguments[:files])
      end

      p4.run_revert(parameters)
    end

    def self.set_options(opts)
      opts.set do
        help 'Revert the given files or all file in the changelist and optionally delete the added files from the disk too.'
        help ''
        help 'Options:'
        help ''
        arg :delete_added_files, 'Delete added files.', :short => '-d'
        arg :changelist, 'Changelist number.', :short => '-c', :type => :int
        arg :files, 'The absolute path of the files to delete.', :short => '-f', :type => :strings
      end
    end
  end
end