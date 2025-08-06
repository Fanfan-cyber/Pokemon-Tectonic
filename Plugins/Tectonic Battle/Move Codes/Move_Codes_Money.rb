#===============================================================================
# Scatters coins that the player picks up after winning the battle. (Pay Day)
#===============================================================================
class PokeBattle_Move_AddMoneyGainedFromBattle < PokeBattle_Move
    MONEY_MULTIPLIER = 8

    def pbEffectGeneral(user)
        user.generateMoney(MONEY_MULTIPLIER)
    end

    def getEffectScore(user, _target)
        return user.getCashFlowEffectScore(MONEY_MULTIPLIER)
    end
end

#===============================================================================
# If it faints the target, you gain lots of money after the battle. (Plunder)
#===============================================================================
class PokeBattle_Move_IfFaintsTargetAddTonsOfMoneyGainedFromBattle < PokeBattle_Move
    MONEY_MULTIPLIER = 30

    def pbEffectAfterAllHits(user, target)
        return unless target.damageState.fainted
        user.generateMoney(MONEY_MULTIPLIER)
    end

    def getFaintEffectScore(user, _target)
        return user.getCashFlowEffectScore(MONEY_MULTIPLIER)
    end
end