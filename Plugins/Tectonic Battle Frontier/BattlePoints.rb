def earnBattlePoints(battlePointsAdded = 1)
    $Trainer.battle_points += battlePointsAdded
    pbMessage(_INTL("\\me[Earn battle points]\\ptYou've earned {1} battle points.\\wtnp[70]", battlePointsAdded))
end