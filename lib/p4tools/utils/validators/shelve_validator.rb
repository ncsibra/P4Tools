module P4Tools
  class ShelveValidator

    def initialize(changelist, check_diff)
      @changelist = changelist
      @check_diff = check_diff
    end

    # @return [Boolean]
    def valid?
      @p4 = P4Tools.connection
      @opened_files = @p4.run(%W{ describe -s #{@changelist} })[0]['depotFile']
      @shelved_files = @p4.run(%W{ describe -s -S #{@changelist} })[0]['depotFile']

      @opened_files.nil? || (!@shelved_files.nil? && all_opened_files_shelved? && files_are_identical?)
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
        shelve_revisions = @opened_files.map { |file| file + "@=#{@changelist}" }
        identical = @p4.run_diff('-Od', *shelve_revisions).empty?
      end

      identical
    end
  end
end