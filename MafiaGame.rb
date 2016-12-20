# A class to store all the data for one particular Mafia game
# The objectives, to be revised and expanded later, are:
# - Given the role list and list of deceased roles,
#   ouput the likelihood of a particular role existing
#   (this data has many applications, as described in the README) 
# - Gather statistical data on games played.
class MafiaGame
    def initialize()
        @roleList = [] # Constant during course of an instance.
        @updatedRoleList = [] # changes during course of game.
        @graveyard = [] # Array storing each player's role, or nil if unknown.
        @claims = []
        @confirmed = []
#        @definitions = {}
        @size = 0
    end

    # Important step: set the updated roles list
    # (the one that will be modified several times in this
    # object instance) equal to the RoleList at first.
    def importSave(num, primList, preparedStructure)
        @size = num
        @roleList = primList
        @updatedRoleList = preparedStructure
    end

    def ready()
        (@size > 0)
    end

    def exportData()
        puts "Method in development"
    end

    def addClaim(num, mesg)
        if (@claims[Num])
            @claims[Num] = Mesg
            return -1
        else
            @Claims[Num] = Mesg
            return 0
        end
    end

    def confirm(num, givenRole, d)
        if (d)
            @graveyard[num] = givenRole.to_sym
        end
        n = @roleList.length()

        matches = 1
        (0...n).times { |index|
            nextRolePossibilities = @updatedRoleList[index][1]
            if (@definitions[nextRolePossibilities.contains(givenRole.to_sym())])
                matches += 1
                lastMatchInd = index
            end
        }
        if (matchess == 1)
            @updatedRoleList[lastMatchInd][1].clear()
            @updatedRoleList[lastMatchInd][1].push(givenRole.to_sym())
        end
    end

    def show_likelihood(number, roleAsString)
        if (confirmedRoles[number])
            if (confirmedRoles[number].to_s().eql?(roleAsString))
                return 1.00
            else
                return 0.00
            end
        end

        # Now for the challenge: compute the probability 
        # that a given role exists in remaining role list.

        # Step 1: Find the total number of (distinct)
        #   possible role combinations
        possibilities = 1
        (0...@size).each { |index|
            unless (updatedRoleList[index].empty?)
                possibilities *= updatedRoleList[index].length()
            end
        }
        # Step 2: cycle through each possibility, and, for each one,
        #   compute the probability that player number X has role Y
        #   (in this 0.1 version model, it will be very simplistic
        #   and assume that each unconfirmed player has equal chance of having Y role).d
        #   In the future, it might incorporate other player's claims,
        #   Last wills, suspicions, typing patterns, previous game data, etc.
        #   But this is all too advanced for now.
        
    end
end
