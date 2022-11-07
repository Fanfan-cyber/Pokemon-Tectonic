#===============================================================================
# No additional effect.
#===============================================================================
class PokeBattle_Move_000 < PokeBattle_Move
end

#===============================================================================
# Does absolutely nothing. (Splash)
#===============================================================================
class PokeBattle_Move_001 < PokeBattle_Move
  def unusableInGravity?; return true; end

  def pbEffectGeneral(user)
    @battle.pbDisplay(_INTL("But nothing happened!"))
  end

  def getScore(score,user,target,skill=100)
    return 0
  end
end

#===============================================================================
# Struggle, if defined as a move in moves.txt. Typically it won't be.
#===============================================================================
class PokeBattle_Move_002 < PokeBattle_Struggle
end

#===============================================================================
# Puts the target to sleep.
#===============================================================================
class PokeBattle_Move_003 < PokeBattle_SleepMove
end

#===============================================================================
# Makes the target drowsy; it falls asleep at the end of the next turn. (Yawn)
#===============================================================================
class PokeBattle_Move_004 < PokeBattle_Move
    def pbFailsAgainstTarget?(user,target)
        if target.effectActive?(:Yawn)
            @battle.pbDisplay(_INTL("But it failed, since #{target.pbThis(true)} is already drowsy!"))
            return true
        end
        return true if !target.pbCanSleep?(user,true,self)
        return false
    end
    
    def pbEffectAgainstTarget(user,target)
      target.applyEffect(:Yawn,2)
    end
    
    def getScore(score,user,target,skill=100)
        score = getSleepMoveScore(score,user,target,skill,user.ownersPolicies,statusMove?)
        score -= 30
        return score
    end
end

#===============================================================================
# Poisons the target.
#===============================================================================
class PokeBattle_Move_005 < PokeBattle_PoisonMove
end

#===============================================================================
# Badly poisons the target. (Poison Fang, Toxic)
#===============================================================================
class PokeBattle_Move_006 < PokeBattle_PoisonMove
  def initialize(battle,move)
    super
    @toxic = true
  end

  def pbOverrideSuccessCheckPerHit(user,target)
    return (Settings::MORE_TYPE_EFFECTS && statusMove? && user.pbHasType?(:POISON))
  end
end

#===============================================================================
# Paralyzes the target.
#===============================================================================
class PokeBattle_Move_007 < PokeBattle_ParalysisMove
end

#===============================================================================
# Paralyzes the target. Accuracy perfect in rain. Hits some
# semi-invulnerable targets. (Thunder)
#===============================================================================
class PokeBattle_Move_008 < PokeBattle_ParalysisMove
  def hitsFlyingTargets?; return true; end

  def immuneToRainDebuff?; return false; end

  def pbBaseAccuracy(user,target)
    return 0 if @battle.rainy?
    return super
  end
end

#===============================================================================
# Paralyzes the target. May cause the target to flinch. (Thunder Fang)
#===============================================================================
class PokeBattle_Move_009 < PokeBattle_Move
  def flinchingMove?; return true; end

  def pbAdditionalEffect(user,target)
    return if target.damageState.substitute
    chance = pbAdditionalEffectChance(user,target,@calcType,10)
    return if chance == 0
    if @battle.pbRandom(100)<chance
      target.pbParalyze(user) if target.pbCanParalyze?(user,false,self)
    end
    target.pbFlinch(user) if @battle.pbRandom(100)<chance
  end

  def getScore(score,user,target,skill=100)
    score = getParalysisMoveScore(score,user,target,skill,user.ownersPolicies,statusMove?)
		score = getFlinchingMoveScore(score,user,target,skill,user.ownersPolicies)
    return score
  end
end

#===============================================================================
# Burns the target.
#===============================================================================
class PokeBattle_Move_00A < PokeBattle_BurnMove
end

#===============================================================================
# Burns the target. May cause the target to flinch. (Fire Fang)
#===============================================================================
class PokeBattle_Move_00B < PokeBattle_Move
  def flinchingMove?; return true; end

  def pbAdditionalEffect(user,target)
    return if target.damageState.substitute
    chance = pbAdditionalEffectChance(user,target,@calcType,10)
    return if chance == 0
    if @battle.pbRandom(100)<chance
      target.pbBurn(user) if target.pbCanBurn?(user,false,self)
    end
    target.pbFlinch(user) if @battle.pbRandom(100)<chance
  end

  def getScore(score,user,target,skill=100)
    score = getBurnMoveScore(score,user,target,skill,user.ownersPolicies,statusMove?)
		score = getFlinchingMoveScore(score,user,target,skill,user.ownersPolicies)
    return score
  end
end

#===============================================================================
# Freezes the target.
#===============================================================================
class PokeBattle_Move_00C < PokeBattle_FreezeMove
end

#===============================================================================
# Freezes the target. Accuracy perfect in hail. (Blizzard)
#===============================================================================
class PokeBattle_Move_00D < PokeBattle_FrostbiteMove
  def pbBaseAccuracy(user,target)
    return 0 if @battle.pbWeather == :Hail
    return super
  end
end

#===============================================================================
# Freezes the target. May cause the target to flinch. (Ice Fang)
#===============================================================================
class PokeBattle_Move_00E < PokeBattle_Move
  def flinchingMove?; return true; end

  def pbAdditionalEffect(user,target)
    return if target.damageState.substitute
    chance = pbAdditionalEffectChance(user,target,@calcType,10)
    return if chance == 0
    if @battle.pbRandom(100)<chance
      target.pbFrostbite if target.pbCanFrostbite?(user,false,self)
    end
    target.pbFlinch(user) if @battle.pbRandom(100)<chance
  end
end

#===============================================================================
# Causes the target to flinch.
#===============================================================================
class PokeBattle_Move_00F < PokeBattle_FlinchMove
end

#===============================================================================
# Causes the target to flinch. (Dragon Rush, Steamroller, Stomp)
#===============================================================================
class PokeBattle_Move_010 < PokeBattle_FlinchMove
end

#===============================================================================
# Causes the target to flinch. Fails if the user is not asleep. (Snore)
#===============================================================================
class PokeBattle_Move_011 < PokeBattle_FlinchMove
  def usableWhenAsleep?; return true; end

  def pbMoveFailed?(user,targets)
    if !user.asleep?
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def getScore(score,user,target,skill=100)
    score += 100
    super
  end
end

#===============================================================================
# Causes the target to flinch. Fails if this isn't the user's first turn.
# (Fake Out)
#===============================================================================
class PokeBattle_Move_012 < PokeBattle_FlinchMove
  def pbMoveFailed?(user,targets)
    if !user.firstTurn?
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def getScore(score,user,target,skill=100)
    score = getFlinchingMoveScore(score,user,target,skill,user.ownersPolicies,10)
    return score
  end
end

#===============================================================================
# Confuses the target.
#===============================================================================
class PokeBattle_Move_013 < PokeBattle_ConfuseMove
end

#===============================================================================
# Confuses the target. (Chatter)
#===============================================================================
class PokeBattle_Move_014 < PokeBattle_Move_013
end

#===============================================================================
# Confuses the target. Accuracy perfect in rain, 50% in sunshine. Hits some
# semi-invulnerable targets. (old!Hurricane)
#===============================================================================
class PokeBattle_Move_015 < PokeBattle_ConfuseMove
  def hitsFlyingTargets?; return true; end

  def pbBaseAccuracy(user,target)
    return 0 if @battle.rainy?
    return super
  end
end

#===============================================================================
# Attracts the target. (Attract)
#===============================================================================
class PokeBattle_Move_016 < PokeBattle_Move
  def ignoresSubstitute?(user); return true; end

  def pbFailsAgainstTarget?(user,target)
    return false if damagingMove?
    return true if !target.pbCanAttract?(user)
    return true if pbMoveFailedAromaVeil?(user,target)
    return false
  end

  def pbEffectAgainstTarget(user,target)
    return if damagingMove?
    target.pbAttract(user)
  end

  def pbAdditionalEffect(user,target)
    return if target.damageState.substitute
    target.pbAttract(user) if target.pbCanAttract?(user,false)
  end
end

#===============================================================================
# Burns, frostbites, or numbs the target. (Tri Attack)
#===============================================================================
class PokeBattle_Move_017 < PokeBattle_Move
  def pbAdditionalEffect(user,target)
    return if target.damageState.substitute
    case @battle.pbRandom(3)
    when 0 then target.pbBurn(user) if target.pbCanBurn?(user, false, self)
    when 1 then target.pbFrostbite if target.pbCanFrostbite?(user, false, self)
    when 2 then target.pbParalyze(user) if target.pbCanParalyze?(user, false, self)
    end
  end

  def getScore(score,user,target,skill=100)
    policies = user.ownersPolicies
    score = getBurnMoveScore(score,user,target,skill,policies,statusMove?)
    score = getFrostbiteMoveScore(score,user,target,skill,policies,statusMove?)
    score = getParalysisMoveScore(score,user,target,skill,policies,statusMove?)
    return score
  end
end

#===============================================================================
# Cures user of any status condition. (Refresh)
#===============================================================================
class PokeBattle_Move_018 < PokeBattle_Move
  def pbMoveFailed?(user,targets)
    if !user.pbHasAnyStatus?
      @battle.pbDisplay(_INTL("But it failed, since #{user.pbThis(true)} has no status condition!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
    user.pbCureStatus
  end

  def getScore(score,user,target,skill=100)
    score += 30
    return score
  end
end

#===============================================================================
# Cures all party Pokémon of permanent status problems. (Aromatherapy, Heal Bell)
#===============================================================================
# NOTE: In Gen 5, this move should have a target of UserSide, while in Gen 6+ it
#       should have a target of UserAndAllies. This is because, in Gen 5, this
#       move shouldn't call def pbSuccessCheckAgainstTarget for each Pokémon
#       currently in battle that will be affected by this move (i.e. allies
#       aren't protected by their substitute/ability/etc., but they are in Gen
#       6+). We achieve this by not targeting any battlers in Gen 5, since
#       pbSuccessCheckAgainstTarget is only called for targeted battlers.
class PokeBattle_Move_019 < PokeBattle_Move
  def worksWithNoTargets?; return true; end

  def pbMoveFailed?(user,targets)
    failed = true
    @battle.eachSameSideBattler(user) do |b|
      next if b.status == :NONE
      failed = false
      break
    end
    if !failed
      @battle.pbParty(user.index).each do |pkmn|
        next if !pkmn || !pkmn.able? || pkmn.status == :NONE
        failed = false
        break
      end
    end
    if failed
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbFailsAgainstTarget?(user,target)
    return target.status == :NONE
  end

  def pbEffectAgainstTarget(user,target)
    healStatus(target)
  end

  def pbEffectGeneral(user)
    # Cure all Pokémon in battle on the user's side. For the benefit of the Gen
    # 5 version of this move, to make Pokémon out in battle get cured first.
    if pbTarget(user) == :UserSide
      @battle.eachSameSideBattler(user) do |b|
        healStatus(b)
      end
    end
    # Cure all Pokémon in the user's and partner trainer's party.
    # NOTE: This intentionally affects the partner trainer's inactive Pokémon
    #       too.
    @battle.pbParty(user.index).each_with_index do |pkmn,i|
      next if pkmn.nil? || !pkmn.able?
      next if @battle.pbFindBattler(i,user)   # Skip Pokémon in battle
      healStatus(pkmn)
    end
  end

  def pbShowAnimation(id,user,targets,hitNum=0,showAnimation=true)
    super
    if @id == :AROMATHERAPY
      @battle.pbDisplay(_INTL("A soothing aroma wafted through the area!"))
    elsif @id == :HEALBELL
      @battle.pbDisplay(_INTL("A bell chimed!"))
    end
  end

  def getScore(score,user,target,skill=100)
    statuses = 0
		@battle.pbParty(user.index).each do |pkmn|
			statuses += 1 if pkmn && pkmn.status != :NONE
		end
		score += 20*statuses
    return score
  end
end

#===============================================================================
# Safeguards the user's side from being inflicted with status problems.
# (Safeguard)
#===============================================================================
class PokeBattle_Move_01A < PokeBattle_Move
  def pbMoveFailed?(user,targets)
    if user.pbOwnSide.effectActive?(:Safeguard)
      @battle.pbDisplay(_INTL("But it failed, since a safeguard is already present!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
    user.pbOwnSide.applyEffect(:Safeguard,5)
  end

  def getScore(score,user,target,skill=100)
    if user.hasSpotsForStatus?
			score += 30
		else
			score -= 30
		end
    return score
  end
end

#===============================================================================
# User passes its first status problem to the target. (Psycho Shift)
#===============================================================================
class PokeBattle_Move_01B < PokeBattle_Move   
  def pbMoveFailed?(user,targets)
    if !user.pbHasAnyStatus?
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbOnStartUse(user,targets)
    @statusBeingMoved = user.getStatuses()[0]
  end

  def pbFailsAgainstTarget?(user,target)
    return !target.pbCanInflictStatus?(@statusBeingMoved,user,true,self)
  end

  def pbEffectAgainstTarget(user,target)
    target.pbInflictStatus(@statusBeingMoved,0,nil,user)
    user.pbCureStatus(true,@statusBeingMoved)
  end
end

#===============================================================================
# Increases the user's Attack by 1 stage.
#===============================================================================
class PokeBattle_Move_01C < PokeBattle_StatUpMove
  def initialize(battle,move)
    super
    @statUp = [:ATTACK,1]
  end
end

#===============================================================================
# Increases the user's Defense by 1 stage. (Harden, Steel Wing, Withdraw)
#===============================================================================
class PokeBattle_Move_01D < PokeBattle_StatUpMove
  def initialize(battle,move)
    super
    @statUp = [:DEFENSE,1]
  end
end

#===============================================================================
# Increases the user's Defense by 1 stage. User curls up. (Defense Curl)
#===============================================================================
class PokeBattle_Move_01E < PokeBattle_StatUpMove
  def initialize(battle,move)
    super
    @statUp = [:DEFENSE,1]
  end

  def pbEffectGeneral(user)
    user.applyEffect(:DefenseCurl)
    super
  end
end

#===============================================================================
# Increases the user's Speed by 1 stage. (Flame Charge)
#===============================================================================
class PokeBattle_Move_01F < PokeBattle_StatUpMove
  def initialize(battle,move)
    super
    @statUp = [:SPEED,1]
  end
end

#===============================================================================
# Increases the user's Special Attack by 1 stage. (Charge Beam, Fiery Dance)
#===============================================================================
class PokeBattle_Move_020 < PokeBattle_StatUpMove
  def initialize(battle,move)
    super
    @statUp = [:SPECIAL_ATTACK,1]
  end
end

#===============================================================================
# Increases the user's Special Defense by 1 stage.
# Charges up user's next attack if it is Electric-type. (Charge)
#===============================================================================
class PokeBattle_Move_021 < PokeBattle_StatUpMove
  def initialize(battle,move)
    super
    @statUp = [:SPECIAL_DEFENSE,1]
  end

  def pbEffectGeneral(user)
    user.applyEffect(:Charge,2)
    super
  end

  def getScore(score,user,target,skill=100)
    foundMove = false
		user.eachMove do |m|
			next if m.type != :ELECTRIC || !m.damagingMove?
			foundMove = true
			break
		end
    if foundMove
      score += 20
    else
      score -= 20
    end
    super
  end
end

#===============================================================================
# Increases the user's evasion by 1 stage. (Double Team)
#===============================================================================
class PokeBattle_Move_022 < PokeBattle_StatUpMove
  def initialize(battle,move)
    super
    @statUp = [:EVASION,1]
  end
end

#===============================================================================
# Increases the user's critical hit rate. (Focus Energy)
#===============================================================================
class PokeBattle_Move_023 < PokeBattle_Move
  def pbMoveFailed?(user,targets)
    if user.effectAtMax?(:FocusEnergy)
      @battle.pbDisplay(_INTL("But it failed, since it cannot bet any more pumped!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
    user.incrementEffect(:FocusEnergy,2)
    @battle.pbDisplay(_INTL("{1} is getting pumped!",user.pbThis))
  end

  def getScore(score,user,target,skill=100)
    score -= 20
    score += 20 if user.firstTurn?
    score += 40 if user.hasActiveAbilityAI?([:SUPERLUCK,:SNIPER])
    return score
  end
end

#===============================================================================
# Increases the user's Attack and Defense by 1 stage each. (Bulk Up)
#===============================================================================
class PokeBattle_Move_024 < PokeBattle_MultiStatUpMove
  def initialize(battle,move)
    super
    @statUp = [:ATTACK,1,:DEFENSE,1]
  end
end

#===============================================================================
# Increases the user's Attack, Defense and accuracy by 1 stage each. (Coil)
#===============================================================================
class PokeBattle_Move_025 < PokeBattle_MultiStatUpMove
  def initialize(battle,move)
    super
    @statUp = [:ATTACK,1,:DEFENSE,1,:ACCURACY,1]
  end
end

#===============================================================================
# Increases the user's Attack and Speed by 1 stage each. (Dragon Dance)
#===============================================================================
class PokeBattle_Move_026 < PokeBattle_MultiStatUpMove
  def initialize(battle,move)
    super
    @statUp = [:ATTACK,1,:SPEED,1]
  end
end

#===============================================================================
# Increases the user's Attack and Special Attack by 1 stage each. (Work Up)
#===============================================================================
class PokeBattle_Move_027 < PokeBattle_MultiStatUpMove
  def initialize(battle,move)
    super
    @statUp = [:ATTACK,1,:SPECIAL_ATTACK,1]
  end
end

#===============================================================================
# Increases the user's Attack and Sp. Attack by 1 stage each.
# In sunny weather, increases are 2 stages each instead. (Growth)
#===============================================================================
class PokeBattle_Move_028 < PokeBattle_MultiStatUpMove
  def initialize(battle,move)
    super
    @statUp = [:ATTACK,1,:SPECIAL_ATTACK,1]
  end

  def pbOnStartUse(user,targets)
    increment = 1
    increment = 2 if @battle.sunny?
    @statUp[1] = @statUp[3] = increment
  end
end

#===============================================================================
# Increases the user's Attack and accuracy by 1 stage each. (Hone Claws)
#===============================================================================
class PokeBattle_Move_029 < PokeBattle_MultiStatUpMove
  def initialize(battle,move)
    super
    @statUp = [:ATTACK,1,:ACCURACY,1]
  end
end

#===============================================================================
# Increases the user's Defense and Special Defense by 1 stage each.
# (Cosmic Power, Defend Order)
#===============================================================================
class PokeBattle_Move_02A < PokeBattle_MultiStatUpMove
  def initialize(battle,move)
    super
    @statUp = [:DEFENSE,1,:SPECIAL_DEFENSE,1]
  end
end

#===============================================================================
# Increases the user's Sp. Attack, Sp. Defense and Speed by 1 stage each.
# (Quiver Dance)
#===============================================================================
class PokeBattle_Move_02B < PokeBattle_MultiStatUpMove
  def initialize(battle,move)
    super
    @statUp = [:SPECIAL_ATTACK,1,:SPECIAL_DEFENSE,1,:SPEED,1]
  end
end

#===============================================================================
# Increases the user's Sp. Attack and Sp. Defense by 1 stage each. (Calm Mind)
#===============================================================================
class PokeBattle_Move_02C < PokeBattle_MultiStatUpMove
  def initialize(battle,move)
    super
    @statUp = [:SPECIAL_ATTACK,1,:SPECIAL_DEFENSE,1]
  end
end

#===============================================================================
# Increases the user's Attack, Defense, Speed, Special Attack and Special Defense
# by 1 stage each. (Ancient Power, Ominous Wind, Silver Wind)
#===============================================================================
class PokeBattle_Move_02D < PokeBattle_MultiStatUpMove
  def initialize(battle,move)
    super
    @statUp = [:ATTACK,1,:DEFENSE,1,:SPECIAL_ATTACK,1,:SPECIAL_DEFENSE,1,:SPEED,1]
  end
end

#===============================================================================
# Increases the user's Attack by 2 stages. (Swords Dance)
#===============================================================================
class PokeBattle_Move_02E < PokeBattle_StatUpMove
  def initialize(battle,move)
    super
    @statUp = [:ATTACK,2]
  end
end

#===============================================================================
# Increases the user's Defense by 2 stages. (Acid Armor, Barrier, Iron Defense)
#===============================================================================
class PokeBattle_Move_02F < PokeBattle_StatUpMove
  def initialize(battle,move)
    super
    @statUp = [:DEFENSE,2]
  end
end

#===============================================================================
# Increases the user's Speed by 2 stages. (Agility, Rock Polish)
#===============================================================================
class PokeBattle_Move_030 < PokeBattle_StatUpMove
  def initialize(battle,move)
    super
    @statUp = [:SPEED,2]
  end

  def getScore(score,user,target,skill=100)
    score += 40 if user.hasActiveAbilityAI?(:STAMPEDE)
    super
  end
end

#===============================================================================
# Increases the user's Speed by 2 stages. Lowers user's weight by 100kg.
# (Autotomize)
#===============================================================================
class PokeBattle_Move_031 < PokeBattle_StatUpMove
  def initialize(battle,move)
    super
    @statUp = [:SPEED,2]
  end

  def pbEffectGeneral(user)
    if user.pbWeight + user.effects[:WeightChange]>1
      user.effects[:WeightChange] -= 100
      @battle.pbDisplay(_INTL("{1} became nimble!",user.pbThis))
    end
    super
  end
end

#===============================================================================
# Increases the user's Special Attack by 2 stages. (Nasty Plot)
#===============================================================================
class PokeBattle_Move_032 < PokeBattle_StatUpMove
  def initialize(battle,move)
    super
    @statUp = [:SPECIAL_ATTACK,2]
  end
end

#===============================================================================
# Increases the user's Special Defense by 2 stages. (Amnesia)
#===============================================================================
class PokeBattle_Move_033 < PokeBattle_StatUpMove
  def initialize(battle,move)
    super
    @statUp = [:SPECIAL_DEFENSE,2]
  end
end

#===============================================================================
# Increases the user's evasion by 2 stages. Minimizes the user. (Minimize)
#===============================================================================
class PokeBattle_Move_034 < PokeBattle_StatUpMove
  def initialize(battle,move)
    super
    @statUp = [:EVASION,2]
  end

  def pbEffectGeneral(user)
    user.applyEffect(:Minimize)
    super
  end
end

#===============================================================================
# Decreases the user's Defense and Special Defense by 1 stage each.
# Increases the user's Attack, Speed and Special Attack by 2 stages each.
# (Shell Smash)
#===============================================================================
class PokeBattle_Move_035 < PokeBattle_StatUpDownMove
  def initialize(battle,move)
    super
    @statUp   = [:ATTACK,2,:SPECIAL_ATTACK,2,:SPEED,2]
    @statDown = [:DEFENSE,1,:SPECIAL_DEFENSE,1]
  end
end

#===============================================================================
# Increases the user's Speed by 2 stages, and its Attack by 1 stage. (Shift Gear)
#===============================================================================
class PokeBattle_Move_036 < PokeBattle_MultiStatUpMove
  def initialize(battle,move)
    super
    @statUp = [:SPEED,2,:ATTACK,1]
  end
end

#===============================================================================
# Increases one random stat of the target by 2 stages (except HP). (Acupressure)
#===============================================================================
class PokeBattle_Move_037 < PokeBattle_Move
  def pbFailsAgainstTarget?(user,target)
    @statArray = []
    GameData::Stat.each_battle do |s|
      @statArray.push(s.id) if target.pbCanRaiseStatStage?(s.id,user,self)
    end
    if @statArray.length==0
      @battle.pbDisplay(_INTL("{1}'s stats won't go any higher!",target.pbThis))
      return true
    end
    return false
  end

  def pbEffectAgainstTarget(user,target)
    stat = @statArray.sample
    target.tryRaiseStat(stat,user,increment: 2, move: self)
  end

  def getScore(score,user,target,skill=100)
    score -= 20 # Annoying moves tax
    statStageTotal = 0
    GameData::Stat.each_battle do |s|
      statStageTotal += target.stages[s.id]
    end
    score -= statStageTotal * 5
    return score
  end
end

#===============================================================================
# Increases the user's Defense by 3 stages. (Cotton Guard)
#===============================================================================
class PokeBattle_Move_038 < PokeBattle_StatUpMove
  def initialize(battle,move)
    super
    @statUp = [:DEFENSE,3]
  end
end

#===============================================================================
# Increases the user's Special Attack by 3 stages. (Tail Glow)
#===============================================================================
class PokeBattle_Move_039 < PokeBattle_StatUpMove
  def initialize(battle,move)
    super
    @statUp = [:SPECIAL_ATTACK,3]
  end
end

#===============================================================================
# Reduces the user's HP by half of max, and sets its Attack to maximum.
# (Belly Drum)
#===============================================================================
class PokeBattle_Move_03A < PokeBattle_Move
  def pbMoveFailed?(user,targets)
    hpLoss = [user.totalhp/2,1].max
    if user.hp<=hpLoss
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return true if !user.pbCanRaiseStatStage?(:ATTACK,user,self,true)
    return false
  end

  def pbEffectGeneral(user)
    hpLoss = [user.totalhp/2,1].max
    user.pbReduceHP(hpLoss,false)
    user.pbMaximizeStatStage(:ATTACK,user,self)
    user.pbItemHPHealCheck
  end

  def getScore(score,user,target,skill=100)
    return 0 if !user.hasPhysicalAttack?

    score += 50 if user.firstTurn?

    score -= user.stages[:ATTACK]*20
    return score
  end
end

#===============================================================================
# Decreases the user's Attack and Defense by 1 stage each. (Superpower)
#===============================================================================
class PokeBattle_Move_03B < PokeBattle_StatDownMove
  def initialize(battle,move)
    super
    @statDown = [:ATTACK,1,:DEFENSE,1]
  end
end

#===============================================================================
# Decreases the user's Defense and Special Defense by 1 stage each.
# (Close Combat, Dragon Ascent)
#===============================================================================
class PokeBattle_Move_03C < PokeBattle_StatDownMove
  def initialize(battle,move)
    super
    @statDown = [:DEFENSE,1,:SPECIAL_DEFENSE,1]
  end
end

#===============================================================================
# Decreases the user's Defense, Special Defense and Speed by 1 stage each.
# (V-create)
#===============================================================================
class PokeBattle_Move_03D < PokeBattle_StatDownMove
  def initialize(battle,move)
    super
    @statDown = [:SPEED,1,:DEFENSE,1,:SPECIAL_DEFENSE,1]
  end
end

#===============================================================================
# Decreases the user's Speed by 1 stage. (Hammer Arm, Ice Hammer)
#===============================================================================
class PokeBattle_Move_03E < PokeBattle_StatDownMove
  def initialize(battle,move)
    super
    @statDown = [:SPEED,1]
  end
end

#===============================================================================
# Decreases the user's Special Attack by 2 stages.
#===============================================================================
class PokeBattle_Move_03F < PokeBattle_StatDownMove
  def initialize(battle,move)
    super
    @statDown = [:SPECIAL_ATTACK,2]
  end
end

#===============================================================================
# Increases the target's Special Attack by 2 stages. Charms the target. (Old!Flatter)
#===============================================================================
class PokeBattle_Move_040 < PokeBattle_Move
  def pbMoveFailed?(user,targets)
    failed = true
    targets.each do |b|
      next if !b.pbCanRaiseStatStage?(:SPECIAL_ATTACK,user,self) &&
              !b.pbCanCharm?(user,false,self)
      failed = false
      break
    end
    if failed
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectAgainstTarget(user,target)
    target.tryRaiseStat(:SPECIAL_ATTACK,user,self,2)
    target.pbCharm if target.pbCanCharm?(user,false,self)
  end

  def getScore(score,user,target,skill=100)
    return 0 if target.pbCanCharm?(user,false,self)
    score += 30 if !target.hasSpecialAttack?
    return score
  end
end

#===============================================================================
# Increases the target's Attack by 2 stages. Confuses the target. (Old!Swagger)
#===============================================================================
class PokeBattle_Move_041 < PokeBattle_Move
  def pbMoveFailed?(user,targets)
    failed = true
    targets.each do |b|
      next if !b.pbCanRaiseStatStage?(:ATTACK,user,self) &&
              !b.pbCanConfuse?(user,false,self)
      failed = false
      break
    end
    if failed
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectAgainstTarget(user,target)
    target.tryRaiseStat(:ATTACK,user,self,2)
    target.pbConfuse if target.pbCanConfuse?(user,false,self)
  end

  def getScore(score,user,target,skill=100)
    return 0 if target.pbCanConfuse?(user,false,self)
    score += 30 if !target.hasPhysicalAttack?
    return score
  end
end

#===============================================================================
# Decreases the target's Attack by 1 stage.
#===============================================================================
class PokeBattle_Move_042 < PokeBattle_TargetStatDownMove
  def initialize(battle,move)
    super
    @statDown = [:ATTACK,1]
  end
end
#===============================================================================
# Decreases the target's Defense by 1 stage.
#===============================================================================
class PokeBattle_Move_043 < PokeBattle_TargetStatDownMove
  def initialize(battle,move)
    super
    @statDown = [:DEFENSE,1]
  end
end

#===============================================================================
# Decreases the target's Speed by 1 stage.
#===============================================================================
class PokeBattle_Move_044 < PokeBattle_TargetStatDownMove
  def initialize(battle,move)
    super
    @statDown = [:SPEED,1]
  end
end

#===============================================================================
# Decreases the target's Special Attack by 1 stage.
#===============================================================================
class PokeBattle_Move_045 < PokeBattle_TargetStatDownMove
  def initialize(battle,move)
    super
    @statDown = [:SPECIAL_ATTACK,1]
  end
end

#===============================================================================
# Decreases the target's Special Defense by 1 stage.
#===============================================================================
class PokeBattle_Move_046 < PokeBattle_TargetStatDownMove
  def initialize(battle,move)
    super
    @statDown = [:SPECIAL_DEFENSE,1]
  end
end

#===============================================================================
# Decreases the target's accuracy by 1 stage.
#===============================================================================
class PokeBattle_Move_047 < PokeBattle_TargetStatDownMove
  def initialize(battle,move)
    super
    @statDown = [:ACCURACY,1]
  end
end

#===============================================================================
# Decreases the target's evasion by 2 stages. (Sweet Scent)
#===============================================================================
class PokeBattle_Move_048 < PokeBattle_TargetStatDownMove
  def initialize(battle,move)
    super
    @statDown = [:EVASION, 2]
  end
end

#===============================================================================
# Decreases the target's evasion by 1 stage. Ends all barriers and entry
# hazards for the target's side OR on both sides. (Defog)
#===============================================================================
class PokeBattle_Move_049 < PokeBattle_TargetStatDownMove
  def ignoresSubstitute?(user); return true; end

  def initialize(battle,move)
    super
    @statDown = [:EVASION,1]
    @miscEffects = [:Mist, :Safeguard]
  end


  def eachDefoggable(side,isOurSide)
    side.eachEffect(true) do |effect,value,data|
      if !isOurSide && (data.is_screen? || @miscEffects.include?(effect))
        yield effect,data
      elsif data.is_hazard?
        yield effect,data
      end
    end
  end

  def pbFailsAgainstTarget?(user,target)
    targetSide = target.pbOwnSide
    ourSide = user.pbOwnSide
    eachDefoggable(targetSide,false) do |effect,data|
      return false
    end
    eachDefoggable(ourSide,true) do |effect,data|
      return false
    end
    return false if @battle.field.terrain != :None
    return super
  end

  def blowAwayEffect(user,side,effect,data)
    side.disableEffect(effect)
    if data.is_hazard?
      hazardName = data.real_name
      @battle.pbDisplay(_INTL("{1} blew away {2}!",user.pbThis, hazardName)) if !data.has_expire_proc?
    end
  end

  def pbEffectAgainstTarget(user,target)
    super
    targetSide = target.pbOwnSide
    ourSide = user.pbOwnSide
    eachDefoggable(targetSide,false) do |effect,data|
      blowAwayEffect(user,targetSide,effect,data)
    end
    eachDefoggable(ourSide,true) do |effect,data|
      blowAwayEffect(user,ourSide,effect,data)
    end
    @battle.endTerrain
  end

  def getScore(score,user,target,skill=100)
    score = super
    score = 100 if score == 0
    # Dislike removing hazards that affect the enemy
    score -= hazardWeightOnSide(target.pbOwnSide)
    # Like removing hazards that affect us
    score += hazardWeightOnSide(target.pbOpposingSide)
    target.pbOwnSide.eachEffect(true) do |effect,value,data|
      score += 25 if data.is_screen? || @miscEffects.include?(effect)
    end
    score += 30 if @battle.field.terrain != :None
    return score
  end
end

#===============================================================================
# Decreases the target's Attack and Defense by 1 stage each. (Tickle)
#===============================================================================
class PokeBattle_Move_04A < PokeBattle_TargetMultiStatDownMove
  def initialize(battle,move)
    super
    @statDown = [:ATTACK,1,:DEFENSE,1]
  end
end

#===============================================================================
# Decreases the target's Attack by 2 stages. (Charm, Feather Dance)
#===============================================================================
class PokeBattle_Move_04B < PokeBattle_TargetStatDownMove
  def initialize(battle,move)
    super
    @statDown = [:ATTACK,2]
  end
end

#===============================================================================
# Decreases the target's Defense by 2 stages. (Screech)
#===============================================================================
class PokeBattle_Move_04C < PokeBattle_TargetStatDownMove
  def initialize(battle,move)
    super
    @statDown = [:DEFENSE,2]
  end
end

#===============================================================================
# Decreases the target's Speed by 2 stages. (Cotton Spore, Scary Face, String Shot)
#===============================================================================
class PokeBattle_Move_04D < PokeBattle_TargetStatDownMove
  def initialize(battle,move)
    super
    @statDown = [:SPEED,2]
  end
end

#===============================================================================
# Decreases the target's Special Attack by 2 stages. Only works on the opposite
# gender. (Captivate)
#===============================================================================
class PokeBattle_Move_04E < PokeBattle_TargetStatDownMove
  def initialize(battle,move)
    super
    @statDown = [:SPECIAL_ATTACK,2]
  end

  def pbFailsAgainstTarget?(user,target)
    return true if super
    return false if damagingMove?
    if user.gender==2 || target.gender==2 || user.gender==target.gender
      @battle.pbDisplay(_INTL("{1} is unaffected!",target.pbThis))
      return true
    end
    if target.hasActiveAbility?(:OBLIVIOUS) && !@battle.moldBreaker
      @battle.pbShowAbilitySplash(target)
      @battle.pbDisplay(_INTL("{1} is unaffected!",target.pbThis))
      @battle.pbHideAbilitySplash(target)
      return true
    end
    return false
  end

  def pbAdditionalEffect(user,target)
    return if user.gender==2 || target.gender==2 || user.gender==target.gender
    return if target.hasActiveAbilityAI?(:OBLIVIOUS) && !@battle.moldBreaker
    super
  end
end

#===============================================================================
# Decreases the target's Special Defense by 2 stages.
#===============================================================================
class PokeBattle_Move_04F < PokeBattle_TargetStatDownMove
  def initialize(battle,move)
    super
    @statDown = [:SPECIAL_DEFENSE,2]
  end
end

#===============================================================================
# Resets all target's stat stages to 0. (Clear Smog)
#===============================================================================
class PokeBattle_Move_050 < PokeBattle_Move
  def pbEffectAgainstTarget(user,target)
    if target.damageState.calcDamage > 0 && !target.damageState.substitute && target.hasAlteredStatStages?
      target.pbResetStatStages
      @battle.pbDisplay(_INTL("{1}'s stat changes were removed!",target.pbThis))
    end
  end
  
  def getScore(score,user,target,skill=100)
    if !target.substituted? && target.hasAlteredStatStages?
			GameData::Stat.each_battle do |s|
				score += target.stages[s.id] * 10
			end
		end
    return score
  end
end

#===============================================================================
# Resets all stat stages for all battlers to 0. (Haze)
#===============================================================================
class PokeBattle_Move_051 < PokeBattle_Move
  def pbMoveFailed?(user,targets)
    failed = true
    @battle.eachBattler do |b|
      failed = false if b.hasAlteredStatStages?
      break if !failed
    end
    if failed
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
    @battle.eachBattler { |b| b.pbResetStatStages }
    @battle.pbDisplay(_INTL("All stat changes were eliminated!"))
  end

  def getScore(score,user,target,skill=100)
		@battle.eachBattler do |b|
			totalStages = 0
			GameData::Stat.each_battle { |s| totalStages += b.stages[s.id] }
			if b.opposes?(user)
				score += totalStages * 10
			else
				score -= totalStages * 10
			end
		end
    return score
  end
end

#===============================================================================
# User and target swap their Attack and Special Attack stat stages. (Power Swap)
#===============================================================================
class PokeBattle_Move_052 < PokeBattle_Move
  def ignoresSubstitute?(user); return true; end

  def pbEffectAgainstTarget(user,target)
    [:ATTACK,:SPECIAL_ATTACK].each do |s|
      user.stages[s],target.stages[s] = target.stages[s],user.stages[s]
    end
    @battle.pbDisplay(_INTL("{1} switched all changes to its Attack and Sp. Atk with the target!",user.pbThis))
  end

  def getScore(score,user,target,skill=100)
    aatk = user.stages[:ATTACK]
		aspa = user.stages[:SPECIAL_ATTACK]
		oatk = target.stages[:ATTACK]
		ospa = target.stages[:SPECIAL_ATTACK]
		if aatk >= oatk && aspa >= ospa
			score -= 80
		else
			score += (oatk-aatk)*10
			score += (ospa-aspa)*10
		end
    return score
  end
end

#===============================================================================
# User and target swap their Defense and Special Defense stat stages. (Guard Swap)
#===============================================================================
class PokeBattle_Move_053 < PokeBattle_Move
  def ignoresSubstitute?(user); return true; end

  def pbEffectAgainstTarget(user,target)
    [:DEFENSE,:SPECIAL_DEFENSE].each do |s|
      user.stages[s],target.stages[s] = target.stages[s],user.stages[s]
    end
    @battle.pbDisplay(_INTL("{1} switched all changes to its Defense and Sp. Def with the target!",user.pbThis))
  end

  def getScore(score,user,target,skill=100)
    adef = user.stages[:DEFENSE]
		aspd = user.stages[:SPECIAL_DEFENSE]
		odef = target.stages[:DEFENSE]
		ospd = target.stages[:SPECIAL_DEFENSE]
		if adef >= odef && aspd >= ospd
			score -= 80
		else
			score += (odef  -adef) * 10
			score += (ospd - aspd) * 10
		end
    return score
  end
end

#===============================================================================
# User and target swap all their stat stages. (Heart Swap)
#===============================================================================
class PokeBattle_Move_054 < PokeBattle_Move
  def ignoresSubstitute?(user); return true; end

  def pbEffectAgainstTarget(user,target)
    GameData::Stat.each_battle do |s|
      user.stages[s.id],target.stages[s.id] = target.stages[s.id],user.stages[s.id]
    end
    @battle.pbDisplay(_INTL("{1} switched stat changes with the target!",user.pbThis))
  end

  def getScore(score,user,target,skill=100)
    userStages = 0; targetStages = 0
    GameData::Stat.each_battle do |s|
      userStages	 += user.stages[s.id]
      targetStages += target.stages[s.id]
    end
    score += (targetStages-userStages)*10
    return score
  end
end

#===============================================================================
# User copies the target's stat stages. (Psych Up)
#===============================================================================
class PokeBattle_Move_055 < PokeBattle_Move
  def ignoresSubstitute?(user); return true; end

  def pbEffectAgainstTarget(user,target)
    GameData::Stat.each_battle { |s| user.stages[s.id] = target.stages[s.id] }
    # Copy critical hit chance raising effects
    target.eachEffect do |effect, value, data|
      user.effects[effect] = value if data.critical_rate_buff?
    end
    @battle.pbDisplay(_INTL("{1} copied {2}'s stat changes!",user.pbThis,target.pbThis(true)))
  end

  def getScore(score,user,target,skill=100)
    equal = true
    GameData::Stat.each_battle do |s|
      stagediff = target.stages[s.id] - user.stages[s.id]
      score += stagediff * 10
      equal = false if stagediff != 0
    end
    score = 0 if equal
    return score
  end
end

#===============================================================================
# For 10 rounds, user's and ally's stat stages cannot be lowered by foes. (Mist)
#===============================================================================
class PokeBattle_Move_056 < PokeBattle_Move
  def pbMoveFailed?(user,targets)
    if user.pbOwnSide.effectActive?(:Mist)
      @battle.pbDisplay(_INTL("But it failed, because #{user.pbTeam(true)} is already shrouded in mist!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
    user.pbOwnSide.applyEffect(:Mist,10)
  end
end

#===============================================================================
# Swaps the user's Attack and Defense stats. (Power Trick)
#===============================================================================
class PokeBattle_Move_057 < PokeBattle_Move
  def pbEffectGeneral(user)
    user.attack,user.defense = user.defense,user.attack
    user.effects[:PowerTrick] = !user.effects[:PowerTrick]
    @battle.pbDisplay(_INTL("{1} switched its Attack and Defense!",user.pbThis))
  end

  def getScore(score,user,target,skill=100)
    aatk = pbRoughStat(user,:ATTACK,skill)
		adef = pbRoughStat(user,:DEFENSE,skill)
		if aatk == adef || user.effectActive?(:PowerTrick)	 # No flip-flopping
			return 0
		elsif adef > aatk	 # Prefer a higher Attack
			score += 50
		else
			score -= 50
		end
    return score
  end
end

#===============================================================================
# Averages the user's and target's Attack.
# Averages the user's and target's Special Attack. (Power Split)
#===============================================================================
class PokeBattle_Move_058 < PokeBattle_Move
  def pbEffectAgainstTarget(user,target)
    newatk   = ((user.attack+target.attack)/2).floor
    newspatk = ((user.spatk+target.spatk)/2).floor
    user.attack = target.attack = newatk
    user.spatk  = target.spatk  = newspatk
    @battle.pbDisplay(_INTL("{1} shared its power with the target!",user.pbThis))
  end

  def getScore(score,user,target,skill=100)
    aatk	 = pbRoughStat(user,:ATTACK,skill)
		aspatk = pbRoughStat(user,:SPECIAL_ATTACK,skill)
		oatk	 = pbRoughStat(target,:ATTACK,skill)
		ospatk = pbRoughStat(target,:SPECIAL_ATTACK,skill)
		if aatk < oatk && aspatk<ospatk
			score += 50
		elsif aatk + aspatk < oatk+ospatk
			score += 30
		else
			score -= 50
		end
    return score
  end
end

#===============================================================================
# Averages the user's and target's Defense.
# Averages the user's and target's Special Defense. (Guard Split)
#===============================================================================
class PokeBattle_Move_059 < PokeBattle_Move
  def pbEffectAgainstTarget(user,target)
    newdef   = ((user.defense+target.defense)/2).floor
    newspdef = ((user.spdef+target.spdef)/2).floor
    user.defense = target.defense = newdef
    user.spdef   = target.spdef   = newspdef
    @battle.pbDisplay(_INTL("{1} shared its guard with the target!",user.pbThis))
  end

  def getScore(score,user,target,skill=100)
    adef	 = pbRoughStat(user,:DEFENSE,skill)
		aspdef = pbRoughStat(user,:SPECIAL_DEFENSE,skill)
		odef	 = pbRoughStat(target,:DEFENSE,skill)
		ospdef = pbRoughStat(target,:SPECIAL_DEFENSE,skill)
		if adef < odef && aspdef < ospdef
			score += 50
		elsif adef + aspdef < odef + ospdef
			score += 30
		else
			score -= 50
		end
    return score
  end
end

#===============================================================================
# Averages the user's and target's current HP. (Pain Split)
#===============================================================================
class PokeBattle_Move_05A < PokeBattle_Move
    def pbFailsAgainstTarget?(user,target)
		if target.boss?
			@battle.pbDisplay(_INTL("But it failed!"))
			return true
		end
		return false
	end

  def pbEffectAgainstTarget(user,target)
      newHP = (user.hp+target.hp)/2
      if user.hp>newHP;    user.pbReduceHP(user.hp-newHP,false,false)
      elsif user.hp<newHP; user.pbRecoverHP(newHP-user.hp,false,true,false)
      end
      if target.hp>newHP;    target.pbReduceHP(target.hp-newHP,false,false)
      elsif target.hp<newHP; target.pbRecoverHP(newHP-target.hp,false,true,false)
      end
      @battle.pbDisplay(_INTL("The battlers shared their pain!"))
      user.pbItemHPHealCheck
      target.pbItemHPHealCheck
  end

  def getScore(score,user,target,skill=100)
    if user.hp >= (user.hp + target.hp) / 2
      score = 0
    else
      score += 40
    end
    return score
  end
end

#===============================================================================
# For 4 rounds, doubles the Speed of all battlers on the user's side. (Tailwind)
#===============================================================================
class PokeBattle_Move_05B < PokeBattle_Move
  def pbMoveFailed?(user,targets)
    if user.pbOwnSide.effectActive?(:Tailwind)
      @battle.pbDisplay(_INTL("But it failed, since there is already a tailwind blowing!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
    user.pbOwnSide.applyEffect(:Tailwind,4)
  end

  def getScore(score,user,target,skill=100)
    score += 30 if @battle.pbSideSize(user.index)
    return score
  end
end

#===============================================================================
# This move turns into the last move used by the target, until user switches
# out. (Mimic)
#===============================================================================
class PokeBattle_Move_05C < PokeBattle_Move
  def ignoresSubstitute?(user); return true; end

  def initialize(battle,move)
    super
    @moveBlacklist = [
       "014",   # Chatter
       "0B6",   # Metronome
       # Struggle
       "002",   # Struggle
       # Moves that affect the moveset
       "05C",   # Mimic
       "05D",   # Sketch
       "069"    # Transform
    ]
  end

  def pbMoveFailed?(user,targets)
    if user.transformed? || !user.pbHasMove?(@id)
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbFailsAgainstTarget?(user,target)
    lastMoveData = GameData::Move.try_get(target.lastRegularMoveUsed)
    if !lastMoveData ||
       user.pbHasMove?(target.lastRegularMoveUsed) ||
       @moveBlacklist.include?(lastMoveData.function_code) ||
       lastMoveData.type == :SHADOW
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectAgainstTarget(user,target)
    user.eachMoveWithIndex do |m,i|
      next if m.id!=@id
      newMove = Pokemon::Move.new(target.lastRegularMoveUsed)
      user.moves[i] = PokeBattle_Move.from_pokemon_move(@battle,newMove)
      @battle.pbDisplay(_INTL("{1} learned {2}!",user.pbThis,newMove.name))
      user.pbCheckFormOnMovesetChange
      break
    end
  end
end

#===============================================================================
# This move permanently turns into the last move used by the target. (Sketch)
#===============================================================================
class PokeBattle_Move_05D < PokeBattle_Move
  def ignoresSubstitute?(user); return true; end

  def initialize(battle,move)
    super
    @moveBlacklist = [
       "014",   # Chatter
       "05D",   # Sketch (this move)
       # Struggle
       "002"    # Struggle
    ]
  end

  def pbMoveFailed?(user,targets)
    if user.transformed? || !user.pbHasMove?(@id)
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbFailsAgainstTarget?(user,target)
    lastMoveData = GameData::Move.try_get(target.lastRegularMoveUsed)
    if !lastMoveData ||
       user.pbHasMove?(target.lastRegularMoveUsed) ||
       @moveBlacklist.include?(lastMoveData.function_code) ||
       lastMoveData.type == :SHADOW
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectAgainstTarget(user,target)
    user.eachMoveWithIndex do |m,i|
      next if m.id!=@id
      newMove = Pokemon::Move.new(target.lastRegularMoveUsed)
      user.pokemon.moves[i] = newMove
      user.moves[i] = PokeBattle_Move.from_pokemon_move(@battle,newMove)
      @battle.pbDisplay(_INTL("{1} learned {2}!",user.pbThis,newMove.name))
      user.pbCheckFormOnMovesetChange
      break
    end
  end
end

#===============================================================================
# Changes user's type to that of a random user's move, except a type the user
# already has (even partially), OR changes to the user's first move's type.
# (Conversion)
#===============================================================================
class PokeBattle_Move_05E < PokeBattle_Move
  def pbMoveFailed?(user,targets)
    if !user.canChangeType?
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    userTypes = user.pbTypes(true)
    @newTypes = []
    user.eachMoveWithIndex do |m,i|
      break if i > 0
      next if GameData::Type.get(m.type).pseudo_type
      next if userTypes.include?(m.type)
      @newTypes.push(m.type) if !@newTypes.include?(m.type)
    end
    if @newTypes.length==0
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
    newType = @newTypes[@battle.pbRandom(@newTypes.length)]
    user.pbChangeTypes(newType)
    typeName = GameData::Type.get(newType).name
    @battle.pbDisplay(_INTL("{1} transformed into the {2} type!",user.pbThis,typeName))
  end
end

#===============================================================================
# Changes user's type to a random one that resists/is immune to the last move
# used by the target. (Conversion 2)
#===============================================================================
class PokeBattle_Move_05F < PokeBattle_Move
  def ignoresSubstitute?(user); return true; end

  def pbMoveFailed?(user, targets)
    if !user.canChangeType?
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbFailsAgainstTarget?(user, target)
    if !target.lastMoveUsed || !target.lastMoveUsedType ||
       GameData::Type.get(target.lastMoveUsedType).pseudo_type
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    @newTypes = []
    GameData::Type.each do |t|
      next if t.pseudo_type || user.pbHasType?(t.id) ||
              !Effectiveness.resistant_type?(target.lastMoveUsedType, t.id)
      @newTypes.push(t.id)
    end
    if @newTypes.length == 0
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
    newType = @newTypes[@battle.pbRandom(@newTypes.length)]
    user.pbChangeTypes(newType)
    typeName = GameData::Type.get(newType).name
    @battle.pbDisplay(_INTL("{1} transformed into the {2} type!", user.pbThis, typeName))
  end
end

#===============================================================================
# Changes user's type depending on the environment. (Camouflage)
#===============================================================================
class PokeBattle_Move_060 < PokeBattle_Move
  def pbMoveFailed?(user,targets)
    if !user.canChangeType?
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    camouflageType = getCamouflageType()
    if !GameData::Type.exists?(camouflageType) || !user.pbHasOtherType?(camouflageType)
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def getCamouflageType()
    newType = :NORMAL
    checkedTerrain = false
    case @battle.field.terrain
    when :Electric
        newType = :ELECTRIC
        checkedTerrain = true
    when :Grassy
        newType = :GRASS
        checkedTerrain = true
    when :Misty
        newType = :FAIRY
        checkedTerrain = true
    when :Psychic
        newType = :PSYCHIC
        checkedTerrain = true
    end
    if !checkedTerrain
      case @battle.environment
      when :Grass, :TallGrass
        newType = :GRASS
      when :MovingWater, :StillWater, :Puddle, :Underwater
        newType = :WATER
      when :Cave
        newType = :ROCK
      when :Rock, :Sand
        newType = :GROUND
      when :Forest, :ForestGrass
        newType = :BUG
      when :Snow, :Ice
        newType = :ICE
      when :Volcano
        newType = :FIRE
      when :Graveyard
        newType = :GHOST
      when :Sky
        newType = :FLYING
      when :Space
        newType = :DRAGON
      when :UltraSpace
        newType = :PSYCHIC
      end
    end
    newType = :NORMAL if !GameData::Type.exists?(newType)
    return newType
  end

  def pbEffectGeneral(user)
    newType = getCamouflageType()
    user.pbChangeTypes(newType)
    typeName = GameData::Type.get(newType).name
    @battle.pbDisplay(_INTL("{1} transformed into the {2} type!",user.pbThis,typeName))
  end
end

#===============================================================================
# Target becomes Water type. (Soak)
#===============================================================================
class PokeBattle_Move_061 < PokeBattle_Move
  def pbFailsAgainstTarget?(user,target)
    if !target.canChangeType? || !GameData::Type.exists?(:WATER) ||
       !target.pbHasOtherType?(:WATER)
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectAgainstTarget(user,target)
    target.pbChangeTypes(:WATER)
    typeName = GameData::Type.get(:WATER).name
    @battle.pbDisplay(_INTL("{1} transformed into the {2} type!",target.pbThis,typeName))
  end
end

#===============================================================================
# User copes target's types. (Reflect Type)
#===============================================================================
class PokeBattle_Move_062 < PokeBattle_Move
  def ignoresSubstitute?(user); return true; end

  def pbMoveFailed?(user,targets)
    if !user.canChangeType?
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbFailsAgainstTarget?(user,target)
    newTypes = target.pbTypes(true)
    if newTypes.length==0   # Target has no type to copy
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    if user.pbTypes==target.pbTypes && user.effects[:Type3] == target.effects[:Type3]
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectAgainstTarget(user,target)
    user.pbChangeTypes(target)
    @battle.pbDisplay(_INTL("{1}'s type changed to match {2}'s!",
       user.pbThis,target.pbThis(true)))
  end
end

#===============================================================================
# Target's ability becomes Simple. (Simple Beam)
#===============================================================================
class PokeBattle_Move_063 < PokeBattle_Move
  def pbMoveFailed?(user,targets)
    if !GameData::Ability.exists?(:SIMPLE)
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbFailsAgainstTarget?(user,target)
    if target.unstoppableAbility? || [:TRUANT, :SIMPLE].include?(target.ability)
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectAgainstTarget(user,target)
    @battle.pbShowAbilitySplash(target,true,false)
    oldAbil = target.ability
    target.ability = :SIMPLE
    @battle.pbReplaceAbilitySplash(target)
    @battle.pbDisplay(_INTL("{1} acquired {2}!",target.pbThis,target.abilityName))
    @battle.pbHideAbilitySplash(target)
    target.pbOnAbilityChanged(oldAbil)
  end
end

#===============================================================================
# Target's ability becomes Insomnia. (Worry Seed)
#===============================================================================
class PokeBattle_Move_064 < PokeBattle_Move
  def pbMoveFailed?(user,targets)
    if !GameData::Ability.exists?(:INSOMNIA)
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbFailsAgainstTarget?(user,target)
    if target.unstoppableAbility? || [:TRUANT, :INSOMNIA].include?(target.ability_id)
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectAgainstTarget(user,target)
    @battle.pbShowAbilitySplash(target,true,false)
    oldAbil = target.ability
    target.ability = :INSOMNIA
    @battle.pbReplaceAbilitySplash(target)
    @battle.pbDisplay(_INTL("{1} acquired {2}!",target.pbThis,target.abilityName))
    @battle.pbHideAbilitySplash(target)
    target.pbOnAbilityChanged(oldAbil)
  end
end

#===============================================================================
# User copies target's ability. (Role Play)
#===============================================================================
class PokeBattle_Move_065 < PokeBattle_Move
  def ignoresSubstitute?(user); return true; end

  def pbMoveFailed?(user,targets)
    if user.unstoppableAbility?
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbFailsAgainstTarget?(user,target)
    if !target.ability || user.ability==target.ability
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    if target.ungainableAbility? || [:POWEROFALCHEMY, :RECEIVER, :TRACE, :WONDERGUARD].include?(target.ability_id)
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectAgainstTarget(user,target)
    @battle.pbShowAbilitySplash(user,true,false)
    oldAbil = user.ability
    user.ability = target.ability
    @battle.pbReplaceAbilitySplash(user)
    @battle.pbDisplay(_INTL("{1} copied {2}'s {3}!",
       user.pbThis,target.pbThis(true),target.abilityName))
    @battle.pbHideAbilitySplash(user)
    user.pbOnAbilityChanged(oldAbil)
    user.pbEffectsOnSwitchIn
  end

  def getScore(score,user,target,skill=100)
    return 0 if target.hasActiveAbilityAI?(DOWNSIDE_ABILITIES)
		score += 100 if user.hasActiveAbilityAI?(DOWNSIDE_ABILITIES)
    return score
  end
end

#===============================================================================
# Target copies user's ability. (Entrainment)
#===============================================================================
class PokeBattle_Move_066 < PokeBattle_Move
  def pbMoveFailed?(user,targets)
    if !user.ability
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    if user.ungainableAbility? ||
       [:POWEROFALCHEMY, :RECEIVER, :TRACE].include?(user.ability_id)
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbFailsAgainstTarget?(user,target)
    if target.unstoppableAbility? || target.ability == :TRUANT
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectAgainstTarget(user,target)
    @battle.pbShowAbilitySplash(target,true,false)
    oldAbil = target.ability
    target.ability = user.ability
    @battle.pbReplaceAbilitySplash(target)
    @battle.pbDisplay(_INTL("{1} acquired {2}!",target.pbThis,target.abilityName))
    @battle.pbHideAbilitySplash(target)
    target.pbOnAbilityChanged(oldAbil)
    target.pbEffectsOnSwitchIn
  end

  def getScore(score,user,target,skill=100)
    score -= 30
		if user.hasActiveAbilityAI?(DOWNSIDE_ABILITIES)
      if user.opposes?(target)
        score += 60
      else
        return 0
      end
    end
    return score
  end
end

#===============================================================================
# User and target swap abilities. (Skill Swap)
#===============================================================================
class PokeBattle_Move_067 < PokeBattle_Move
  def ignoresSubstitute?(user); return true; end

  def pbMoveFailed?(user,targets)
    if !user.ability
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    if user.unstoppableAbility?
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    if user.ungainableAbility? || user.ability == :WONDERGUARD
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbFailsAgainstTarget?(user,target)
    if !target.ability
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    if target.unstoppableAbility?
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    if target.ungainableAbility? || target.ability == :WONDERGUARD
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectAgainstTarget(user,target)
    if user.opposes?(target)
      @battle.pbShowAbilitySplash(user,false,false)
      @battle.pbShowAbilitySplash(target,true,false)
    end
    oldUserAbil   = user.ability
    oldTargetAbil = target.ability
    user.ability   = oldTargetAbil
    target.ability = oldUserAbil
    if user.opposes?(target)
      @battle.pbReplaceAbilitySplash(user)
      @battle.pbReplaceAbilitySplash(target)
    end
    @battle.pbDisplay(_INTL("{1} swapped Abilities with its target!",user.pbThis))
    if user.opposes?(target)
      @battle.pbHideAbilitySplash(user)
      @battle.pbHideAbilitySplash(target)
    end
    user.pbOnAbilityChanged(oldUserAbil)
    target.pbOnAbilityChanged(oldTargetAbil)
    user.pbEffectsOnSwitchIn
    target.pbEffectsOnSwitchIn
  end

  def getScore(score,user,target,skill=100)
    return 0 if target.hasActiveAbilityAI?(DOWNSIDE_ABILITIES)
    score -= 40
		score += 100 if user.hasActiveAbilityAI?(DOWNSIDE_ABILITIES)
    return score
  end
end

#===============================================================================
# Target's ability is negated. (Gastro Acid)
#===============================================================================
class PokeBattle_Move_068 < PokeBattle_Move
  def pbFailsAgainstTarget?(user,target)
    if target.unstoppableAbility? || target.effectActive?(:GastroAcid)
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectAgainstTarget(user,target)
    target.applyEffect(:GastroAcid)
  end

  def getScore(score,user,target,skill=100)
    if target.hasActiveAbilityAI?(DOWNSIDE_ABILITIES)
      if user.opposes?(target)
        return 0
      else
        score += 40
      end
    end
    score -= 20
    return score
  end
end

#===============================================================================
# User transforms into the target. (Transform)
#===============================================================================
class PokeBattle_Move_069 < PokeBattle_Move
  def pbMoveFailed?(user,targets)
    if user.transformed?
      @battle.pbDisplay(_INTL("But it failed, since the user is already transformed!"))
      return true
    end
    return false
  end

  def pbFailsAgainstTarget?(user,target)
    if target.transformed? || target.illusion?
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectAgainstTarget(user,target)
    user.pbTransform(target)
  end

  def getScore(score,user,target,skill=100)
    score += 100
    return score
  end
end

#===============================================================================
# Inflicts a fixed 20HP damage. (Sonic Boom)
#===============================================================================
class PokeBattle_Move_06A < PokeBattle_FixedDamageMove
  def pbFixedDamage(user,target)
    return 20
  end
end

#===============================================================================
# Inflicts a fixed 40HP damage. (Dragon Rage)
#===============================================================================
class PokeBattle_Move_06B < PokeBattle_FixedDamageMove
  def pbFixedDamage(user,target)
    return 40
  end
end

#===============================================================================
# Halves the target's current HP. (Nature's Madness, Super Fang)
#===============================================================================
class PokeBattle_Move_06C < PokeBattle_FixedDamageMove
    def pbFixedDamage(user,target)
        damage = target.hp/2.0
        damage /= BOSS_HP_BASED_EFFECT_RESISTANCE if target.boss?
        return damage.round
    end
end

#===============================================================================
# Inflicts damage equal to the user's level. (Night Shade, Seismic Toss)
#===============================================================================
class PokeBattle_Move_06D < PokeBattle_FixedDamageMove
  def pbFixedDamage(user,target)
    return user.level
  end
end

#===============================================================================
# Inflicts damage to bring the target's HP down to equal the user's HP. (Endeavor)
#===============================================================================
class PokeBattle_Move_06E < PokeBattle_FixedDamageMove
  def pbFailsAgainstTarget?(user,target)
    if user.hp>=target.hp || target.boss?
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbNumHits(user,targets,checkingForAI=false); return 1; end

  def pbFixedDamage(user,target)
    return target.hp-user.hp
  end
end

#===============================================================================
# Inflicts damage between 0.5 and 1.5 times the user's level. (Psywave)
#===============================================================================
class PokeBattle_Move_06F < PokeBattle_FixedDamageMove
  def pbFixedDamage(user,target)
    min = (user.level/2).floor
    max = (user.level*3/2).floor
    return min+@battle.pbRandom(max-min+1)
  end

  def getScore(score,user,target,skill=100)
    echoln("The AI will never use Psywave.")
    return 0
  end
end

#===============================================================================
# OHKO. Accuracy increases by difference between levels of user and target.
#===============================================================================
class PokeBattle_Move_070 < PokeBattle_FixedDamageMove
  def pbFailsAgainstTarget?(user,target)
    if target.level>user.level
      @battle.pbDisplay(_INTL("{1} is unaffected!",target.pbThis))
      return true
    end
    if target.hasActiveAbility?(:STURDY) && !@battle.moldBreaker
      @battle.pbShowAbilitySplash(target)
      @battle.pbDisplay(_INTL("But it failed to affect {1}!",target.pbThis(true)))
      @battle.pbHideAbilitySplash(target)
      return true
    end
    return false
  end

  def pbAccuracyCheck(user,target)
    return true if user.boss
    acc = @accuracy+user.level-target.level
    return @battle.pbRandom(100)<acc
  end

  def pbFixedDamage(user,target)
    return target.totalhp
  end

  def pbHitEffectivenessMessages(user,target,numTargets=1)
    super
    if target.fainted?
      @battle.pbDisplay(_INTL("It's a one-hit KO!"))
    end
  end

  def getScore(score,user,target,skill=100)
    echoln("The AI will never use a OHKO move.")
    return 0
  end
end
#===============================================================================
# Counters a physical move used against the user this round, with 2x the power.
# (Counter)
#===============================================================================
class PokeBattle_Move_071 < PokeBattle_FixedDamageMove
  def pbAddTarget(targets,user)
    target = user.getBattlerPointsTo(:CounterTarget)
    return if target.nil? || !user.opposes?(target)
    user.pbAddTarget(targets,user,target,self,false)
  end

  def pbMoveFailed?(user,targets)
    if targets.length == 0
      @battle.pbDisplay(_INTL("But there was no target..."))
      return true
    end
    return false
  end

  def pbFixedDamage(user,target)
    dmg = user.effects[:Counter] * 2
    dmg = 1 if dmg==0
    return dmg
  end

  def getScore(score,user,target,skill=100)
    return 0 if !target.canActThisTurn?
		return 0 if user.hp/user.totalhp <= 0.5
    return 0 if target.lastMoveUsed.nil?
		moveData = GameData::Move.get(target.lastMoveUsed)
    score += 100 if moveData.physical?
    return score
  end
end

#===============================================================================
# Counters a specical move used against the user this round, with 2x the power.
# (Mirror Coat)
#===============================================================================
class PokeBattle_Move_072 < PokeBattle_FixedDamageMove
  def pbAddTarget(targets,user)
    target = user.getBattlerPointsTo(:MirrorCoatTarget)
    return if target.nil? || !user.opposes?(target)
    user.pbAddTarget(targets,user,target,self,false)
  end

  def pbMoveFailed?(user,targets)
    if targets.length == 0
      @battle.pbDisplay(_INTL("But there was no target..."))
      return true
    end
    return false
  end

  def pbFixedDamage(user,target)
    dmg = user.effects[:MirrorCoat] * 2
    dmg = 1 if dmg==0
    return dmg
  end

  def getScore(score,user,target,skill=100)
    return 0 if !target.canActThisTurn?
		return 0 if user.hp/user.totalhp <= 0.5
    return 0 if target.lastMoveUsed.nil?
		moveData = GameData::Move.get(target.lastMoveUsed)
    score += 100 if moveData.special?
    return score
  end
end

#===============================================================================
# Counters the last damaging move used against the user this round, with 1.5x
# the power. (Metal Burst)
#===============================================================================
class PokeBattle_Move_073 < PokeBattle_FixedDamageMove
  def pbAddTarget(targets,user)
    return if user.lastFoeAttacker.length==0
    lastAttacker = user.lastFoeAttacker.last
    return if lastAttacker<0 || !user.opposes?(lastAttacker)
    user.pbAddTarget(targets,user,@battle.battlers[lastAttacker],self,false)
  end

  def pbMoveFailed?(user,targets)
    if targets.length==0
      @battle.pbDisplay(_INTL("But there was no target..."))
      return true
    end
    return false
  end

  def pbFixedDamage(user,target)
    dmg = (user.lastHPLostFromFoe*1.5).floor
    dmg = 1 if dmg==0
    return dmg
  end

  def getScore(score,user,target,skill=100)
    return 0 if !target.canActThisTurn?
		return 0 if user.hp/user.totalhp <= 0.5
    return 0 if target.lastMoveUsed.nil?
		moveData = GameData::Move.get(target.lastMoveUsed)
    score += 50 if moveData.damaging?
    return score
  end
end

#===============================================================================
# The target's ally loses 1/16 of its max HP. (Flame Burst)
#===============================================================================
class PokeBattle_Move_074 < PokeBattle_Move
  def pbEffectWhenDealingDamage(user,target)
    hitAlly = []
    target.eachAlly do |b|
      next if !b.near?(target.index)
      next if !b.takesIndirectDamage?
      hitAlly.push([b.index,b.hp])
      b.pbReduceHP(b.totalhp/16,false)
    end
    if hitAlly.length==2
      @battle.pbDisplay(_INTL("The bursting flame hit {1} and {2}!",
         @battle.battlers[hitAlly[0][0]].pbThis(true),
         @battle.battlers[hitAlly[1][0]].pbThis(true)))
    elsif hitAlly.length>0
      hitAlly.each do |b|
        @battle.pbDisplay(_INTL("The bursting flame hit {1}!",
           @battle.battlers[b[0]].pbThis(true)))
      end
    end
    switchedAlly = []
    hitAlly.each do |b|
      @battle.battlers[b[0]].pbItemHPHealCheck
      if @battle.battlers[b[0]].pbAbilitiesOnDamageTaken(b[1])
        switchedAlly.push(@battle.battlers[b[0]])
      end
    end
    switchedAlly.each { |b| b.pbEffectsOnSwitchIn(true) }
  end

  def getScore(score,user,target,skill=100)
    target.eachAlly do |b|
			next if !b.near?(target)
			score += 10
		end
    return score
  end
end

#===============================================================================
# Power is doubled if the target is using Dive. Hits some semi-invulnerable
# targets. (Surf)
#===============================================================================
class PokeBattle_Move_075 < PokeBattle_Move
  def hitsDivingTargets?; return true; end

  def pbModifyDamage(damageMult,user,target)
    damageMult *= 2 if target.inTwoTurnAttack?("0CB")   # Dive
    return damageMult
  end

  def pbEffectAfterAllHits(user,target)
    if !target.damageState.unaffected && !target.damageState.protected && !target.damageState.missed && user.canGulpMissile?
      user.form=2
      user.form=1 if user.hp>(user.totalhp/2)
      @battle.scene.pbChangePokemon(user,user.pokemon)
    end
  end

  def getScore(score,user,target,skill=100)
    score += 40 if user.canGulpMissile?
    return score
  end
end

#===============================================================================
# Power is doubled if the target is using Dig. Hits digging targets. (Earthquake)
#===============================================================================
class PokeBattle_Move_076 < PokeBattle_Move
  def hitsDiggingTargets?; return true; end

  def pbModifyDamage(damageMult,user,target)
    damageMult *= 2 if target.inTwoTurnAttack?("0CA")   # Dig
    return damageMult
  end
end

#===============================================================================
# Puts the target to sleep, but only if the user is Darkrai. (Dark Void)
#===============================================================================
class PokeBattle_Move_077 < PokeBattle_SleepMove
  def pbMoveFailed?(user,targets)
    if !user.countsAs?(:DARKRAI)
      @battle.pbDisplay(_INTL("But {1} can't use the move!",user.pbThis))
      return true
    end
    return false
  end
end

#===============================================================================
# Has a chance to put the target to sleep. Swaps form if the user is Meloetta.
#===============================================================================
class PokeBattle_Move_078 < PokeBattle_SleepMove
  def pbEndOfMoveUsageEffect(user,targets,numHits,switchedBattlers)
    return if numHits == 0
    return if user.fainted? || user.transformed?
    return if !user.isSpecies?(:MELOETTA)
    return if user.hasActiveAbility?(:SHEERFORCE)
    newForm = (user.form + 1) % 2
    user.pbChangeForm(newForm,_INTL("{1} transformed!",user.pbThis))
  end
end

#===============================================================================
# Power is doubled if Fusion Flare has already been used this round. (Fusion Bolt)
#===============================================================================
class PokeBattle_Move_079 < PokeBattle_Move
  def pbChangeUsageCounters(user,specialUsage)
    @doublePower = @battle.field.effectActive?(:FusionFlare)
    super
  end

  def pbBaseDamageMultiplier(damageMult,user,target)
    damageMult *= 2 if @doublePower
    return damageMult
  end

  def pbEffectGeneral(user)
    @battle.field.applyEffect(:FusionBolt)
  end

  def pbShowAnimation(id,user,targets,hitNum=0,showAnimation=true)
    hitNum = 1 if (targets.length>0 && targets[0].damageState.critical) ||
                  @doublePower   # Charged anim
    super
  end
end

#===============================================================================
# Power is doubled if Fusion Bolt has already been used this round. (Fusion Flare)
#===============================================================================
class PokeBattle_Move_07A < PokeBattle_Move
  def pbChangeUsageCounters(user,specialUsage)
    @doublePower = @battle.field.effectActive?(:FusionBolt)
    super
  end

  def pbBaseDamageMultiplier(damageMult,user,target)
    damageMult *= 2 if @doublePower
    return damageMult
  end

  def pbEffectGeneral(user)
    @battle.field.applyEffect(:FusionFlare)
  end

  def pbShowAnimation(id,user,targets,hitNum=0,showAnimation=true)
    hitNum = 1 if (targets.length>0 && targets[0].damageState.critical) ||
                  @doublePower   # Charged anim
    super
  end
end

#===============================================================================
# Power is doubled if the target is poisoned. (Venoshock)
#===============================================================================
class PokeBattle_Move_07B < PokeBattle_Move
  def pbBaseDamage(baseDmg,user,target)
    baseDmg *= 2 if target.poisoned?
    return baseDmg
  end
end

#===============================================================================
# Power is doubled if the target is paralyzed. Cures the target of paralysis.
# (Smelling Salts)
#===============================================================================
class PokeBattle_Move_07C < PokeBattle_Move
  def pbBaseDamage(baseDmg,user,target)
    baseDmg *= 2 if target.paralyzed?
    return baseDmg
  end

  def pbEffectAfterAllHits(user,target)
    return if target.fainted?
    return if target.damageState.unaffected || target.damageState.substitute
    target.pbCureStatus(true,:PARALYSIS)
  end
end

#===============================================================================
# Power is doubled if the target is asleep. Wakes the target up. (Wake-Up Slap)
#===============================================================================
class PokeBattle_Move_07D < PokeBattle_Move
  def pbBaseDamage(baseDmg,user,target)
    baseDmg *= 2 if target.asleep?
    return baseDmg
  end

  def pbEffectAfterAllHits(user,target)
    return if target.fainted?
    return if target.damageState.unaffected || target.damageState.substitute
    target.pbCureStatus(true,:SLEEP)
  end
end

#===============================================================================
# Power is doubled if the user is burned, poisoned or paralyzed. (Facade)
# Burn's halving of Attack is negated (new mechanics).
#===============================================================================
class PokeBattle_Move_07E < PokeBattle_Move
  def damageReducedByBurn?; return false; end

  def pbBaseDamage(baseDmg,user,target)
    baseDmg *= 2 if user.pbHasAnyStatus?
    return baseDmg
  end
end

#===============================================================================
# Power is doubled if the target has a status problem. (Hex, Cruelty)
#===============================================================================
class PokeBattle_Move_07F < PokeBattle_Move
  def pbBaseDamage(baseDmg,user,target)
    baseDmg *= 2 if target.pbHasAnyStatus?
    return baseDmg
  end
end
