module P4Tools
  class Revert

    def self.run(arguments)
      p4 = P4Tools.connection
      parameters = []
      parameters.push('-w') if arguments[:delete_added_files]
      check_shelve = arguments[:check_shelve]

      if arguments[:changelists]
        parameters.push('-c').push('').push('//...')

        arguments[:changelists].each do |changelist|
          if check_shelve && !CommandUtils.changelist_shelved?(changelist, true)
              raise(StandardError, "Not all files are shelved in changelist: #{changelist}")
          end

          parameters[-2] = changelist
          p4.run_revert(parameters)
        end
      else
        if check_shelve && !CommandUtils.files_shelved?(arguments[:files], true)
          raise(StandardError, "Not all files are shelved from list: #{arguments[:files]}")
        end

        parameters.push(*arguments[:files])
        p4.run_revert(parameters)
      end

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
  end
end