module P4Tools
  class ShelveValidator

    # @return [Boolean]
    def self.files_shelved?(files, check_diff)
      ShelveValidator.new.shelved?(files, check_diff)
    end

    # @return [Boolean]
    def self.changelist_shelved?(changelist, check_diff)
      files = CommandUtils.opened_files(changelist)
      ShelveValidator.new.shelved?(files, check_diff)
    end


    # @return [Boolean]
    def shelved?(files, check_diff)
      return false if files.nil?

      @opened_files = files
      @check_diff = check_diff
      @p4 = P4Tools.connection

      @cl = CommandUtils.pending_changelist_for_file(@opened_files[0])
      @shelved_files = CommandUtils.shelved_files(@cl)

      !@shelved_files.nil? && all_opened_files_shelved? && files_are_identical?
    end

    # @return [Boolean]
    def all_opened_files_shelved?
      (@opened_files - @shelved_files).empty?
    end

    # @return [Boolean]
    def files_are_identical?
      return true unless @check_diff

      shelve_revisions = []
      @p4.run_opened(*@opened_files).each { |file|
        unless deleted?(file)
          shelve_revisions.push("#{file['depotFile']}@=#{@cl}")
        end
      }

      @p4.run_diff('-Od', *shelve_revisions).empty?
    end

    def deleted?(file)
      file['action'].include?('delete')
    end

  end
end