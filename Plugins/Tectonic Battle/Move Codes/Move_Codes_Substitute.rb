#===============================================================================
# User turns 1/4 of max HP into a substitute. (Substitute)
#===============================================================================
class PokeBattle_Move_UserMakesSubstitute25 < PokeBattle_Move_UserMakesSubstitute
    def initialize(battle, move)
        super
        @subFraction = 0.25
    end
end

#===============================================================================
# Forces the target to use a substitute (Doll Stitch)
#===============================================================================
class PokeBattle_Move_UserOrTargetMakesSubstitute25 < PokeBattle_Move
    def pbEffectAgainstTarget(_user, target)
        @battle.forceUseMove(target, :SUBSTITUTE)
    end
end

#===============================================================================
# User turns 1/2 of max HP into a substitute, then raises their (Mitosis)
# Speed by 2 steps.
#===============================================================================
class PokeBattle_Move_UserMakeSubstitute50RaiseSpd4 < PokeBattle_Move_UserMakesSubstitute
    def initialize(battle, move)
        super
        @subFraction = 0.50
        @speedIncrement = 4
    end

    def pbEffectGeneral(user)
        super
        user.tryRaiseStat(:SPEED, user, move: self, increment: @speedIncrement)
    end

    def getEffectScore(user, target)
        score = super
        score += getMultiStatUpEffectScore([:SPEED, @speedIncrement], user, user)
        return score
    end
end