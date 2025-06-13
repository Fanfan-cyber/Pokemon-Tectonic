class PokeBattle_Battler
    def generateMoney(multiplier)
        return unless pbOwnedByPlayer?
        pseudoLevel = rescaleLevelForStats(@level)
        moneyDropped = pseudoLevel * multiplier
        moneyDropped = (moneyDropped * @battle.moneyMult).floor
        @battle.field.incrementEffect(:PayDay, moneyDropped)
    end
end