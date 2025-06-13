#===============================================================================
# Scatters coins that the player picks up after winning the battle. (Pay Day)
#===============================================================================
class PokeBattle_Move_AddMoneyGainedFromBattle < PokeBattle_Move
    def pbEffectGeneral(user)
        user.generateMoney(10)
    end
end

#===============================================================================
# Scatters lots of coins that the player picks up after winning the battle. (Cha-ching)
#===============================================================================
class PokeBattle_Move_AddLotsOfMoneyGainedFromBattle < PokeBattle_Move
    def pbEffectGeneral(user)
        user.generateMoney(15)
    end
end

#===============================================================================
# If it faints the target, you gain lots of money after the battle. (Plunder)
#===============================================================================
class PokeBattle_Move_IfFaintsTargetAddTonsOfMoneyGainedFromBattle < PokeBattle_Move
    def pbEffectAfterAllHits(user, target)
        return unless target.damageState.fainted
        user.generateMoney(30)
    end
end