#===============================================================================
# This round, user becomes the target of attacks that have single targets.
# (Follow Me)
#===============================================================================
class PokeBattle_Move_RedirectAllMovesToUser < PokeBattle_Move
    def redirectionMove?; return true; end

    def pbEffectGeneral(user)
        maxFollowMe = 0
        user.eachAlly do |b|
            next if b.effects[:FollowMe] <= maxFollowMe
            maxFollowMe = b.effects[:FollowMe]
        end
        user.applyEffect(:FollowMe, maxFollowMe + 1)
    end

    def getEffectScore(user, _target)
        return 0 unless user.hasAlly?
        score = 50
        score += 25 if user.aboveHalfHealth?
        return score
    end
end

#===============================================================================
# This round, target becomes the target of attacks that have single targets.
# (Spotlight)
#===============================================================================
class PokeBattle_Move_RedirectAllMovesToTarget < PokeBattle_Move
    def redirectionMove?; return true; end

    def pbEffectAgainstTarget(_user, target)
        maxSpotlight = 0
        target.eachAlly do |b|
            next if b.effects[:Spotlight] <= maxSpotlight
            maxSpotlight = b.effects[:Spotlight]
        end
        target.applyEffect(:Spotlight, maxSpotlight + 1)
    end

    def getEffectScore(_user, target)
        return 0 unless target.hasAlly?
        score = 50
        score += 25 if target.aboveHalfHealth?
        return score
    end
end