module P4Tools
  class P4Delegate

    def self.run(arguments)
      p4 = P4Tools.connection
      command = arguments[:raw]

      if help?(command)
        help
      else
        p p4.run(command)
      end
    end

    def self.set_options(opts)
    end

    def self.help
      $stdout.puts "\n"
      $stdout.puts "Special command which delegate every argument to the perforce 'run()' method."
      $stdout.puts 'This way it will behave as the command line client of perforce(p4).'
      $stdout.puts "So if in the command line using a command like 'p4 revert -w -c 1234', you can use it in the exact same way with p4tools, e.g.: 'p4tools p4 revert -w -c 1234'"
      $stdout.puts "For more information check the perforce command reference: http://www.perforce.com/perforce/doc.current/manuals/cmdref"
      exit
    end

    def self.help?(command)
      %w(--help -h).include?(command[0])
    end

  end
end