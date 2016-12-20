# Definitions are all based on the game SC2Mafia
# with help from the sc2mafia wiki.

# This class stores all Constant Variables, to be used by the class below.
module Save0
    # Here, store a hash of all general role types
    # i.e., general slots that exist in a given save.
    # The program needs a way of interpreting the role list,
    # so it will draw conclusions using this record of definitions:
    definitions =
        {
        :TownGovt => [:Mayor, :Marshall, :Crier, :Citizen,
                    :MasonLeader, :Mason],
        :TownProtective => [:Doctor, :Bodyguard, :BusDriver, :Escort],
        :TownInvestigative => [:Investigator, :Sheriff, :Detective, :Coroner],
        :TownPower => [:BusDriver, :Veteran, :Spy, :Jailor],
        :TownKilling => [:Veteran, :Bodyguard, :Vigilante, :Jailor],
        :TownRandom => [:Mayor, :Marshall, :Crier, :Citizen,
                      :Sheriff, :Investigator, :Detective,
                      :Lookout, :Coroner, :Jailor, :Doctor,
                      :Escort, :Bodyguard, :Vigilante,
                      :Veteran, :Spy, :BusDriver, :Stump,
                      :MasonLeader, :Mason],

        :MafiaSupport => [:Consigliere, :Consort, :Blackmailer, :Agent,
                        :Kidnapper],
        :MafiaDeception => [:Disguiser, :Beguiler, :Framer, :Janitor],
        :MafiaKilling => [:Kidnapper, :Mafioso, :Godfather],
        :MafiaRandom => [:Godfather, :Consigliere, :Beguiler,
                       :Consort, :Blackmailer, :Agent, :Kidnapper,
                       :Disguiser, :Janitor],

        :NeutralBenign => [:Jester, :Amnesiac, :Executioner, :Survivor],
        :NeutralEvil => [:Cultist, :WitchDoctor, :SerialKiller, :Arsonist,
                       :MassMurderer, :Auditor, :Judge, :Witch, :Scumbag],
        :NeutralKilling => [:SerialKiller, :Arsonist, :MassMurderer],
        :NeutralRandom => [:Jester, :Amnesiac, :Executioner, :Survivor,
                         :Cultist, :WitchDoctor, :SerialKiller, :Arsonist,
                         :MassMurderer, :Auditor, :Judge, :Witch, :Scumbag]
        }

end
