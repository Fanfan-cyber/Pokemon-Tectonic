#===============================================================================
# Raises Attack of user and allies by 2 steps. (Howl)
#===============================================================================
class PokeBattle_Move_RaiseUserAndAlliesAtk2 < PokeBattle_TeamStatBuffMove
    def initialize(battle, move)
        super
        @statUp = [:ATTACK, 2]
    end
end

# Empowered Howl
class PokeBattle_Move_EmpoweredHowl < PokeBattle_Move_RaiseUserAndAlliesAtk2
    include EmpoweredMove

    def pbEffectGeneral(user)
        summonAvatar(user, :POOCHYENA, _INTL("{1} calls out to the pack!", user.pbThis))
        super
        transformType(user, :DARK)
    end
end

#===============================================================================
# Summons Moonglow for 8 turns. Raises the Attack of itself and all allies by 2 steps. (Midnight Hunt)
#===============================================================================
class PokeBattle_Move_RaiseUserAndAlliesAtk2StartMoonglow8 < PokeBattle_Move_RaiseUserAndAlliesAtk2
    def pbMoveFailed?(user, _targets, show_message)
        return false unless @battle.primevalWeatherPresent?(false)
        super
    end

    def pbEffectGeneral(user)
        @battle.pbStartWeather(user, :Moonglow, 8, false) unless @battle.primevalWeatherPresent?
        super
    end

    def getEffectScore(user, _target)
        score = super
        score += getWeatherSettingEffectScore(:Moonglow, user, @battle, 8)
        return score
    end
end

#===============================================================================
# Raises Defense of user and allies by 2 steps. (Stand Together)
#===============================================================================
class PokeBattle_Move_RaiseUserAndAlliesDef2 < PokeBattle_TeamStatBuffMove
    def initialize(battle, move)
        super
        @statUp = [:DEFENSE, 2]
    end
end

# Empowered Stand Together
class PokeBattle_Move_EmpoweredStandTogether < PokeBattle_Move_RaiseUserAndAlliesDef2
    include EmpoweredMove

    def pbEffectGeneral(user)
        summonAvatar(user, :TYROGUE, _INTL("{1} joins with an ally!", user.pbThis))
        super
        transformType(user, :FIGHTING)
    end
end

#===============================================================================
# Raises Sp. Atk of user and allies by 2 steps. (Mind Link)
#===============================================================================
class PokeBattle_Move_RaiseUserAndAlliesSpAtk2 < PokeBattle_TeamStatBuffMove
    def initialize(battle, move)
        super
        @statUp = [:SPECIAL_ATTACK, 2]
    end
end

# Empowered Mind Link
class PokeBattle_Move_EmpoweredMindLink < PokeBattle_Move_RaiseUserAndAlliesSpAtk2
    include EmpoweredMove

    def pbEffectGeneral(user)
        summonAvatar(user, :ABRA, _INTL("{1} gathers an new mind!", user.pbThis))
        super
        transformType(user, :PSYCHIC)
    end
end

#===============================================================================
# Raises Sp. Def of user and allies by 2 steps. (Symbiosis)
#===============================================================================
class PokeBattle_Move_RaiseUserAndAlliesSpDef2 < PokeBattle_TeamStatBuffMove
    def initialize(battle, move)
        super
        @statUp = [:SPECIAL_DEFENSE, 2]
    end
end

# Empowered Symbiosis
class PokeBattle_Move_EmpoweredSymbiosis < PokeBattle_Move_RaiseUserAndAlliesSpDef2
    include EmpoweredMove

    def pbEffectGeneral(user)
        summonAvatar(user, :GOSSIFLEUR, _INTL("{1} connects with their friend!", user.pbThis))
        super
        transformType(user, :GRASS)
    end
end