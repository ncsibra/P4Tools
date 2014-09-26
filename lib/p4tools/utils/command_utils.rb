require_relative 'validators/shelve_validator'

module P4Tools
  module CommandUtils

    # @param [Integer] changelist
    # @param [Boolean] check_diff
    # @return [Boolean]
    def self.all_files_shelved?(changelist, check_diff=false)
      validator = ShelveValidator.new(changelist, check_diff)
      validator.valid?
    end

    # @param [Integer] changelist
    # @return [Boolean]
    def self.empty_changelist?(changelist)
      p4 = P4Tools.connection
      opened_files = p4.run(%W{ describe -s #{changelist} })[0]['depotFile']
      opened_files.nil?
    end

    # @param [String] description
    # @return [String]
    # The number of the new changelist
    def create_new_changelist(description='Created with P4Tools.')
      p4 = P4Tools.connection

      p4.input = {
          'Change' => 'new',
          'Description' => description,
      }

      confirmation = p4.run('change', '-i').first
      confirmation.match(/\d+/)[0]
    end
  end
end