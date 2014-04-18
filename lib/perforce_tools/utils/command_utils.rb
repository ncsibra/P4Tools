require_relative 'validators/shelve_validator'

module PerforceTools
  module CommandUtils

    def all_files_shelved?(changelist, check_diff=false)
      validator = ShelveValidator.new(changelist, check_diff)
      validator.valid?
    end

    def empty_changelist?(changelist)
      perforce = PerforceTools.connection
      opened_files = perforce.run(%W{ describe -s #{changelist} })[0]['depotFile']
      opened_files.nil?
    end

  end
end