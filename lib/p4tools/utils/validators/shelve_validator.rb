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
      unshelved_files + find_diff_files
    end

    def find_not_shelved_files
      @opened_files - @shelved_files
    end

    # @return [Boolean]
    def find_diff_files
      return [] unless @check_diff

      diff_files = []
      shelve_revisions = []
      files_to_check = @opened_files & @shelved_files

      unless files_to_check.empty?
        @p4.run_opened(*files_to_check).each { |file|
          if edited?(file)
            shelve_revisions.push("#{file['depotFile']}@=#{@cl}")
          end
        }

        unless shelve_revisions.empty?
          diff_files = @p4.run_diff('-f', '-se', *shelve_revisions).collect { |d| d['depotFile'] }
        end
      end

      diff_files
    end

    def edited?(file)
      file['action'].include?('edit')
    end

  end
end