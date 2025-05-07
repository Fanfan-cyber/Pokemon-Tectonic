def styleValueMult(level)
    return (2.0 + level.to_f / 50.0)
end

# @return [Integer] the specified stat of this Pokémon (not used for total HP)
def calcStatGlobal(base, level, sv, hp: false, stylish: false, accumulation: false)
    return 1 if base == 1

    pseudoLevel = 15.0
    if accumulation
        pseudoLevel += level.to_f
    else
        pseudoLevel += (level.to_f / 2.0)
    end
    levelRatio = pseudoLevel / 100.0

    # Calculate stats from base stats
    baseStatComponent = base.to_f * 2.0 * levelRatio

    # Calculate stats from style values
    styleValueComponent = sv.to_f * styleValueMult(level) * levelRatio
    styleValueComponent *= 2.0 if stylish

    # Calculate the final stat
    finalStat = baseStatComponent + styleValueComponent + 5.0
    finalStat += 5.0 + pseudoLevel if hp

    return finalStat.floor
end
