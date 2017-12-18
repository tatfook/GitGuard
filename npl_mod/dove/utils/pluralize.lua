--[[
title: NPL Pluralize support
author: chenqh
date: 2017/11/22
desc: Support pluralize and singularize. You can also add your own rules to meet your special needs.
examples:
--------------------------------------------------------------------

local Pluralize = Dove.Utils.Pluralize
-- plural
Pluralize.plural("word")        -- => "words"
Pluralize.plural("word", 1)     -- => "word"
Pluralize.plural("words", 1)    -- => "word"
Pluralize.plural("word", 0)     -- => "words"
Pluralize.plural("words", 0)    -- => "words"
Pluralize.plural("man")         -- => "men"
Pluralize.plural("Hey Man")     -- => "Hey Men"
Pluralize.plural("xMan")        -- => "xMen"
-- singular
Pluralize.singular("words")     -- => "word"
Pluralize.singular("word")      -- => "word"

-- add your own rules
-- add_pluralization_rules
Pluralize.plural("word")        -- => "words"
Pluralize.add_pluralization_rule('word', 'wordiii')
Pluralize.plural("word")        -- => "wordiii"
-- add_singularization_rules
Pluralize.singular("words")     -- => "word"
Pluralize.add_singularization_rule('words', 'wordiii')
Pluralize.singular("word")      -- => "wordiii"
-- add all rules in one table
local new_rules = {
    pluralization_rules = {
        {"word", "wordsss"}
    },
    singularization_rules = {
        {"words", "wordy"}
    },
    uncountable_reg_rules = {
        "^test$", -- important: uncountable_reg_rule is a string
    },
    irregular_plurals = {
        {"bus", "buss"}
    }
}
Pluralize.add_rules(new_rules)

-- is_plural
Pluralize.is_plural("words")    -- => "true"
Pluralize.is_plural("word")     -- => "false"
-- is_singular
Pluralize.is_singular("words")  -- => "false"
Pluralize.is_singular("word")   -- => "true"
]]

local _M = commonlib.gettable("Dove.Utils.Pluralize")

local irregular_signles = {}
local irregular_plurals = {}

local irregular_rules = {
    {'I', 'we'},
    {'me', 'us'},
    {'he', 'they'},
    {'she', 'they'},
    {'them', 'them'},
    {'myself', 'ourselves'},
    {'yourself', 'yourselves'},
    {'itself', 'themselves'},
    {'herself', 'themselves'},
    {'himself', 'themselves'},
    {'themself', 'themselves'},
    {'is', 'are'},
    {'was', 'were'},
    {'has', 'have'},
    {'this', 'these'},
    {'that', 'those'},
    {'person', 'people'},
    {'child', 'children'},
    -- Words ending with a consonant and `o`.
    {'echo', 'echoes'},
    {'dingo', 'dingoes'},
    {'volcano', 'volcanoes'},
    {'tornado', 'tornadoes'},
    {'torpedo', 'torpedoes'},
    -- Ends with `us`.
    {'genus', 'genera'},
    {'viscus', 'viscera'},
    {'alumnus', 'alumni'},
    {'syllabus', 'syllabi'},
    {'octopus', 'octopi'},
    {'virus', 'viri'},
    {'radius', 'radii'},
    {'fungus', 'fungi'},
    {'cactus', 'cacti'},
    {'stimulus', 'stimuli'},
    {'terminus', 'termini'},
    {'bacillus', 'bacilli'},
    {'focus', 'foci'},
    {'uterus', 'uteri'},
    {'locus', 'loci'},
    {'stratus', 'strati'},
    -- Ends with `ma`.
    {'stigma', 'stigmata'},
    {'stoma', 'stomata'},
    {'dogma', 'dogmata'},
    {'lemma', 'lemmata'},
    {'schema', 'schemata'},
    {'anathema', 'anathemata'},
    -- Ends with `life`
    {'life', 'lives'},
    {'afterlife', 'afterlives'},
    {'halflife', 'halflives'},
    {'highlife', 'highlives'},
    {'lowlife', 'lowlives'},
    {'midlife', 'midlives'},
    {'nonlife', 'nonlives'},
    {'nightlife', 'nightlives'},
    -- Ends with `ie`
    {'pie', 'pies'},
    {'lie', 'lies'},
    {'zombie', 'zombies'},
    {'talkie', 'talkies'},
    {'cutie', 'cuties'},
    {'goalie', 'goalies'},
    {'lassie', 'lassies'},
    {'groupie', 'groupies'},
    {'goonie', 'goonies'},
    {'genie', 'genies'},
    {'foodie', 'foodies'},
    {'faerie', 'faeries'},
    {'collie', 'collies'},
    {'tie', 'ties'},
    -- Other irregular rules.
    {'ox', 'oxen'},
    {'axe', 'axes'},
    {'die', 'dice'},
    {'yes', 'yeses'},
    {'foot', 'feet'},
    {'eave', 'eaves'},
    {'goose', 'geese'},
    {'tooth', 'teeth'},
    {'quiz', 'quizzes'},
    {'human', 'humans'},
    {'proof', 'proofs'},
    {'carve', 'carves'},
    {'valve', 'valves'},
    {'looey', 'looies'},
    {'thief', 'thieves'},
    {'groove', 'grooves'},
    {'pickaxe', 'pickaxes'},
    {'whiskey', 'whiskies'},
    {'twelve', 'twelves'},
    {'movie', 'movies'},
    {'smiley', 'smilies'},
    {'money', 'monies'},
    {'appendix', 'appendices'},
    {'abuse', 'abuses'}
}

local uncountable_rules = {
    -- Singular words with no plurals.
    'adulthood',
    'advice',
    'agenda',
    'aid',
    'alcohol',
    'ammo',
    'anime',
    'athletics',
    'audio',
    'bison',
    'blood',
    'bream',
    'buffalo',
    'butter',
    'carp',
    'cash',
    'chassis',
    'chess',
    'clothing',
    'cod',
    'commerce',
    'cooperation',
    'corps',
    'debris',
    'diabetes',
    'digestion',
    'elk',
    'energy',
    'equipment',
    'excretion',
    'expertise',
    'flounder',
    'fun',
    'gallows',
    'garbage',
    'graffiti',
    'headquarters',
    'health',
    'herpes',
    'highjinks',
    'homework',
    'housework',
    'information',
    'jeans',
    'justice',
    'kudos',
    'labour',
    'literature',
    'machinery',
    'mackerel',
    'mail',
    'media',
    'mews',
    'moose',
    'music',
    'manga',
    'news',
    'pike',
    'plankton',
    'pliers',
    'pollution',
    'premises',
    'rain',
    'research',
    'rice',
    'salmon',
    'scissors',
    'series',
    'sewage',
    'shambles',
    'shrimp',
    'species',
    'staff',
    'swine',
    'tennis',
    'traffic',
    'transportation',
    'trout',
    'tuna',
    'wealth',
    'welfare',
    'whiting',
    'wildebeest',
    'wildlife',
    'you',
}

local uncountable_reg_rules = {
    "[^aeiou]ese$", -- "chinese", "japanese"
    "deer$", -- "deer", "reindeer"
    "fish$", -- "fish", "blowfish", "angelfish"
    "measles$",
    "o[iu]s$", -- "carnivorous"
    "pox$", -- "chickpox", "smallpox"
    "sheep$"
}

local pluralization_rules = {
    {"$", "s"},
    {"s$", "s"},
    {"^(ax)is$", "%1es"},
    {"^(test)is$", "%1es"},
    {"([^aou]us)$", "%1es"},
    {"(t[lm]as)$", '%1es'},
    {"(gas)$", '%1es'},
    {"(ris)$", '%1es'},
    {"(buffal)o$", "%1oes"},
    {"(hero)$", '%1es'},
    {"(ato)$", '%1es'},
    {"(gro)$", '%1es'},
    {"(s[hs])$", "%1es"},
    {"(ch)$", "%1es"},
    {"(x)$", "%1es"},
    {"(zz)$", "%1es"},
    {"(alias)$", "%1es"},
    {"sis$", "ses"},
    {"([oe][oa])f$", "%1ves"},
    {"(ar)f$", '%1ves'},
    {"(wol)f$", '%1ves'},
    {"([ae]l)f$", '%1ves'},
    {"([nwl]i)fe$", '%1ves'},
    {"([^h]oof)$", "%1s"},
    {"(hive)$", "%1s"},
    {"([^aeiouy])y$", "%1ies"},
    {"(qu)y$", "%1ies"},
    {"([^ch][ieo][ln])ey$", "%1ies"},
    {"(matr)[ie]x$", "%1ices"},
    {"(vert)[ie]x$", "%1ices"},
    {"(ind)[ie]x$", "%1ices"},
    {"([ml])ouse$", "%1ice"},
    {"([ml])ice$", "%1ice"},
    {"m[ae]n$", 'men'},
}

local singularization_rules = {
    {"s$", ""},
    {"(ss)$", "%1"},
    {"ies$", "y"},
    {"(n)ews$", "%1ews"},
    {"((a)naly)s[ie]s$", "%1sis"},
    {"((b)a)s[ie]s$", "%1sis"},
    {"((d)iagno)s[ie]s$", "%1sis"},
    {"((p)arenthe)s[ie]s$", "%1sis"},
    {"((p)rogno)s[ie]s$", "%1sis"},
    {"((s)ynop)s[ie]s$", "%1sis"},
    {"(empha)s[ie]s$", "%1sis"},
    {"((t)he)s[ie]s$", "%1sis"},
    {"(^analy)s[ie]s$", "%1sis"},
    {"([^%w]li)ves$", "%1fe"},
    {"(wi)ves$", "%1fe"},
    {"(kni)ves$", "%1fe"},
    {"(ar)ves$", '%1f'},
    {"(wol)ves$", '%1f'},
    {"([ae]l)ves$", '%1f'},
    {"([eo][ao])ves$", '%1f'},
    {"([^h]oof)s$", "%1"},
    {"([ht]ive)s$", "%1"},
    {"(x)es$", "%1"},
    {"([cs]h)es$", "%1"},
    {"(ss)es$", "%1"},
    {"([at]to)es$", "%1"},
    {"(cho)es$", "%1"},
    {"(zz)es$", "%1"},
    {"(go)es$", "%1"},
    {"(alias)es$", "%1"},
    {"([^aou]us)es$", "%1"},
    {"([eg]ro)es$", "%1"},
    {"(t[lm]as)es$", '%1'},
    {"(gas)es$", '%1'},
    {"(ris)es$", '%1'},
    {"(test)[ie]s$", "%1is"},
    {"(cris)[ie]s$", "%1is"},
    {"^(a)x[ie]s$", "%1xis"},
    {"(vert)ices$", "%1ex"},
    {"(ind)ices$", "%1ex"},
    {"(matr)ices$", "%1ix"},
    {"([ml])ice$", "%1ouse"},
    {"m[ae]n$", 'man'}
}

local function restore_case(word, result)
    if(word == result or result == nil) then return result end
    if(word == word:upper()) then return result:upper() end
    local word_len = #word
    local result_len = #result
    local restored_word = ""
    local char
    for i = 1, word_len, 1 do
        if(i > result_len) then break end
        char = word:sub(i, i)
        if(char == char:upper()) then
            restored_word = restored_word .. result:sub(i,i):upper()
        else
            restored_word = restored_word .. result:sub(i,i)
        end
    end
    if(word_len < result_len) then restored_word = restored_word .. result:sub(word_len + 1, result_len) end
    return restored_word
end

function _M.add_irregular_rule(signle, plural)
    signle, plural = signle:lower(), plural:lower()
    irregular_plurals[plural], irregular_signles[signle] = signle, plural
end

function _M.add_irregular_rules(rules)
    for i = 1, #rules, 1 do
        _M.add_irregular_rule(rules[i][1], rules[i][2])
    end
end

function _M.add_uncountable_reg_rule(reg)
    table.insert(uncountable_reg_rules, reg)
end

function _M.add_uncountable_reg_rules(rules)
    for i = 1, #rules, 1 do
        _M.add_uncountable_reg_rule(rules[i])
    end
end

function _M.add_singularization_rule(origin_reg, replace_reg)
    table.insert(singularization_rules, {origin_reg, replace_reg}) -- the new rule add by user will get higher priority.
end

function _M.add_singularization_rules(rules)
    for i = 1, #rules, 1 do
        _M.add_singularization_rule(rules[i][1], rules[i][2])
    end
end

function _M.add_pluralization_rule(origin_reg, replace_reg)
    table.insert(pluralization_rules, {origin_reg, replace_reg}) -- the new rule add by user will get higher priority.
end

function _M.add_pluralization_rules(rules)
    for i = 1, #rules, 1 do
        _M.add_pluralization_rule(rules[i][1], rules[i][2])
    end
end

function _M.add_rules(new_rules)
    _M.add_irregular_rules(new_rules.irregular_plurals or {})
    _M.add_uncountable_reg_rules(new_rules.uncountable_reg_rules or {})
    _M.add_pluralization_rules(new_rules.pluralization_rules or {})
    _M.add_singularization_rules(new_rules.singularization_rules or {})
end

function _M.check_uncountable_word_reg_rule(word)
    for _, reg in pairs(uncountable_reg_rules) do
        if word:match(reg) then return true end
    end
    return false
end

function _M.is_plural(word)
    if(irregular_plurals[word] ~= nil) then return true end
    if(_M.check_uncountable_word_reg_rule(word)) then return true end
    if(_M.plural(word) == word) then return true end
    return false
end

function _M.is_singular(word)
    if(irregular_signles[word] ~= nil) then return true end
    if(_M.check_uncountable_word_reg_rule(word)) then return true end
    if(_M.singular(word) == word) then return true end
    return false
end

local function plural_word(word)
    local result
    local lower_word = word:lower()

    if(irregular_signles[lower_word] ~= nil) then return restore_case(word, irregular_signles[lower_word]) end
    if(_M.check_uncountable_word_reg_rule(lower_word) or irregular_plurals[lower_word] ~= nil) then return word end

    -- Reverse traversal, the higher index get the higher priority.
    local rule
    for i=#pluralization_rules, 1, -1 do
        rule = pluralization_rules[i]
        if(lower_word:match(rule[1])) then
            result = lower_word:gsub(rule[1], rule[2])
            return restore_case(word, result)
        end
    end
    return word
end

local function singular_word(word)
    local result
    local lower_word = word:lower()
    if(irregular_plurals[lower_word] ~= nil) then return restore_case(word, irregular_plurals[lower_word]) end
    if(_M.check_uncountable_word_reg_rule(lower_word) or irregular_signles[lower_word] ~= nil) then return word end

    -- Reverse traversal, the higher index get the higher priority.
    local rule
    for i=#singularization_rules, 1, -1 do
        rule = singularization_rules[i]
        if(lower_word:match(rule[1])) then
            result = lower_word:gsub(rule[1], rule[2])
            return restore_case(word, result)
        end
    end
    return word
end

function _M.plural(line, count)
    if(line == nil) then return line end
    if(count == 1) then return _M.singular(word) end
    local last_word = line:match("[^%w]?%w+$"):gsub("[^%w]?", "")

    local result = plural_word(last_word)
    return line:gsub("([^%w]?)%w+$", "%1" .. result)
end

function _M.singular(line)
    if(line == nil) then return line end
    local last_word = line:match("[^%w]?%w+$"):gsub("[^%w]?", "")
    local lower_word = last_word:lower()

    local result = singular_word(last_word)
    return line:gsub("([^%w]?)%w+$", "%1" .. result)
end

-- initialize
for i = 1, #irregular_rules, 1 do
    rule = irregular_rules[i]
    _M.add_irregular_rule(rule[1], rule[2])
end

for _, uncountable_word in pairs(uncountable_rules) do
    _M.add_irregular_rule(uncountable_word, uncountable_word)
end
