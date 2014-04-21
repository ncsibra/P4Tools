require_relative 'validators/shelve_validator'

module P4Tools
  module CommandUtils

    # @param [Integer] changelist
    # @param [Boolean] check_diff
    # @return [Boolean]
    def all_files_shelved?(changelist, check_diff=false)
      validator = ShelveValidator.new(changelist, check_diff)
      validator.valid?
    end

    # @param [Integer] changelist
    # @return [Boolean]
    def empty_changelist?(changelist)
      perforce = P4Tools.connection
      opened_files = perforce.run(%W{ describe -s #{changelist} })[0]['depotFile']
      opened_files.nil?
    end

    # @param [String] description
    # @return [String]
    # The number of the new changelist
    def create_new_changelist(description='Created with P4Tools.')
      perforce = P4Tools.connection

      perforce.input = {
          'Change' => 'new',
          'Description' => description,
      }

      confirmation = @perforce.run('change', '-i').first
      confirmation.match(/\d+/)[0]
    end
  end
end