class PokeBattle_Battle
    #=============================================================================
    # End Of Round phase
    #=============================================================================
    def pbEndOfRoundPhase
        PBDebug.log("")
        PBDebug.log("[End of round]")
        @endOfRound = true

        checkForInvalidEffectStates

        @scene.pbBeginEndOfRoundPhase
        pbCalculatePriority           # recalculate speeds
        priority = pbPriority(true)   # in order of fastest -> slowest speeds only

        checkBattleStateAchievements(self)

        if @field.effectActive?(:EmotionRoom)
            priority.each { |b|
               next if b.fainted?
               b.add_random_ability(true)
=begin
                next if b.immutableAbility?
                possibleAbilitySwitches = []
                b.legalAbilities.each do |abil|
                    next if b.hasAbility?(abil)
                    possibleAbilitySwitches.push(abil)
                end
                next unless possibleAbilitySwitches.length >= 1
                newAbility = possibleAbilitySwitches.sample
                pbDisplay(_INTL("{1} was overwhelmed with emotion!", b.pbThis))
                b.replaceAbility(newAbility)
=end
            }
        end

        pbEORHealing(priority)

        pbEORWeather(priority)

        pbEORStatusDamage(priority)

        countDownPerishSong(priority)

        # Check for end of battle
        if @decision > 0
            pbGainExp
            return
        end

        # Curses effects here
        @curses.each do |curse_policy|
            triggerEndOfTurnCurseEffect(curse_policy, self)
        end

        # Reset the echoed voice counter unless anyone used echoed voice this turn
        @sides.each do |side|
            side.disableEffect(:EchoedVoiceCounter) unless side.effectActive?(:EchoedVoiceUsed)
        end

        # Tick down or reset battle effects
        allEffectHolders do |effectHolder|
            effectHolder.processEffectsEOR
        end

        processTriggersEOR(priority)

        end_of_round_field_process

        tick_down_step_counter(priority)

        pbGainExp

        return if @decision > 0

        # Form checks
        priority.each { |b| b.pbCheckForm(true) }

        # Switch Healing Rest part
        field_battlers = field_battlers_id
        (@party1 + @party2).each do |pkmn|
            next unless pkmn
            next unless tracker_get(:battled_battlers).include?(pkmn.unique_id)
            next if tracker_get(:turn_switched)[pkmn.unique_id] == @turnCount
            next if pkmn.fainted?
            next if pkmn.pinch?
            next if pkmn.has_status?
            next if field_battlers.include?(pkmn.unique_id)
            pkmn.healByFraction(Settings::REST_HEALING_NUM / 100.0)
        end

        # Switch Pokémon in if possible
        pbEORSwitch

        return if @decision > 0

        # In battles with at least one side of size 3+, move battlers around if none
        # are near to any foes
        pbEORShiftDistantBattlers

        # Try to make Trace work, check for end of primordial weather
        priority.each { |b| b.pbContinualAbilityChecks }

        eachBattler do |b|
            b.modifyTrackersEOR
        end

        # Neutralizing Gas
        pbCheckNeutralizingGas

        checkForInvalidEffectStates

        @endOfRound = false
    end

    def pbEORHealing(priority)
        # Status-curing effects/abilities and HP-healing items
        priority.each do |b|
            next if b.fainted?
            # Healer, Hydration, Shed Skin
            b.eachActiveAbility do |ability|
                BattleHandlers.triggerEORHealingAbility(ability, b, self)
            end
            # Black Sludge, Leftovers
            b.eachActiveItem do |item|
                BattleHandlers.triggerEORHealingItem(item, b, self)
            end
        end
    end

    def damageFromDOTStatus(battler, status, aiCheck = false)
        if battler.takesIndirectDamage? && !battler.hasActiveAbility?(:PLACIDITY)
            if %i[POISON LEECHED].include?(status)
                fraction = 1.0 / 10.0
            else
                fraction = 1.0 / 16.0
            end
            fraction *= 2 if battler.pbOwnedByPlayer? && curseActive?(:CURSE_STATUS_DOUBLED)
            fraction *= 2 if battler.hasActiveAbility?(:CLEANFREAK)
            if status == :POISON
                battler.getPoisonDoublings.times do
                    fraction *= 2
                end
            end
            damage = 0
            if aiCheck
                damage = battler.applyFractionalDamage(fraction, false, aiCheck: true)
            else
                battler.pbContinueStatus(status) do
                    damage = battler.applyFractionalDamage(fraction)
                end
                triggerDOTDeathDialogue(battler) if battler.fainted?
            end
            return damage
        end
        return 0
    end

    def pbEORStatusDamage(priority)
        if pbCheckGlobalAbility(:INEXORABLE)
            battlersInOrder = []
            pbParty(0).each do |partyMember, partyIndex|
                next unless partyMember
                dummyBattler = PokeBattle_Battler.new(self, 0)
                dummyBattler.pbInitDummyPokemon(partyMember, partyIndex)
                battlersInOrder.push(dummyBattler)
            end
            pbParty(1).each do |partyMember, partyIndex|
                next unless partyMember
                dummyBattler = PokeBattle_Battler.new(self, 1)
                dummyBattler.pbInitDummyPokemon(partyMember, partyIndex)
                battlersInOrder.push(dummyBattler)
            end
        else
            battlersInOrder = priority.clone
        end

        # Damage from poisoning
        battlersInOrder.each do |b|
            next if b.fainted?
            next unless b.poisoned?
            damageDealt = damageFromDOTStatus(b, :POISON)

            # Venom Gorger
            if b.getStatusCount(:POISON) % POISON_DOUBLING_TURNS == 0 && !b.fainted?
                b.eachOpposing do |opposingB|
                    next unless opposingB.hasActiveAbility?(:VENOMGORGER)
                    healingMessage = _INTL("{1} slurped up venom leaking from {2}.", opposingB.pbThis, b.pbThis(true))
                    opposingB.applyFractionalHealing(0.5 / 2.0, ability: :VENOMGORGER, customMessage: healingMessage)
                end
            end

            # Toxin Tax
            if damageDealt > 0
                priority.each do |b|
                    next unless b.hasActiveAbility?(:TOXINTAX)
                    pbShowAbilitySplash(b, :TOXINTAX)
                    healingMessage = _INTL("{1} absorbs the damage from the poison.", b.pbThis)
                    b.pbRecoverHP(damageDealt, true, true, true, healingMessage)
                    pbHideAbilitySplash(b)
                end
            end
        end
        # Damage from burn
        battlersInOrder.each do |b|
            next if b.fainted?
            next unless b.burned?
            damageFromDOTStatus(b, :BURN)
        end
        # Damage from frostbite
        battlersInOrder.each do |b|
            next if b.fainted?
            next unless b.frostbitten?
            damageFromDOTStatus(b, :FROSTBITE)
        end
        # Leeched
        battlersInOrder.each do |b|
            next if b.fainted?
            next unless b.leeched?
            enemyCount = 0
            b.eachOpposing do |opposingBattler|
                enemyCount += 1
            end
            next if enemyCount == 0
            leechedHP = damageFromDOTStatus(b, :LEECHED)
            next if leechedHP <= 0
            healthRestore = leechedHP / enemyCount.to_f
            b.eachOpposing do |opposingBattler|
                opposingBattler.pbRecoverHPFromDrain(healthRestore, b)
            end
        end
    end

    def countDownPerishSong(priority)
        # Perish Song
        fainters = []
        priority.each do |b|
            next if b.fainted?
            next unless b.effectActive?(:PerishSong)
            pbDisplay(_INTL("{1}'s perish count fell to {2}!", b.pbThis, b.effects[:PerishSong] - 1))
            b.tickDownAndProc(:PerishSong)
        end
    end

    def processTriggersEOR(priority)
        # End of Round Effect Abilities
        priority.each do |b|
            next if b.fainted?
            # Bad Dreams, Moody, Speed Boost
            b.eachActiveAbility do |ability|
                BattleHandlers.triggerEOREffectAbility(ability, b, self)
            end
        end
        # End of Round Effect Items
        priority.each do |b|
            next if b.fainted?
            # Flame Orb, Sticky Barb, Toxic Orb
            b.eachActiveItem do |item|
                BattleHandlers.triggerEOREffectItem(item, b, self)
            end
        end
        # End of Round Item Gain abilities
        priority.each do |b|
            next if b.fainted?
            # Harvest, Pickup
            b.eachActiveAbility do |ability|
                BattleHandlers.triggerEORGainItemAbility(ability, b, self)
            end
        end
    end

    def tick_down_step_counter(priority)
        priority.each do |b|
            next if b.fainted?
            step_counter = b.tracker_get(:step_counter)
            step_data = Hash.new(0)
            step_counter.each_key do |stat|
                step_counter[stat].each do |counter| # [[increment1, remaining1], [increment2, remaining2], [increment3, remaining3], ...]
                    counter[1] -= 1
                    if counter[1] == 0
                        b.steps[stat] -= counter[0]
                        step_data[stat] += counter[0]
                    end
                end
                step_counter[stat].reject! { |counter| counter[1] == 0 }
            end
            next if step_data.empty?
            step_data.each do |stat, amount|
                next if amount == 0
                if amount > 0
                    pbDisplay(_INTL("{1}'s raised {2} recovered by {3}!", b.pbThis, GameData::Stat.get(stat).name, amount)) 
                else
                    pbDisplay(_INTL("{1}'s lowered {2} recovered by {3}!", b.pbThis, GameData::Stat.get(stat).name, amount)) 
                end
            end
        end
    end

    def checkForInvalidEffectStates
        allEffectHolders do |effectHolder|
            effectHolder.effects.each do |effect, value|
                effectData = GameData::BattleEffect.try_get(effect)
                raise _INTL("Effect \"#{effectData.name}\" is not a defined effect.") if effectData.nil?
                next if effectData.valid_value?(value)
                raise _INTL("Effect \"#{effectData.name}\" is in invalid state: #{value}")

                mainEffectActive = effectData.active_value?(value)

                effectData.each_sub_effect do |sub_effect|
                    sub_active = effectActive?(sub_effect)
                    if sub_active != mainEffectActive
                        raise _INTL("Sub-Effect #{getData(sub_effect).name} of effect #{effectData.name} has mismatched activity status")
                    end
                end
            end
        end
    end

    #=============================================================================
    # End Of Round shift distant battlers to middle positions
    #=============================================================================
    def pbEORShiftDistantBattlers
        # Move battlers around if none are near to each other
        # NOTE: This code assumes each side has a maximum of 3 battlers on it, and
        #       is not generalised to larger side sizes.
        unless singleBattle?
            swaps = [] # Each element is an array of two battler indices to swap
            for side in 0...2
                next if pbSideSize(side) == 1 # Only battlers on sides of size 2+ need to move
                # Check if any battler on this side is near any battler on the other side
                anyNear = false
                eachSameSideBattler(side) do |b|
                    eachOtherSideBattler(b) do |otherB|
                        next unless nearBattlers?(otherB.index, b.index)
                        anyNear = true
                        break
                    end
                    break if anyNear
                end
                break if anyNear
                # No battlers on this side are near any battlers on the other side; try
                # to move them
                # NOTE: If we get to here (assuming both sides are of size 3 or less),
                #       there is definitely only 1 able battler on this side, so we
                #       don't need to worry about multiple battlers trying to move into
                #       the same position. If you add support for a side of size 4+,
                #       this code will need revising to account for that, as well as to
                #       add more complex code to ensure battlers will end up near each
                #       other.
                eachSameSideBattler(side) do |b|
                    # Get the position to move to
                    pos = -1
                    case pbSideSize(side)
                    when 2 then pos = [2, 3, 0, 1][b.index] # The unoccupied position
                    when 3 then pos = (side == 0) ? 2 : 3 # The centre position
                    end
                    next if pos < 0
                    # Can't move if the same trainer doesn't control both positions
                    idxOwner = pbGetOwnerIndexFromBattlerIndex(b.index)
                    next if pbGetOwnerIndexFromBattlerIndex(pos) != idxOwner
                    swaps.push([b.index, pos])
                end
            end
            # Move battlers around
            swaps.each do |pair|
                next if pbSideSize(pair[0]) == 2 && swaps.length > 1
                next unless pbSwapBattlers(pair[0], pair[1])
                case pbSideSize(side)
                when 2
                    pbDisplay(_INTL("{1} moved across!", @battlers[pair[1]].pbThis))
                when 3
                    pbDisplay(_INTL("{1} moved to the center!", @battlers[pair[1]].pbThis))
                end
            end
        end
    end
end
