# The absolute path of the main script(p4_tools.rb)
ROOT = File.expand_path('..', File.dirname(__FILE__))
# The absolute path of the folder which contains the command files
COMMANDS_ROOT = ROOT + '/commands'
# The absolute path of the folder which contains the custom command files
CUSTOM_COMMANDS_ROOT = COMMANDS_ROOT + '/custom'
# The absolute path of the folder which contains the configuration files
CONFIG_ROOT = ROOT + '/config'
# Array of command names, read from the COMMAND_ROOT folder
SUB_COMMANDS = Dir[COMMANDS_ROOT + '/*.rb'].collect { |file|
                File.basename(file, '.rb')
              }

$LOAD_PATH.unshift(CUSTOM_COMMANDS_ROOT, COMMANDS_ROOT)