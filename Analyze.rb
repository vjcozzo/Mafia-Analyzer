require_relative "MafiaGame.rb"

# A class to manage the interface between the user/client
# (presumably a Mafia player)
# and the MafiaGame object (currentGame), which computes probabilities
# and keeps track of data like role list.
class Interface

    # Initialize the currentGame to the nil object;
    # Read abbreviation data (which shouldn't change from game to game).
    # This data will be useful for the interface.
    def initialize()
        @currentGame = nil
        roleAbbreviationFile = open("conf/role-const.conf")
        allAbbreviations = roleAbbreviationFile.read()
        abbrevArr = allAbbreviations.split("\n")
        @definitions = {}
        @roleAbbrevHash = {}
        abbrevArr.each { |n|
            abbrev = n.split("=>")
            @roleAbbrevHash[abbrev[0]] = abbrev[1]
        }
        roleAbbreviationFile.close()
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
                fullRole = cmd[1]
                lowerCase = cmd[1].downcase()
                if (@roleAbbrevHash[lowerCase])
                    fullRole = @roleAbbrevHash[fullRole]
                end
                result = @currentGame.addClaim(cmd[0].to_i(), fullRole)
                if (result == (-1))
                    puts "Note: the claim has been replaced."
                else
                    puts "Claim set successfully."
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
                    @currentGame.showLikelihood(args[0].to_i(), args[1].to_sym())
                end
            elsif ((cmd[0].eql?("claims")) || (cmd[0].eql?("claim")))
                if (@currentGame)
                    @currentGame.showClaims()
                end
            elsif (cmd[0].eql?("confirmed"))
                if (@currentGame)
                    @currentGame.showConfirmed()
                end
            elsif (cmd[0].eql?("graveyard"))
                if (@currentGame)
                    @currentGame.showGraveyard()
                end
            elsif (cmd[0].eql?("lifetime"))
                puts "Case in development..."               
            elsif (cmd[0].eql?("help"))
                discard = cmd.shift()
                help(cmd)
            else
                puts "\'show\' command not recognized."
            end
        elsif (first_token.eql?("confirm"))
            if (@currentGame)
                fullRole = cmd[1]
                lowerCase = cmd[1].downcase()
                if (@roleAbbrevHash[lowerCase])
                    fullRole = @roleAbbrevHash[fullRole]
                end

                # If this role is a deceased role...
                if (cmd[2])
                    # Then pass true as the third argument, signaling this case.
                    result = @currentGame.confirm(cmd[0].to_i(), fullRole, true)
                else
                    result = @currentGame.confirm(cmd[0].to_i(), fullRole, false)
                end
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
        result = 0
        while ((result != 2) && (command.empty? || (! command[0].eql?("done"))))
            if (! (command.empty?))
                result = processSaveCMD(command)
            end
            unless (result == 2)
                # Output the prompt again
                print ("  >> ")
                command = gets.chomp()
                command = command.split(/\s+/)
            end
        end
        if (! (@currentGame.ready()))
            puts "Err -- no save has been successfully set! Try again please."
            return -1
        end
        return 0
    end

    def processSaveCMD(save_cmd)
        first_token = save_cmd.shift()
        if (first_token.eql?("list"))
            listSaves()
        elsif (first_token.eql?("use"))
            puts "use/load command identified..."
            puts "#{save_cmd.length}"
            if (save_cmd.empty? || (save_cmd.length() > 1))
                puts "Error -- load command should take one and only one argument,"
                puts "\tthe name of the save to be loaded."
                return -1
            end
            loadSave(save_cmd[0].to_s())
            return 2
        else
            puts "Command not identified. Enter \'help\' for an up-to-date command list."
        end
        return 0
    end

    def listSaves()
        Dir.foreach("saves/") { |name|
            if (name[-5,5].eql?(".conf"))
                puts name
            end
        }
    end

    # Precondition: @currentGame has been set / is not nil
    # Postcondition: loads / uses a particular save 
    #    by reading data from conf files
    def loadSave(userinput)
        f = open("saves/" + userinput + ".conf")
        alltext = f.read()

        # First, get role definitions from the def.conf file.
        defsFile = open("saves/" + userinput + "-def.conf")
        roleDefs = defsFile.read()
        definitionFileLines = roleDefs.split("\n")
        # Possible future step: allow comments in the def file
        # by eliminating all lines beginning with #
        definitionFileLines.each { |nextLine|
            nextLineSeparated = nextLine.split("=>")
            targetRolesStrings = nextLineSeparated[1].split(",")
            targetRolesSymbols = targetRolesStrings.map { |str| str.to_sym() }
            nextGeneralRole = nextLineSeparated[0].to_sym()
            @definitions[nextGeneralRole] = targetRolesSymbols
        }

        # Then read from the primary role list file,
        # and use the definitions to frame the initial
        # dynamic-role-list structure
        lines = alltext.split("\n")
        numRoles = lines.shift().to_i()
        data = []
        (0...numRoles).each { |i|
            nextEntry = []
            nextEntry.push(lines[i].to_sym())
            nextEntry.push(@definitions[lines[i].to_sym()])
            data.push(nextEntry)
        }
        @currentGame.importSave(numRoles, lines, data)
        f.close()
        defsFile.close()
    end

    def help(arg)
        if (arg.empty?)
            puts  "\n"
            puts "\tconfirm"
            puts "\t\tUpdated the game database with a new confirmed role"
            puts "\t\t-d\tupdates graveyard along with the confirmed role list"
            puts "\texit"
            puts "\t\tEnds the program."
            puts "\tsave\n\t\tDefines/Loads data for a Mafia save"
            puts "\t\t(role list and definitions used for a particular game)"
            puts "\tshow"
            puts "\t\trolelist\tprints the current save/rolelist"
            puts "\t\tupdatedrolelist\tprints the updated understanding of the save (factors in confirmed roles)"
            puts "\t\t-c [#]\tshows the claim someone's made"
            puts "\t\t-l [ROLE]\tshows the statistical likelihood of a role"
            puts  "\n"
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
