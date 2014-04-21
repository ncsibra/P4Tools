module P4Tools
  class ShelveValidator

    def initialize(changelist, check_diff)
      @changelist = changelist
      @check_diff = check_diff
    end

    # @return [Boolean]
    def valid?
      @perforce = P4Tools.connection
      @opened_files = @perforce.run(%W{ describe -s #{@changelist} })[0]['depotFile']
      @shelved_files = @perforce.run(%W{ describe -s -S #{@changelist} })[0]['depotFile']

      @opened_files.nil? || (!@shelved_files.nil? && all_opened_files_shelved? && files_are_identical?)
    end

    private

    # @return [Boolean]
    def all_opened_files_shelved?
      (@opened_files - @shelved_files).empty?
    end

    # @return [Boolean]
    def files_are_identical?
      if @check_diff
        intersection = @shelved_files & @opened_files

        intersection.each do |file|
          diff = @perforce.run(%W{ diff -Od #{file}@=#{@changelist} })
          return false unless diff.empty?
        end
      end

      true
    end
  end
end