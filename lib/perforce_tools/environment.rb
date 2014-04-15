ROOT = File.expand_path('..', File.dirname(__FILE__))
COMMANDS_ROOT = ROOT + '/commands'
CONFIG_ROOT = ROOT + '/config'
SUB_COMMANDS = Dir[COMMANDS_ROOT + '/*.rb'].collect { |file|
                File.basename(file, '.rb')
              }

$LOAD_PATH.unshift(COMMANDS_ROOT)