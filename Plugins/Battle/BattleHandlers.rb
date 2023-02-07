module BattleHandlers
    # Battler's speed calculation
    SpeedCalcAbility                    = AbilityHandlerHash.new
    SpeedCalcItem                       = ItemHandlerHash.new
    # Battler's weight calculation
    WeightCalcAbility                   = AbilityHandlerHash.new
    WeightCalcItem                      = ItemHandlerHash.new # Float Stone
    # Battler's HP changed
    HPHealItem                          = ItemHandlerHash.new
    AbilityOnHPDroppedBelowHalf         = AbilityHandlerHash.new
    # Battler's status problem
    StatusCheckAbilityNonIgnorable      = AbilityHandlerHash.new   # Comatose
    StatusImmunityAbility               = AbilityHandlerHash.new
    StatusImmunityAbilityNonIgnorable   = AbilityHandlerHash.new
    StatusImmunityAllyAbility           = AbilityHandlerHash.new
    AbilityOnStatusInflicted            = AbilityHandlerHash.new   # Synchronize
    StatusCureItem                      = ItemHandlerHash.new
    StatusCureAbility                   = AbilityHandlerHash.new
    # Battler's stat stages
    StatLossImmunityAbility             = AbilityHandlerHash.new
    StatLossImmunityAbilityNonIgnorable = AbilityHandlerHash.new   # Full Metal Body
    StatLossImmunityAllyAbility         = AbilityHandlerHash.new   # Flower Veil
    AbilityOnStatGain                   = AbilityHandlerHash.new
    AbilityOnEnemyStatGain              = AbilityHandlerHash.new
    AbilityOnStatLoss                   = AbilityHandlerHash.new
    # Priority and turn order
    PriorityChangeAbility               = AbilityHandlerHash.new
    PriorityBracketChangeAbility        = AbilityHandlerHash.new   # Stall
    PriorityBracketChangeItem           = ItemHandlerHash.new
    PriorityBracketUseAbility           = AbilityHandlerHash.new   # None!
    PriorityBracketUseItem              = ItemHandlerHash.new
    # Move usage failures
    AbilityOnFlinch                     = AbilityHandlerHash.new # Steadfast
    MoveBlockingAbility                 = AbilityHandlerHash.new
    MoveImmunityTargetAbility           = AbilityHandlerHash.new
    MoveImmunityAllyAbility = AbilityHandlerHash.new
    # Move usage
    MoveBaseTypeModifierAbility         = AbilityHandlerHash.new
    # Accuracy calculation
    AccuracyCalcUserAbility             = AbilityHandlerHash.new
    AccuracyCalcUserAllyAbility         = AbilityHandlerHash.new # Victory Star
    AccuracyCalcTargetAbility           = AbilityHandlerHash.new
    AccuracyCalcUserItem                = ItemHandlerHash.new
    AccuracyCalcTargetItem              = ItemHandlerHash.new
    # Damage calculation
    DamageCalcUserAbility               = AbilityHandlerHash.new
    DamageCalcUserAllyAbility           = AbilityHandlerHash.new
    DamageCalcTargetAbility             = AbilityHandlerHash.new
    DamageCalcTargetAbilityNonIgnorable = AbilityHandlerHash.new
    DamageCalcTargetAllyAbility         = AbilityHandlerHash.new
    DamageCalcUserItem                  = ItemHandlerHash.new
    DamageCalcTargetItem                = ItemHandlerHash.new
    # Attack calculation
    AttackCalcUserAbility = AbilityHandlerHash.new
    AttackCalcAllyAbility = AbilityHandlerHash.new
    AttackCalcUserItem                  = ItemHandlerHash.new
    # Special Attack calculation
    SpecialAttackCalcUserAbility        = AbilityHandlerHash.new
    SpecialAttackCalcAllyAbility        = AbilityHandlerHash.new
    SpecialAttackCalcUserItem           = ItemHandlerHash.new
    # Defense calculation
    DefenseCalcUserAbility = AbilityHandlerHash.new
    DefenseCalcAllyAbility = AbilityHandlerHash.new
    DefenseCalcUserItem                  = ItemHandlerHash.new
    # Special Defense calculation
    SpecialDefenseCalcUserAbility        = AbilityHandlerHash.new
    SpecialDefenseCalcAllyAbility        = AbilityHandlerHash.new
    SpecialDefenseCalcUserItem           = ItemHandlerHash.new
    # Critical hit calculation
    CriticalCalcUserAbility = AbilityHandlerHash.new
    GuaranteedCriticalUserAbility	= AbilityHandlerHash.new
    CriticalCalcTargetAbility = AbilityHandlerHash.new
    CriticalPreventTargetAbility	= AbilityHandlerHash.new
    CriticalCalcUserItem                = ItemHandlerHash.new
    CriticalCalcTargetItem              = ItemHandlerHash.new # None!
    # Upon a move hitting a target
    TargetAbilityOnHit                  = AbilityHandlerHash.new
    UserAbilityOnHit                    = AbilityHandlerHash.new # Poison Touch
    TargetItemOnHit                     = ItemHandlerHash.new
    TargetItemOnHitPositiveBerry        = ItemHandlerHash.new
    # Abilities/items that trigger at the end of using a move
    UserAbilityEndOfMove                = AbilityHandlerHash.new
    TargetItemAfterMoveUse              = ItemHandlerHash.new
    UserItemAfterMoveUse                = ItemHandlerHash.new
    TargetAbilityAfterMoveUse           = AbilityHandlerHash.new
    EndOfMoveItem                       = ItemHandlerHash.new   # Leppa Berry
    EndOfMoveStatRestoreItem            = ItemHandlerHash.new   # White Herb
    # Experience and EV gain
    ExpGainModifierItem                 = ItemHandlerHash.new # Lucky Egg
    EVGainModifierItem                  = ItemHandlerHash.new
    # Weather and terrin
    WeatherExtenderItem                 = ItemHandlerHash.new
    TerrainExtenderItem                 = ItemHandlerHash.new # Terrain Extender
    TerrainStatBoostItem                = ItemHandlerHash.new
    # End Of Round
    EORWeatherAbility                   = AbilityHandlerHash.new
    EORHealingAbility                   = AbilityHandlerHash.new
    EORHealingItem                      = ItemHandlerHash.new
    EOREffectAbility                    = AbilityHandlerHash.new
    EOREffectItem                       = ItemHandlerHash.new
    EORGainItemAbility                  = AbilityHandlerHash.new
    # Switching and fainting
    CertainSwitchingUserAbility         = AbilityHandlerHash.new # None!
    CertainSwitchingUserItem            = ItemHandlerHash.new   # Shed Shell
    TrappingTargetAbility               = AbilityHandlerHash.new
    TrappingTargetItem                  = ItemHandlerHash.new   # None!
    AbilityOnSwitchIn                   = AbilityHandlerHash.new
    AbilityOnEnemySwitchIn              = AbilityHandlerHash.new
    ItemOnSwitchIn = ItemHandlerHash.new # Air Balloon
    ItemOnIntimidated                   = ItemHandlerHash.new # Adrenaline Orb
    AbilityOnSwitchOut                  = AbilityHandlerHash.new
    AbilityChangeOnBattlerFainting      = AbilityHandlerHash.new
    AbilityOnBattlerFainting            = AbilityHandlerHash.new # Soul-Heart
    # Running from battle
    RunFromBattleAbility                = AbilityHandlerHash.new # Run Away
    RunFromBattleItem                   = ItemHandlerHash.new # Smoke Ball
    # Consuming items
    OnBerryConsumedAbility              = AbilityHandlerHash.new
    # Other triggers
    ItemOnEnemyStatGain                 = ItemHandlerHash.new
    ItemOnStatLoss                      = ItemHandlerHash.new
    FieldEffectStatLossItem	            = ItemHandlerHash.new

    #=============================================================================

    def self.triggerSpeedCalcAbility(ability, battler, mult)
        ret = SpeedCalcAbility.trigger(ability, battler, mult)
        return !ret.nil? ? ret : mult
    end

    def self.triggerSpeedCalcItem(item, battler, mult)
        ret = SpeedCalcItem.trigger(item, battler, mult)
        return !ret.nil? ? ret : mult
    end

    #=============================================================================

    def self.triggerWeightCalcAbility(ability, battler, w)
        ret = WeightCalcAbility.trigger(ability, battler, w)
        return !ret.nil? ? ret : w
    end

    def self.triggerWeightCalcItem(item, battler, w)
        ret = WeightCalcItem.trigger(item, battler, w)
        return !ret.nil? ? ret : w
    end

    #=============================================================================

    def self.triggerHPHealItem(item, battler, battle, forced)
        ret = HPHealItem.trigger(item, battler, battle, forced)
        return !ret.nil? ? ret : false
    end

    def self.triggerAbilityOnHPDroppedBelowHalf(ability, user, battle)
        ret = AbilityOnHPDroppedBelowHalf.trigger(ability, user, battle)
        return !ret.nil? ? ret : false
    end

    #=============================================================================

    def self.triggerStatusCheckAbilityNonIgnorable(ability, battler, status)
        ret = StatusCheckAbilityNonIgnorable.trigger(ability, battler, status)
        return !ret.nil? ? ret : false
    end

    def self.triggerStatusImmunityAbility(ability, battler, status)
        ret = StatusImmunityAbility.trigger(ability, battler, status)
        return !ret.nil? ? ret : false
    end

    def self.triggerStatusImmunityAbilityNonIgnorable(ability, battler, status)
        ret = StatusImmunityAbilityNonIgnorable.trigger(ability, battler, status)
        return !ret.nil? ? ret : false
    end

    def self.triggerStatusImmunityAllyAbility(ability, battler, status)
        ret = StatusImmunityAllyAbility.trigger(ability, battler, status)
        return !ret.nil? ? ret : false
    end

    def self.triggerAbilityOnStatusInflicted(ability, battler, user, status)
        AbilityOnStatusInflicted.trigger(ability, battler, user, status)
    end

    def self.triggerStatusCureItem(item, battler, battle, forced)
        ret = StatusCureItem.trigger(item, battler, battle, forced)
        return !ret.nil? ? ret : false
    end

    def self.triggerStatusCureAbility(ability, battler)
        ret = StatusCureAbility.trigger(ability, battler)
        return !ret.nil? ? ret : false
    end

    #=============================================================================

    def self.triggerStatLossImmunityAbility(ability, battler, stat, battle, showMessages)
        ret = StatLossImmunityAbility.trigger(ability, battler, stat, battle, showMessages)
        return !ret.nil? ? ret : false
    end

    def self.triggerStatLossImmunityAbilityNonIgnorable(ability, battler, stat, battle, showMessages)
        ret = StatLossImmunityAbilityNonIgnorable.trigger(ability, battler, stat, battle, showMessages)
        return !ret.nil? ? ret : false
    end

    def self.triggerStatLossImmunityAllyAbility(ability, bearer, battler, stat, battle, showMessages)
        ret = StatLossImmunityAllyAbility.trigger(ability, bearer, battler, stat, battle, showMessages)
        return !ret.nil? ? ret : false
    end

    def self.triggerAbilityOnStatGain(ability, battler, stat, user)
        AbilityOnStatGain.trigger(ability, battler, stat, user)
    end

    def self.triggerAbilityOnEnemyStatGain(ability, battler, stat, user, benefactor)
        AbilityOnEnemyStatGain.trigger(ability, battler, stat, user, benefactor)
    end

    def self.triggerAbilityOnStatLoss(ability, battler, stat, user)
        AbilityOnStatLoss.trigger(ability, battler, stat, user)
    end

    #=============================================================================

    def self.triggerPriorityChangeAbility(ability, battler, move, pri, targets = [], aiCheck)
        ret = PriorityChangeAbility.trigger(ability, battler, move, pri, targets, aiCheck)
        return !ret.nil? ? ret : 0
    end

    def self.triggerPriorityBracketChangeAbility(ability, battler, subPri, battle)
        ret = PriorityBracketChangeAbility.trigger(ability, battler, subPri, battle)
        return !ret.nil? ? ret : subPri
    end

    def self.triggerPriorityBracketChangeItem(item, battler, subPri, battle)
        ret = PriorityBracketChangeItem.trigger(item, battler, subPri, battle)
        return !ret.nil? ? ret : subPri
    end

    def self.triggerPriorityBracketUseAbility(ability, battler, battle)
        PriorityBracketUseAbility.trigger(ability, battler, battle)
    end

    def self.triggerPriorityBracketUseItem(item, battler, battle)
        PriorityBracketUseItem.trigger(item, battler, battle)
    end

    #=============================================================================

    def self.triggerAbilityOnFlinch(ability, battler, battle)
        AbilityOnFlinch.trigger(ability, battler, battle)
    end

    def self.triggerMoveBlockingAbility(ability, bearer, user, targets, move, battle)
        ret = MoveBlockingAbility.trigger(ability, bearer, user, targets, move, battle)
        return !ret.nil? ? ret : false
    end

    def self.triggerMoveImmunityTargetAbility(ability, user, target, move, type, battle, showMessages, aiChecking)
        ret = MoveImmunityTargetAbility.trigger(ability, user, target, move, type, battle, showMessages, aiChecking)
        return !ret.nil? ? ret : false
    end

    def self.triggerMoveImmunityAllyAbility(ability, user, target, move, type, battle, ally, showMessages)
        ret = MoveImmunityAllyAbility.trigger(ability, user, target, move, type, battle, ally, showMessages)
        return !ret.nil? ? ret : false
    end

    #=============================================================================

    def self.triggerMoveBaseTypeModifierAbility(ability, user, move, type)
        ret = MoveBaseTypeModifierAbility.trigger(ability, user, move, type)
        return !ret.nil? ? ret : type
    end

    #=============================================================================

    def self.triggerAccuracyCalcUserAbility(ability, mults, user, target, move, type)
        AccuracyCalcUserAbility.trigger(ability, mults, user, target, move, type)
    end

    def self.triggerAccuracyCalcUserAllyAbility(ability, mults, user, target, move, type)
        AccuracyCalcUserAllyAbility.trigger(ability, mults, user, target, move, type)
    end

    def self.triggerAccuracyCalcTargetAbility(ability, mults, user, target, move, type)
        AccuracyCalcTargetAbility.trigger(ability, mults, user, target, move, type)
    end

    def self.triggerAccuracyCalcUserItem(item, mults, user, target, move, type)
        AccuracyCalcUserItem.trigger(item, mults, user, target, move, type)
    end

    def self.triggerAccuracyCalcTargetItem(item, mults, user, target, move, type)
        AccuracyCalcTargetItem.trigger(item, mults, user, target, move, type)
    end

    #=============================================================================

    def self.triggerDamageCalcUserAbility(ability, user, target, move, mults, baseDmg, type, aiChecking = false)
        DamageCalcUserAbility.trigger(ability, user, target, move, mults, baseDmg, type, aiChecking)
    end

    def self.triggerDamageCalcUserAllyAbility(ability, user, target, move, mults, baseDmg, type, aiChecking = false)
        DamageCalcUserAllyAbility.trigger(ability, user, target, move, mults, baseDmg, type, aiChecking)
    end

    def self.triggerDamageCalcUserItem(item, user, target, move, mults, baseDmg, type, aiChecking = false)
        DamageCalcUserItem.trigger(item, user, target, move, mults, baseDmg, type, aiChecking)
    end

    #=============================================================================

    def self.triggerDamageCalcTargetAbility(ability, user, target, move, mults, baseDmg, type)
        DamageCalcTargetAbility.trigger(ability, user, target, move, mults, baseDmg, type)
    end

    def self.triggerDamageCalcTargetAbilityNonIgnorable(ability, user, target, move, mults, baseDmg, type)
        DamageCalcTargetAbilityNonIgnorable.trigger(ability, user, target, move, mults, baseDmg, type)
    end

    def self.triggerDamageCalcTargetAllyAbility(ability, user, target, move, mults, baseDmg, type)
        DamageCalcTargetAllyAbility.trigger(ability, user, target, move, mults, baseDmg, type)
    end

    def self.triggerDamageCalcTargetItem(item, user, target, move, mults, baseDmg, type)
        DamageCalcTargetItem.trigger(item, user, target, move, mults, baseDmg, type)
    end

    #=============================================================================

    def self.triggerAttackCalcUserAbility(ability, user, battle, attackMult)
        ret = AttackCalcUserAbility.trigger(ability, user, battle, attackMult)
        return ret || attackMult
    end

    def self.triggerAttackCalcAllyAbility(ability, user, battle, attackMult)
        ret = AttackCalcAllyAbility.trigger(ability, user, battle, attackMult)
        return ret || attackMult
    end

    def self.triggerAttackCalcUserItem(item, user, battle, attackMult)
        ret = AttackCalcUserItem.trigger(item, user, battle, attackMult)
        return ret || attackMult
    end

    #=============================================================================

    def self.triggerSpecialAttackCalcUserAbility(ability, user, battle, spAtkMult)
        ret = SpecialAttackCalcUserAbility.trigger(ability, user, battle, spAtkMult)
        return ret || spAtkMult
    end

    def self.triggerSpecialAttackCalcAllyAbility(ability, user, battle, spAtkMult)
        ret = SpecialAttackCalcAllyAbility.trigger(ability, user, battle, spAtkMult)
        return ret || spAtkMult
    end

    def self.triggerSpecialAttackCalcUserItem(item, user, battle, spAtkMult)
        ret = SpecialAttackCalcUserItem.trigger(item, user, battle, spAtkMult)
        return ret || spAtkMult
    end

    #=============================================================================

    def self.triggerDefenseCalcUserAbility(ability, user, battle, defenseMult)
        ret = DefenseCalcUserAbility.trigger(ability, user, battle, defenseMult)
        return ret || defenseMult
    end

    def self.triggerDefenseCalcAllyAbility(ability, user, battle, defenseMult)
        ret = DefenseCalcAllyAbility.trigger(ability, user, battle, defenseMult)
        return ret || defenseMult
    end

    def self.triggerDefenseCalcUserItem(item, user, battle, defenseMult)
        ret = DefenseCalcUserItem.trigger(item, user, battle, defenseMult)
        return ret || defenseMult
    end

    #=============================================================================

    def self.triggerSpecialDefenseCalcUserAbility(ability, user, battle, spDefMult)
        ret = SpecialDefenseCalcUserAbility.trigger(ability, user, battle, spDefMult)
        return ret || spDefMult
    end

    def self.triggerSpecialDefenseCalcAllyAbility(ability, user, battle, spDefMult)
        ret = SpecialDefenseCalcAllyAbility.trigger(ability, user, battle, spDefMult)
        return ret || spDefMult
    end

    def self.triggerSpecialDefenseCalcUserItem(item, user, battle, spDefMult)
        ret = SpecialDefenseCalcUserItem.trigger(item, user, battle, spDefMult)
        return ret || spDefMult
    end

    #=============================================================================

    def self.triggerCriticalCalcUserAbility(ability, user, target, move, c)
        ret = CriticalCalcUserAbility.trigger(ability, user, target, move, c)
        return !ret.nil? ? ret : c
    end

    def self.triggerGuaranteedCriticalUserAbility(ability, user, target, battle)
        ret = GuaranteedCriticalUserAbility.trigger(ability, user, target, battle)
        return !ret.nil? ? ret : false
    end

    def self.triggerCriticalCalcTargetAbility(ability, user, target, c)
        ret = CriticalCalcTargetAbility.trigger(ability, user, target, c)
        return !ret.nil? ? ret : c
    end

    def self.triggerCriticalPreventTargetAbility(ability, user, target, battle)
        ret = CriticalPreventTargetAbility.trigger(ability, user, target, battle)
        return !ret.nil? ? ret : false
    end

    def self.triggerCriticalCalcUserItem(item, user, target, c)
        ret = CriticalCalcUserItem.trigger(item, user, target, c)
        return !ret.nil? ? ret : c
    end

    def self.triggerCriticalCalcTargetItem(item, user, target, c)
        ret = CriticalCalcTargetItem.trigger(item, user, target, c)
        return !ret.nil? ? ret : c
    end

    #=============================================================================

    def self.triggerTargetAbilityOnHit(ability, user, target, move, battle)
        TargetAbilityOnHit.trigger(ability, user, target, move, battle)
    end

    def self.triggerUserAbilityOnHit(ability, user, target, move, battle)
        UserAbilityOnHit.trigger(ability, user, target, move, battle)
    end

    def self.triggerTargetItemOnHit(item, user, target, move, battle)
        TargetItemOnHit.trigger(item, user, target, move, battle)
    end

    def self.triggerTargetItemOnHitPositiveBerry(item, battler, battle, forced)
        ret = TargetItemOnHitPositiveBerry.trigger(item, battler, battle, forced)
        return !ret.nil? ? ret : false
    end

    #=============================================================================

    def self.triggerUserAbilityEndOfMove(ability, user, targets, move, battle, switchedBattlers)
        UserAbilityEndOfMove.trigger(ability, user, targets, move, battle, switchedBattlers)
    end

    def self.triggerTargetItemAfterMoveUse(item, battler, user, move, switched, battle)
        TargetItemAfterMoveUse.trigger(item, battler, user, move, switched, battle)
    end

    def self.triggerUserItemAfterMoveUse(item, user, targets, move, numHits, battle)
        UserItemAfterMoveUse.trigger(item, user, targets, move, numHits, battle)
    end

    def self.triggerTargetAbilityAfterMoveUse(ability, target, user, move, switched, battle)
        TargetAbilityAfterMoveUse.trigger(ability, target, user, move, switched, battle)
    end

    def self.triggerEndOfMoveItem(item, battler, battle, forced)
        ret = EndOfMoveItem.trigger(item, battler, battle, forced)
        return !ret.nil? ? ret : false
    end

    def self.triggerEndOfMoveStatRestoreItem(item, battler, battle, forced)
        ret = EndOfMoveStatRestoreItem.trigger(item, battler, battle, forced)
        return !ret.nil? ? ret : false
    end

    #=============================================================================

    def self.triggerExpGainModifierItem(item, battler, exp)
        ret = ExpGainModifierItem.trigger(item, battler, exp)
        return !ret.nil? ? ret : -1
    end

    def self.triggerEVGainModifierItem(item, battler, evarray)
        return false unless EVGainModifierItem[item]
        EVGainModifierItem.trigger(item, battler, evarray)
        return true
    end

    #=============================================================================

    def self.triggerWeatherExtenderItem(item, weather, duration, battler, battle)
        ret = WeatherExtenderItem.trigger(item, weather, duration, battler, battle)
        return !ret.nil? ? ret : duration
    end

    def self.triggerTerrainExtenderItem(item, terrain, duration, battler, battle)
        ret = TerrainExtenderItem.trigger(item, terrain, duration, battler, battle)
        return !ret.nil? ? ret : duration
    end

    def self.triggerTerrainStatBoostItem(item, battler, battle)
        ret = TerrainStatBoostItem.trigger(item, battler, battle)
        return !ret.nil? ? ret : false
    end

    #=============================================================================

    def self.triggerEORWeatherAbility(ability, weather, battler, battle)
        EORWeatherAbility.trigger(ability, weather, battler, battle)
    end

    def self.triggerEORHealingAbility(ability, battler, battle)
        EORHealingAbility.trigger(ability, battler, battle)
    end

    def self.triggerEORHealingItem(item, battler, battle)
        EORHealingItem.trigger(item, battler, battle)
    end

    def self.triggerEOREffectAbility(ability, battler, battle)
        EOREffectAbility.trigger(ability, battler, battle)
    end

    def self.triggerEOREffectItem(item, battler, battle)
        EOREffectItem.trigger(item, battler, battle)
    end

    def self.triggerEORGainItemAbility(ability, battler, battle)
        EORGainItemAbility.trigger(ability, battler, battle)
    end

    #=============================================================================

    def self.triggerCertainSwitchingUserAbility(ability, switcher, battle, trappingProc)
        ret = CertainSwitchingUserAbility.trigger(ability, switcher, battle, trappingProc)
        return !ret.nil? ? ret : false
    end

    def self.triggerCertainSwitchingUserItem(item, switcher, battle)
        ret = CertainSwitchingUserItem.trigger(item, switcher, battle)
        return !ret.nil? ? ret : false
    end

    def self.triggerTrappingTargetAbility(ability, switcher, bearer, battle)
        ret = TrappingTargetAbility.trigger(ability, switcher, bearer, battle)
        return !ret.nil? ? ret : false
    end

    def self.triggerTrappingTargetItem(item, switcher, bearer, battle)
        ret = TrappingTargetItem.trigger(item, switcher, bearer, battle)
        return !ret.nil? ? ret : false
    end

    def self.triggerAbilityOnSwitchIn(ability, battler, battle)
        AbilityOnSwitchIn.trigger(ability, battler, battle)
    end

    def self.triggerAbilityOnEnemySwitchIn(ability, switcher, bearer, battle)
        AbilityOnEnemySwitchIn.trigger(ability, switcher, bearer, battle)
    end

    def self.triggerItemOnSwitchIn(item, battler, battle)
        ItemOnSwitchIn.trigger(item, battler, battle)
    end

    def self.triggerItemOnIntimidated(item, battler, battle)
        ret = ItemOnIntimidated.trigger(item, battler, battle)
        return !ret.nil? ? ret : false
    end

    def self.triggerAbilityOnSwitchOut(ability, battler, endOfBattle)
        AbilityOnSwitchOut.trigger(ability, battler, endOfBattle)
    end

    def self.triggerAbilityChangeOnBattlerFainting(ability, battler, fainted, battle)
        AbilityChangeOnBattlerFainting.trigger(ability, battler, fainted, battle)
    end

    def self.triggerAbilityOnBattlerFainting(ability, battler, fainted, battle)
        AbilityOnBattlerFainting.trigger(ability, battler, fainted, battle)
    end

    #=============================================================================

    def self.triggerRunFromBattleAbility(ability, battler)
        ret = RunFromBattleAbility.trigger(ability, battler)
        return !ret.nil? ? ret : false
    end

    def self.triggerRunFromBattleItem(item, battler)
        ret = RunFromBattleItem.trigger(item, battler)
        return !ret.nil? ? ret : false
    end

    #=============================================================================

    def self.triggerOnBerryConsumedAbility(ability, user, berry, own_item, battle)
        ret = OnBerryConsumedAbility.trigger(ability, user, berry, own_item, battle)
        return !ret.nil? ? ret : false
    end

    #=============================================================================

    def self.triggerItemOnEnemyStatGain(item, battler, user, battle, benefactor)
        ItemOnEnemyStatGain.trigger(item, battler, user, battle, benefactor)
    end

    def self.triggerItemOnStatLoss(item, battler, user, move, switched, battle)
        ItemOnStatLoss.trigger(item, battler, user, move, switched, battle)
    end

    def self.triggerFieldEffectItem(item, battler, battle)
        FieldEffectStatLossItem.trigger(item, battler, battle)
    end
end
