require_relative 'validators/shelve_validator'

module P4Tools
  module CommandUtils

    # @param [Array<String>] files
    # @param [Boolean] check_diff
    # @return [Boolean]
    def self.files_shelved?(files, check_diff=true)
      ShelveValidator.files_shelved?(files, check_diff)
    end

    # @param [Integer] changelist
    # @param [Boolean] check_diff
    # @return [Boolean]
    def self.changelist_shelved?(changelist, check_diff=true)
      ShelveValidator.changelist_shelved?(changelist, check_diff)
    end

    # @param [Integer] changelist
    # @return [Boolean]
    def self.empty_changelist?(changelist)
      p4 = P4Tools.connection
      opened_files = p4.run_describe('-s', changelist).first['depotFile']
      opened_files.nil?
    end

    # @param [String] file
    # @return [Integer]
    def self.pending_changelist_for_file(file)
      p4 = P4Tools.connection
      p4.run_opened(file).first['change']
    end

    # @param [Integer] changelist
    # @return [Array<String>]
    def self.shelved_files(changelist)
      p4 = P4Tools.connection
      p4.run_describe('-s', '-S', changelist).first['depotFile']
    end

    # @param [Integer] changelist
    # @return [Array<String>]
    def self.opened_files(changelist)
      p4 = P4Tools.connection
      p4.run_describe('-s', changelist).first['depotFile']
    end

    # @param [String] description
    # @return [String]
    # The number of the new changelist
    def self.create_new_changelist(description='Created with P4Tools.')
      p4 = P4Tools.connection

      p4.input = {
          'Change' => 'new',
          'Description' => description,
      }

      confirmation = p4.run_change('-i').first
      confirmation.match(/\d+/)[0]
    end
  end
end