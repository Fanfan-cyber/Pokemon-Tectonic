class PokeBattle_Battler
    def generateMoney(multiplier)
        pbOwnSide.incrementEffect(:PayDay, calcMoney(multiplier))
    end

    def calcMoney(multiplier)
        pseudoLevel = rescaleLevelForStats(@level)
        moneyDropped = pseudoLevel * multiplier
        (moneyDropped * @battle.moneyMult).floor
    end
end