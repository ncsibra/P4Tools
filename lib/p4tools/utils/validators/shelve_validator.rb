module P4Tools
  class ShelveValidator

    # @return [Array<String>]
    def find_unshelved_files(files, check_diff)
      return false if files.nil?

      @opened_files = files
      @check_diff = check_diff
      @p4 = P4Tools.connection

      @cl = CommandUtils.pending_changelist_for_file(@opened_files[0])
      @shelved_files = CommandUtils.shelved_files(@cl)

      if @shelved_files.nil?
        return files
      end

      unshelved_files = find_not_shelved_files
      unless unshelved_files.empty?
        return unshelved_files
      end

      find_diff_files
    end

    # @return [Boolean]
    def find_not_shelved_files
      @opened_files - @shelved_files
    end

    # @return [Boolean]
    def find_diff_files
      return [] unless @check_diff

      shelve_revisions = []
      @p4.run_opened(*@opened_files).each { |file|
        unless deleted?(file)
          shelve_revisions.push("#{file['depotFile']}@=#{@cl}")
        end
      }

      @p4.run_diff('-f', '-se', *shelve_revisions)
    end

    def deleted?(file)
      file['action'].include?('delete')
    end

  end
end