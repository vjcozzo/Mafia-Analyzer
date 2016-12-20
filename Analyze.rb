require_relative "MafiaGame.rb"

class Interface

    def initialize()
        @currentGame = nil
    end

    def start()
        print ("$ ")
        command = gets.chomp
        command = command.split(/\s+/)
        while ((command.empty?) || command[0].eql?("exit") == false)
            if (! (command.empty?))
                process(command)
            end

            # Output the prompt again
            print ("$ ")
            command = gets.chomp()
            command = command.split(/\s+/)
        end
        return 0
    end

    def process(cmd)
        first_token = cmd.shift()
        puts "Now about to process the first token, #{first_token}"
        if (first_token.eql?("new"))
            process_new()
        elsif (first_token.eql?("help"))
            help(cmd)
        elsif (first_token.eql?("claim"))
            if (@currentGame)
                result = @currentGame.addClaim(cmd)
                if (result == (-1))
                    puts "Note: the claim has been replaced."
                else
                    puts "Claim set successful"
                end
            end
        elsif (first_token.eql?("show"))
            puts "\'show\' still in development. Many cases need to be addressed :P"
            if (cmd[0].eql?("rolelist"))
                if (@currentGame)
                    @currentGame.printRoleList()
                end
            elsif (cmd[0].eql?("updatedrolelist"))
                if (@currentGame)
                    @currentGame.printUpToDate()
                end
            elsif (cmd[0].eql?("likelihood"))
                args = cmd.shift()
                if (@currentGame)
                    @currentGame.likelihood()
                end
            elsif (cmd[0].eql?("lifetime"))

            elsif (cmd[0].eql?("help"))

            else

            end
        elsif (first_token.eql?("confirm"))
            if (@currentGame)
                result = @currentGame.confirm(cmd)
                if (result == (-1))
                    puts "ERR: confirm was not valid!"
                else
                    puts "Role confirmed successfully."
                end
            end
        else
            puts "Command not identified. Enter \'help (cmd)\' for an up-to-date command list."
        end
        return 0
    end

    def process_new()
        @currentGame = MafiaGame.new()
        print ("  >> ")
        command = gets.chomp
        command = command.split(/\s+/)
        while (command.empty? || (! command[0].eql?("done")))
            if (! (command.empty?))
                processSaveCMD(command)
            end

            # Output the prompt again
            print ("  >> ")
            command = gets.chomp()
            command = command.split(/\s+/)
        end
        if (! (@currentGame.ready()))
            puts "Err -- no save has been successfully set! Try again please."
            return -1
        end
        return 0
    end

    def processSaveCMD(save_cmd)
        first_token = save_cmd.shift()
#        puts "Now about to process the first token, #{first_token}"
        if (first_token.eql?("list"))
            listSaves()
        elsif (first_token.eql?("use"))
            puts "use/load command identified..."
            puts "#{save_cmd.length}"
            if (save_cmd.empty? || (save_cmd.length() > 1))
                puts "Error -- load command should take one and only one argument,"
                puts "\tthe name of the save to be loaded."
                return 1
            end
            loadSave(save_cmd[0].to_s())
        else
            puts "Command not identified. Enter \'help\' for an up-to-date command list."
        end
        return 0
    end

    def listSaves()
        Dir.foreach("conf/") { |name|
            if (name[-5,5].eql?(".conf"))
                puts name
            end
        }
    end

    # Precondition: @currentGame has been set / is not nil
    # Postcondition: loads / uses a particular save 
    #    by reading data from conf files
    def loadSave(userinput)
        f = open("conf/" + userinput + ".conf")
        defsfile = open("conf/" + userinput + "-def.conf")
        roleList = f.read()
        roleDefs = defsfile.read()

        # First, get role definitions from the def.conf file.
        definitionFileLines = roleDefs.split("\n")
        # Possible future step: allow comments in the def file
        # by eliminating all lines beginning with #
        definitionFileLines.each { |nextLine|
            nextLineSeparated = nextLine.split("=>")
            targetRolesStrings = nextLineSeparated[1].split(",")
            targetRolesSymbols = targetRolesString.map { |str| str.to_sym() }
            nextGeneralRole = nextLineSeparated[0].to_sym()
            definitions[nextGeneralRole] = targetRolesSymbols
        }

        # Then read from the primary role list file,
        # and use the definitions to frame the initial
        # dynamic-role-list structure
        lines = alltext.split("\n")
        numRoles = lines.shift()
        data = []
        (0...numRoles).each { |i|
            nextEntry = []
            nextEntry.push(lines[i])
            nextEntry.push(defeinitions[line[i]])
            data.push(nextEntry)
        }
        @currentGame.loadSave(numRoles, lines, data)
        f.close()
        fdefs.close()
    end

    def help(arg)
        if (arg.empty?)
            puts "\tconfirm"
            puts "\t\tUpdated the game database with a new confirmed role"
            puts "\t\t-d\tupdates graveyard along with the confirmed role list"
            puts "\texit"
            puts "\t\tEnds the program."
            puts "\tsave\n\t\tDefines/Loads data for a Mafia save"
            puts "\t\t(role list and definitions used for a particular game)"
            puts "\tshow"
            puts "\t\t-c [#]\tshows the claim someone's made"
            puts "\t\t-l [ROLE]\tshows the statistical likelihood of a role"
            puts  "\n\n"
        else
            if (arg[0].eql?("show"))
                puts "\tshow"
                puts "\t\tstats\tshows various lifetime stats from the lifetime/ directory"
                puts "\t\tlikelihood\tcalculates the likelihood that player X has role Y"
            elsif (arg[0].eql?("confirm"))
                puts "\tconfirm"
                puts "\t\t-d\tupdates graveyard along with the confirmed role list"
            elsif (arg[0].eql?("exit"))
                puts "\texit"
                puts "\tEnds the program."
            else
                puts "Command not identified."
            end
        end

    end

end
