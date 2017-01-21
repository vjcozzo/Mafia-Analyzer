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
        @confirmed = [] #        @definitions = {}
        @size = 0
        @@iterations = 0
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
        if (@claims[num-1])
            @claims[num-1] = mesg.to_sym()
            return -1
        else
            @claims[num-1] = mesg.to_sym()
            return 0
        end
    end

    def confirm(num, givenRole, d)
        if (d)
            @graveyard[num-1] = []
            @graveyard[num-1].push(givenRole.to_sym())
        end

        lastMatchInd = 0
        matches = 1
        (0...(@size)).each { |index|
            nextRolePossibilities = @updatedRoleList[index][1]
            nextMatch = false
            if (nextRolePossibilities)
                nextRolePossibilities.each { |nth|
                    if (nth == (givenRole.to_sym()))
                        nextMatch = true
                    end
                }
            end
            if (nextMatch)
                matches += 1
                lastMatchInd = index
            end
        }
        if (matches == 1)
            @updatedRoleList[lastMatchInd][1] = []
            @updatedRoleList[lastMatchInd][0] = givenRole.to_sym()
            @graveyard[num-1].push(lastMatchInd)
        end
        @confirmed[num-1] = givenRole.to_sym()
    end

    def showLikelihood(number, roleAsString)
        if (@confirmed[number-1])
            if (@confirmed[number-1].to_s().eql?(roleAsString))
                return 1.00
            else
                return 0.00
            end
        end

        # Now for the challenge: compute the probability 
        # that a given role exists in remaining role list.

        # Step 1: Find the total number of (distinct)
        #   possible role combinations
        # To be more efficient, only the role slots that contain 
        # this given role as a possibility are counted.
        relevantSlots = []
        possibilities = 1
        numDistinctSlots = 0
        (0...@size).each { |index|
            if (@updatedRoleList[index][1].nil?)
                # check if updated list[0] matches the claim; if so,
                # then we DO in fact want to include it in the list of
                # relevantSlots.
                if ((@updatedRoleList[index][0].eql?(roleAsString.to_sym())))
                    relevantSlots.push()
                    numDistinctSlots += 1
		end
	    else
                # otherwise: for every vague save slot,
                # check if it CAN be the suggested / claimed role:
                counted = false
                @updatedRoleList[index][1].each { |nextRoleSymbol|
                    if (roleAsString.to_sym() == nextRoleSymbol)
                        counted = true
                    end
                }
                if (counted)
                    possibilities *= @updatedRoleList[index][1].length()
                    relevantSlots.push(@updatedRoleList[index][0])
                    numDistinctSlots += 1
                end
            end
        }
        puts "Possible role lists given this save template: ~ #{possibilities}"
        # Step 2: cycle through each possibility, and, for each one,
        #   execute the following list of instructions:
        #   a) check if this role list is even valid, given the ambiguous deceased roles
        #
        #   b) if this role list is invalid, return 0.00 additional probability.
        #      otherwise: 
        #
        #   c) compute the probability that player number X has role Y
        #       (in this ver 0.1 model, it will be very simplistic
        #      and assume that each unconfirmed player has equal chance of having Y role).
        #      In the future, it might incorporate other player's claims,
        #      Last wills, suspicions, typing patterns, previous game data, etc.
        #      But this is all too advanced for now.

        # First - show basic data about this role claim:
        # how many people have it confirmed, how many people have claimed it, and
        # how many people in total can have the role.
	count = 0
        @confirmed.each { |a|
            if (a.eql?(roleAsString))
	        count += 1
            end
        }
	puts "Out of #{numDistinctSlots} save slots that can be #{roleAsString}, #{count} have been confirmed so far"
	puts "This leaves exactly #{numDistinctSlots - count} slots remaining..."
        
        total_probability_sum =
            cumulative_probability_backtrack(@size-1, [], number, roleAsString)
        puts "Total probability sum, before modding by the number of possibilities ~ #{total_probability_sum.round(9)}"
        total_probability_sum /= possibilities
        puts "#{@@iterations} iterations done in the cycling/backtracking function"
        puts "Percentage likelihood: #{100.0*(total_probability_sum.round(10))}"
        return total_probability_sum
    end

    # I realize that cycling through each of these possible save configurations
    #   is very time-intensive...
    #   but in a future version, I'll be analyzing each case individually,
    #   to find contradicting claims etc.
    def cumulative_probability_backtrack(rem, oldBaseList, numX, roleY)
        if (rem == 0) # if we start at a rem=0 base case, array manipulations can use rem
            nextArray = oldBaseList
            if (@updatedRoleList[rem][1].nil?)
                nextArray[rem] = @updatedRoleList[rem][0]
                nextPr = getPrXHasY(nextArray, numX, roleY)
#                puts "\tBASE CASE --- rem = 0. Array in development is #{nextArray.inspect}, prob returned=#{nextPr}"
                return nextPr
            else
                sum = 0.00
                @updatedRoleList[rem][1].each { |nextChoice|
                    nextArray[rem] = nextChoice
                    nextPr = getPrXHasY(nextArray, numX, roleY)
#                    puts "\tBASE CASE --- rem = 0. Array in development is #{nextArray.inspect}, prob returned=#{nextPr}"
                    sum += nextPr
                }
                return sum
            end
        else
#            puts "\trem (#{rem}) > 0 --- Array in dev in #{oldBaseList.inspect}"
            nextArray = oldBaseList
            if (@updatedRoleList[rem][1].nil?)
                nextArray[rem] = @updatedRoleList[rem][0]
                return cumulative_probability_backtrack(rem-1, nextArray, numX, roleY)
            else
                innerSum = 0.00
                @updatedRoleList[rem][1].each { |nextChoice|
                    # choose the next value from @updatedRoleList[rem][1]...
                    nextArray[rem] = nextChoice
                    # and then use it recursively.
                    innerSum += cumulative_probability_backtrack(rem-1, nextArray, numX, roleY)
                }
                return innerSum
            end

        end
    end

    # For now, this is a very simplistic implementation.
    # In future versions, this calculation should involve role claims and LWs.
    def getPrXHasY(roleArray, numX, roleY)
        # For now, a very simplitic calculation is done.
        # (Again, in future versions, many other factors could be taken into account).

        # In fact, the first step is to traverse the graveyard,
        # and we should see how many matches there are...
        @@iterations += 1
        sum = 0.00
        roleArray.each { |b|
            if (b.to_s().eql?(roleY))
                sum += 1.00
            end
        }
        return (sum / @size)
    end

    def printRoleList()
        @roleList.each { |a|
            puts (a.to_s())
        }
    end

    def printUpToDate()
        @updatedRoleList.each { |en|
            puts (en.to_s())
        }
    end

    def showClaims()
        (0...(@size)).each { |ind|
            entry = @claims[ind]
            if (entry)
                puts "#{ind+1}: #{entry}"
            else
                puts "#{ind+1}: -------"
            end
        }
    end

    def showConfirmed()
        (0...(@size)).each { |ind|
            entry = @confirmed[ind]
            if (entry)
                puts "#{ind+1}: #{entry}"
            else
                puts "#{ind+1}: -------"
            end
        }
    end

    def showGraveyard()
        puts @graveyard
        (0...(@graveyard.size)).each { |ind|
            entry = @graveyard[ind]
            if (entry)
                puts "#{ind+1}: #{entry}"
            end
        }
    end
end
