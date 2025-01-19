def battleKeywordsImportant
    return [
        _INTL("rainstorm"),
        _INTL("sunshine"),
        _INTL("sandstorm"),
        _INTL("hail"),
        _INTL("total eclipse"),
        _INTL("eclipse"),
        _INTL("full moon"),
        _INTL("moonglow"),
        _INTL("burning"),
        _INTL("burned"),
        _INTL("burns"),
        _INTL("burn"),
        _INTL("frostbiting"),
        _INTL("frostbitten"),
        _INTL("frostbites"),
        _INTL("frostbite"),
        _INTL("numbing"),
        _INTL("numbed"),
        _INTL("numbs"),
        _INTL("numb"),
        _INTL("poisoning"),
        _INTL("poisoned"),
        _INTL("poisons"),
        _INTL("poison"),
        _INTL("leeching"),
        _INTL("leeched"),
        _INTL("leeches"),
        _INTL("leech"),
        _INTL("dizzying"),
        _INTL("dizzied"),
        _INTL("dizzies"),
        _INTL("dizzy"),
        _INTL("waterlogging"),
        _INTL("waterlogged"),
        _INTL("waterlogs"),
        _INTL("waterlog"),
        _INTL("sleep"),
        _INTL("asleep"),
        _INTL("drowsy"),
        _INTL("cursing"),
        _INTL("cursed"),
        _INTL("curse"),
        _INTL("fracturing"),
        _INTL("fractured"),
        _INTL("fracture"),
        _INTL("jinxing"),
        _INTL("jinxed"),
        _INTL("jinx"),
        _INTL("maximize"),
        _INTL("minimize"),
        _INTL("aqua ring"),
        _INTL("energy charged"),
        _INTL("energy charge"),
        _INTL("recoil"),
        _INTL("flinch"),
        _INTL("flinched"),
        _INTL("flinching"),
        _INTL("random added effects"),
        _INTL("defensive stats"),
        _INTL("offensive stats"),
        _INTL("trapped"),
        _INTL("traps"),
        _INTL("trap"),
    ]
end

def battleKeywordsImportantCaseSensitive
    return [
        _INTL("Sp. Atk"),
        _INTL("Special Attack"),
        _INTL("Attack"),
        _INTL("Sp. Def"),
        _INTL("Special Defense"),
        _INTL("Defense"),
        _INTL("Speed"),
        _INTL("Accuracy"),
        _INTL("Evasion"),
    ]
end

def battleKeywordsUnimportant
    return [
        _INTL("two"),
        _INTL("three"),
        _INTL("four"),
        _INTL("five"),
        _INTL("six"),
        _INTL("seven"),
        _INTL("eight"),
        _INTL("nine"),
        _INTL("ten"),
        _INTL("eleven"),
        _INTL("twelve"),
        _INTL("thirteen"),
        _INTL("fourteen"),
        _INTL("fifteen"),
        _INTL("sixteen"),
        _INTL("seventeen"),
        _INTL("eighteen"),
        _INTL("nineteen"),
        _INTL("twenty"),
        _INTL("twice"),
        _INTL("doubles"),
        _INTL("double"),
        _INTL("three times"),
        _INTL("four times"),
        _INTL("five times"),
        _INTL("half"),
        _INTL("one third"),
        _INTL("two thirds"),
        _INTL("one quarter"),
        _INTL("three quarters"),
        _INTL("one fifth"),
        _INTL("1/6th"),
        _INTL("1/8th"),
        _INTL("1/10th"),
        _INTL("1/12th"),
        _INTL("1/16th"),
    ]
end

def addBattleKeywordHighlighting(description)
    # Highlight very important words in red
    importantColorTag = getSkinColor(nil, 2, darkMode?, true)
    battleKeywordsImportant.each do |keyword|
        description = description.gsub(/\b(#{keyword})\b/i,"#{importantColorTag}\\1</c3>")
    end
    battleKeywordsImportantCaseSensitive.each do |keyword|
        description = description.gsub(/\b(#{keyword})\b/,"#{importantColorTag}\\1</c3>")
    end

    # Outline less important keywords
    unimportantColorTag = getSkinColor(nil, 13, darkMode?, true)
    battleKeywordsUnimportant.each do |keyword|
        description = description.gsub(/\b(#{keyword})\b/i,"#{unimportantColorTag}\\1</c3>")
    end
    description = description.gsub(/\b(\d+%)/i,"#{unimportantColorTag}\\1</c3>")

    return description
end