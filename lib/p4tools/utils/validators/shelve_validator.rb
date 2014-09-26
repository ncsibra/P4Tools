module P4Tools
  class ShelveValidator

    def initialize(files, check_diff)
      @opened_files = files
      @check_diff = check_diff
    end

    # @return [Boolean]
    def valid?
      if @opened_files.nil?
        return false
      end

      @p4 = P4Tools.connection
      @cl = CommandUtils.pending_changelist_for_file(@opened_files[0])
      @shelved_files = CommandUtils.shelved_files(@cl)

      !@shelved_files.nil? && all_opened_files_shelved? && files_are_identical?
    end

    private

    # @return [Boolean]
    def all_opened_files_shelved?
      (@opened_files - @shelved_files).empty?
    end

    # @return [Boolean]
    def files_are_identical?
      identical = true

      if @check_diff
        not_deleted_files = []
        @p4.run_opened(*@opened_files).each { |file|
          if file['action'] != 'move/delete'
            not_deleted_files.push(file['depotFile'])
          end
        }
        shelve_revisions = not_deleted_files.map { |file| file + "@=#{@cl}" }
        identical = @p4.run_diff('-Od', *shelve_revisions).empty?
      end

      identical
    end
  end
end