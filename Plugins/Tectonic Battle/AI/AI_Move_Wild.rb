class PokeBattle_AI
    def pbChooseMovesWild(idxBattler)
        battler = @battle.battlers[idxBattler]
        moveIndex = battler.turnCount % battler.getMoves.length
        unless @battle.pbRegisterMove(idxBattler, moveIndex, false)
            @battle.pbAutoChooseMove(idxBattler)
        end
    end
end
