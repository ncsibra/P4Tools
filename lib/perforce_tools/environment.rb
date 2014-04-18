ROOT = File.expand_path('..', File.dirname(__FILE__))
COMMANDS_ROOT = ROOT + '/commands'
CUSTOM_COMMANDS_ROOT = ROOT + '/commands/custom'
CONFIG_ROOT = ROOT + '/config'
SUB_COMMANDS = Dir[COMMANDS_ROOT + '/*.rb'].collect { |file|
                File.basename(file, '.rb')
              }


$LOAD_PATH.unshift(CUSTOM_COMMANDS_ROOT, COMMANDS_ROOT)