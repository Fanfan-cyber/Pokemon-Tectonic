class PokeBattle_AI
    def pbChooseMovesTrainer(idxBattler, choices)
        user = @battle.battlers[idxBattler]
        owner = @battle.pbGetOwnerFromBattlerIndex(user.index)
        policies = owner.policies || []

        # Log the available choices
        logMoveChoices(user, choices)

        # If there are valid choices, pick among them
        if choices.length > 0
            # Determine the most preferred move
            sortedChoices = choices.sort_by { |choice| -choice[1] }
            preferredChoice = sortedChoices[0]
            PBDebug.log("[AI] #{user.pbThis} (#{user.index}) thinks #{user.moves[preferredChoice[0]].name} is the highest rated choice")
            unless preferredChoice.nil?
                @battle.pbRegisterMove(idxBattler, preferredChoice[0], false)
                @battle.pbRegisterTarget(idxBattler, preferredChoice[2]) if preferredChoice[2] >= 0
            end
        else # If there are no calculated choices, create a list of the choices all scored the same, to be chosen between randomly later on
            PBDebug.log("[AI] #{user.pbThis} (#{user.index}) scored no moves above a zero, resetting all choices to default")
            user.eachMoveWithIndex do |m, i|
                next unless @battle.pbCanChooseMove?(user, i, false)
                next if m.empoweredMove?
                choices.push([i, 100, -1]) # Move index, score, target
            end
            if choices.length == 0 # No moves are physically possible to use; use Struggle
                @battle.pbAutoChooseMove(user.index)
            end
        end

        # if there is somehow still no choice, randomly choose a move from the choices and register it
        if @battle.choices[idxBattler][2].nil?
            echoln("All AI protocols have failed or fallen through, picking at random.")
            randomChoice = choices.sample
            @battle.pbRegisterMove(idxBattler, randomChoice[0], false)
            @battle.pbRegisterTarget(idxBattler, randomChoice[2]) if randomChoice[2] >= 0
        end

        # Log the result
        if @battle.choices[idxBattler][2]
            user.lastMoveChosen = @battle.choices[idxBattler][2].id
            PBDebug.log("[AI] #{user.pbThis} (#{user.index}) will use #{@battle.choices[idxBattler][2].name}")
        end
    end

    # Returns an array filled with each move that has a target worth using against
    # Giving also the best target to use the move against and the score of doing so
    def pbGetBestTrainerMoveChoices(user, opposingBattler = nil)
        choices = []
        user.eachAIKnownMoveWithIndex do |move, i|
            next unless @battle.pbCanChooseMove?(user, i, false)
            newChoice = pbEvaluateMoveTrainer(user, move)
            # Push a new array of [moveIndex,moveScore,targetIndex]
            # where targetIndex could be -1 for anything thats not single target
            choices.push([i].concat(newChoice)) if newChoice
        end
        return choices
    end

    def pbEvaluateMoveTrainer(user, move, targets = [])
        policies = user.ownersPolicies
        target_data = move.pbTarget(user)
        newChoice = nil
        if target_data.num_targets > 1
            # If move affects multiple battlers and you don't choose a particular one
            totalScore = 0
            if targets.empty?
                @battle.eachBattler do |b|
                    next unless @battle.pbMoveCanTarget?(user.index, b.index, target_data)
                    targets.push(b)
                end
            end
            targets.each do |b|
                score = pbGetMoveScore(move, user, b, policies, targets.length)
                if user.opposes?(b)
                    totalScore += score
                else
                    next if policies.include?(:EQ_PROTECT) && b.canChooseProtect?
                    totalScore -= score
                end
            end
            newChoice = [totalScore, -1] if totalScore > 0
        elsif target_data.num_targets == 0
            # If move has no targets, affects the user, a side or the whole field
            score = pbGetMoveScore(move, user, user, policies, 0)
            newChoice = [score, -1] if score > 0
        else
            # If move affects one battler and you have to choose which one
            scoresAndTargets = []
            @battle.eachBattler do |b|
                next unless targets.empty? || targets.include?(b)
                next unless @battle.pbMoveCanTarget?(user.index, b.index, target_data)
                next if target_data.targets_foe && !user.opposes?(b)
                score = pbGetMoveScore(move, user, b, policies)
                scoresAndTargets.push([score, b.index]) if score > 0
            end
            if scoresAndTargets.length > 0
                # Get the one best target for the move
                scoresAndTargets.sort! { |a, b| b[0] <=> a[0] }
                newChoice = [scoresAndTargets[0][0], scoresAndTargets[0][1]]
            end
        end
        return newChoice
    end

    #=============================================================================
    # Get a score for the given move being used against the given target
    #=============================================================================
    def pbGetMoveScore(move, user, target, policies = [], numTargets = 1)
        scoringKey = [move.id, user.personalID, target.personalID, numTargets]
        if @precalculatedChoices.key?(scoringKey)
            precalcedScore = @precalculatedChoices[scoringKey]
            echoln("[MOVE SCORING] Score for #{user.pbThis(true)}'s #{move.name} (#{move.function}) against target #{target.pbThis(true)} already calced this round: #{precalcedScore}")
            return precalcedScore
        end

        move.calculated_category = move.calculateCategory(user, [target])
        move.calcType = move.pbCalcType(user)

        if aiPredictsFailure?(move, user, target, false)
            @precalculatedChoices[scoringKey] = 0
            return 0
        end
        
        switchPredicted = @battle.aiPredictsSwitch?(user,target.index,true)

        # DAMAGE SCORE AND HIT TRIGGERS SCORE
        damageScore = 0
        triggersScore = 0
        willFaint = false
        damagingMove = move.damagingMove?(true)
        if damagingMove
            # Adjust the score based on the move dealing damage
            # and perhaps a percent chance to actually benefit from its effect score
            begin
                damageScore,willFaint = pbGetMoveScoreDamage(move, user, target, numTargets)
            rescue StandardError => exception
                pbPrintException($!) if $DEBUG
            end

            numHits = move.numberOfHits(user, [target], true).ceil

            # Account for triggered abilities of the user
            begin
                scoreModifierUserAbility = 0
                user.eachAIKnownActiveAbility do |ability|
                    scoreModifierUserAbility += 
                        BattleHandlers.triggerUserAbilityOnHitAI(ability, user, target, move, @battle, numHits)
                end
                triggersScore += scoreModifierUserAbility
                echoln("[MOVE SCORING] #{user.pbThis}'s #{numHits} hits against #{target.pbThis(false)} adjusts the score by #{scoreModifierUserAbility} due to the user's abilities") if scoreModifierUserAbility != 0
            rescue StandardError => exception
                pbPrintException($!) if $DEBUG
            end

            # Account for the triggered abilities of the target
            if user.activatesTargetAbilities?(true)
                begin
                    scoreModifierTargetAbility = 0
                    target.eachAIKnownActiveAbility do |ability|
                        scoreModifierTargetAbility += 
                            BattleHandlers.triggerTargetAbilityOnHitAI(ability, user, target, move, @battle, numHits)
                    end
                    triggersScore += scoreModifierTargetAbility
                    echoln("[MOVE SCORING] #{user.pbThis}'s #{numHits} hits against #{target.pbThis(false)} adjusts the score by #{scoreModifierTargetAbility} due to the target's abilities") if scoreModifierTargetAbility != 0
                rescue StandardError => exception
                    pbPrintException($!) if $DEBUG
                end
            end

            # Account for the items of the target
            unless user.hasActiveItem?(:PROXYFIST)
                begin
                    scoreModifierTargetItem = 0
                    target.eachActiveItem do |item|
                        scoreModifierTargetItem += 
                            BattleHandlers.triggerTargetItemOnHitAI(item, user, target, move, @battle, numHits)
                    end
                    triggersScore += scoreModifierTargetItem
                    echoln("[MOVE SCORING] #{user.pbThis}'s #{numHits} hits against #{target.pbThis(false)} adjusts the score by #{scoreModifierTargetAbility} due to the target's items") if scoreModifierTargetAbility != 0
                rescue StandardError => exception
                    pbPrintException($!) if $DEBUG
                end
            end
        end

        # EFFECT SCORING
        effectScore = 0
        begin
            regularEffectScore = move.getEffectScore(user, target)
            faintEffectScore = 0
            targetAffectingEffectScore = 0
            if willFaint
                faintEffectScore = move.getFaintEffectScore(user, target)
            elsif !target.substituted? || move.ignoresSubstitute?(user)
                targetAffectingEffectScore = move.getTargetAffectingEffectScore(user, target)
            end
            effectScore += regularEffectScore
            effectScore += faintEffectScore
            effectScore += targetAffectingEffectScore
        rescue StandardError => e
            echoln("FAILURE IN THE SCORING SYSTEM FOR MOVE #{move.name} #{move.function}")
            effectScore = 0
            raise e if @battle.autoTesting
        end

        # Modify the effect score by the move's additional effect chance if it has one
        if move.randomEffect?
            type = pbRoughType(move, user)
            realProcChance = move.pbAdditionalEffectChance(user, target, type, 0, true)
            realProcChance = 0 unless move.canApplyRandomAddedEffects?(user,target,false,true)
            factor = (realProcChance / 100.0)
            echoln("[MOVE SCORING] #{user.pbThis} multiplies #{move.id}'s effect score of #{effectScore} by a factor of #{factor} based on its predicted additional effect chance (against target #{target.pbThis(false)})")
            effectScore *= factor
        end

        # Combine
        echoln("[MOVE SCORING] #{user.pbThis} gives #{move.id} an effect score of #{effectScore}, a damage score of #{damageScore}, and a triggers score of #{triggersScore} (against target #{target.pbThis(false)})")
        score = damageScore + triggersScore + effectScore

        # ! All score changes from this point forward must be multiplicative !

        # Pick a good move for the Choice items
        if user.hasActiveItem?(CHOICE_LOCKING_ITEMS) || user.hasActiveAbilityAI?(CHOICE_LOCKING_ABILITIES)
            echoln("[MOVE SCORING] #{user.pbThis} scores the move #{move.id} differently due to choice locking.")
            score /= 2 unless damagingMove
        end

        # Account for accuracy of move
        accuracy = pbRoughAccuracy(move, user, target)
        score *= accuracy / 100.0

        if accuracy < 100
            echoln("[MOVE SCORING] #{user.pbThis} predicts the move #{move.id} against target #{target.pbThis(false)} will have an accuracy of #{accuracy}")
        end

        # If slower than them, our move will be worse in comparison
        if damagingMove && !switchPredicted && !userMovesFirst?(move, user, target)
            echoln("[MOVE SCORING] #{user.pbThis} scores the move #{move.id} lower since its an attack going slower than the target")
            score *= 0.7
        end

        # Account for some abilities
        score = getMultiplicativeAbilityScore(score, move, user, target)

        # Policies
        score *= 0.75 if move.damagingMove?(true) && policies.include?(:DISLIKEATTACKING)

        # Final adjustments t score
        score = score.to_i
        score = 0 if score < 0
        echoln("[MOVE SCORING] #{user.pbThis} scores the move #{move.id} against target #{target.pbThis(false)}: #{score}")
        @precalculatedChoices[scoringKey] = score
        return score
    end

    def getMultiplicativeAbilityScore(score, move, user, target)
        if move.danceMove?
            dancerBonus = 1.0
            user.eachOther do |b|
                next unless b.hasActiveAbilityAI?(:DANCER)
                if b.opposes?(user)
                    dancerBonus -= 0.8
                else
                    dancerBonus += 0.8
                end
            end
            score *= dancerBonus
        end

        if move.soundMove?
            dancerBonus = 1.0
            user.eachOther do |b|
                next unless b.hasActiveAbilityAI?(:ECHO)
                if b.opposes?(user)
                    dancerBonus -= 0.8
                else
                    dancerBonus += 0.8
                end
            end
            score *= dancerBonus
        end

        return score
    end

    #=============================================================================
    # Add to a move's score based on how much damage it will deal (as a percentage
    # of the target's current HP)
    #=============================================================================
    def pbGetMoveScoreDamage(move, user, target, numTargets = 1)
        damagePercentage = getDamagePercentageAI(move, user, target, numTargets)

        damagePercentage *= 0.66 if target.allyHasRedirectionMove?

        # Adjust score
        willFaint = false
        if damagePercentage >= 100 # Prefer lethal damage
            damagePercentage = 150
            willFaint = true
        end

        damageScore = (damagePercentage * 2.0).to_i

        return damageScore, willFaint
    end

    def getDamagePercentageAI(move, user, target, numTargets = 1)
        # Calculate how much damage the move will do (roughly)
        realDamage = pbTotalDamageAI(move, user, target, numTargets)

        if playerTribalBonus.hasTribeBonus?(:DECEIVER)
            realDamage *= 1.5
            echoln("[MOVE SCORING] #{user.pbThis} is overestimating its damage by 50 percent due to the deceiver tribal bonus")
        end

        # Convert damage to percentage of target's remaining HP
        damagePercentage = realDamage * 100.0 / target.hp

        echoln("[MOVE SCORING] #{user.pbThis} thinks that move #{move.id} will deal #{realDamage} damage -- #{damagePercentage.round(1)} percent of #{target.pbThis(false)}'s HP")

        return damagePercentage
    end
end
