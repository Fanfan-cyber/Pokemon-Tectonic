#encoding: utf-8
#----------------------------------------
# Mod pour \pokemonsdk\scripts\01200 PFM\00100 Global Systems\01200 Environnement.rb
# Mod pour \scripts\01500 Alpha 24 Battle Engine (deprecated)\01600 Scene_Battle\00600 Scene_Battle_Graphics.rb
#----------------------------------------
# Base pour les Field Effects de Keltios

module FieldEffects

	include Db::Type
	include Rayquaza
	module_function #extend self - les attr_accessor et attr_reader ne fonctionnent pas sur un module_function

	#Météos dissipables par Anti-Brume
	BAD_WEATHERS_LIST = [RAIN,HEAVY_RAIN,THUNDERSTORM,STORMY_RAIN,HAIL,BLIZZARD,SHADOW_SKY,MISTY,FOG,SANDSTORM]
	
	#Météos qui infligent des dégâts indirects
	HAZARDOUS_WEATHERS_LIST = [THUNDERSTORM,STORMY_RAIN,HAIL,BLIZZARD,SHADOW_SKY,SANDSTORM]
	
	#Types pris par le move Ball'Météo (NORMAL = pas de boost de puissance)
	WEATHER_BALL_TYPES = [NORMAL,FIRE,FIRE,WATER,WATER,ELECTRIC,WATER,ROCK,FAIRY,FAIRY,ICE,ICE,ICE,SHADOW,FLYING]

	#Météo non combinables
	NOT_COMBINABLE_WEATHERS = [CLEAR,SHADOW_SKY,SANDSTORM,STRONG_WINDS]

	#Array des animations climatiques, indexé sur les ID de chaque climat
	CLIMATE_ANIMATIONS = [nil,492,492,493,493,388,389,494,386,386,503,495,504,502,505]
	
	#Dégâts élémentaires maximum qu'un terrain peut subir avant d'être altéré
	FIELD_MAX_DAMAGE = 10000

	#Base de données des champs de bataille - permet de gérer les alias de terrain (champs de bataille visuellement différents, mais aux effets identiques)
	#Key/name => [Category field (symbol), Holiness level (Integer), ID string of field announce (Integer), Alterable flag (Boolean),
	## Elemental Fire damage vulnerability (Integer 0 to 4), Elemental Water damage vulnerability (Integer 0 to 4), Elemental Ice damage vulnerability (Integer 0 to 4), Elemental Poison damage vulnerability (Integer 0 to 4)
	## Interior flag (Integer : 0 = Exterior, 1 = Interior that cannot collapse, 2 = cave, 3 = water cave, 4 = icy cave - 2 to 4 means Rocky Elemental damage vulnerability and collapse outcome with respectively Rock, Water or Ice damage for all fighters),
	## Transition after excessive Fire damage (nil or [symbol,Integer of ID string]), Transition after excessive Water damage (nil or [symbol,Integer of ID string]), Transition after excessive Ice damage (nil or [symbol,Integer of ID string]), Transition after excessive Poison damage (nil or [symbol,Integer of ID string])]
	## Camouflage / Mimicry type (Integer) - dedicated getter to handle the Psychic Aura and Misty weather
	
	BATTLEFIELDS = {
	#Neutral base
	:cursed_place         => [:neutral   , 0,173, true,0,0,0,0,0,                     nil,                     nil,                     nil,                     nil,    DARK],#Lieu maudit (extérieur)
	:graveyard            => [:neutral   , 0,173, true,0,0,0,0,0,                     nil,                     nil,                     nil,                     nil,    DARK],#Cimetière
	:arena_black_wings    => [:neutral   , 0,173, true,0,0,0,0,0,                     nil,                     nil,                     nil,                     nil,    DARK],#Colisée des Ailes Noires (arène de Sambucus)
	:countryside          => [:neutral   , 1,nil, true,0,0,0,0,0,                     nil,                     nil,                     nil,                     nil,     nil],#Campagne (terrain neutre hors hautes herbes)
	:countrysidegrassy    => [:neutral   , 1,nil, true,0,0,0,0,0,                     nil,                     nil,                     nil,                     nil,     nil],#Campagne (terrain neutre en hautes herbes)
	:village              => [:neutral   , 1,nil, true,0,0,0,0,0,                     nil,                     nil,                     nil,                     nil,     nil],#Place du village (terrain neutre)
	:town                 => [:neutral   , 1,nil, true,0,0,0,0,0,                     nil,                     nil,                     nil,                     nil,     nil],#Place de la ville (terrain neutre)
	:arena_neutral        => [:neutral   , 1,nil, true,0,0,0,0,0,                     nil,                     nil,                     nil,                     nil,     nil],#Arène neutre
	:arena_arceus_neutral => [:neutral   , 1,nil, true,0,0,0,0,0,                     nil,                     nil,                     nil,                     nil,     nil],#Colisée d'Arceus (arène neutre)
	:circle_of_illusion   => [:neutral   , 1,nil, true,0,0,0,0,0,                     nil,                     nil,                     nil,                     nil,     nil],#Cercle d'Illusion (terrain neutre de l'Université d'Ardrasil)
	:sacred_place         => [:neutral   , 2,175, true,0,0,0,0,0,                     nil,                     nil,                     nil,                     nil,   FAIRY],#Lieu saint (extérieur)
	:arena_fairy          => [:neutral   , 2,175, true,0,0,0,0,0,                     nil,                     nil,                     nil,                     nil,   FAIRY],#Colisée Féerique (arène de Fearnos)
	:arena_spirit         => [:neutral   , 2,175, true,0,0,0,0,0,                     nil,                     nil,                     nil,                     nil,   FAIRY],#Colisée de l'Esprit (arène de Collia)
	:cursed_temple        => [:neutral   , 0,176, true,0,0,0,0,1,                     nil,                     nil,                     nil,                     nil,    DARK],#Temple maudit
	:giratina_temple      => [:neutral   , 0,176, true,0,0,0,0,1,                     nil,                     nil,                     nil,                     nil,    DARK],#Temple de Giratina
	:darkrai_temple       => [:neutral   , 0,176, true,0,0,0,0,1,                     nil,                     nil,                     nil,                     nil,    DARK],#Temple de Darkrai
	:tomb                 => [:neutral   , 0,176, true,0,0,0,0,1,                     nil,                     nil,                     nil,                     nil,    DARK],#Tombeau / Tour d'Yveltal
	:interior             => [:neutral   , 1,177, true,0,0,0,0,1,                     nil,                     nil,                     nil,                     nil,     nil],#Intérieur de bâtiment
	:sacred_temple        => [:neutral   , 2,178, true,0,0,0,0,1,                     nil,                     nil,                     nil,                     nil,   FAIRY],#Temple 
	:ivy_tower            => [:neutral   , 2,178, true,0,0,0,0,1,                     nil,                     nil,                     nil,                     nil,   FAIRY],#Tour de Lierre
	#Rocky base
	:cursed_mountain      => [:rocky     , 0,182, true,1,0,2,0,0, :volcanic_or_dragon_den,                     nil,            [:snowy,378],                     nil,    ROCK],#Montagne sinistre
	:mountain             => [:rocky     , 1,183, true,1,0,2,0,0, :volcanic_or_dragon_den,                     nil,            [:snowy,378],                     nil,    ROCK],#Rocheux
	:arena_arceus_rocky   => [:rocky     , 1,183, true,1,0,2,0,0,         [:volcanic,348],                     nil,            [:snowy,378],                     nil,    ROCK],#Colisée d'Arceus (arène rocheuse)
	:sacred_mountain      => [:rocky     , 2,184, true,1,0,2,0,0, :volcanic_or_dragon_den,                     nil,            [:snowy,378],                     nil,    ROCK],#Montagne sacrée
	:cursed_cave          => [:rocky     , 0,185, true,1,0,2,0,2, :volcanic_or_dragon_den,                     nil,            [:snowy,380],                     nil,    DARK],#Grotte sinistre
	:cursed_dungeon       => [:rocky     , 0,185, true,1,0,2,0,2,         [:volcanic,349],                     nil,            [:snowy,380],                     nil,    DARK],#Donjon sinistre
	:cave                 => [:rocky     , 1,186, true,1,0,2,0,2, :volcanic_or_dragon_den,                     nil,            [:snowy,380],                     nil,    ROCK],#Grotte
	:dungeon              => [:rocky     , 1,186, true,1,0,2,0,2,         [:volcanic,349],                     nil,            [:snowy,380],                     nil,    ROCK],#Donjon
	:sacred_cave          => [:rocky     , 2,187, true,1,0,2,0,2, :volcanic_or_dragon_den,                     nil,            [:snowy,380],                     nil,   FAIRY],#Grotte sacrée
	:sacred_dungeon       => [:rocky     , 2,187, true,1,0,2,0,2,         [:volcanic,349],                     nil,            [:snowy,380],                     nil,   FAIRY],#Donjon sacré
	#Grassy base
	:cursed_meadow        => [:meadow    , 0,191, true,2,1,2,2,0,          [:burning,344],            [:swamp,361],            [:snowy,374],            [:swamp,384],   GRASS],#Prairie maudite
	:meadow               => [:meadow    , 1,192, true,2,1,2,2,0,          [:burning,344],            [:swamp,361],            [:snowy,374],            [:swamp,384],   GRASS],#Prairie
	:arena_arceus_grassy  => [:meadow    , 1,192, true,2,1,2,2,0,          [:burning,344],            [:swamp,361],            [:snowy,374],            [:swamp,384],   GRASS],#Colisée d'Arceus (terrain herbu)
	:sacred_meadow        => [:meadow    , 2,193, true,2,1,2,2,0,          [:burning,344],            [:swamp,361],            [:snowy,374],            [:swamp,384],   GRASS],#Prairie sacrée
	:arena_ivy            => [:meadow    , 2,193, true,2,1,2,2,0,          [:burning,344],            [:swamp,361],            [:snowy,374],            [:swamp,384],   GRASS],#Colisée du Lierre (arène de Gortelda)
	:cursed_forest        => [:forest    , 0,194, true,2,1,2,2,0,          [:burning,344],            [:swamp,362],            [:snowy,375],            [:swamp,385],     BUG],#Forêt maudite
	:forest               => [:forest    , 1,195, true,2,1,2,2,0,          [:burning,344],            [:swamp,362],            [:snowy,375],            [:swamp,385],     BUG],#Forêt
	:sacred_forest        => [:forest    , 2,196, true,2,1,2,2,0,          [:burning,344],            [:swamp,362],            [:snowy,375],            [:swamp,385],     BUG],#Forêt sacrée
	:cursed_forest_cave   => [:forest    , 0,197, true,2,1,2,2,2,          [:burning,345],            [:swamp,363],            [:snowy,376],            [:swamp,386],   GRASS],#Grotte forestière maudite
	:forest_cave          => [:forest    , 1,198, true,2,1,2,2,2,          [:burning,345],            [:swamp,363],            [:snowy,376],            [:swamp,386],   GRASS],#Grotte forestière
	:sacred_forest_cave   => [:forest    , 2,199, true,2,1,2,2,2,          [:burning,345],            [:swamp,363],            [:snowy,376],            [:swamp,386],   GRASS],#Grotte forestière sacrée
	#Swamp base
	:cursed_swamp         => [:swamp     , 0,203, true,2,2,2,0,0,      :erase_battlefield,   :flood_aquatic_or_sea,           [:frozen,369],                     nil,  POISON],#Marécage fétide
	:swamp                => [:swamp     , 1,204, true,2,2,2,0,0,      :erase_battlefield,   :flood_aquatic_or_sea,           [:frozen,369],                     nil,  POISON],#Marécageux
	:sacred_swamp         => [:swamp     , 2,205, true,2,2,2,0,0,      :erase_battlefield,   :flood_aquatic_or_sea,           [:frozen,369],                     nil,  POISON],#Marais sacré
	:cursed_swamp_cave    => [:swamp     , 0,206, true,2,2,2,0,2,      :erase_battlefield,          [:aquatic,365],            [:snowy,370],                     nil,  POISON],#Grotte marécageuse fétide
	:swamp_cave           => [:swamp     , 1,207, true,2,2,2,0,2,      :erase_battlefield,          [:aquatic,365],            [:snowy,370],                     nil,  POISON],#Grotte marécageuse
	:sacred_swamp_cave    => [:swamp     , 2,208, true,2,2,2,0,2,      :erase_battlefield,          [:aquatic,365],            [:snowy,370],                     nil,  POISON],#Grotte marécageuse bénie
	#Desert base
	:cursed_desert        => [:desert    , 0,212, true,0,0,0,0,0,                     nil,                     nil,                     nil,                     nil,  GROUND],#Désert maudit
	:desert               => [:desert    , 1,213, true,0,0,0,0,0,                     nil,                     nil,                     nil,                     nil,  GROUND],#Désert
	:arena_telluric       => [:desert    , 1,213, true,0,0,0,0,0,                     nil,                     nil,                     nil,                     nil,  GROUND],#Colisée Tellurique (arène d'Aceris)
	:sacred_desert        => [:desert    , 2,214, true,0,0,0,0,0,                     nil,                     nil,                     nil,                     nil,  GROUND],#Désert sacrée
	#Beach base
	:cursed_beach         => [:beach     , 0,218, true,0,0,0,0,0,                     nil,                     nil,                     nil,                     nil,  GROUND],#Désert sinistre
	:beach                => [:beach     , 1,219, true,0,0,0,0,0,                     nil,                     nil,                     nil,                     nil,  GROUND],#Désert
	:sacred_beach         => [:beach     , 2,220, true,0,0,0,0,0,                     nil,                     nil,                     nil,                     nil,  GROUND],#Désert sacré
	#Aquatic base
	:cursed_aquatic       => [:aquatic   , 0,224, true,0,0,2,2,0,                     nil,                     nil,           [:frozen,371],            [:swamp,387],   WATER],#Eaux pestilentielles
	:aquatic              => [:aquatic   , 1,225, true,0,0,2,2,0,                     nil,                     nil,           [:frozen,371],            [:swamp,387],   WATER],#Aquatique
	:arena_nereids        => [:aquatic   , 1,225, true,0,0,2,2,0,                     nil,                     nil,           [:frozen,371],            [:swamp,387],   WATER],#Colisée des Néréides (arène de Sailadh)
	:arena_arceus_water   => [:aquatic   , 1,225, true,0,0,2,2,0,                     nil,                     nil,           [:frozen,371],            [:swamp,387],   WATER],#Colisée d'Arceus (arène aquatique)
	:sacred_aquatic       => [:aquatic   , 2,226, true,0,0,2,2,0,                     nil,                     nil,           [:frozen,371],            [:swamp,387],   WATER],#Eaux bénies
	:cursed_aquatic_cave  => [:aquatic   , 0,227, true,0,0,2,2,3,                     nil,                     nil,            [:snowy,372],            [:swamp,388],   WATER],#Grotte aquatique maudite
	:aquatic_cave         => [:aquatic   , 1,228, true,0,0,2,2,3,                     nil,                     nil,            [:snowy,372],            [:swamp,388],   WATER],#Grotte aquatique
	:sacred_aquatic_cave  => [:aquatic   , 2,229, true,0,0,2,2,3,                     nil,                     nil,            [:snowy,372],            [:swamp,388],   WATER],#Grotte aquatique bénie
	#Sea base
	:cursed_sea           => [:sea       , 0,233,false,0,0,1,0,0,                     nil,                     nil,           [:frozen,373],                     nil,   WATER],#Maritime maudit
	:sea                  => [:sea       , 1,234,false,0,0,1,0,0,                     nil,                     nil,           [:frozen,373],                     nil,   WATER],#Maritime
	:arena_oceanic        => [:sea       , 1,234,false,0,0,1,0,0,                     nil,                     nil,           [:frozen,373],                     nil,   WATER],#Colisée Océanique (arène de Selenion)
	:sacred_sea           => [:sea       , 2,235,false,0,0,1,0,0,                     nil,                     nil,           [:frozen,373],                     nil,   WATER],#Maritime béni
	#Icy base
	:cursed_snowy         => [:snowy     , 0,239, true,2,0,0,0,0,            [:swamp,340],                     nil,                     nil,                     nil,     ICE],#Enneigé maudit
	:snowy                => [:snowy     , 1,240, true,2,0,0,0,0,            [:swamp,340],                     nil,                     nil,                     nil,     ICE],#Enneigé
	:sacred_snowy         => [:snowy     , 2,241, true,2,0,0,0,0,            [:swamp,340],                     nil,                     nil,                     nil,     ICE],#Enneigé sacré
	:cursed_ice_cave      => [:snowy     , 0,245, true,2,0,0,0,4,            [:swamp,342],                     nil,                     nil,                     nil,     ICE],#Grotte de glace maudite
	:ice_cave             => [:snowy     , 1,246, true,2,0,0,0,4,            [:swamp,342],                     nil,                     nil,                     nil,     ICE],#Grotte de glace
	:sacred_ice_cave      => [:snowy     , 2,247, true,2,0,0,0,4,            [:swamp,342],                     nil,                     nil,                     nil,     ICE],#Grotte de glace bénie
	:cursed_frozen        => [:frozen    , 0,242, true,2,0,0,0,0,    :heat_aquatic_or_sea,                     nil,                     nil,                     nil,     ICE],#Gelé maudit
	:frozen               => [:frozen    , 1,243, true,2,0,0,0,0,    :heat_aquatic_or_sea,                     nil,                     nil,                     nil,     ICE],#Gelé
	:arena_arceus_icy     => [:frozen    , 1,243, true,2,0,0,0,0,          [:aquatic,339],                     nil,                     nil,                     nil,     ICE],#Colisée d'Arceus (arène gelée)
	:sacred_frozen        => [:frozen    , 2,244, true,2,0,0,0,0,    :heat_aquatic_or_sea,                     nil,                     nil,                     nil,     ICE],#Gelé sacré
	#Volcanic base
	:cursed_volcanic      => [:volcanic  , 0,251, true,1,2,0,0,0,          [:burning,350],            [:rocky,357],                     nil,                     nil,    FIRE],#Volcan maudit
	:volcanic             => [:volcanic  , 1,252, true,1,2,0,0,0,          [:burning,350],            [:rocky,357],                     nil,                     nil,    FIRE],#Volcanique
	:arena_caldera        => [:volcanic  , 1,252, true,1,2,0,0,0,          [:burning,350],            [:rocky,357],                     nil,                     nil,    FIRE],#Colisée de la Caldeira (arène d'Huath)
	:sacred_volcanic      => [:volcanic  , 2,253, true,1,2,0,0,0,          [:burning,350],            [:rocky,357],                     nil,                     nil,    FIRE],#Volcan sacré
	:cursed_volcanic_cave => [:volcanic  , 0,254, true,1,2,0,0,2,          [:burning,351],            [:rocky,358],                     nil,                     nil,    FIRE],#Grotte volcanique maudite
	:volcanic_cave        => [:volcanic  , 1,255, true,1,2,0,0,2,          [:burning,351],            [:rocky,358],                     nil,                     nil,    FIRE],#Grotte volcanique
	:sacred_volcanic_cave => [:volcanic  , 2,256, true,1,2,0,0,2,          [:burning,351],            [:rocky,358],                     nil,                     nil,    FIRE],#Grotte volcanique bénie
	#Draconic base
	:cursed_draconic      => [:draconic  , 0,260, true,1,0,2,0,0,          [:burning,352],                     nil,            [:rocky,377],                     nil,  DRAGON],#Draconique sombre
	:draconic             => [:draconic  , 1,261, true,1,0,2,0,0,          [:burning,352],                     nil,            [:rocky,377],                     nil,  DRAGON],#Draconique
	:arena_draconic       => [:draconic  , 1,261, true,1,0,2,0,0,          [:burning,352],                     nil,            [:rocky,377],                     nil,  DRAGON],#Colisée Draconique (arène de Duiraco)
	:sacred_draconic      => [:draconic  , 2,262, true,1,0,2,0,0,          [:burning,352],                     nil,            [:rocky,377],                     nil,  DRAGON],#Draconique sacré
	:cursed_dragon_den    => [:draconic  , 0,263, true,1,1,2,0,2,          [:burning,353],            [:rocky,359],            [:rocky,379],                     nil,  DRAGON],#Antre de Dragon maléfique
	:dragon_den           => [:draconic  , 1,264, true,1,1,2,0,2,          [:burning,353],            [:rocky,359],            [:rocky,379],                     nil,  DRAGON],#Antre de Dragon
	:sacred_dragon_den    => [:draconic  , 2,265, true,1,1,2,0,2,          [:burning,353],            [:rocky,359],            [:rocky,379],                     nil,  DRAGON],#Antre de Dragon sacré
	#Burned base
	:cursed_burning       => [:burning   , 0,269, true,0,4,0,0,0,                     nil,         :original_field,                     nil,                     nil,    FIRE],#Incendié maudit
	:burning              => [:burning   , 1,270, true,0,4,0,0,0,                     nil,         :original_field,                     nil,                     nil,    FIRE],#Incendié
	:sacred_burning       => [:burning   , 2,271, true,0,4,0,0,0,                     nil,         :original_field,                     nil,                     nil,    FIRE],#Incendié sacré
	:cursed_burning_cave  => [:burning   , 0,272, true,0,4,0,0,2,                     nil,         :original_field,                     nil,                     nil,    FIRE],#Grotte incendiée maudite
	:burning_cave         => [:burning   , 1,273, true,0,4,0,0,2,                     nil,         :original_field,                     nil,                     nil,    FIRE],#Grotte incendiée
	:sacred_burning_cave  => [:burning   , 2,274, true,0,4,0,0,2,                     nil,         :original_field,                     nil,                     nil,    FIRE],#Grotte incendiée bénie
	#Magnetic base
	:cursed_magnetic      => [:magnetic  , 0,278, true,0,0,0,0,0,                     nil,                     nil,                     nil,                     nil,ELECTRIC],#Magnétique maudit
	:magnetic             => [:magnetic  , 1,279, true,0,0,0,0,0,                     nil,                     nil,                     nil,                     nil,ELECTRIC],#Magnétique
	:sacred_magnetic      => [:magnetic  , 2,280, true,0,0,0,0,0,                     nil,                     nil,                     nil,                     nil,ELECTRIC],#Magnétique sacré
	:cursed_magnetic_cave => [:magnetic  , 0,281, true,0,0,0,0,2,                     nil,                     nil,                     nil,                     nil,ELECTRIC],#Grotte magnétique maudite
	:magnetic_cave        => [:magnetic  , 1,282, true,0,0,0,0,2,                     nil,                     nil,                     nil,                     nil,ELECTRIC],#Grotte magnétique
	:sacred_magnetic_cave => [:magnetic  , 2,283, true,0,0,0,0,2,                     nil,                     nil,                     nil,                     nil,ELECTRIC],#Grotte magnétique bénie
	#Windy base
	:cursed_windy         => [:windy     , 0,287, true,0,0,0,0,0,                     nil,                     nil,                     nil,                     nil,  FLYING],#Promontoire maudit
	:windy                => [:windy     , 1,288, true,0,0,0,0,0,                     nil,                     nil,                     nil,                     nil,  FLYING],#Venteux
	:arena_phoenix        => [:windy     , 1,288, true,0,0,0,0,0,                     nil,                     nil,                     nil,                     nil,  FLYING],#Colisée du Phénix (arène d'Hulis)
	:sacred_windy         => [:windy     , 2,289, true,0,0,0,0,0,                     nil,                     nil,                     nil,                     nil,  FLYING],#Promontoire sacré
	:celestial_tower      => [:windy     , 2,289, true,0,0,0,0,0,                     nil,                     nil,                     nil,                     nil,  FLYING],#Tour Céleste
	#Etheric base (Not used)
	:cursed_etheric       => [:etheric   , 0,999, true,0,0,0,0,0,                     nil,                     nil,                     nil,                     nil,   LIGHT],#Étherique maudit
	:etheric              => [:etheric   , 1,999, true,0,0,0,0,0,                     nil,                     nil,                     nil,                     nil,   LIGHT],#Étherique
	:sacred_etheric       => [:etheric   , 2,999, true,0,0,0,0,0,                     nil,                     nil,                     nil,                     nil,   LIGHT],#Étherique sacré
	#Inalterable battlefields (only one version)
	:underwater           => [:underwater, 1,299,false,0,0,0,0,0,                     nil,                     nil,                     nil,                     nil,   WATER],#Sous-marin
	:sky_battle           => [:sky       , 1,300,false,0,0,0,0,0,                     nil,                     nil,                     nil,                     nil,  FLYING],#Terrain aérien
	:spatial              => [:spatial   , 1,301,false,0,0,0,0,0,                     nil,                     nil,                     nil,                     nil, PSYCHIC],#Spatial
	:distortion_world     => [:underworld,-1,302,false,0,0,0,0,0,                     nil,                     nil,                     nil,                     nil,  SHADOW] #Monde Distorsion
	}

	#Default transitions for a battlefield
	#Category => [[ext_cursed,exterior,ext_sacred],[int_cursed,interior,int_sacred]]
	BATTLEFIELDS_TRANSITIONS = {
	:neutral      => [[:cursed_place, :countryside, :sacred_place],[:cursed_temple, :interior, :sacred_temple]],
	:rocky        => [[:cursed_mountain, :mountain, :sacred_mountain],[:cursed_cave, :cave, :sacred_cave]],
	:meadow       => [[:cursed_meadow, :meadow, :sacred_meadow],[:cursed_forest_cave, :forest_cave, :sacred_forest_cave]],
	:forest       => [[:cursed_forest, :forest, :sacred_forest],[:cursed_forest_cave, :forest_cave, :sacred_forest_cave]],
	:swamp        => [[:cursed_swamp, :swamp, :sacred_swamp],[:cursed_swamp_cave, :swamp_cave, :sacred_swamp_cave]],
	:desert       => [[:cursed_desert, :desert, :sacred_desert],[]],
	:beach        => [[:cursed_beach, :beach, :sacred_beach],[]],
	:aquatic      => [[:cursed_aquatic,:aquatic,:sacred_aquatic],[:cursed_aquatic_cave,:aquatic_cave,:sacred_aquatic_cave]],
	:sea          => [[:cursed_sea,:sea,:sacred_sea],[]],
	:snowy        => [[:cursed_snowy, :snowy, :sacred_snowy],[:cursed_ice_cave, :ice_cave, :sacred_ice_cave]],
	:frozen       => [[:cursed_frozen, :frozen, :sacred_frozen],[:cursed_ice_cave, :ice_cave, :sacred_ice_cave]],
	:volcanic     => [[:cursed_volcanic,:volcanic,:sacred_volcanic],[:cursed_volcanic_cave,:volcanic_cave,:sacred_volcanic_cave]],
	:burning      => [[:cursed_burning,:burning,:sacred_burning],[:cursed_burning_cave,:burning_cave,:sacred_burning_cave]],
	:draconic     => [[:cursed_draconic,:draconic,:sacred_draconic],[:cursed_dragon_den,:dragon_den,:sacred_dragon_den]],
	:magnetic     => [[:cursed_magnetic,:magnetic,:sacred_magnetic],[:cursed_magnetic_cave,:magnetic_cave,:sacred_magnetic_cave]],
	:windy        => [[:cursed_windy,:windy,:sacred_windy],[]],
	#Not used, planned for Arceus' plane
	:etheric      => [[:cursed_etheric,:etheric,:sacred_etheric],[]],
	#Terrains inaltérables
	:underwater   => [[:underwater,:underwater,:underwater],[]],
	:sky          => [[:sky_battle,:sky_battle,:sky_battle],[]],
	:spatial      => [[:spatial,:spatial,:spatial],[]],
	:underworld   => [[:distortion_world,:distortion_world,:distortion_world],[]],
	}

	ALL_BATTLEFIELDS_TRANSITIONS = BATTLEFIELDS_TRANSITIONS.keys << :grassy

	#--------- Méthode mère d'initialisation : à appeler en début de combat ---------#
	def initialize_field(field=nil)
		initialize_battlefield_instance
		if field == ""
			field = nil
		elsif field.is_a?(String)
			field = field.to_sym
		end
		@original_battlefield = generate_starting_field(field)
		@current_battlefield = @original_battlefield
		@original_battlefield_category = battlefield_category(@original_battlefield)
		#@announce_battlefield_str = $game_variables[Var::BT_BonusExp] == 0 && equivalence?(@original_battlefield,@old_original_battlefield) ? nil : battlefield_announce_id(@original_battlefield) #Pas d'annonce si combat standard dans un terrain identique au précédent combat
		@announce_battlefield_str = battlefield_announce_id(@original_battlefield) #Proposer cette QoL en option ? (Annoncer toujours les battlefields / Seulement si différent du précédent / Jamais)
		@old_original_battlefield = @original_battlefield #Conservé pour le prochain combat
		initialize_starting_weather
		initialize_starting_auras
		reset_move_factor
		return @original_battlefield
	end

	#Méthode à appeler en évent-making pour prédéfinir le terrain de combat avant celui-ci (privilégier la base de données Db::Trainer pour les dresseurs en insérant la donnée :battlefield => arg)
	#arg : String ou Symbol. Sera réinitalisé en nil.to_s si c'est un Symbol. Sera conservé après le combat si c'est un String.
	def set(arg = nil.to_s)
		$game_map.battleback_name = arg
	end
		
	#Setter pour forced_weather - à appeler en évent-making pour forcer une météo naturelle sur un combat
	#Value : nil, Symbol or Integer - used for scripted naturel weather (set before the battle)
	def set_forced_weather(value)
		return @forced_weather = nil unless value
		@forced_weather = weather_symbol_to_id(value)
	end
	
	#Getter pour field_effect_move_factor (sécurisé et avec cap)
	def field_effect_move_factor
		return 1 unless @field_effect_move_factor
		return 0 if @field_effect_move_factor == 0
		return @field_effect_move_factor.clamp(0.25,2) #Capped
	end
		
	#Getter pour energy_cost_factor
	def energy_cost_factor
		return @energy_cost_factor
	end
		
	#Getter pour quote_strong_winds_mitigation
	def quote_strong_winds_mitigation
		return @quote_strong_winds_mitigation
	end

	#Getter pour primal_master
	def primal_master
		return @primal_master
	end

	def generate_starting_field(field)
		if field == nil #Automatic battlefield - seek on Palkia module
			return automatic_battlefield
		else #Manual override
			if ALL_BATTLEFIELDS_TRANSITIONS.include?(field)
				return automatic_battlefield_transition(field)
			elsif !BATTLEFIELDS.include?(field) #Symbol inconnu
				log_error("Unknown manual battlefield (argument given: #{field}), toggle to automatic mode.")
				return automatic_battlefield
			elsif battlefield_holiness(field) != holiness_rank
				log_debug("Info: The holiness level of the manual battlefield doesn't match with the vibratory rate of the player's location (#{battlefield_holiness(field)} instead of #{holiness_rank}). Current vibratory rate is overwritten for this battle.")
				@holiness_backup = $game_variables[Var::HolinessOfThePlace]
				$game_variables[Var::HolinessOfThePlace] = battlefield_holiness(field) #Override de la variable (redeviendra normale après le combat)
			end
			return field #Inchanged
		end
	end

	#Return the default battlefield with the player's location, checked by priority
	def automatic_battlefield
		if Palkia.distortion_world?
			return :distortion_world
		elsif Palkia.underwater?
			return :underwater
		elsif Palkia.space?
			return :spatial
		elsif Palkia.sky?
			return :sky_battle
		elsif Palkia.sea?
			return automatic_battlefield_transition(:sea)
		elsif Palkia.pond?
			return automatic_battlefield_transition(:aquatic)
		elsif Palkia.etheric?
			return automatic_battlefield_transition(:etheric)
		elsif Palkia.windy?
			return automatic_battlefield_transition(:windy)
		elsif Palkia.magnetic_field?
			return automatic_battlefield_transition(:magnetic)
		elsif Palkia.dragon_den?
			return automatic_battlefield_transition(:draconic)
		elsif Palkia.volcano?
			return automatic_battlefield_transition(:volcanic)
		elsif Palkia.ice?
			return automatic_battlefield_transition(:frozen)
		elsif Palkia.snow_area?
			return automatic_battlefield_transition(:snowy)
		elsif Palkia.beach?
			return automatic_battlefield_transition(:beach)
		elsif Palkia.desert?
			return automatic_battlefield_transition(:desert)
		elsif Palkia.swamp?
			return automatic_battlefield_transition(:swamp)
		elsif Palkia.forest?
			return automatic_battlefield_transition(:forest)
		elsif Palkia.meadow? || Palkia.very_tall_grass?
			return automatic_battlefield_transition(:meadow)	
		elsif Palkia.mount? || Palkia.cave_map?
			return automatic_battlefield_transition(:rocky)
		else
			return automatic_battlefield_transition(:neutral)	
		end
	end

	def automatic_battlefield_transition(desired_battlefield_category)
		if BATTLEFIELDS_TRANSITIONS.include?(desired_battlefield_category)
			if desired_battlefield_category == :neutral && interior_index == 0 && holiness_rank == 1 #Extérieur à taux vibratoire neutre
				if Palkia.city_map?
					return :town
				elsif Palkia.town_map?
					return :village
				elsif Palkia.tall_grass?
					return :countrysidegrassy
				end
			end
			field = BATTLEFIELDS_TRANSITIONS[desired_battlefield_category][interior_index][holiness_rank]
			field = BATTLEFIELDS_TRANSITIONS[desired_battlefield_category][0][holiness_rank] unless field
			return field || BATTLEFIELDS_TRANSITIONS[:neutral][interior_index][holiness_rank]
		elsif desired_battlefield_category == :grassy
			return automatic_battlefield_transition(:forest) if battlefield_category(@original_battlefield) == :forest
			return automatic_battlefield_transition(:meadow)
		else
			log_error("Invalid battlefield_category (argument given : #{desired_battlefield_category}), give a category and not a battlefield.")
			return automatic_battlefield_transition(battlefield_category(desired_battlefield_category)) if BATTLEFIELDS.include?(desired_battlefield_category)
			return automatic_battlefield_transition(:neutral)
		end
	end

	#A appeler en tout début de combat
	def initialize_battlefield_instance
		@field_alteration_cooldown = 0
		reset_field_damage_gauges
	end

	def reset_field_damage_gauges
		@field_temperature = 0 #Ice and Fire elemental damage gauge, negative values = cold, positive value = hot
		@water_elemental_damage = 0 #Water elemental damage gauge
		@poison_elemental_damage = 0 #Poison elemental damage gauge
		@telluric_elemental_damage = 0 #Rocky elemental damage gauge
	end

	def initialize_starting_weather
		clear_weather_instance
		@natural_weather = @forced_weather || $env.natural_weather #Don't change for the whole battle
		if @forced_weather
			log_debug("Forced weather set from overworld: ##{@forced_weather}")
		elsif $env.natural_weather != CLEAR
			log_debug("Natural weather set from overworld : ##{$env.natural_weather}")
		end
		#Importation de la météo invoquée en OW, mais pas en combat de dresseurs où au contraire, la météo d'OW sera réinitialisée (fait en map lors de la phase d'aggro)
		if $env.battle_weather
			duration = [($env.weather_duration+1)/3,1].max #Rounded, min 1 turn
			@weather_instance_1 = $env.battle_weather_instance_1 #Instance 1 is always set in priority
			@weather_instance_2 = $env.battle_weather_instance_2
			@weather_duration_1 = duration
			@weather_duration_2 = duration if @weather_instance_2
			#puts "-------------------------"
			#puts @weather_duration_1
			#puts "-------------------------"
			log_debug("Apply summoned weather ##{$env.battle_weather} from previous battle with a remaining duration of #{duration} turn#{duration == 1 ? '' : 's'}")
			$env.call_natural_weather #Reset météo OW dans tous les cas (s'il reste encore des tours, ça sera réappliqué en fin de combat) - nécessaire pour éviter une rémanence visuelle de l'ancienne météo si elle a expirée durant ce combat
		end
		@primal_weather = nil #Summoned primal weather (precedence over regular summoned weather)
		@primal_master = nil
		@air_locked = 0
		@air_locker = nil
		@bad_weathers_dispel_timer = 0 #Defog (temporally dispel natural bad weather)
		@teraform_dispel_timer = 0 #Teraform Zero (temporally dispel all natural weathers)
		refresh_active_weather
	end

	def initialize_starting_auras
		if @permanent_psychic_aura.is_a?(Integer) #Durée limitée programmée (annonce à faire !)
			@psychic_aura = @permanent_psychic_aura
			@permanent_psychic_aura = false
		else
			@permanent_psychic_aura |= false
			@psychic_aura = @permanent_psychic_aura ? Float::INFINITY : 0 #Penser à annoncer l'aura en début de combat + animation
		end
		@sigil_of_light = 0
	end

	#A appeler en fin de combat pour nettoyer la très grande majorité des variables
	def clear_battlefield_instance	
		set_battle_weather_in_overworld if Palkia.weather_map? && @active_weather && $game_switches[Sw::MixWeather] #Seulement en extérieur
		@announce_battlefield_str = nil
		@announce_move_forced = nil
		@quote_strong_winds_mitigation = nil
		@announce_move_field_effect = nil
		@positive_quote_id = nil
		@field_effect_move_factor = nil
		@energy_cost_factor = nil
		@field_effect_already_calc = nil
		@field_effect_set = nil
		@max_mult = nil
		@min_mult = nil
		@calc_weather_factor = nil
		@original_battlefield = nil
		@original_battlefield_category = nil
		@current_battlefield = nil
		@field_alteration_cooldown = nil
		@field_temperature = nil #Ice and Fire elemental damage gauge, negative values = cold, positive value = hot
		@water_elemental_damage = nil #Water elemental damage gauge
		@poison_elemental_damage = nil #Poison elemental damage gauge
		@telluric_elemental_damage = nil #Rocky elemental damage gauge
		@natural_weather = nil
		@active_weather = nil
		clear_weather_instance
		@bad_weathers_dispel_timer = nil
		@primal_weather = nil
		@primal_master = nil
		@air_locked = nil
		@air_locker = nil
		@primal_weather_announce = nil
		@teraform_dispel_timer = nil
		@psychic_aura = nil
		@permanent_psychic_aura = nil
		@sigil_of_light = nil
	end

	#Utilisé si jamais on doit étendre la météo temporairement en map - ne marche que pour un climat invoqué avec une durée.
	def set_battle_weather_in_overworld
		last_weather_duration = [@weather_duration_1 || 0,@weather_duration_2 || 0].max #If two instances, the longest duration is kept for both
		$env.set_battle_weather_in_overworld(@active_weather,@weather_instance_1,@weather_instance_2,last_weather_duration)
	end

	###------------------- Setter des terrains -------------------###

	#Setter maître du champ de bataille
	def set_field(new_field,pokemon_or_duration=nil)
		if new_field == @original_battlefield #Restoration to original field
			duration = 0
		elsif pokemon_or_duration.is_a?(Integer) #Manual override
			duration = pokemon_or_duration
		elsif pokemon_or_duration.is_a?(PFM::Pokemon)
			duration = BattleEngine._has_items(pokemon_or_duration, :terrain_extender, :telluric_rock) ? 8 : 5
		else #No argument or invalid argument
			duration = 5
		end
		return BattleEngine::_mp([:ai_change_field,new_field,duration]) if BattleEngine._AI? #Pas appelé en push, donc il faut envoyer une balise à l'IA au lieu d'exécuter la commande
		@current_battlefield = new_field
		@field_alteration_cooldown = duration
		reset_field_damage_gauges
		BattleEngine.reset_plegdes
		BattleEngine._mp([:push_change_battleback,new_field])
	end

	#--------- Méthode mère du terrassement du champ de bataille (Hurlement des Roches-Lames, Métalliroue, Cryo-Pirouette et assèchement d'un marais + talent Téraformation 0) ---------#
	#Annonce le message de changement de terrain (calculé automatiquement)
	#Retourne Symbol du nouveau battlefield si le terrassement a réussi, false si le terrain actuel est immunisé au terrassement, et nil si aucun changement (terrain actuel déjà "terrassé")
	#drying_swamp = true si assèchement d'un marais ou d'une grotte marécageuse (change la citation)
	IMMUNIZED_ERASING_STRINGS = {:sea => 545, :underwater=> 638, :sky => 627, :spatial => 659, :underworld => 669}
	DRYING_SWAMP_STRINGS = [341,343] #Le marais a été complètement asséché par la hausse des températures ! / La chaleur a complètement asséché la vase de cette grotte !
	def erase_battlefield(pokemon_or_duration=nil,drying_swamp=false)
		return nil if field_erasing_immune? #Terrain inchangé, aucun message
		if unalterable_battlefield? #Terrain inaltérable
			BattleEngine::_mp([:msg, parse_text(986 - Db::CSV_BASE, IMMUNIZED_ERASING_STRINGS[battlefield_category])])
			return false
		end
		erased_field_matches_original_field = (sea = @original_battlefield_category == :sea) || @original_battlefield_category == :neutral || (@original_battlefield_category == :rocky && cave_or_interior?) #Pas besoin de checker si c'est un intérieur ou un extérieur : ces deux sous-catégories sont imperméables
		#Calcul du terrain
		if erased_field_matches_original_field
			field = @original_battlefield
		elsif arena_battlefield? || battlefield_exterior?
			field = future_battlefield(:neutral)
		else
			field = future_battlefield(:rocky)
		end
		#Calcul du string
		if drying_swamp && !sea
			id_string = DRYING_SWAMP_STRINGS[interior_index]
		elsif (erased_field_matches_original_field && holiness_rank != 1) || cave_or_interior? || sea
			id_string = battlefield_announce_id(@original_battlefield) #Citation standard du terrain (car pas entièrement neutre)
		elsif arena_battlefield?
			id_string = 415 #Le sol de l’arène a été terrassé et n’a plus aucun impact sur le combat !
		elsif holiness_rank == 1
			id_string = 414 #Le champ de bataille a été terrassé et n’a plus aucun impact sur le combat !
		else #Terrain spécial terrassé en zone extérieur sainte ou maudite
			id_string = battlefield_announce_id(field)
		end
		set_field(field,pokemon_or_duration)
		BattleEngine::_mp([:msg, parse_text(986 - Db::CSV_BASE, id_string)]) #Annonce
		check_field_dependent_abilities
		return field 
	end


	#--------- Méthode mère de changement champ de bataille en cours de combat (attaques, talents, dégâts élémentaires...) ---------#
	# arg [Integer or symbol] : 2, 3, 5, 6 ou 8 correspondant au type des dégâts élémentaires, ou categorie du terrain désirée
	#Une fois la catégorie calculée, renvoie sur change_battlefield en rajoutant en argument le string_id
	def change_battlefield(arg,pokemon_or_duration=nil,announce=true)
		return if !BattleEngine._AI? && BattleEngine.battle_finished #QoL
		output = battlefield_category_for_transition(arg) #Symbol or [Symbol,Integer or nil]
		#puts "Step 1 for change_battlefield - output : #{output}"
		if !output #No battlefield found, generate a log error
			log_error("Invalid elemental transition between the battlefield #{@current_battlefield} and the type n°#{arg}") if output == nil
			return false
		elsif output == :erase_battlefield #Assèchement de marais
			return erase_battlefield(pokemon_or_duration,true)
		elsif output == :original_field #Incendie éteint
			desired_category = @original_battlefield_category
			desired_category = :neutral if desired_category == :burning
			string_id = 360 #Les trombes d’eau déversées sur le terrain ont éteint l’incendie !
		elsif output.is_a?(Symbol)
			desired_category = output
			string_id = nil
		else #Array
			desired_category = output[0]
			string_id = output[1]
		end
		#Calcul du terrain
		#puts "Step 2 for change_battlefield - desired_category : #{desired_category}"
		field = future_battlefield(desired_category)
		#puts "Step 3 for change_battlefield - field : #{field}"
		#Calcul du string
		id_string = calc_string_transition(field,string_id)
		set_field(field,pokemon_or_duration)
		if announce #Annonce
			BattleEngine::_mp([:msg, parse_text(986 - Db::CSV_BASE, id_string)])
			check_field_dependent_abilities
		end
		return field
	end

	#A appeler en fin de tour
	def update_battlefield
		return if @field_alteration_cooldown == 0
		@field_alteration_cooldown -= 1
		return unless @field_alteration_cooldown == 0
		set_field(@original_battlefield,0)
		if battlefield_category == :neutral && battlefield_holiness == 1
			field_effect_text(413) #Le terrain retourne à son état originel
		else
			announce_battlefield
		end
		check_field_dependent_abilities
	end

	#---------- Magnetic battlefield (setter for move and abilities) ----------#

	def summon_magnetic_field(summoner,hadron_engine = false)
		if battlefield_category == :sea #Terrain maritime (citation spéciale)
			BattleEngine::_mp([:msg, parse_text(986 - Db::CSV_BASE,544)]) #Impossible de magnétiser une surface lorsque rien n’émerge de l’eau !
			announce_hadron_engine_passive_boost(summoner) if hadron_engine
			return false
		elsif unalterable_battlefield? #Terrain inaltérable
			BattleEngine::_mp([:msg, parse_text(986 - Db::CSV_BASE, IMMUNIZED_ERASING_STRINGS[battlefield_category])])
			announce_hadron_engine_passive_boost(summoner) if hadron_engine
			return false
		elsif battlefield_category == :magnetic #Terrain déjà présent (mettre un message d'échec classique, ou rien si c'est un talent)
			announce_hadron_engine_passive_boost(summoner) if hadron_engine
			return nil
		end
		if hadron_engine
			change_battlefield(:magnetic,summoner,false)
			BattleEngine::_msgtp(986 - Db::CSV_BASE, 416, summoner) #Pokémon magnétise le terrain et active une machine du futur !
			summoner.set_ability_proc
			check_field_dependent_abilities
		else
			change_battlefield(:magnetic,summoner)
		end
		return true
	end

	#---------- Grassy battlefield (setter for move and abilities) ----------#

	def summon_grassy_field(summoner)
		if battlefield_category == :sea #Terrain inaltérable
			BattleEngine::_mp([:msg, parse_text(986 - Db::CSV_BASE,543)]) #Impossible de faire pousser de la végétation sur des eaux aussi profondes !
			return false
		elsif unalterable_battlefield? #Terrain inaltérable
			BattleEngine::_mp([:msg, parse_text(986 - Db::CSV_BASE, IMMUNIZED_ERASING_STRINGS[battlefield_category])])
			return false
		elsif battlefield_category == :meadow || battlefield_category == :forest #Terrain déjà présent (mettre un message d'échec classique, ou rien si c'est un talent)
			return nil
		end
		change_battlefield(:grassy,summoner) 
		return true
	end


	#Va chercher dans la base de donnée principale la transition de terrain qui va être générée.
	#arg : Symbol de la catégorie désirée ou Array [symbol de la catégorie désiréee, ID string], ou Integer avec n° du type de dégâts élémentaire (2, 3, 5, 6 ou 8)
	#Return Symbol de la catégorie de terrain ou Array[Symbol de catégorie de terrain, ID string] ou false si transition impossible ou nil si transition invalide
	def battlefield_category_for_transition(arg)
		if arg.is_a?(Symbol)
			if BATTLEFIELDS_TRANSITIONS.include?(arg) || arg == :erase_battlefield || arg == :original_field  #Cas des attaques ou talents forçant une modification de terrain
				return arg
			elsif arg == :volcanic_or_dragon_den || arg == :heat_aquatic_or_sea || arg == :flood_aquatic_or_sea #Special transition methods
				return send(arg)
			elsif arg == :grassy #Cas des invocations d'un terrain herbu, gestion de la préséance entre la Forêt (prioritaire) et la Prairie
				return false if battlefield_category == :grassy || battlefield_category == :forest  #Terrain non affecté
				return :forest if @original_battlefield_category == :forest
				return :meadow
			elsif arg == :icy
				return icy
			end
		elsif arg.is_a?(Array)
			return arg if ALL_BATTLEFIELDS_TRANSITIONS.include?(arg[0]) && arg[1].is_a?(Integer) #Message forcé
		elsif arg.is_a?(Integer)
			if arg == FIRE
				new_arg = BATTLEFIELDS[@current_battlefield][9]
				return send(new_arg) if new_arg.is_a?(Symbol) #Gestion des préséances du terrain original (hardcodé)
				return new_arg
			elsif arg == WATER
				new_arg = BATTLEFIELDS[@current_battlefield][10]
				return send(new_arg) if new_arg.is_a?(Symbol) #Gestion des préséances du terrain original (hardcodé)
				return new_arg
			elsif arg == GRASS #Aire d'Herbe (Grass Pledge)
				return :grassy if battlefield_category == :swamp
				return :swamp if battlefield_category == :aquatic
				return false #Terrain non affecté
			elsif arg == ICE
				return icy
			elsif arg == POISON
				return BATTLEFIELDS[@current_battlefield][12]
			end
		end
		log_error("Incompatible battlefield_transition (current battlefield : #{@current_battlefield}, argument given : #{arg})")
		return nil
	end

	#Gestion d'une transition vers un terrain gelé
	def icy
		return false if battlefield_category == :snowy || battlefield_category == :frozen #Terrain déjà gelé
		return BATTLEFIELDS[@current_battlefield][11]
	end

	#Gestion d'une transition spéciale - Rocky to Volcanic or Draconic (exterior or interior)
	def volcanic_or_dragon_den
		if @original_battlefield_category == :draconic
			if battlefield_exterior?
				return [:draconic,346] #L’ardeur de ce combat a restauré le flux draconique !
			else
				return [:draconic,347] #L’ardeur de ce combat a restauré le flux de l’Antre de Dragon !
			end
		else
			if battlefield_exterior?
				return [:volcanic,348] #L’ardeur de ce combat est telle que les rochers sont devenus brûlants !
			else
				return [:volcanic,349] #L’ardeur de ce combat est telle que les parois de cette grotte sont devenues brûlantes !
			end
		end
	end
	
	#Gestion d'une transition spéciale - Frozen to Water surface (exterior only)
	def heat_aquatic_or_sea
		if @original_battlefield_category == :sea
			return [:sea,338] #Les attaques ardentes ont fait fondre la glace qui recouvrait la mer !
		else
			return [:aquatic,339] #La glace a complètement fondu à cause des attaques ardentes et laisse désormais place à une étendue d’eau !
		end
	end
	
	#Gestion d'une transition spéciale - Swamp to Water surface (exterior only)
	def flood_aquatic_or_sea
		if @original_battlefield_category == :sea
			return [:sea,364] #Les trombes d’eau déversées sur le terrain ont complètement inondé le marais !
		else 
			return [:aquatic,364] #Les trombes d’eau déversées sur le terrain ont complètement inondé le marais !
		end
	end

	#Ajuste le terrain désiré en fonction du terrain d'origine et des alias
	#Argument : symbol de la catégorie de terrain désirée
	#Retourne symbol du terrain
	def future_battlefield(desired_category)
		return @original_battlefield if desired_category == nil || desired_category == :erase_battlefield || desired_category == @original_battlefield_category #Terrain inaltérable ou restauration du terrain (comme un incendie éteint)
		future_field = send(desired_category)
		future_field = check_equivalent_battlefield(future_field)
		return future_field
	end

	#[Integer] Indique l'ID du string d'annonce de changement de terrain
	# string_id == nil = mode automatique : sortira la phrase d'annonce par défaut du terrain avec une citation forcée en cas de terrain parfaitement neutre
	def calc_string_transition(field,string_id)
		current_category = battlefield_category
		if string_id == nil
			return battlefield_announce_id(field) || (arena_battlefield? ? 413 : 412) #Le terrain est désormais neutre et n’a plus aucune influence sur le combat…
		else #Gestion des cas spéciaux
			future_category = battlefield_category(field)
			exterior = battlefield_interior_type(@current_battlefield) == 0
			if future_category == :draconic && current_category == :rocky
				return exterior ? 346 : 347 #L’ardeur de ce combat a restauré le flux draconique ! / L’ardeur de ce combat a restauré le flux de l’Antre de Dragon !
			elsif future_category == :sea && current_category == :snowy
				return 338 #Les attaques ardentes ont fait fondre la glace qui recouvrait la mer !
			end
			return string_id #Pas de changement
		end
	end

	def announce_battlefield(str = battlefield_announce_id)
		$scene.display_message(ext_text(986,str))
	end

	def announce_starting_battlefield
		return unless @announce_battlefield_str
		BattleEngine::_mp([:msg, ext_text(986, @announce_battlefield_str)])
		#$scene.display_message(ext_text(986,@announce_battlefield_str))
	end
	
	def announce_starting_weather
		return if current_weather(false) == CLEAR
		weather_global_animation(true)
		announce_natural_weather
	end

	#--------- Méthodes à send pour engendrer une transition (n'est jamais appelé pour une initialisation) ---------#
	def neutral
		if arena_battlefield?
			return :arena_arceus_neutral if arceus_colosseum?
			return :arena_black_wings if holiness_rank == 0
			return :arena_fairy if holiness_rank == 2
			return :arena_neutral
		end
		return automatic_battlefield_transition(:neutral)
	end

	def rocky
		return automatic_battlefield_transition(:rocky)
	end

	def meadow
		return grassy
	end

	def forest
		return grassy
	end

	def grassy
		return automatic_battlefield_transition(:forest) if battlefield_category(@original_battlefield) == :forest
		return :arena_arceus_grassy if arceus_colosseum?
		return :arena_ivy if arena_battlefield?
		return automatic_battlefield_transition(:meadow)
	end

	def swamp
		return automatic_battlefield_transition(:swamp)
	end	

	def desert
		return :arena_telluric if arena_battlefield?
		return automatic_battlefield_transition(:desert)
	end

	def beach
		return automatic_battlefield_transition(:beach)
	end

	#Transition to Aquatic and Sea battlefield
	def aquatic
		if @original_battlefield_category == :sea
			return :arena_oceanic if arena_battlefield?
			return BATTLEFIELDS_TRANSITIONS[:sea][0][holiness_rank]
		else
			return :arena_arceus_water if arceus_colosseum?
			return :arena_nereids if arena_battlefield?
			return BATTLEFIELDS_TRANSITIONS[:aquatic][interior_index][holiness_rank]
		end
	end

	#Transition to Snowy battlefield
	def snowy
		#return :arena_snowy if arena_battlefield? #ToDo : Arène gelée non Arceus + Arène enneigée non arceus
		return automatic_battlefield_transition(:snowy)
	end

	#Transition to Frozen battlefield
	def frozen
		return :arena_arceus_icy if arceus_colosseum?
		return automatic_battlefield_transition(:frozen)
	end

	#Transition to Volcanic and Draconic battlefield
	def volcanic
		if @original_battlefield_category == :draconic
			return :arena_draconic if arena_battlefield?
			return automatic_battlefield_transition(:draconic)
		else
			return :arena_caldera if arena_battlefield? #Pas de terrain feu encore créé au Colisée d'Arceus
			return automatic_battlefield_transition(:volcanic)
		end
	end
	
	#Transition to Burning battlefield
	def burning
		return automatic_battlefield_transition(:burning)
	end

	#Transition to Magnetic battlefield
	def magnetic
		return automatic_battlefield_transition(:magnetic)
	end

	#Transition to Windy battlefield (not used)
	def windy
		return automatic_battlefield_transition(:windy)
	end


	#---------- Méthodes liées à la base de données (getters) ----------#

	def battlefield_category(battlefield = @current_battlefield)
		return nil unless battlefield #Sécurité si check hors-combat
		return BATTLEFIELDS[battlefield][0]
	end

	def battlefield_holiness(battlefield = @current_battlefield)
		return BATTLEFIELDS[battlefield][1]
	end

	def battlefield_announce_id(battlefield = @current_battlefield)
		return BATTLEFIELDS[battlefield][2]
	end

	def battlefield_alterable?(battlefield = @current_battlefield)
		return BATTLEFIELDS[battlefield][3]
	end

	def unalterable_battlefield?(battlefield = @current_battlefield)
		return BATTLEFIELDS[battlefield][3] == false
	end

	def fire_elemental_damage_factor
		return BATTLEFIELDS[@current_battlefield][4]
	end

	def water_elemental_damage_factor
		return BATTLEFIELDS[@current_battlefield][5]
	end

	def ice_elemental_damage_factor
		return BATTLEFIELDS[@current_battlefield][6]
	end

	def poison_elemental_damage_factor
		return BATTLEFIELDS[@current_battlefield][7]
	end

	def battlefield_interior_type(battlefield = @current_battlefield)
		return BATTLEFIELDS[battlefield][8]
	end

	def collapsible_cave?
		return BATTLEFIELDS[@current_battlefield][8] > 1
	end

	def fire_elemental_transition
		return BATTLEFIELDS[@current_battlefield][9]
	end

	def water_elemental_transition
		return BATTLEFIELDS[@current_battlefield][10]
	end

	def ice_elemental_transition
		return BATTLEFIELDS[@current_battlefield][11]
	end

	def poison_elemental_transition
		return BATTLEFIELDS[@current_battlefield][12]
	end

	def cave_or_interior?(battlefield = @current_battlefield)
		return Palkia.interior_battlefield? if battlefield == nil
		return battlefield_interior_type(battlefield) > 0
	end

	def battlefield_exterior?(battlefield = @current_battlefield)
		return Palkia.exterior_battlefield? if battlefield == nil
		return battlefield_interior_type(battlefield) == 0
	end

	#return 0 if exterior and 1 if interior
	#Used for array index
	def interior_index(battlefield = @current_battlefield)
		if @current_battlefield == nil #Not initialized
			return Palkia.exterior_battlefield? ? 0 : 1
		end
		return [battlefield_interior_type(battlefield),1].min
	end

	#Vérifie si le terrain original est un équivalent du terrain original, auquel cas le terrain original est reposé en priorité.
	#Return symbol du futur terrain
	def check_equivalent_battlefield(field_arg)
		return @original_battlefield if original_battlefield_equivalence?(field_arg)
		return field_arg
	end

	#Check utilisé lors d'une transition de terrain : si le terrain original a les mêmes caractéristiques que le terrain demandé, il est appliqué en priorité.
	#L'annonce de changement de terrain resté inchangé (pas de strings spécifiques pour les alias strictement identiques)
	#Holiness and interior states are ignored, because them never change
	def original_battlefield_equivalence?(desired_battlefield = @current_battlefield)
		return battlefield_category(desired_battlefield) == battlefield_category(@original_battlefield)
	end

	#[Boolean] Retourne si deux terrains sont exactement identiques sur leurs caractéristiques
	#Vérification faite sur le string d'annonce (seuls les alias ont une phrase d'annonce strictement identique)
	def equivalence?(field1,field2)
		return false if field1 == nil || field2 == nil
		return battlefield_announce_id(field1) == battlefield_announce_id(field2)
		#return battlefield_category(field1) == battlefield_category(field2) && battlefield_holiness(field1) == battlefield_holiness(field2)  && battlefield_interior_type(field1) == battlefield_interior_type(field2)
	end

	# [Boolean] Indique si le terrain actuel est déjà terrassé et ne sera donc pas modifié par le terrassement.
	def field_erasing_immune?
		return battlefield_category == :neutral || (battlefield_category == :rocky && cave_or_interior?)
	end

	#[Integer or nil] Mimicry and Camouflage type getter
	def mimicry_type
		return nil unless $game_temp.in_battle
		return BATTLEFIELDS[@current_battlefield][13] if unalterable_battlefield? #Precedence over Psychic aura and Misty weather
		return PSYCHIC if psychic_aura?
		return FAIRY if misty_weather?
		return BATTLEFIELDS[@current_battlefield][13]
	end

	#---------- Getters de battlefields ----------#

	#[Boolean] Si on est dans le Colisée d'Arceus (impacte certaines transitions de terrain)
	def arceus_colosseum?
		return (@original_battlefield.to_s).start_with?("arena_arceus_")
	end

	#[Boolean] Si on est dans un Colisée (impacte certaines transitions de terrain)
	def arena_battlefield?
		return (@original_battlefield.to_s).start_with?("arena_")
	end


	#---------- Aura de Lumière (setter / getter) ----------#

	#Field Effect : Sigil de Lumière
	def sigil_of_light?
		return @sigil_of_light > 0
	end
	
	def summon_sigil_of_light(turns=5)
		@sigil_of_light = turns
		#Animation permanente par dessus le champ de bataille ?
		@field_effect_already_calc = false #Recalc needed for the next move
		BattleEngine._mp([:msgf, parse_text(986 - Db::CSV_BASE, 426)]) #Le terrain a été sanctifié par un sigil sacré !
	end

	def decrease_sigil_of_light
		return unless sigil_of_light?
		@sigil_of_light -= 1
		BattleEngine._mp([:msgf, parse_text(986 - Db::CSV_BASE, 427)]) if @sigil_of_light == 0 #La bénédiction posée sur le terrain s’est estompée…
	end

	def dispel_sigil_of_light
		return unless sigil_of_light?
		@sigil_of_light = 0
		BattleEngine._mp([:msgf, parse_text(986 - Db::CSV_BASE, 427)]) if @sigil_of_light == 0 #La bénédiction posée sur le terrain s’est estompée…
	end


	#---------- Psychic Aura (setter / getter) ----------#

	#Field Effect : champ psychique (Psychic Terrain)
	def psychic_aura?
		return @psychic_aura > 0
	end

	#Set l'Aura Psychique pour le prochain combat
	#Possible de set un Integer pour régler une durée limitée
	def set_psychic_aura(bool_or_int=true)
		@permanent_psychic_aura = bool_or_int
	end

	def summon_psychic_aura(turns=5)
		@psychic_aura = turns
		#Animation permanente par dessus le champ de bataille ?
		@field_effect_already_calc = false #Recalc needed for the next move
		BattleEngine._mp([:global_animation, 387])
		BattleEngine._mp([:msgf, parse_text(986 - Db::CSV_BASE, 417)]) #Une aura mystérieuse et magique imprègne le terrain !
		BattleEngine._mp([:push_check_field_dependent_abilities]) #En push, sinon c'est désynchro
	end

	def decrease_psychic_aura
		return if @psychic_aura == 0
		if psychic_aura?
			@psychic_aura -= 1
			BattleEngine._mp([:msgf, parse_text(986 - Db::CSV_BASE, 419)]) if @psychic_aura == 0 #L’aura psychique se disperse…
		else #Permanent Psychic aura temporarily dispelled by Defog or Teraform Zero
			@psychic_aura += 1
			if @psychic_aura == 0
				BattleEngine._mp([:msgf, parse_text(986 - Db::CSV_BASE, 417)]) #Une aura mystérieuse et magique imprègne le terrain !
				@psychic_aura = Float::INFINITY
			end
		end
	end

	def dispel_psychic_aura(teraform_zero=false)
		return if @psychic_aura == 0
		if @permanent_psychic_aura
			@psychic_aura = teraform_zero ? -8 : -6
		else
			@psychic_aura = 0
		end
		teraform_zero ? BattleEngine._mp([:msgf, parse_text(986 - Db::CSV_BASE, 419)]) : $scene.display_message(parse_text(986 - Db::CSV_BASE, 419)) #L’aura psychique se disperse…
	end

	#---------- Getters for current battlefield category ----------#

	def distortion_world?
		return battlefield_category == :underworld
	end

	# [Boolean] Is the battle is underwater ?
	def underwater_field?
		return battlefield_category == :underwater
	end

	def spatial_field?
		return battlefield_category == :spatial
	end

	def sky_field?
		return battlefield_category == :sky
	end

	#[Boolean] Si on est dans un terrain maritime (mais pas aquatique)
	def sea_field?
		return battlefield_category == :sea
	end

	def etheric_field?
		return battlefield_category == :etheric
	end

	def windy_field?
		return battlefield_category == :windy
	end

	#[Boolean] Si on est dans un terrain aerien ou venteux
	def aerial_field?
		return windy_field? || sky_field?
	end

	#[Boolean] Si le terrain actuel est magnétique (naturellement ou par champ électrifié)
	def magnetic_field?
		return battlefield_category == :magnetic
	end

	#[Boolean] Si le terrain actuel est un territoire de dragons
	def draconic_field?
		return battlefield_category == :draconic
	end

	#[Boolean] Si le terrain actuel est en flammes
	def burning_field?
		return battlefield_category == :burning
	end

	#[Boolean] Si le terrain actuel est volcanique
	def volcanic_field?
		return battlefield_category == :volcanic
	end

	#[Boolean] Si le terrain actuel est un lac gelé
	def frozen_field?
		return battlefield_category == :frozen
	end

	#[Boolean] Si le terrain actuel est enneigé
	def snowy_field?
		return battlefield_category == :snowy
	end

	#[Boolean] Si le terrain actuel est gelé (glace ou neige)
	def icy_field?
		return frozen_field? || snowy_field?
	end

	#[Boolean] Si on est dans une grotte de glace
	def ice_cave_field?
		return snowy_field? && cave_or_interior?
	end

	#[Boolean] Si on est dans un terrain aquatique (mais pas maritime)
	def aquatic_field?
		return battlefield_category == :aquatic
	end

	#[Boolean] Si on est dans un terrain maritime ou aquatique
	def water_surface_field?
		return sea_field? || aquatic_field?
	end

	#[Boolean] Si on est dans un terrain sous-marin, maritime ou aquatique
	def water_field?
		return underwater_field? || water_surface_field?
	end

	def aquatic_exterior_field?
		return aquatic_field? && battlefield_exterior?
	end

	def aquatic_cave_field?
		return aquatic_field? && cave_or_interior?
	end

	def beach_field?
		return battlefield_category == :beach
	end

	def desert_field?
		return battlefield_category == :desert
	end

	def sandy_field?
		return desert_field? || beach_field?
	end

	def hot_field?
		return desert_field? || draconic_field? || volcanic_field? || burning_field?
	end

	def swamp_field?
		return battlefield_category == :swamp
	end

	def forest_field?
		return battlefield_category == :forest
	end

	def forest_cave_field?
		return forest_field? && cave_or_interior?
	end

	def meadow_field?
		return battlefield_category == :meadow
	end

	#[Boolean] Si le terrain actuel est herbu
	#Utilisé pour certains checks tels que la régénération des Pokémons Plante
	def grassy_field?
		return meadow_field? || forest_field?
	end

	#[Boolean] Si le terrain actuel est rocheux
	def rocky_field?
		return battlefield_category == :rocky
	end

	#[Boolean] Si le terrain actuel est de catégorie neutre
	def neutral_field?
		return battlefield_category == :neutral
	end

	#[Boolean] Si le terrain actuel est rocheux et en extérieur
	def rocky_exterior_field?
		return rocky_field? && battlefield_exterior?
	end

	#[Boolean] Si le terrain actuel est une grotte rocheuse (ou un donjon souterrain)
	def cave_field?
		return rocky_field? && cave_or_interior?
	end

	#[Boolean] Test si le joueur est sur le terrain ou la catégorie de terrain demandée (compatible hors-combat)
	def is_in_field?(value)
		value = [value] unless value.is_a?(Array) #On wrap dans un array
		if $game_temp.in_battle
			return value.any? { |sub_value| sub_value == current_battlefield || sub_value == battlefield_category }
		else
			field = automatic_battlefield
			category = battlefield_category(field)
			return value.any? { |sub_value| sub_value == field || sub_value == category }
		end
	end


	###----------------- Battlefields - Vibratory rate -----------------###

	#Méthode à appeler en combat pour déterminer la sainteté d'un champ de bataille
	def vibratory_rate
		return -1 if distortion_world?
		return 1 if BattleEngine.has_aura_break?
		return $game_variables[Var::HolinessOfThePlace]
	end

	def holy_place?
		return vibratory_rate == 2
	end

	def cursed_place?
		return vibratory_rate < 1
	end

	#Pour prélever le bon battleback dans les arrays
	def holiness_rank
		return $game_variables[Var::HolinessOfThePlace]
	end

	#A appeler en fin de combat
	def restore_holiness
		return if @holiness_backup == nil
		$game_variables[Var::HolinessOfThePlace] = @holiness_backup
		@holiness_backup = nil
	end

	###----------------- Weather handler -----------------###
	##-------- Weather getters --------##

	#Neutral weather
	def clear?
		return current_weather == CLEAR
	end

	#Sunny weather
	def sunny?
		return current_weather == SUNNY
	end

	#Scorching sun weather (reinforced version of the sun, triggered if sun is actively summoned when there is already sun)
	def harsh_sun?
		return current_weather == HARSH_SUN
	end

	#Rain weather
	def rain?
		return current_weather == RAIN
	end

	#Torrential rain weather (reinforced version of the rain, triggered if rain is actively summoned when there is already rain, freezing rain or rainy storm)
	def heavy_rain?
		return current_weather == HEAVY_RAIN  
	end

	#Thunderstorm weather
	def storm?
		return current_weather == THUNDERSTORM  
	end

	#Rainy storm weather (combination of rain and storm)
	def stormy_rain?
		return current_weather == STORMY_RAIN  
	end

	#Sandstorm weather
	def sandstorm?
		return current_weather == SANDSTORM
	end

	#Misty weather
	def misty?
		return current_weather == MISTY  
	end

	#Fog weather (reinforced version of the mist, triggered if mist is actively summoned when there is already mist)
	def fog?
		return current_weather == FOG  
	end

	#Snowing weather (not hail or blizzard)
	def snowing?
		return current_weather == SNOWING 
	end

	#Hail / Freezing rain weather (combination of rain and snow)
	def hail?
		return current_weather == HAIL 
	end

	#Blizzard weather (reinforced version of the snow, triggered if snow is actively summoned when there is already snow or hail)
	def blizzard?
		return current_weather == BLIZZARD  
	end

	#Shadow sky weather
	def shadow_sky?
		return current_weather == SHADOW_SKY  
	end

	#Strong winds weather
	def strong_winds?
		return current_weather == STRONG_WINDS
	end

	def stormy_weather?
		return stormy_rain? || storm?
	end

	def rainy_weather?
		return rain? || stormy_rain? || heavy_rain?
	end

	def misty_weather?
		return misty? || fog?
	end

	#Check for volcanic and burning fields
	def wet_weather?
		return rainy_weather? || hail? || blizzard?
	end

	def sunny_weather?
		return sunny? || harsh_sun?
	end
	
	def freezing_weather?
		return snowing? || hail? || blizzard?
	end

	#[Boolean] If the weather can inflict indirect damage
	def hazardous_weather?
		return HAZARDOUS_WEATHERS_LIST.include?(current_weather)
	end

	#[Boolean] If the weather is rotten (weaken Solar Beam and Solar Blade)
	def bad_weather?
		return hail? || blizzard? || shadow_sky? || rainy_weather? || fog? || sandstorm?
	end

	#[Boolean] If the weather is dissipable by Defog
	def dissipable_weather?
		return BAD_WEATHERS_LIST.include?(current_weather(false)) #Cloud Nine ignored
	end

	#[Boolean] If the natural weather is dissipable by Defog
	def natural_dissipable_weather?
		return BAD_WEATHERS_LIST.include?(@natural_weather)
	end

	#[Boolean] If the natural weather can inflict indirect damage
	def hazardous_natural_weather?
		return false if @teraform_dispel_timer > 1 || @bad_weathers_dispel_timer > 1 
		return HAZARDOUS_WEATHERS_LIST.include?(@natural_weather)
	end

	#[Integer - Float::INFINITY] Getter du temps restant pour une météo invoquée en combat (0 si climat naturel actif, infini si climat primal)
	def weather_duration
		return Float::INFINITY if @primal_weather
		return [@weather_duration_1 || 0, @weather_duration_2 || 0].max
	end

	#[Float - 0] Facteur climatique pour les attaques de soin
	def sky_clarity_factor(skill_sym)
		return 0.25 if sunny_weather?
		case skill_sym
		when :moonlight
			return 0.125 if misty? #La Brume booste ce soin
			return 0 if fog? #Le Brouillard est neutre sur ce soin
			return -0.125 if storm?
			return -0.25 if bad_weather?
			return 0
		else #when :morning_sun, :synthesis
			return -0.125 if fog? || storm? #N'handicape pas autant que les autres mauvaises météos
			return -0.25 if bad_weather?
			return 0
		end
	end

	#[Float - 0] Facteur de terrain pour les attaques de soin
	def rate_healed_by_sky(skill_sym)
		return 0 if distortion_world?
		rate_healed = 0.375 + vibratory_rate*0.125 #Influence de la sainteté du lieu
		rate_healed -= 0.125 if cave_or_interior? && vibratory_rate < 2 #Terrain intérieur, sauf si lieu saint
		rate_healed += sky_clarity_factor(skill_sym) #Récupération du facteur climatique
		return rate_healed.clamp(0.25,0.75)
	end

	#Getter universel pour la météo en cours (ne refresh pas les variables)
	def current_weather(check_cloud_nine=true)
		return @primal_weather if @primal_weather #Préseance 1 et 2
		return CLEAR if check_cloud_nine && cloud_nine? #Préseance 3
		return @active_weather || natural_weather #Préseance 4 et 5 || Préseance 6 et 7
	end
	
	#Setter - optimisation pour éviter dans 90% des cas une moulinette dans get_weather_instance
	def refresh_active_weather
		@weather_instance_1 = nil if @weather_instance_1 && @weather_duration_1 == 0
		@weather_instance_2 = nil if @weather_instance_2 && @weather_duration_2 == 0
		@active_weather = get_weather_instance
	end
	
	def natural_weather
		return CLEAR if @teraform_dispel_timer > 0
		return CLEAR if @bad_weathers_dispel_timer > 0 && BAD_WEATHERS_LIST.include?(@natural_weather)
		return @natural_weather
	end

	#Getter de refresh gérant les deux instances de climat actif en prenant en compte la météo naturelle si elle est combinable.
	def get_weather_instance
		if @weather_instance_1 == nil && @weather_instance_2 == nil #Aucune instance climatique active
			return nil 
		elsif @weather_instance_1 == nil || @weather_instance_2 == nil #1 seule instance climatique active
			weather = @weather_instance_1 || @weather_instance_2
			return weather if weather == SHADOW_SKY || weather == SANDSTORM || NOT_COMBINABLE_WEATHERS.include?(nat_w = natural_weather) #Météos non combinables
			case weather
			when SUNNY
				return HARSH_SUN if nat_w == SUNNY || nat_w == HARSH_SUN
			when RAIN
				return STORMY_RAIN if nat_w == THUNDERSTORM
				return HAIL if nat_w == SNOWING || nat_w == BLIZZARD
				return HEAVY_RAIN if [RAIN, HEAVY_RAIN, HAIL, STORMY_RAIN].include?(nat_w)
			when MISTY
				return FOG if nat_w == MISTY || nat_w == FOG
			when SNOWING
				return BLIZZARD if [SNOWING, HAIL, BLIZZARD].include?(nat_w)
				return HAIL if [RAIN, HEAVY_RAIN, STORMY_RAIN].include?(nat_w)
			end
			return weather
		else #2 instances actives de climats invoqués, c'est donc obligatoirement une météo combinée si les setters sont bien paramétrés
			weather = [@weather_instance_1,@weather_instance_2]
			if weather.include?(SUNNY)
				return HARSH_SUN
			elsif weather.include?(MISTY)
				return FOG
			elsif weather.include?(THUNDERSTORM)
				return STORMY_RAIN
			elsif weather.include?(SNOWING)
				return HAIL if weather.include?(RAIN)
				return BLIZZARD
			elsif weather.include?(RAIN)
				return HEAVY_RAIN
			end
		end
	end

	#[Integer - nil] Getter de refresh gérant les deux instances de climat actif en prenant en compte la météo naturelle si elle est combinable.
	#Méthode utilisable hors-combat en renseignant manuellement les 3 arguments.
	def get_weather_instance(nat_w=natural_weather, w_instance_1=@weather_instance_1, w_instance_2=@weather_instance_2)
		if w_instance_1 == nil && w_instance_2 == nil #Aucune instance climatique active
			return nil 
		elsif w_instance_1 == nil || w_instance_2 == nil #1 seule instance climatique active
			weather = w_instance_1 || w_instance_2
			return weather if weather == SHADOW_SKY || weather == SANDSTORM || NOT_COMBINABLE_WEATHERS.include?(nat_w) #Météos non combinables
			case weather
			when SUNNY
				return HARSH_SUN if nat_w == SUNNY || nat_w == HARSH_SUN
			when RAIN
				return STORMY_RAIN if nat_w == THUNDERSTORM
				return HAIL if nat_w == SNOWING || nat_w == BLIZZARD
				return HEAVY_RAIN if [RAIN, HEAVY_RAIN, HAIL, STORMY_RAIN].include?(nat_w)
			when MISTY
				return FOG if nat_w == MISTY || nat_w == FOG
			when SNOWING
				return BLIZZARD if [SNOWING, HAIL, BLIZZARD].include?(nat_w)
				return HAIL if [RAIN, HEAVY_RAIN, STORMY_RAIN].include?(nat_w)
			end
			return weather
		else #2 instances actives de climats invoqués, c'est donc obligatoirement une météo combinée si les setters sont bien paramétrés
			weather = [w_instance_1,w_instance_2]
			if weather.include?(SUNNY)
				return HARSH_SUN
			elsif weather.include?(MISTY)
				return FOG
			elsif weather.include?(THUNDERSTORM)
				return STORMY_RAIN
			elsif weather.include?(SNOWING)
				return HAIL if weather.include?(RAIN)
				return BLIZZARD
			elsif weather.include?(RAIN)
				return HEAVY_RAIN
			end
		end
	end

	#[Boolean] Si le seigneur suprême climatique est présent (Méga Rayquaza)
	def weather_overlord?
		return @air_locked == 3
	end

	#[Boolean] Si la bulle d'oxygène est présente
	def air_locked?
		return weather_overlord? || @air_locked == 2
	end
	
	#[Boolean] Si les météos communes (préseance < 3) ne peuvent faire effet
	def cloud_nine?
		return @air_locked != 0
	end
	
	def get_weather_ball_type
		return WEATHER_BALL_TYPES[current_weather]
	end

	def weather_symbol_to_id(input)
		if input.is_a?(Integer)
			return input if input.between?(0,14)
		elsif input.is_a?(Symbol)
			case input
			when :neutral, :clear, :none
				return CLEAR
			when :sunny, :sun
				return SUNNY
			when :harsh_sun
				return HARSH_SUN
			when :rain, :rainy
				return RAIN
			when :heavy_rain
				return HEAVY_RAIN
			when :thunderstorm, :storm
				return THUNDERSTORM
			when :stormy_rain
				return STORMY_RAIN
			when :sandstorm
				return SANDSTORM
			when :misty, :mist
				return MISTY
			when :fog
				return FOG
			when :snowing, :snow
				return SNOWING
			when :hail, :freezing_rain
				return HAIL
			when :blizzard
				return BLIZZARD
			when :shadow_sky
				return SHADOW_SKY
			when :strong_winds, :windy, :celestial_winds
				return STRONG_WINDS
			end
		end
		log_error("Invalid arg on weather_symbol_to_id (arg given : #{input})")
		return CLEAR #Clear weather
	end


	###----------------- Weather setters -----------------###
	##-------- Weather individuals setters --------##
	
	#Setter de refresh
	def refresh_weather
		return clear_full_weather_instance if underwater_field?
		update_air_lock
		if spatial_field?
			return STRONG_WINDS if @primal_weather == STRONG_WINDS #Préseance 1
			return clear_full_weather_instance
		end
		return current_weather
	end
	
	#Cas forcés où le climat doit obligatoirement être neutre (y compris celui naturel)
	def clear_full_weather_instance
		@primal_weather = nil
		@primal_master = nil
		clear_weather_instance
		return @natural_weather = CLEAR
	end
	
	def clear_weather_instance
		@weather_instance_1 = nil
		@weather_duration_1 = 0
		@weather_instance_2 = nil
		@weather_duration_2 = 0
	end

	#Transfert l'instance climatique n°2 vers la n°1 lorsqu'elle est libre
	def toggle_weather_instance
		return if @weather_instance_1 || @weather_instance_2 == nil
		@weather_instance_1 = @weather_instance_2
		@weather_duration_1 = @weather_duration_2
		@weather_instance_2 = nil
		@weather_duration_2 = nil
	end

	#Setter pour call une météo de manière active (l'invocation doit se faire en push, mais le booléen doit être retourné immédiatement)
	def summon_weather(pokemon,skill_sym)
		return false if battlefield_block_weather
		return false if primal_weather_move_interference(pokemon,skill_sym)
		old_weather = current_weather #Pas de "false", car il faut prendre en compte cloud_nine pour l'IA)
		weather_summoned = skill_symbol_to_weather_id(skill_sym)
		result = set_weather(pokemon,weather_summoned,skill_sym)
		puts "summon_weather result : #{result}"
		if BattleEngine._AI? && result
			return ai_annonce_weather(result[0],old_weather,result[1])
		else
			return result #Boolean
		end
	end

	def skill_symbol_to_weather_id(skill_sym)
		case skill_sym
		when :sunny_day
			return SUNNY
		when :rain_dance
			return RAIN
		when :thunderstorm
			return THUNDERSTORM
		when :snowscape, :hail, :chilly_reception
			return SNOWING #directly HAIL is not managed
		when :sandstorm
			return SANDSTORM
		when :mystical_mist, :misty_terrain
			return MISTY
		when :shadow_sky
			return SHADOW_SKY
		else
			log_error("#{skill_sym} is a invalid symbol for weather move.")
			return CLEAR #Failsafe
		end
	end

	#Méthode servant à envoyer une balise à l'IA (non utilisé lors des tirs réels) - Recoder la méthode get_weather_advantage_factor pour l'actualiser sur les nouveaux climats, sinon l'IA va complètement être perdue
	def ai_annonce_weather(new_weather,old_weather,duration)
		BattleEngine::_message_stack_push([:ai_weather_change, new_weather, old_weather, duration])
	end

	def air_locked_msg(pkmn,generate_gendered_txt=true)
		pkmn.gendered_txt if generate_gendered_txt
		BattleEngine::_mp([:ability_display, pkmn])
		if underwater_field? #No climate here
			push_weather_text(92) #[POKEMON] crée une bulle d’oxygène !
		else
			if pkmn.ability == :delta_stream
				BattleEngine._mp([:global_animation, 505])
				push_weather_text(49) #Un courant aérien mystérieux enveloppe les Pokémons de type Vol !
				wind_power_field_effect(true)
			else #Air Lock
				if spatial_field?
					push_weather_text(92) #[POKEMON] crée une bulle d’oxygène !
				else
					push_weather_text(91) #[POKEMON] stabilise l’atmosphère !
				end
			end
		end
		pkmn.battle_effect.set_ability_proc unless BattleEngine._AI? #Marquage que le talent a proc sans attendre le push, évitera des proc multiples de l'animation s'il y a plusieurs poseur de climats en combat double
	end

	#A appeler à chaque fois qu'un Pokémon avec un talent climatique arrive sur le terrain, summoner étant le Pokémon en question
	#Attention en début de combat lorsque plusieurs Pokémons sont envoyés en même temps ! Air Lock et Souffle Delta sont à checker en priorité, comme si c'était le plus rapide des battlers.
	def proc_ability_weather(summoner,weather_summoned)
		battlers = ([summoner]+BattleEngine.get_battlers).uniq #Le nouveau Pokémon est passé en priorité
		if @primal_master
			@primal_master = nil unless battlers.include?(@primal_master) #Refresh si le Légendaire climatique a quitté le combat
		end
		old_air_locked_level = @air_locked
		old_weather = current_weather(false)
		update_air_lock(battlers)
		if weather_overlord? #Ce talent proc en priorité, @air_locker proc donc maintenant
			delta_stream_interference(summoner,old_air_locked_level)
		#Les 4 conditions suivantes correspondent à des talents de préséance de rang 2 et peuvent casser le climat primal actif (sauf Vents Célestes qui a la préséance de rang 1)
		elsif summoner.ability == :teraform_zero
			teraform_field_effects(summoner)
		elsif summoner.ability == :desolate_land
			apply_legendary_climate(summoner,HARSH_SUN,old_weather)
		elsif summoner.ability == :primordial_sea
			apply_legendary_climate(summoner,HEAVY_RAIN,old_weather)
		elsif summoner.ability == :air_lock
			apply_legendary_climate(summoner,CLEAR,old_weather,old_air_locked_level)
		elsif summoner.ability == :cloud_nine #Ciel Gris - préséance de rang 3
			proc_cloud_nine(summoner) 
		elsif @primal_master && !(summoner.ability == :orichalcum_pulse && @primal_weather == HARSH_SUN) #Un talent primal est présent, l'invocation va être bloquée, sauf pour Pouls Orichalque sous le soleil où il n'y a pas interférence
			primal_weather_interference(summoner)
		elsif summoner.ability == :orichalcum_pulse #Citations spéciales
			proc_orichalcum_pulse(summoner) #Proc d'un talent climatique de priorité non légendaire sans interférence - vérification si la météo actuelle est altérable avant de faire proc le talent
		else 
			set_weather(summoner,weather_summoned)
		end
	end

	#A appeler lorsqu'un Pokémon détenteur d'un talent climatique primal quitte le combat
	def update_leaving_primal_weather(leaving_pokemon)
		return unless @primal_master == leaving_pokemon
		old_weather = current_weather(false)
		battlers = BattleEngine.get_battlers
		unless underwater_field?
			@primal_master = battlers.find { |battlers| battlers.ability == :delta_stream }
			unless spatial_field? || @primal_master
				@primal_master = battlers.find { |battlers| %i[primordial_sea desolate_land air_lock].include?(battlers.ability) }
			end
		end
		synchronize_primal_weather
		update_air_lock_with_announce(old_weather)
	end

	#Refresh + light, à appeler si un talent se fait neutraliser ou déneutraliser
	def refresh_cloud_nine(leaving=false)
		return false unless leaving || cloud_nine? || BattleEngine.get_battlers.any? { |battler| battler.ability == :cloud_nine }
		update_air_lock 
		on_weather_change
		return true
	end

	def synchronize_primal_weather
		if @primal_master
			case @primal_master.ability
			when :delta_stream
				@primal_weather = STRONG_WINDS
				clear_weather_instance
			when :air_lock
				@primal_weather = CLEAR
				clear_weather_instance
			when :desolate_land
				@primal_weather = HARSH_SUN
				clear_weather_instance
			when :primordial_sea
				@primal_weather = HEAVY_RAIN
				clear_weather_instance
			else
				@primal_weather = nil
			end
		else
			@primal_weather = nil
		end
	end

	#Anciennement BattleEngine::_State_sub_update qui redirigeait sur refresh_air_lock_state
	def update_air_lock_with_announce(old_weather = current_weather(false))
		update_air_lock
		refresh_active_weather
		new_weather = current_weather(false)
		on_weather_change if announce_weather_transition(old_weather,new_weather)
	end

	#Faire un merge avec BattleEngine::Abilities.proc_air_lock(pkmn, ability_sym) / check_air_lock
	def update_air_lock(battlers=nil)
		air_locked_before = air_locked?
		battlers = BattleEngine.get_battlers unless battlers
		if delta_streamer = battlers.find { |battler| battler.ability == :delta_stream } #Préseance absolue
			@air_locked = 3
			clear_weather_instance #Souffle Delta casse la météo invoquée de préseance 4 ou moins
			@air_locker = delta_streamer unless @air_locker && @air_locker.in_front?
		elsif airlocker = battlers.find { |battler| battler.ability == :air_lock } #Préseance 2, mais peut être cassé par un autre talent climatique légendaire de même priorité qui proc après Air Lock
			@air_locked = 2
			clear_weather_instance #Air Lock casse la météo invoquée de préseance 4 ou moins
			@air_locker = airlocker unless @air_locker && @air_locker.in_front?
		elsif battlers.any? { |battler| BattleEngine::Abilities.has_ability_usable(battler, :cloud_nine) } #Préseance 3, mais tous les talents climatiques légendaires override cet effet.
			@air_locked = 1
			@air_locker = nil
		else
			@air_locked = 0
			@air_locker = nil
		end
		if underwater_field? || spatial_field?
			if air_locked? && !air_locked_before
				pokemon = delta_streamer || airlocker
				BattleEngine::_msgtp(985 - Db::CSV_BASE, 92, pokemon) #Pokémon crée une bulle d’oxygène ! => Vérifier que le message n'est pas affiché en double
				battlers.each { |battler| battler.battle_effect.reset_oxygen_lack } #Reset le compteur d'air pour tous les combattants
			elsif !air_locked? && air_locked_before
				weather_text(93) #La bulle d’oxygène se dissipe…
			end
		end
	end

	#Gestion de Souffle Delta pour les talents climatiques (aussi bien le proc du talent que les interférences que ça génère)
	def delta_stream_interference(summoner,old_air_locked_level)
		return if old_air_locked_level == 3 && summoner.ability == :delta_stream && @primal_master #Ce talent a déjà proc chez un combattant présent
		@air_locker.gendered_txt
		air_locked_msg(@air_locker,false) unless @air_locker.battle_effect.ability_has_proc?
		@primal_master = @air_locker unless @primal_master && @primal_master.in_front?
		@primal_weather = STRONG_WINDS
		return if summoner == @air_locker
		return if summoner.ability == :delta_stream #Talent identique à celui déjà actif, ne proquera pas
		return teraform_field_effects(summoner) if summoner.ability == :teraform_zero #Cette méthode gèrera tout, y compris le blocage climatique par Souffle Delta
		#Phase de proc et contre proc
		BattleEngine::_mp([:ability_display, summoner])
		BattleEngine::_mp([:ability_display, @primal_master]) #Proc contre talent
		BattleEngine::_msgtp(985 - Db::CSV_BASE, 157, @primal_master,'[ABILITY]' => summoner.ability_name) #[ABILITY] ne peut contrer le pouvoir atmosphérique du Maître des Cieux…
		announce_orichalcum_pulse_passive_boost(summoner) if summoner.ability == :orichalcum_pulse && (draconic_field? || volcanic_field? || burning_field?)
	end

	#Gestion de l'interférences des talents climatiques légendaires sur les talents climatiques standards.
	def primal_weather_interference(summoner)	
		BattleEngine::_mp([:ability_display, summoner])
		BattleEngine::_mp([:ability_display, @primal_master]) #Proc contre talent
		if @primal_weather == CLEAR #Air Lock mène la danse
			BattleEngine::_msgtp(985 - Db::CSV_BASE, 151, summoner) #Air Lock empêche Pokémon d’invoquer son climat!
		elsif @primal_weather == HARSH_SUN #Primo-Groudon
			BattleEngine::_mp([:msg, ext_text(985, 154)]) #Le soleil brille si intensément que rien ne peut l’obscurcir !
		else #HEAVY_RAIN - Primo-Kyogre
			BattleEngine::_mp([:msg, ext_text(985, 155)]) #Impossible de dissiper une telle pluie !
		end
		announce_orichalcum_pulse_passive_boost(summoner) if summoner.ability == :orichalcum_pulse && (draconic_field? || volcanic_field? || burning_field?)
	end

	#Procédure du talent Téraformation 0 (Teraform Zero), engendre 4 effets à la fois :
	##Suppression du terrain pour 8 tours (si altérable)
	##Interruption de la météo invoquée en cours (s'il en y a une) jusqu'à la préséance de rang 2 (n'interfère pas avec Ciel Gris et Air Lock qui posent aussi un climat neutre).
	##Neutralisation de la météo naturelle pour 8 tours
	##Dissipation de l'Aura Psychique (qui est un terrain dissipable dans les jeux officiels)
	def teraform_field_effects(deity)
		return if deity.ability_used #Un seul proc possible par combat
		BattleEngine::_mp([:ability_display, deity])
		update_air_lock #Vérifier s'il n'y a pas d'interférence avec la phrase de bulle d'oxygène (vu que cette méthode ne fait proc aucun talent, ni ne met à jour la variable #@primal_master)
		weather_cur = current_weather(false)
		#Phase 1 : check champ de bataille
		did_something = erase_battlefield(8) != nil
		#Phase 2 et 3 : check météo actuelle
		unless clear? && @natural_weather == CLEAR
			if weather_overlord?
				@primal_master ||= @air_locker
				@primal_weather = STRONG_WINDS
				BattleEngine::_mp([:ability_display, @primal_master]) #Proc contre talent
				BattleEngine::_msgtp(985 - Db::CSV_BASE, 156, @primal_master) #Le légendaire [POKEMON] règne en maître sur les cieux et empêche les Vents célestes d’être dissipés !
				did_something |= true
			elsif !clear? #Météo naturelle non neutre, mais aucune météo active (possible avec Anti-Brume ou une instance précédente de Téraformation 0)
				if @primal_master 
					unless @primal_weather == CLEAR #Air Lock qui domine
						if air_locked? #Présence d'un talent Air Lock dominé
							@primal_master = @air_locker #Redonne discrètement le lead de la danse (ces deux talents sont protagonistes, évitera des procs dans le vent)
							@primal_weather = CLEAR #Plutôt faire un double proc de talent, non ?
						else
							@primal_master = nil
						end
						BattleEngine::_mp([:push_force_dispel_weather, weather_cur]) #Obligé de faire un aller-retour en push, sinon la météo est dissipée avec le proc du talent
						force_dispel_weather(weather_cur)
						did_something |= true
					end
				else
					BattleEngine::_mp([:push_force_dispel_weather, weather_cur]) #Obligé de faire un aller-retour en push, sinon la météo est dissipée avec le proc du talent
					did_something |= true
				end
			end
			@teraform_dispel_timer = 8 unless @natural_weather == CLEAR #Le timer est quand même posé pour bloquer tout climat naturel
		end
		#Phase 4 : aura psychique
		if psychic_aura?
			dispel_psychic_aura(true)
			did_something |= true
		end
		BattleEngine._msgp(995 - Db::CSV_BASE, 361) unless did_something #Mais rien ne se passe!
	end

	#Setter pour les talents Primals
	def apply_legendary_climate(deity,summoned_primal_weather,old_weather,old_air_locked_level=nil)
		if deity.ability == :air_lock
			return if @primal_weather == CLEAR && old_air_locked_level == 2 && (spatial_field? || underwater_field?) #Pas de proc talent, car aucun impact en terme de game design dans ce cas précis
			@primal_master = deity
			@primal_weather = summoned_primal_weather
			air_locked_msg(deity) #Inclut le proc du talent
			announce_weather_transition(old_weather,summoned_primal_weather,true) unless old_air_locked_level > 1 || old_weather == CLEAR
			on_weather_change
		else
			BattleEngine::_mp([:ability_display, deity])
			if spatial_field?
				BattleEngine::_msgtp(986- Db::CSV_BASE,657) #Impossible d’invoquer un climat dans le vide spatial…
			elsif underwater_field?
				BattleEngine::_msgtp(986- Db::CSV_BASE,640) #Impossible d’invoquer un climat dans les profondeurs aquatiques…
			else
				clear_weather_instance #Tout comme Air Lock, les talents primaux cassent la météo invoquée de préseance 4 ou moins
				@primal_master = deity
				@primal_weather = summoned_primal_weather
				on_weather_change if announce_weather_transition(CLEAR,summoned_primal_weather) #Annonce forcée
			end
		end
	end

	def proc_cloud_nine(pokemon)
		BattleEngine::_mp([:ability_display, pokemon])
		if @primal_master && @primal_weather != CLEAR #Climat primal de préséance supérieure, interférence avec Ciel Gris
			BattleEngine::_mp([:ability_display, @primal_master]) #Proc contre talent
			BattleEngine::_msgtp(985 - Db::CSV_BASE, 150, @primal_master,'[ABILITY]' => pokemon.ability_name) #[ABILITY] ne peut contrer le pouvoir atmosphérique d’un Légendaire primordial…
		else
			BattleEngine::_mp([:msg, ext_text(985, 52)]) #Les effets de la météo se dissipent !
		end
	end

	#Setter spécial pour Pouls Orichalque, les interférences ont toutes été testées en amont
	def proc_orichalcum_pulse(pokemon)
		if sunny_weather? #Temps déjà ensoleillé
			if @natural_weather == SUNNY && sunny? #Temps amplifiable
				set_weather(pokemon,SUNNY,false,false)
				BattleEngine::_msgtp(985 - Db::CSV_BASE, 90, pokemon) #Pokémon rend la chaleur du soleil accablante et libère l’énergie d’une pulsation primitive !
			else
				announce_orichalcum_pulse_passive_boost(pokemon,true)
			end
		else	
			set_weather(pokemon,SUNNY,false,false)
			BattleEngine::_msgtp(985 - Db::CSV_BASE, 89, pokemon) #Pokémon intensifie les rayons du soleil et libère l’énergie d’une pulsation primitive !
		end
	end

	def announce_orichalcum_pulse_passive_boost(pokemon,proc=false)
		return if pokemon.battle_effect.ability_has_proc?
		BattleEngine::_mp([:ability_display, pokemon]) if proc
		BattleEngine::_msgtp(996 - Db::CSV_BASE, 1015, pokemon) if pokemon.ability == :orichalcum_pulse && (sunny_weather? || draconic_field? || volcanic_field? || burning_field?) #Pokémon tire profit de la chaleur ambiante et libère l’énergie d’une pulsation primitive !
		pokemon.battle_effect.set_ability_proc
	end

	#Cette méthode est déjà appelée par push lorsque c'est via summon_magnetic_field, donc pas besoin de double push
	def announce_hadron_engine_passive_boost(pokemon,push=false)
		return if pokemon.battle_effect.ability_has_proc? && push
		BattleEngine::_mp([:ability_display, pokemon]) if push
		if pokemon.ability == :hadron_engine && (stormy_weather? || magnetic_field?)
			push ? BattleEngine::_msgtp(996 - Db::CSV_BASE, 1017, pokemon) : $scene.display_message(parse_text_tag_pokemon(996 - Db::CSV_BASE, 1017, pokemon)) #Pokémon active une machine du futur grâce à l’atmosphère électrique !
		end
		pokemon.battle_effect.set_ability_proc
	end

	#A appeler à chaque fois qu'une météo ou un terrain est modifié
	def check_field_dependent_abilities
		return if BattleEngine._AI?
		BattleEngine.get_battlers.each do |battler|
			if battler.ability == :orichalcum_pulse
				if battler.battle_effect.ability_has_proc?
					battler.set_ability_proc(false) unless sunny_weather? || draconic_field? || volcanic_field? || burning_field?
				elsif sunny_weather? || draconic_field? || volcanic_field? || burning_field?
					announce_orichalcum_pulse_passive_boost(battler,true)
				end
			elsif battler.ability == :hadron_engine
				if battler.battle_effect.ability_has_proc?
					battler.set_ability_proc(false) unless stormy_weather? || magnetic_field?
				elsif stormy_weather? || magnetic_field?
					announce_hadron_engine_passive_boost(battler,true)
				end
			elsif battler.ability == :mimicry && !BattleEngine::Abilities.ability_gassed_and_not_shielded?(battler) #Ensure that the ability is active
				type = mimicry_type
				if type
					next if battler.type_1 == type && battler.type2 == Db::Type::NEUTRAL
				else
					next if battler.type1 == battler.unaltered_type1 && battler.type2 == battler.unaltered_type2
				end
				BattleEngine::_mp([:push_mimicry,battler,type])
			elsif battler.ability == :protosynthesis && !BattleEngine::Abilities.ability_gassed_and_not_shielded?(battler) #Ensure that the ability is active
				BattleEngine::Abilities.proc_protosynthesis(battler)
			elsif battler.ability == :quark_drive && !BattleEngine::Abilities.ability_gassed_and_not_shielded?(battler) #Ensure that the ability is active
				BattleEngine::Abilities.proc_quark_drive(battler)
			end
			check_seed(battler)
		end
		@field_effect_already_calc = false #Recalc needed for the next move
	end

	#Trigger pour les graines de terrain (passer par BattleEngine::BE_Interpreter.push_check_seed pour le calculer en push)
	#A appeler aussi lorsque le Pokémon se prend des dégâts directs ou est envoyé au combat (attention, si le Pokémon a un talent qui change le terrain, le changement de terrain est appliqué avant le check de la graine !)
	def check_seed(pokemon)
		return if pokemon.out_of_combat? || BattleEngine.has_item_blocked?(pokemon)
		case pokemon.held_item
		when :electric_seed #Graine Électrik
			return unless stormy_weather? || magnetic_field?
			stage_limit = BattleEngine::Abilities.active_ability_no_mold(pokemon) == :contrary ? BattleEngine::MIN_STAGE : BattleEngine::MAX_STAGE
			return if pokemon.battle_stage[BattleEngine::DFE_ID] == stage_limit
			display_seed_message(pokemon)
			BattleEngine::BE_Interpreter.change_dfe(pokemon, 1) #+ Défense
		when :psychic_seed #Graine Psychique
			return unless psychic_aura?
			stage_limit = BattleEngine::Abilities.active_ability_no_mold(pokemon) == :contrary ? BattleEngine::MIN_STAGE : BattleEngine::MAX_STAGE
			return if pokemon.battle_stage[BattleEngine::DFS_ID] == stage_limit
			display_seed_message(pokemon)
			BattleEngine::BE_Interpreter.change_dfs(pokemon, 1) #+ Défense Spéciale
		when :misty_seed #Graine Brume
			return unless misty_weather?
			stage_limit = BattleEngine::Abilities.active_ability_no_mold(pokemon) == :contrary ? BattleEngine::MIN_STAGE : BattleEngine::MAX_STAGE
			return if pokemon.battle_stage[BattleEngine::DFS_ID] == stage_limit
			display_seed_message(pokemon)
			BattleEngine::BE_Interpreter.change_dfs(pokemon, 1) #+ Défense Spéciale
		when :grassy_seed #Graine Herbe
			return unless grassy_field?
			stage_limit = BattleEngine::Abilities.active_ability_no_mold(pokemon) == :contrary ? BattleEngine::MIN_STAGE : BattleEngine::MAX_STAGE
			return if pokemon.battle_stage[BattleEngine::DFE_ID] == stage_limit
			display_seed_message(pokemon)
			BattleEngine::BE_Interpreter.change_dfe(pokemon, 1) #+ Défense
		when :telluric_seed #Graine Tellurique
			stage_limit = BattleEngine::Abilities.active_ability_no_mold(pokemon) == :contrary ? BattleEngine::MIN_STAGE : BattleEngine::MAX_STAGE
			if rocky_field?
				return if pokemon.battle_stage[BattleEngine::ATK_ID] == stage_limit
				display_seed_message(pokemon)
				BattleEngine::BE_Interpreter.change_atk(pokemon, 1) #+ Attaque
			elsif grassy_field?
				return if pokemon.battle_effect.is_rooted?
				display_seed_message(pokemon)
				BattleEngine::BE_Interpreter.push_ingrain(pokemon)
			elsif swamp_field?
				return if pokemon.battle_stage[BattleEngine::ATS_ID] == stage_limit
				display_seed_message(pokemon)
				BattleEngine::BE_Interpreter.change_ats(pokemon, 1)  #+ Attaque Spéciale
			elsif sandy_field?
				return if pokemon.battle_stage[BattleEngine::DFE_ID] == stage_limit && (!beach_field? || pokemon.battle_effect.has_aqua_ring_effect)
				display_seed_message(pokemon)
				BattleEngine::BE_Interpreter.change_dfe(pokemon, 1) #+ Défense
				BattleEngine::BE_Interpreter.push_aqua_ring(pokemon) if beach_field? && !pokemon.battle_effect.has_aqua_ring_effect?
			elsif water_field?
				return if pokemon.battle_stage[BattleEngine::SPD_ID] == stage_limit && pokemon.battle_effect.has_aqua_ring_effect
				display_seed_message(pokemon)
				BattleEngine::BE_Interpreter.change_spd(pokemon, 1) #+ Vitesse
				BattleEngine::BE_Interpreter.push_aqua_ring(pokemon) unless pokemon.battle_effect.has_aqua_ring_effect?
			elsif draconic_field? || volcanic_field? || burning_field?
				return if pokemon.battle_effect.focus_energy > 15
				display_seed_message(pokemon)
				lbe.apply_focus_energy(16) #+ Buff critique
				BattleEngine::BE_Interpreter.animation_on(pokemon, 370)
				$scene.display_message(parse_text_tag_pokemon(996 - Db::CSV_BASE, 321, pokemon))
			elsif aerial_field?
				return if pokemon.battle_stage[BattleEngine::SPD_ID] == stage_limit && pokemon.battle_stage[BattleEngine::ACC_ID] == stage_limit
				display_seed_message(pokemon)
				BattleEngine::BE_Interpreter.change_spd(pokemon, 1) #+ Vitesse et précision
				BattleEngine::BE_Interpreter.change_acc(pokemon, 1)
			elsif spatial_field?
				return if pokemon.battle_stage[BattleEngine::ATS_ID] == stage_limit && pokemon.battle_stage[BattleEngine::DFS_ID] == stage_limit
				display_seed_message(pokemon)
				BattleEngine::BE_Interpreter.change_ats(pokemon, 1) #+ Attaque Spéciale + Défense Spéciale
				BattleEngine::BE_Interpreter.change_dfs(pokemon, 1)
			else
				return
			end
		when :cursed_seed #Graine Maudite
			return unless cursed_place?
			stage_limit = active_ability_no_mold(pokemon) == :contrary ? BattleEngine::MIN_STAGE : BattleEngine::MAX_STAGE
			return if pokemon.battle_stage[BattleEngine::ATK_ID] == stage_limit
			display_seed_message(pokemon)
			BattleEngine::BE_Interpreter.change_atk(pokemon, distortion_world? ? 2 : 1) #+ Attaque
		when :sacred_seed #Graine Sacrée
			return unless holy_place?
			stage_limit = active_ability_no_mold(pokemon) == :contrary ? BattleEngine::MIN_STAGE : BattleEngine::MAX_STAGE
			return if pokemon.battle_stage[BattleEngine::ATS_ID] == stage_limit
			display_seed_message(pokemon)
			BattleEngine::BE_Interpreter.change_ats(pokemon, 1) #+ Attaque Spéciale
		else
			return
		end
		BattleEngine::BE_Interpreter.consume_item(pokemon, pokemon.held_item)
	end

	def display_seed_message(pokemon)
		BattleEngine::BE_Interpreter.animation_on(pokemon, 563) #Trouver peut être une animation moins flamboyante ?
		$scene.display_message(parse_text_tag_pokemon(996 - Db::CSV_BASE, 754, pokemon, '[SEED_ITEM]' => pokemon.item_name)) #Les effets de terrain activent la [SEED_ITEM] de Pokémon !	
	end

	#Gestion du blocage du champ de bataille
	def battlefield_block_weather
		if spatial_field?
			push_field_effect_text(657) #Impossible d’invoquer un climat dans le vide spatial…
		elsif underwater_field?
			push_field_effect_text(640) #Impossible d’invoquer un climat dans les profondeurs aquatiques…
		else
			return false	
		end
		return true
	end

	#Gestion de l'interférence des talents primaux pour les capacités climatiques
	def primal_weather_move_interference(summoner,from_move)
		return false unless @primal_master
		BattleEngine::_mp([:ability_display, @primal_master])
		if weather_overlord?
			BattleEngine::_msgtp(985 - Db::CSV_BASE, 158, summoner, '[MOVE]' => Db::Move.name(from_move)) #L’attaque [MOVE] ne peut contrer le pouvoir atmosphérique du Maître des Cieux…
		elsif @primal_weather == CLEAR #Air Lock mène la danse
			climate_str = skill_symbol_to_weather_id(from_move)
			PFM::Text.set_variable('[WEATHER_ACTION]',ext_text(985,106+climate_str)) #106 pour une météo neutre
			BattleEngine::_msgtp(985 - Db::CSV_BASE, 149, @primal_master,'[ABILITY]' => @primal_master.ability_name)
			#BattleEngine::_msgtp(985 - Db::CSV_BASE, 151, summoner) #Air Lock empêche Pokémon d’invoquer son climat!
		else
			BattleEngine::_msgtp(985 - Db::CSV_BASE, 152, nil,'[MOVE]' => Db::Move.name(from_move)) #L’attaque [MOVE] ne peut contrer le pouvoir atmosphérique d’un Légendaire primordial…
		end
		return true
	end

	#Clear temporairement la météo naturelle si elle est pourrie
	def defog_natural_weather
		return unless natural_dissipable_weather?
		@bad_weathers_dispel_timer = 6
	end

	#Exécution de l'effet climatique de Defog (éligibilité déjà check)
	def defog_weather
		defog_natural_weather
		dispel_weather
	end

	def dispel_weather(weather_dispelled=nil)
		old_weather = weather_dispelled || current_weather(false)
		@weather_duration_1 = 0
		@weather_duration_2 = 0
		update_air_lock_with_announce(old_weather)
	end

	#Idem que dispel_weather, mais englobe aussi @primal_weather
	def force_dispel_weather(weather_dispelled)
		unless @primal_master&.ability == :air_lock
			@primal_weather = nil
			@primal_master = nil
		end
		dispel_weather(weather_dispelled)
	end

	#Appelé uniquement en fin de tour, ne pas utiliser pour invoquer un climat activement ou passivement
	def update_weather
		old_weather = current_weather(false)
		decrease_weather_duration(old_weather)
		new_weather = current_weather(false)
		$scene.global_animation(387) if @psychic_aura > 1
		$scene.global_animation(506) if BattleEngine.state[:rainbow] > 1
		return if new_weather == CLEAR && new_weather == old_weather #Aucun changement, et météo neutre (Ciel Gris ignoré)
		announce_weather_transition(old_weather,new_weather)
		weather_global_animation
		on_weather_change(false) #Pas en push, la forme doit être changée avant les dégâts climatiques.
		case new_weather
		when THUNDERSTORM, STORMY_RAIN
			weather_text(101) #L’orage gronde sur le champ de bataille !
			proc_thunderstorm_damage unless cloud_nine?
		when SANDSTORM
			weather_text(99) #La tempête de sable fait rage.
			proc_sandstorm_damage unless cloud_nine?
		when HAIL
			weather_text(100) #Il y a un déluge de grêle.
			proc_hail_damage unless cloud_nine?
		when BLIZZARD
			weather_text(98) #Le blizzard souffle violemment !
			proc_hail_damage unless cloud_nine?
		when SHADOW_SKY
			weather_text(102) #Le ciel obscur projette des éclairs de lumière!
			proc_shadow_sky_damage unless cloud_nine?
		end
	end

	#Setter pour les instances climatiques principales
	# @return false or nil if no weather change, so no message to display
	# Return true if there is a change, and [Integer,Integer] for AI (without modify the weather)
	def set_weather(pokemon, weather_summoned, from_move=false, announce_change=true)
		old_weather = current_weather(false)
		#Pré-check de la compabilité des climats
		case weather_summoned
		when SUNNY
			result = summon_sun(pokemon,from_move)
		when RAIN
			result = summon_rain(pokemon,from_move)
		when THUNDERSTORM
			result = summon_thunderstorm(pokemon,from_move)
		when SANDSTORM		
			result = summon_sandstorm(pokemon,from_move)
		when MISTY
			result = summon_mist(pokemon,from_move)
		when SNOWING
			result = summon_snow(pokemon,from_move)
		when SHADOW_SKY		
			result = summon_shadow_sky(pokemon,from_move)
		else
			log_error("weather_summoned (#{weather_summoned}) unknown for set_weather.")
			return nil
		end
		return result if BattleEngine._AI? || !result
		refresh_active_weather
		weather_global_animation(true)
		return true unless announce_change
		new_weather = current_weather(false)
		announce_weather_transition(old_weather,new_weather,true)
		return true
	end

	def summon_sun(summoner,from_move)
		return nil if harsh_sun? #Météo déjà au maximum
		if from_move == false #From ability
			return nil if sunny? && natural_weather != SUNNY #Le talent ne peut amplifier le soleil non naturel, pas de proc
			BattleEngine::_mp([:ability_display, summoner])
		end
		boost_duration = ((desert_field? || volcanic_field? || burning_field?) && battlefield_exterior?) || BattleEngine._has_item(summoner, :heat_rock)
		return set_weather_instance(SUNNY,boost_duration ? 8 : 5)
	end

	def summon_rain(summoner,from_move)
		return nil if heavy_rain? #Météo déjà au maximum
		if from_move == false #From ability
			return nil if (rainy_weather? || hail?) && ![RAIN,HAIL,STORMY_RAIN,HEAVY_RAIN].include?(natural_weather) #Le talent ne peut amplifier la pluie non naturelle, pas de proc
			BattleEngine::_mp([:ability_display, summoner])
		end
		boost_duration = ((beach_field? || swamp_field? || water_surface_field?) && battlefield_exterior?) || BattleEngine._has_item(summoner, :damp_rock)
		return set_weather_instance(RAIN,boost_duration ? 8 : 5)
	end

	def summon_thunderstorm(summoner,from_move)
		return nil if stormy_weather? #Météo déjà orageuse
		BattleEngine::_mp([:ability_display, summoner]) unless from_move
		boost_duration = (magnetic_field? && battlefield_exterior?) || BattleEngine._has_item(summoner, :storm_rock)
		return set_weather_instance(THUNDERSTORM,boost_duration ? 8 : 5)
	end

	def summon_sandstorm(summoner,from_move)
		return nil if sandstorm? #Météo déjà présente
		BattleEngine::_mp([:ability_display, summoner]) unless from_move
		boost_duration = (sandy_field? && battlefield_exterior?) || BattleEngine._has_item(summoner, :smooth_rock)
		return set_weather_instance(SANDSTORM,boost_duration ? 8 : 5)
	end

	def summon_mist(summoner,from_move)
		return nil if fog? #Météo déjà au maximum
		unless from_move #From ability
			return nil if misty? && natural_weather != MISTY #Le talent ne peut amplifier la brume non naturelle
			BattleEngine::_mp([:ability_display, summoner])
		end
		boost_duration = BattleEngine._has_item(summoner, :misty_rock)
		return set_weather_instance(MISTY,boost_duration ? 8 : 5)
	end

	#De loin la météo la plus complexe au niveau des combinaisons...
	def summon_snow(summoner,from_move)
		return nil if blizzard? #Météo déjà au maximum
		active_summon = from_move && from_move != :chilly_reception
		return nil if !active_summon && [SNOWING,HAIL].include?(current_weather) && ![SNOWING,HAIL,BLIZZARD].include?(natural_weather)
		BattleEngine::_mp([:ability_display, summoner]) unless from_move
		boost_duration = (icy_field? && battlefield_exterior?) || BattleEngine._has_item(summoner, :icy_rock)
		return set_weather_instance(SNOWING,boost_duration ? 8 : 5)
	end

	def summon_shadow_sky(summoner,from_move)
		return nil if shadow_sky? #Météo déjà présente
		BattleEngine::_mp([:ability_display, summoner]) unless from_move
		boost_duration = BattleEngine._has_item(summoner, :shadow_rock)
		return set_weather_instance(SHADOW_SKY,boost_duration ? 8 : 5)
	end

	#Setter gérant les deux instances de climat actif en prenant en compte la météo naturelle si elle est combinable.
	#Attention à l'IA si elle lit cette méthode ! Il faut aussi qu'elle sache si une météo peut être invoquée avec succès, et laquelle
	def set_weather_instance(weather_requested,duration)
		backup = [@weather_instance_1,@weather_duration_1,@weather_instance_2,@weather_duration_2,@active_weather] if BattleEngine._AI?
		current_w = current_weather(false)
		toggle_weather_instance #On transfert sur l'instance 1 si elle est vide mais pas l'instance 2, ça sera plus facile à gérer
		if @weather_instance_1 == nil
			#Aucune instance climatique active - cas le plus simple et le getter calculera automatiquement le bon climat
			set_first_weather_instance(weather_requested,duration)
		elsif (natural_weather == HARSH_SUN && weather_requested == SUNNY) || (natural_weather == HEAVY_RAIN && weather_requested == RAIN) || (natural_weather == FOG && weather_requested == MISTY) || (natural_weather == BLIZZARD && weather_requested == SNOWING)
			#Météo naturelle de rang 2, mais météo active qui ne l'est pas. La météo demandée correspond à celle naturelle => Suppression des instances, ce qui redébloquera automatiquement le climat naturel de rang 2 sans limite de temps.
			clear_weather_instance
		elsif current_w == HEAVY_RAIN && weather_requested == SNOWING && @weather_duration_2 > 0
			#Cas complexe: deux instances de pluie invoquées quand la neige est invoquée => Donne de la grêle en conservant l'instance de pluie qui a la durée la plus longue
			set_first_weather_instance(RAIN,[@weather_duration_1,@weather_duration_2].max)
			set_second_weather_instance(weather_requested,duration)
		elsif current_w == BLIZZARD && weather_requested == RAIN && @weather_duration_2 > 0
			#Cas miroir du cas précédent : pluie invoquée sur deux instances de neige invoquées => Donne de la grêle en conservant l'instance de neige qui a la durée la plus longue
			set_first_weather_instance(SNOWING,[@weather_duration_1,@weather_duration_2].max)
			set_second_weather_instance(weather_requested,duration)
		elsif (NOT_COMBINABLE_WEATHERS+[HARSH_SUN,HEAVY_RAIN,BLIZZARD,FOG]).include?(current_w) || NOT_COMBINABLE_WEATHERS.include?(weather_requested)
			#Cas d'une météo de niveau 2 (forcément non compatible) ou non combinable avec weather_requested. On peut donc reset toute l'instance active.
			force_first_weather_instance(weather_requested,duration)
		elsif @weather_instance_2 == nil
			#1 instance climatique active - cas le plus complexe car il faut prend en compte la météo naturelle et quel slot d'instance est utilisé
			if current_w == weather_requested && [SUNNY,RAIN,MISTY,SNOWING].include?(current_w) #Amplification du climat actuel qui est un climat simple (météo naturelle neutre ou non compatible), donc on set sur l'instance 2.
				set_second_weather_instance(weather_requested,duration)
			elsif current_w == RAIN && (weather_requested == THUNDERSTORM || weather_requested == SNOWING) #Combinaison valide avec une instance de pluie
				set_second_weather_instance(weather_requested,duration)
			elsif current_w == THUNDERSTORM && weather_requested == RAIN #Combinaison valide avec une instance d'orage
				set_second_weather_instance(weather_requested,duration)
			elsif current_w == SNOWING && weather_requested == RAIN #Combinaison valide avec une instance de neige
				set_second_weather_instance(weather_requested,duration)
			elsif current_w == HAIL #Météo combinée avec l'instance naturelle
				if @weather_instance_1 == SNOWING #Instance de pluie naturelle combinée à une instance de neige invoquée
					if weather_requested == SNOWING #Seconde instance de neige qui s'ajoute pour former du Blizzard
						set_second_weather_instance(weather_requested,duration)
					else
						force_first_weather_instance(weather_requested,duration) #Tous les autres cas sont non compatibles avec l'instance invoquée
					end
				else #Instance de neige naturelle combinée à une instance de pluie invoquée
					if weather_requested == RAIN #Seconde instance de neige qui s'ajoute pour former du Blizzard
						set_second_weather_instance(weather_requested,duration)
					else
						force_first_weather_instance(weather_requested,duration) #Tous les autres cas sont non compatibles avec l'instance invoquée
					end
				end
			elsif current_w == STORMY_RAIN #Météo combinée avec l'instance naturelle
				if @weather_instance_1 == THUNDERSTORM #Instance de pluie naturelle combinée à une instance d'orage invoquée
					force_first_weather_instance(weather_requested,duration) #Tous les autres cas sont non compatibles avec l'instance invoquée
				else #Instance d'orage naturel combinée à une instance de pluie invoquée
					if weather_requested == RAIN #Seconde instance de neige qui s'ajoute pour former du Blizzard
						set_second_weather_instance(weather_requested,duration)
					else
						force_first_weather_instance(weather_requested,duration) #Tous les autres cas sont non compatibles avec l'instance invoquée
					end
				end
			else
				unexpected_weather_combination(weather_requested,duration)
			end
		else #Double instance climatique invoquée, donc forcément une météo combinée (pluie orageuse ou grêle), vu que celle de niveau 2 ou incombinables ont été remises à zéro.
			if current_w = HAIL
				if weather_requested == SNOWING || weather_requested == RAIN
					if @weather_instance_1 == weather_requested #On remplace l'instance non compatible
						set_second_weather_instance(weather_requested,duration)
					else
						set_first_weather_instance(weather_requested,duration)
					end
				else #Météo non compatible avec les 2 instances actives
					force_first_weather_instance(weather_requested,duration)
				end
			elsif current_w = STORMY_RAIN
				if weather_requested == THUNDERSTORM || weather_requested == RAIN
					if @weather_instance_1 == weather_requested #On remplace l'instance non compatible
						set_second_weather_instance(weather_requested,duration)
					else
						set_first_weather_instance(weather_requested,duration)
					end
				else #Météo non compatible avec les 2 instances actives
					force_first_weather_instance(weather_requested,duration)
				end
			else
				unexpected_weather_combination(weather_requested,duration)
			end
		end	
		return expected_weather_for_ai(backup,duration) if BattleEngine._AI?
		return true
	end

	def expected_weather_for_ai(backup,duration)
		refresh_active_weather
		expected_weather = current_weather
		duration = Float::INFINITY if current_weather == @natural_weather
		@weather_instance_1 = backup[0]
		@weather_duration_1 = backup[1]
		@weather_instance_2 = backup[2]
		@weather_duration_2 = backup[3]
		@active_weather = backup[4]
		return [expected_weather,duration]
	end

	def force_first_weather_instance(weather_requested,duration)
		clear_weather_instance
		set_first_weather_instance(weather_requested,duration)
	end

	def set_first_weather_instance(weather_requested,duration)
		@weather_instance_1 = weather_requested
		@weather_duration_1 = duration
	end

	def set_second_weather_instance(weather_requested,duration)
		@weather_instance_2 = weather_requested
		@weather_duration_2 = duration
	end

	#Mode dégradé pour set un climat invoqué (la combinaision des instances climatiques est ignorée, donc on active uniquement l'instance n°1)
	def unexpected_weather_combination(weather_requested,duration)
		log_error("Unexpected weather combination (Natural weather: #{natural_weather}, Instance 1: #{@weather_instance_1}, Instance 2: #{@weather_instance_2}, weather_requested: #{weather_requested}), check the conditional cascade on set_weather_instance")
		force_first_weather_instance(weather_requested,duration)
	end
	
	def on_weather_change(push=true)
		BattleEngine::Abilities.on_weather_change(push)
		check_field_dependent_abilities
	end

	# Decrease the weather duration at the end of the turn, just before the weather damage.
	def decrease_weather_duration(old_weather)
		update_air_lock
		check_field_alteration_from_weather
		@weather_duration_1 -= 1 if @weather_duration_1 > 0
		@weather_duration_2 -= 1 if @weather_duration_2 > 0
		@teraform_dispel_timer -= 1 if @teraform_dispel_timer > 0
		@bad_weathers_dispel_timer -= 1 if @bad_weathers_dispel_timer > 0 
		refresh_primal_weather(old_weather) #Le plus rapide des détenteurs d'un talent climatique légendaire fait reproc son talent si @primal_weather == nil (et que Téraformation 0 ne fait pas effet)
		refresh_active_weather #refresh
	end

	#[Boolean] Incrémentation des dégâts élémentaires climatiques sur le terrain : Returne true si le terrain a été altéré, sinon false
	# Cette méthode est appelée juste avant la décrémentation (mais après le refresh de Air Lock) afin que le terrain soit altéré selon l'ancienne météo.
	# Si le terrain est altéré, il est set pour 6 tours, car ce compteur sera décrémenté de 1 tour tout de suite après.
	# Toujours traiter en priorité les cas qui n'altèreront pas le terrain (par exemple les réinitialisations de dégâts élémentaires)
	def check_field_alteration_from_weather
		return change_battlefield(:original_field) if burning_field? && wet_weather? #Tout invocation de pluie éteint l'incendie en cours d'un terrain
		case current_weather #Ciel Gris est pris en compte
		when SUNNY
			@water_elemental_damage = [@water_elemental_damage-1000,0].max
			@field_temperature = [@field_temperature+1000,0].min if @field_temperature < 0
		when HARSH_SUN
			@water_elemental_damage = 0 #Reset any water damage
			@field_temperature = [@field_temperature+800*fire_elemental_damage_factor,0].max #+800 fire base damage, reset any ice damage in minimum
			return apply_fire_transition(@field_temperature >= FIELD_MAX_DAMAGE,6)
		when RAIN,STORMY_RAIN #Same effect
			@poison_elemental_damage = [@poison_elemental_damage-800,0].max
			if fire_elemental_damage_factor > 0
				@field_temperature = [@field_temperature-1200,0].max if @field_temperature > 0
			end
		when HEAVY_RAIN
			@poison_elemental_damage = [@poison_elemental_damage-2000,0].max
			@field_temperature = 0 if @field_temperature > 0
			if water_elemental_damage_factor > 0
				@water_elemental_damage += 750*water_elemental_damage_factor
				return apply_water_transition(@water_elemental_damage >= FIELD_MAX_DAMAGE,6)
			end
		when SNOWING
			ice_damage = 400*ice_elemental_damage_factor
			if ice_damage == 0 #Battlefield not vulnerable to cold, temperature variable is never negative
				@field_temperature = [@field_temperature-600,0].max
			elsif ice_damage < 600 && @field_temperature >= 400
				if @field_temperature >= 600
					@field_temperature -= 600
				else
					@field_temperature = 0
				end
			else
				@field_temperature -= ice_damage
				return apply_ice_transition(@field_temperature <= -FIELD_MAX_DAMAGE,6)
			end
		when HAIL #+400 ice base damage, cancel up to 1200 fire damage in positive area in minimum   #-1200 en négatif (-600 si Neige), +400 base en positif sur temp
			ice_damage = 400*ice_elemental_damage_factor
			if ice_damage == 0 #Battlefield not vulnerable to cold, temperature variable is never negative
				@field_temperature = [@field_temperature-1200,0].max
			elsif @field_temperature >= ice_damage
				@field_temperature -= 1200
			else
				@field_temperature -= ice_damage
				return apply_ice_transition(@field_temperature <= -FIELD_MAX_DAMAGE,6)
			end
		when BLIZZARD
			ice_damage = 1000*ice_elemental_damage_factor
			if @field_temperature >= ice_damage
				@field_temperature = 0 #Cancel in minimum all fire damage
			else
				@field_temperature -= ice_damage
				return apply_ice_transition(@field_temperature <= -FIELD_MAX_DAMAGE,6)
			end
		end
		return false #No field alteration
	end

	#A appeler en fin de tour uniquement pour refresh la météo primale
	def refresh_primal_weather(old_weather)
		return @primal_weather_announce = false if underwater_field? #Terrain interdisant toute météo
		return @primal_weather_announce = false if @teraform_dispel_timer > 0 #Téraformation 0 empêche le reproc naturel des talents climatiques légendaires
		return @primal_weather_announce = false if @primal_master && @primal_master.in_front? && @primal_weather #Un Légendaire mène déjà la danse et est toujours présent
		battlers = BattleEngine.get_battlers #Le plus rapide prend l'ascendance (avec en priorité Souffle Delta)
		if weather_overlord?
			@primal_master = battlers.find { |deity| deity.ability == :delta_stream }
			@primal_weather = STRONG_WINDS
			return @primal_weather_announce = old_weather != STRONG_WINDS
		elsif spatial_field? #Cas très rare, mais possible si Méga Rayquaza perd sa méga évolution en combat (Air Lock n'interfère pas avec l'espace)
			@primal_master = battlers.find { |deity| deity.ability == :air_lock }
			if @primal_master
				@primal_weather = CLEAR
				return @primal_weather_announce = old_weather != CLEAR
			end
		else
			@primal_master = battlers.find { |deity| [:air_lock,:desolate_land,:primordial_sea].include?(deity.ability) } #Pas besoin de check Souffle Delta, vu qu'il est fait en priorité à part
			if @primal_master
				case @primal_master.ability
				when :air_lock
					weather_change = old_weather != CLEAR
					@primal_weather = CLEAR
				when :desolate_land
					weather_change = old_weather != HARSH_SUN
					@primal_weather = HARSH_SUN
				when :primordial_sea
					weather_change = old_weather != HEAVY_RAIN
					@primal_weather = HEAVY_RAIN
				end
				return @primal_weather_announce = weather_change
			end
		end
		@primal_weather = nil
		@primal_weather_announce = false
	end

	def announce_weather_transition(old_weather,new_weather,push=false)
		return false if old_weather == new_weather
		if @primal_weather_announce
			BattleEngine::_mp([:ability_display, @primal_master]) #Proc talent
			if @primal_weather == CLEAR
				@primal_master.gendered_txt
				if spatial_field? || underwater_field?
					weather_text(92) #Pokémon crée une bulle d’oxygène !
				else
					weather_text(91) #Pokémon stabilise l’atmosphère !
				end
				announce_old_weather_dispelled(old_weather,push) unless old_weather == CLEAR
				#wind_power_field_effect(push) if new_weather == STRONG_WINDS
				return true
			end
		end
		case old_weather
		when HARSH_SUN
			return weather_text(69) if new_weather == SUNNY #Le soleil tape un peu moins fort, mais il est toujours présent.
		when HEAVY_RAIN
			return weather_text(70) if new_weather == RAIN #La pluie se calme un peu, mais elle est toujours présente.
		when FOG
			return weather_text(71) if new_weather == MISTY #L’épais brouillard s’est partiellement dissipé, laissant place à une brume féerique.
		when BLIZZARD
			return weather_text(72) if new_weather == SNOWING #Le blizzard perd significativement en vigueur et laisse place à de la simple neige.
			return weather_text(73) if new_weather == HAIL #La pluie environnante humidifie le blizzard et le transforme en grêle !
		when HAIL
			return weather_text(74) if new_weather == SNOWING #La grêle a perdu en intensité et laisse place à de la neige.
			return weather_text(75) if new_weather == RAIN #La grêle s’est réchauffée et s’est transformée en pluie.
		when STORMY_RAIN
			return weather_text(76) if new_weather == THUNDERSTORM #La pluie s’est arrêtée, mais l’orage gronde toujours !
			return weather_text(77) if new_weather == RAIN #L’orage s’est calmé, mais la pluie continue de tomber !
		end
		if new_weather == CLEAR
			announce_old_weather_dispelled(old_weather,push)
		else
			announce_new_weather(new_weather,push)
			check_ice_face(old_weather,new_weather)
		end
	ensure
		change_battlefield(:original_field) if burning_field? && wet_weather? #Tout invocation de pluie éteint immédiatement l'incendie en cours d'un terrain (second check)
	end

	#Vérification pour la restauration de Tête de Gel
	def check_ice_face(old_weather,new_weather)
		return unless [SNOWING,HAIL,BLIZZARD].include?(new_weather) #Other incompatible cases are already skimmed on announce_weather_transition - The check of burning_field? is done downstream in push
		BattleEngine.get_battlers.each { |battler| BattleEngine::_mp([:ice_face_restored,battler]) if battler.ability == :ice_face && battler.symbol == :eiscue && battler.form == 1 }
	end

	def wind_power_field_effect(push)
		push ? BattleEngine::_mp([:push_wind_power_field_effect]) : BattleEngine::BE_Interpreter.push_wind_power_field_effect
	end

	def announce_old_weather_dispelled(old_weather,push=false)
		return false if old_weather == -1
		push ? push_weather_text(52+old_weather) : weather_text(52+old_weather) #Annonce classique que l'ancienne météo prend fin
	end

	def announce_new_weather(new_weather=current_weather(false),push=false)
		push ? push_weather_text(35+new_weather) : weather_text(35+new_weather) #Annonce classique de la nouvelle météo
		return true
	end

	def announce_natural_weather
		push_weather_text(180+current_weather(false)) #Annonce dédiée pour la météo naturelle
	end

	def weather_text(str)
		$scene.display_message(ext_text(985, str))
		return true
	end

	def push_weather_text(str)
		BattleEngine._mp([:msgf, ext_text(985, str)])
	end

	def get_weather_animation_id
		return CLIMATE_ANIMATIONS[current_weather(false)]
	end

	def weather_global_animation(push=false)
		return unless id_anim = get_weather_animation_id
		push ? BattleEngine::_mp([:global_animation, id_anim]) : $scene.global_animation(id_anim)
	end

	def proc_thunderstorm_damage
		BattleEngine.get_battlers.each do |i|
			unless i.protected_from_thunderstorm?
				damage = BattleEngine::thunderstorm_damage(i)
				BattleEngine::_message_stack_push([:hp_down, i, damage]) if damage > 0
			end
			next if i.type_electric? #Gestion de la partie qui restaure le type Électrik du Pokémon s'il l'a perdu.
			if i.type1 != i.unaltered_type1 && i.unaltered_type1 == ELECTRIC
				BattleEngine::_message_stack_push([:lightning_restore_type, i, 1])
			elsif i.type2 != i.unaltered_type2 && i.unaltered_type2 == ELECTRIC
				BattleEngine::_message_stack_push([:lightning_restore_type, i, 2])
			end
		end
	end

	def proc_sandstorm_damage
		BattleEngine.get_battlers.each do |i|
			next if i.protected_from_sandstorm?
			damage = BattleEngine::sandstorm_damage(i)
			BattleEngine::_message_stack_push([:hp_down, i, damage]) if damage > 0
		end
	end

	def proc_hail_damage
		BattleEngine.get_battlers.each do |i|
			next if i.protected_from_hail?
			damage = BattleEngine::hail_damage(i)
			BattleEngine::_message_stack_push([:hp_down, i, damage]) if damage > 0
		end
	end
	
	def proc_shadow_sky_damage
		BattleEngine.get_battlers.each do |i|
			next if i.protected_from_shadow_sky?
			damage = BattleEngine::shadow_sky_damage(i)
			BattleEngine::_message_stack_push([:hp_down, i, damage]) if damage > 0
		end
	end

	def field_effect_text(str)
		$scene.display_message(ext_text(986, str))
	end

	def push_field_effect_text(str,pokemon=nil)
		pokemon.gendered_txt if pokemon && !BattleEngine._AI?
		BattleEngine::_mp([:msgf, ext_text(986, str)])
	end

	def quote_field_effect(pokemon)
		return unless @field_effect_to_quote
		push_field_effect_text(@field_effect_to_quote,pokemon)
	end

	###----------------- Méthodes dédiées pour calculer les facteurs d'effets secondaires ou de statut liés aux Field Effects -----------------###
	# Cela influe :
	## La probabilité qu'un statut en effet secondaire d'une attaque offensive de produise
	## La probabilité qu'un talent infligeant ce statut s'active (sauf Synchro)
	## La précision d'une attaque de statut infligeant ce statut
	#Ces méthodes doivent donc s'incruster à tous ces endroits (notament field_bonus_on_status_chance)

	#[Float] Retourne le facteur d'empoisonement liés aux effets de terrain
	def poison_factor
		factor = 1.25 - vibratory_rate*0.25 #Plus le lieu est sacré, moins il y a de chances d'empoisonnement
		factor += 0.4 if swamp_field?
		factor -= 0.25 if aerial_field? #Le vent disperse les toxines
		factor -= 0.25 if sigil_of_light?
		return factor
	end

	#[Float] Retourne le facteur pour paralyser liés aux effets de terrain (multiplicateurs nuls ignorés, car checkés à part)
	# (boolean) Argument electric_move requis, car ça influence le facteur
	def paralysis_factor(electric_move=true)
		return 1.0 unless electric_move #Seules les attaques électriques sont influencées
		factor = 1.0
		#Battlefield impact
		if desert_field?
			factor *= 0.5 
		elsif rocky_field? || burning_field? || (volcanic_field? && !wet_weather?)
			factor *= 0.8
		elsif swamp_field?
			factor *= 1.2
		elsif water_field?
			factor *= 1.4
		elsif magnetic_field?
			factor *= 1.5 
		end
		#Weather impact
		if harsh_sun?
			factor *= 0.5
		elsif sunny?
			factor *= 0.7 
		elsif rain? || heavy_rain?
			if water_surface_field?
				factor *= 1.2 #Capped at ×1.68, the battlefield is already soaked.
			elsif swamp_field? #Wet battlefield, but not soaked
				factor *= 1.35 #×1.62, a little less compared to a soaked battlefield
			else
				factor *= 1.5
				factor = 2.0 if factor > 2.0 #Capped
			end
		elsif storm? #Thunderstorm stacks normally with wet battlefields
			factor *= 1.5
			factor = 2.0 if factor > 2.0 #Capped
		elsif stormy_rain?
			factor *= 2.0
			factor = 2.0 if factor > 2.0 #Capped
		end
		return factor
	end

	#[Float] Retourne le facteur pour brûler liés aux effets de terrain (multiplicateurs nuls ignorés, car checkés à part)
	def burn_factor
		factor = 1.0
		#Battlefield impact
		if water_surface_field?
			factor *= 0.5
		elsif swamp_field? || icy_field?
			factor *= 0.8
		elsif burning_field?
			factor *= 2.0
		elsif hot_field?
			factor *= 1.3
		end
		#Weather impact
		if rain? || stormy_rain?
			factor *= 0.5
		elsif blizzard?
			factor *= 0.6
		elsif hail?
			factor *= 0.75
		elsif snowing?
			factor *= 0.9
		elsif harsh_sun?
			factor *= 1.5
			factor = 2.0 if factor > 2 #Capped
		elsif sunny?
			factor *= 1.3
			factor = 2.0 if factor > 2 #Capped
		end
		return factor
	end

	#[Float] Retourne le facteur pour endormir liés aux effets de terrain (multiplicateurs nuls ignorés, car checkés à part)
	def sleep_factor
		factor = 1.0
		factor *= 1.1 if Palkia.dark_place? #Coder une colonne dans la constante BATTLEFIELDS pour indiquer si c'est un terrain toujours sombre, sombre s'il fait nuit, ou toujours éclairé (évitera des incohérences en cas de battleback manuel).
		if hail? || blizzard? || sandstorm? || shadow_sky?
			factor *= 0.7
		elsif harsh_sun? || heavy_rain? || strong_winds?
			factor *= 0.8
		elsif sunny? || rain?
			factor *= 0.9 
		end
		factor *= 1.3 if psychic_aura?
		factor *= 0.5 if burning_field?
		return factor
	end

	#[Float] Retourne le facteur pour geler liés aux effets de terrain (multiplicateurs nuls ignorés, car checkés à part)
	def freeze_factor
		factor = 1.0
		#Battlefield impact
		if desert_field? || draconic_field? || volcanic_field?
			factor *= 0.5
		elsif icy_field?
			factor *= 1.3
		end
		#Weather impact
		if sunny?
			factor *= 0.5
		elsif blizzard?
			factor *= 1.5
		elsif snowing? || hail?
			factor *= 1.3
		elsif rainy_weather?
			factor *= 1.1
		end
		return factor
	end

	#[Float] Retourne le facteur pour rendre confus liés aux effets de terrain (multiplicateurs nuls ignorés, car checkés à part)
	def madness_factor
		factor = 1.25 - vibratory_rate*0.25 #Plus le lieu est sacré, moins il y a de chances de sombrer dans la folie
		factor -= 0.25 if sigil_of_light?
		factor *= 1.3 if psychic_aura?
		factor *= 1.2 if strong_winds? || stormy_weather? || shadow_sky?
		return factor
	end

	#[Float] Retourne le facteur pour apeurer (ne concerne que certains grottes et le terrain rocheux)
	#invert_holy_place_factor : true si check du talent Master of Emotions
	def flinch_factor(invert_holy_place_factor=false)
		factor = 1.0
		factor += 0.25 if rocky_field? || (cave_or_interior? && (draconic_field? || magnetic_field? || volcanic_field? || snowy_field?))
		if holy_place?
			mod = invert_holy_place_factor ? 0.25 : -0.25
			factor += mod
		end
		return factor
	end

	###----------------- Méthodes dédiées pour détecter les immunités de statuts dû aux Field Effects -----------------###

	#[Boolean] Check si les effets de terrain immunisent au poison
	#Pour ne pas afficher de message, laisser l'argument pkmn à nil
	def poison_nullified?(pkmn = nil)
		if misty_weather?
			BattleEngine::_message_stack_push([:msgf, parse_text_tag_pokemon(996 - Db::CSV_BASE, 72, pkmn)]) if pkmn #La brume a protégé Pokémon du poison !
			return true
		end
		return false
	end

	#[Boolean] Check si les effets de terrain immunisent à la paralysue
	#Pour ne pas afficher de message, laisser l'argument pkmn à nil
	def paralysis_nullified?(pkmn = nil)
		if misty_weather?
			BattleEngine::_message_stack_push([:msgf, parse_text_tag_pokemon(996 - Db::CSV_BASE, 87, pkmn)]) if pkmn #La brume a empêché Pokémon d’être paralysé !
			return true
		end
		return false
	end

	#[Boolean] Check si les effets de terrain immunisent à la brûlure
	# L'argument pkmn est requis ici à cause du check is_grounded
	# heal = nil pour bloquer le message d'immersion (à cause du check de l'Orbe Flamme), true pour afficher le message de guérison
	def burn_nullified?(pkmn, heal=false)
		if underwater_field? || (sea_field? && BattleEngine::is_grounded?(pkmn))
			BattleEngine::_message_stack_push([:msgf, parse_text_tag_pokemon(996 - Db::CSV_BASE, heal ? 109 : 104, pkmn)]) if pkmn && heal != nil # L’immersion met fin à la brûlure de Pokémon ! / L’immersion a empêché Pokémon d’être brulé !
			return true
		elsif heavy_rain?
			BattleEngine::_message_stack_push([:msgf, parse_text_tag_pokemon(996 - Db::CSV_BASE, heal ? 108 : 103, pkmn)]) if pkmn && heal != nil #La pluie diluvienne met fin à la brûlure de Pokémon ! / La pluie diluvienne a empêché Pokémon d’être brûlé !
			return true
		elsif misty_weather? && !heal #Pas de rétroactivité sur la brume
			BattleEngine::_message_stack_push([:msgf, parse_text_tag_pokemon(996 - Db::CSV_BASE, 102, pkmn)]) if pkmn && heal != nil #La brume a empêché Pokémon d’être brûlé !
			return true
		end
		return false
	end

	#[Boolean] Check si les effets de terrain immunisent au sommeil
	#Pour ne pas afficher de message, laisser l'argument pkmn à nil
	def sleep_nullified?(pkmn = nil)
		if stormy_weather? || magnetic_field?
			BattleEngine::_message_stack_push([:msgf, parse_text_tag_pokemon(996 - Db::CSV_BASE, 120, pkmn)]) if pkmn #L’air électrifié empêche Pokémon de dormir !
			return true
		end
		return false
	end

	#[Boolean] Check si les effets de terrain immunisent au gel
	#Pour ne pas afficher de message, laisser l'argument pkmn à nil
	#heal permet d'afficher un message de guérison au lieu d'un message d'immunité
	def freeze_nullified?(pkmn=nil, heal=false)
		if burning_field? || harsh_sun? || (sunny? && hot_field?)
			BattleEngine::_msgtp(996 - Db::CSV_BASE, heal ? 145 : 138 , pkmn) if pkmn # La chaleur accablante a décongelé Pokémon ! / Pokémon ne peut pas être gelé à cause de la chaleur accablante !
			return true
		end
		return false
	end

	#[Boolean] Check si les effets de terrain immunisent à la folie
	#Pour ne pas afficher de message, laisser l'argument pkmn à nil
	def madness_nullified?(pkmn=nil)
		if misty_weather?
			BattleEngine._msgtp(996 - Db::CSV_BASE, 160, pkmn) if pkmn #Le temps brumeux a empêché Pokémon de sombrer dans la folie !
			return true
		end
		return false
	end

	###----------------- Méthodes dédiées pour calculer l'impact des Field Effects sur un move et l'annoncer -----------------###

	#Getter pour l'annonce
	def announce_move_field_effect(skill)
		return nil if !@announce_move_forced && (skill.status? || (@positive_quote_id == true && @field_effect_move_factor <= 1.125) || (@positive_quote_id == false && @field_effect_move_factor >= 0.875)) #Seuil pour qu'une citation de field effect se fasse - si le facteur est trop proche de 1 ou en contradiction avec la phrase affichée, l'effet est considéré comme négligeable et n'est pas annoncé
		return nil if skill.db_symbol == :splash && !move_nullified?
		return @announce_move_field_effect
	end

	def move_nullified?
		return @field_effect_move_factor == 0
	end

	#Idem que move_nullified?, mais avec annonce
	def move_nullified_by_field_effects?(msg_push=true)
		if move_nullified?
			BattleEngine._msgp(986 - Db::CSV_BASE, @announce_move_field_effect) if @announce_move_field_effect && msg_push
			return true
		end
		return false
	end

	#Setter maitre de l'impact des champs de bataille sur les capacités (et les dégâts d'immobilisations)
	#Fait un tir groupé en calculant en même temps le facteur de puissance, la phrase à afficher et le facteur énergétique
	#Toujours checker en premier les nullifications pour éviter des calculs inutiles
	#Retourne [Float] pour bind_damage
	def calc_field_effects_factor(type,symbol=nil)
		return @field_effect_move_factor if @field_effect_already_calc && symbol #Optimization: use the previous value (eg. same move used on an additional strike or target)
		@field_effect_set = false #Flag pour savoir s'il faut initier les variables multiplicatives, ou les multiplier à une valeur déjà existante (gestion des cumuls d'effets de terrain, incluant les citations)
		@max_mult = 1
		@min_mult = 1
		@calc_weather_factor = true #To manage hardcoded stacking of battlefields with weather (battle auras stack normally)
		#Battlefield factor (including interior factor)
		if distortion_world?
			distortion_world_factor(symbol,type)
		elsif spatial_field?
			spatial_factor(symbol,type)
		elsif underwater_field?
			underwater_factor(symbol,type)
		elsif aerial_field?
			windy_factor(symbol,type)
		elsif etheric_field?
			#Nothing for this moment
		elsif magnetic_field?
			magnetic_factor(symbol,type)
		elsif burning_field?
			burning_factor(symbol,type)
		elsif draconic_field?
			draconic_factor(symbol,type)
		elsif volcanic_field?
			volcanic_factor(symbol,type)
		elsif icy_field?
			icy_factor(symbol,type)
		elsif water_surface_field?
			water_surface_factor(symbol,type)
		elsif beach_field?
			beach_factor(symbol,type)
		elsif desert_field?
			desert_factor(symbol,type)
		elsif swamp_field?
			swamp_factor(symbol,type)
		elsif forest_field?
			forest_factor(symbol,type)
		elsif meadow_field?
			meadow_factor(symbol,type)
		elsif rocky_field?
			rocky_factor(symbol,type)
		elsif cave_or_interior?
			no_flying_cave_factor(symbol,type)
		end
		return 0 if move_nullified?
		#Facteur de sainteté du lieu
		if holy_place?
			holy_place_factor(symbol,type)
			return 0 if move_nullified?
		elsif cursed_place? && !distortion_world?
			cursed_place_factor(symbol,type)
			return 0 if move_nullified?
		end
		#Facteur climatique
		if @calc_weather_factor
			weather_factor(symbol,type) 
			return 0 if move_nullified?
		end
		#Aura psychique
		psychic_aura_factor(type,symbol)
		#Sigil de Lumière
		sigil_of_light_factor(type,symbol)
		@field_effect_already_calc = true
		return @field_effect_move_factor
	end

	#Une multiplication par 0 donnera toujours 0, donc stopper tous les calculs dès qu'une nullification est détectée
	def set_move_nullified(quote_id=nil)
		@announce_move_forced = true #Pas d'exception lorsqu'un move est nullifié, ça doit toujours être annoncé
		@announce_move_field_effect = BattleEngine._AI? ? nil : quote_id
		@field_effect_move_factor = 0
		@energy_cost_factor = 2
		@field_effect_already_calc = true
		@field_effect_set = true
		return 0
	end

	def set_move_factor(factor,quote_id=nil)
		if @field_effect_set #Additionnal impact from other factor - multiplicative stacking
			@field_effect_move_factor *= factor
			if quote_id
				if factor > 1
					if factor > @max_mult
						if @field_effect_move_factor >= 1
							set_announce_move_field_effect(quote_id) 
							@positive_quote_id = true
						end
						@max_mult = factor
					end
				elsif factor < @min_mult
					if @field_effect_move_factor <= 1
						set_announce_move_field_effect(quote_id) 
						@positive_quote_id = false
					end
					@min_mult = factor
				end
			end
		else #First change
			set_announce_move_field_effect(quote_id)
			@field_effect_move_factor = factor
			if quote_id
				if factor > 1
					@max_mult = factor
					@positive_quote_id = true
				else
					@min_mult = factor
					@positive_quote_id = false
				end
			end
		end
		if factor < 1
			@energy_cost_factor = 1.0/(0.25+factor*0.75)
			@energy_cost_factor = 2 if @energy_cost_factor > 2 #Capped
		else
			@energy_cost_factor = 1.0/factor
			@energy_cost_factor = 0.35 if @energy_cost_factor < 0.35 #Capped (Technically, 0.5 is the minimum)
		end
		@field_effect_set = true
	end

	def reset_move_factor
		@announce_move_field_effect = nil
		@announce_move_forced = false
		@quote_strong_winds_mitigation = false
		@field_effect_already_calc = false
		@field_effect_set = false
		@field_effect_move_factor = 1
		@energy_cost_factor = 1
		@max_mult = 1
		@min_mult = 1
	end

	#Setter pour l'annonce
	def set_announce_move_field_effect(quote_id)
		return if BattleEngine._AI?
		@announce_move_field_effect = quote_id
	end

	#Getter pour les Vents Célestes + active un flag pour citer la phrase
	#Attention aux combats inversés ! (Un argument supplémentaire sera nécessaire)
	def strong_winds_mitigation(target,type,no_quote)
		if strong_winds? && target.type_flying? && [ELECTRIC,ICE,ROCK].include?(type)
			@quote_strong_winds_mitigation = true unless no_quote
			return true
		end
		return false
	end


	##------- Setters de facteur dédiés pour chaque effet de terrain (factorisation) -------##

	def distortion_world_factor(symbol,type)
		if type == LIGHT || %i[meditate synthesis morning_sun moonlight].include?(symbol)
			set_move_nullified(668) #Le Monde Distorsion a complètement désacralisé l’attaque !
		elsif Db::Move.field_altering_move?(symbol)
			set_move_nullified(669) #Le Monde Distorsion empêche toute altération du terrain !
		elsif [GHOST,DARK,SHADOW].include?(type)
			set_move_factor(1.5,666) #La malveillance de cette attaque entre en résonnance avec le Monde Distorsion !
		elsif Db::Move.wrath_move?(symbol)
			set_move_factor(1.4,666) #La malveillance de cette attaque entre en résonnance avec le Monde Distorsion !
		elsif type == POISON
			set_move_factor(1.3,666) #La malveillance de cette attaque entre en résonnance avec le Monde Distorsion !
		elsif type == FAIRY || (type == PSYCHIC && symbol != :dream_eater) || symbol == :floral_healing
			set_move_factor(0.5,667) #Les énergies du Monde Distorsion corrompent la spiritualité de cette attaque !
			@announce_move_forced = true if symbol == :floral_healing
		end
	end

	def spatial_factor(symbol,type)
		if Db::Move.weather_altering_move?(symbol)
			set_move_nullified(657) #Impossible d’invoquer un climat dans le vide spatial…
		elsif Db::Move.field_altering_move?(symbol)
			set_move_nullified(659) #Le vide spatial est infini et ne laisse nulle autre alternative…
		elsif Db::Move.unusable_in_spatial_field?(symbol)
			set_move_nullified(658) #Cette capacité ne peut fonctionner au milieu de l’espace…
		elsif %i[black_hole_eclipse hyperspace_fury hyperspace_hole judgment shadow_force spacial_rend roar_of_time].include?(symbol)
			set_move_factor(1.75,647) #L’espace-temps est déchiré !
		elsif symbol == :dragon_ascent
			set_move_factor(1.5,648) #Par la grâce des cieux !
		elsif symbol == :doom_desire #Quotation is deferred for future attack
			set_move_factor(1.75,nil) 
		elsif symbol == :wish || symbol == :future_sight #Just to set the energy cost for wish and Future Sight, the sentence is displayed when there is the heal or the future attack (hardcoded)
			set_move_factor(1.5,nil)
		elsif symbol == :cosmic_power
			set_move_factor(1.5,649) #Les étoiles ont entendu la prière !
			@announce_move_forced = true
		elsif %i[swift meteor_mash ancient_power comet_punch power_gem].include?(symbol)
			set_move_factor(1.5,650) #Les météores gravitant autour se joignent à l’attaque !
		elsif %i[menacing_moonraze_maelstrom searing_sunraze_smash soul_stealing_7_star_strike].include?(symbol)
			set_move_factor(1.5,651) #L’énergie stellaire renforce l’attaque !
		elsif symbol == :lunar_blessing
			set_move_factor(1.5,655) #Le pouvoir de la lune illumine l’attaque !
			@announce_move_forced = true
		elsif type == PSYCHIC
			set_move_factor(1.5,652) #L’énergie psychique rayonne au milieu des étoiles !
		elsif type == DRAGON
			set_move_factor(1.4,653) #Les dragons règnent sur les hauts cieux !
		elsif type == LIGHT || %i[life_dew sacred_fire synthesis morning_sun].include?(symbol)
			set_move_factor(1.25,654) #La lumière des étoiles fait rayonner cette attaque sacrée !
			@announce_move_forced = true if %i[life_dew synthesis morning_sun].include?(symbol)
		elsif type == FAIRY || symbol == :moonlight
			set_move_factor(1.25,655) #Le pouvoir de la lune illumine l’attaque !
			@announce_move_forced = true if symbol == :moonlight
		elsif type == GROUND
			set_move_factor(0.25,656) #L’attaque tellurique ne prend vie que grâce à quelques météores gravitant autour…
		end	
	end

	def underwater_factor(symbol,type)
		if Db::Move.weather_altering_move?(symbol)
			set_move_nullified(640) #Impossible d’invoquer un climat dans les profondeurs aquatiques…
		elsif Db::Move.field_altering_move?(symbol)
			set_move_nullified(638) #L’eau baigne tout ne peut être repoussée en dehors du champ de bataille…
		elsif Db::Move.broken_wings_affected?(symbol)
			set_move_nullified(637) #Impossible de voler sous l’eau !
		elsif type == FIRE
			set_move_nullified(636) #Impossible de faire du feu sous l’eau !
		elsif type == WATER
			set_move_factor(2,633) #L’attaque aquatique devient dévastatrice sous l’eau !
		elsif type == ELECTRIC
			set_move_factor(1.5,526) #L’eau conduit l’électricité et augmente l’intensité du choc !
		elsif type == GROUND || type == ROCK
			set_move_factor(0.5,634) #Le milieu sous-marin atténue l’impact de cette attaque tellurique !
		elsif type == FLYING
			set_move_factor(0.5,635) #L’eau n’est pas aussi fluide que l’air…
		end
	end

	def windy_factor(symbol,type)
		#Si l'attaque est inutilisable sur un champ de bataille aérien (Sky Battle)
		if sky_field? && (type == GROUND || Db::Move.unusable_in_sky_battle?(symbol))
			set_move_nullified(type == GROUND ? 625 : 626) #Impossible de faire une attaque tellurique au milieu des nuages ! / Cette capacité ne peut fonctionner en combattant dans le ciel…
		elsif type == FLYING || Db::Move.wind_move?(symbol) || %i[flying_press sky_uppercut steel_wing].include?(symbol)
			set_move_factor(1.4,stormy_weather? || blizzard? ? 623 : 622) #L’air vivifiant rend l’attaque aérienne dévastatrice ! / Avec grâce aérienne !
		elsif type == POISON
			set_move_factor(0.75,624) #Le vent disperse les toxines…
		end
	end

	def magnetic_factor(symbol,type)
		if type == ELECTRIC
			if stormy_weather? #Partial stacking
				set_move_factor(1.8,601) #Le champ magnétique se combine à l’orage et rend le choc mortel !
				@calc_weather_factor = false
			else
				set_move_factor(1.4,600) #Le champ magnétique fait grimper l’intensité !
			end
			if %i[charge eerie_impulse magnet_rise].include?(symbol) #Quotation overwrite on three status moves + forcing
				set_announce_move_field_effect(symbol == :charge ? 602 : 603) #La charge est plus rapide grâce au champ magnétique ! / Les ondes sont intensifiées par le champ magnétique !
				@announce_move_forced = true
			end
		elsif type == PSYCHIC
			set_move_factor(0.75,604) #Les crépitements électriques perturbent la concentration psychique…
		end
		if cave_or_interior? #Magnetic cave
			if %i[fly bounce sky_drop].include?(symbol)
				set_move_nullified(471) #Impossible de s’envoler haut dans cet espace restreint !
			elsif Db::Move.sound_attack?(symbol)
				set_move_factor(1.25,470) #La grotte fait résonner cette attaque !
			elsif type == ROCK
				set_move_factor(1.25,468) #La caverne amplifie l’attaque !
			elsif type == GROUND
				set_move_factor(1.25,469) #La caverne augmente la force de l’attaque tellurique !
			elsif type == FIGHTING
				set_move_factor(1.25,462) #Le sol pierreux rend le coup plus fracassant !
			elsif type == FLYING
				set_move_factor(0.75,472) #L’espace restreint empêche l’attaque aérienne d’avoir son plein potentiel !
			end
		end
	end

	def burning_factor(symbol,type)
		if symbol == :smoke
			set_move_factor(1.5,587) #La fumée devient étouffante au milieu des flammes !
			@announce_move_forced = true
		elsif type == FIRE
			if harsh_sun?
				set_move_factor(2.0,586) #Le brasier combiné au soleil rend cette attaque de feu mortelle !
				@calc_weather_factor = false
			elsif sunny?
				set_move_factor(1.9,586) #Le brasier combiné au soleil rend cette attaque de feu mortelle !
				@calc_weather_factor = false
			else
				set_move_factor(1.5,585) #Le brasier renforce la puissance de cette attaque !
			end
		elsif type == FLYING
			if battlefield_exterior?
				set_move_factor(1.25,588) #Les courants ascendants produits par les flammes renforcent l’attaque aérienne !
			else #Cave
				no_flying_cave_factor(symbol,type)
			end
		elsif type == ICE
			set_move_factor(0.5,589) #La glace perd de sa force à cause des flammes !
		elsif type == WATER
			set_move_factor(0.6,sunny_weather? ? 566 : 590) #L’attaque est quasiment asséchée par le soleil et les flammes… / L’incendie assèche l’attaque !
		elsif type == GRASS
			set_move_factor(0.7,591) #L’énergie végétale se flétrit à cause des flammes…
		elsif type == FAIRY
			set_move_factor(0.7,592) #La magie féerique dépérit au milieu de ce brasier…
		elsif type == ELECTRIC
			set_move_factor(0.8,593) #L’air asséché par l’incendie réduit la conductivité électrique !
		end
		if cave_or_interior? #Burning cave - only some effets from cave battlefields
			no_flying_cave_factor(symbol,type)
		end
	end

	def draconic_factor(symbol,type)
		if symbol == :dragon_ascent
			set_move_factor(1.5,648) #Par la grâce des cieux !
		elsif symbol == :payday
			set_move_factor(2,574) #Le trésor des dragons se révèle !
		elsif %i[make_it_rain diamond_storm power_gem].include?(symbol)
			set_move_factor(1.5,574) #Le trésor des dragons se révèle !
		elsif type == DRAGON
			set_move_factor(1.5,573) #L’énergie draconique amplifie l’attaque !
			@announce_move_forced = true if symbol == :dragon_dance
		elsif type == FIRE
			if harsh_sun?
				set_move_factor(1.9,576) #Le soleil et la chaleur draconique rendent ces flammes dévorantes !
				@calc_weather_factor = false
			elsif sunny?
				set_move_factor(1.7,576) #Le soleil et la chaleur draconique rendent ces flammes dévorantes !
				@calc_weather_factor = false
			else
				set_move_factor(1.3,575) #La chaleur draconique intensifie les flammes !
			end
		elsif type == LIGHT	
			set_move_factor(1.3,577) #L’énergie des dragons est sacrée !
		elsif type == FAIRY	
			set_move_factor(0.7,578) #La magie féerique faiblit dans cette atmosphère hostile…
		elsif type == ICE	
			set_move_factor(0.5,579) #La chaleur draconique affaiblit l’attaque glaciale !
		end
		if cave_or_interior? #Dragon's Den - only some effets from cave battlefields
			if Db::Move.sound_attack?(symbol)
				set_move_factor(1.25,470) #La grotte fait résonner cette attaque !
			elsif type == ROCK
				set_move_factor(1.25,468) #La caverne amplifie l’attaque !
			elsif type == GROUND
				set_move_factor(1.25,469) #La caverne augmente la force de l’attaque tellurique !
			elsif type == FIGHTING
				set_move_factor(1.25,462) #Le sol pierreux rend le coup plus fracassant !
			end
		end
	end

	def volcanic_factor(symbol,type)
		if symbol == :smoke
			set_move_factor(1.5,563) #Les fumerolles du volcan amplifient l’attaque !
			@announce_move_forced = true
		elsif type == FIRE
			if harsh_sun?
				set_move_factor(2.0,562) #Le soleil et la chaleur volcanique rendent ces flammes dévorantes !
				@calc_weather_factor = false
			elsif sunny?
				set_move_factor(1.8,562) #Le soleil et la chaleur volcanique rendent ces flammes dévorantes !
				@calc_weather_factor = false
			else
				set_move_factor(1.4,561) #La chaleur volcanique intensifie les flammes !
			end
		elsif type == ROCK
			if cave_or_interior?
				set_move_factor(1.5,468) #La caverne amplifie l’attaque !
			else
				set_move_factor(1.3,459) #Le terrain rocheux amplifie l’attaque !
			end
			return
		elsif type == GROUND
			if cave_or_interior?
				set_move_factor(1.4,469) #La caverne augmente la force de l’attaque tellurique !
			else
				set_move_factor(1.25,460) #La montagne augmente la force de l’attaque tellurique !
			end
			return
		elsif type == FIGHTING
			set_move_factor(1.25,462) #Le sol pierreux rend le coup plus fracassant !
		elsif type == ICE
			set_move_factor(0.5,564) #La chaleur volcanique affaiblit l’attaque glaciale !
		elsif type == WATER
			set_move_factor(0.7,sunny_weather? ? 566 : 565) #L’attaque est quasiment asséchée par le soleil et les flammes… / La chaleur volcanique assèche l’attaque !
		elsif type == ELECTRIC
			unless wet_weather? #Pénalité annulée sous ces météos
				set_move_factor(0.8,567) #L’air asséché par les hautes températures réduit la conductivité électrique !
			end
		end
		if cave_or_interior? #Volcanic cave
			if Db::Move.sound_attack?(symbol)
				set_move_factor(1.25,470) #La grotte fait résonner cette attaque !
			else
				no_flying_cave_factor(symbol,type)
			end
		end
	end

	def icy_factor(symbol,type)
		if type == ICE #Icy field + Blizzard will be automatically capped at ×2, others cases stack normally
			set_move_factor(1.4, freezing_weather? ? 550 : 551) #L’environnement extrêmement glacial rend cette attaque dévastatrice ! / L’environnement glacial renforce l’attaque !
		elsif type == FLYING
			if battlefield_exterior? #Stacks normally with weather
				set_move_factor(1.3, blizzard? || stormy_weather? || strong_winds? ? 623 : 552) #L’air vivifiant rend l’attaque aérienne dévastatrice ! / L’air frais augmente la force de l’attaque aérienne !
			else #Cave penality is cancelled with field boost, except if there is nullification
				if %i[fly bounce sky_drop].include?(symbol)
					set_move_nullified(471) #Impossible de s’envoler haut dans cet espace restreint !
				elsif strong_winds?
					set_move_factor(1.3,555) #L’air vivifiant augmente la force de l’attaque aérienne !
					@calc_weather_factor = false
				elsif blizzard? || stormy_weather?
					set_move_factor(1.25,555) #L’air vivifiant augmente la force de l’attaque aérienne !
					@calc_weather_factor = false
				end
			end
			return 
		elsif type == FIRE #Stacks normally with weather
			set_move_factor(0.8, blizzard? || hail? || rainy_weather? ? 553 : 554) #L’environnement extrêmement glacial affaiblit l’attaque ardente ! / Le froid affaiblit l’attaque ardente !
		end
		if cave_or_interior? #Icy cave - only some effets from cave battlefields and Flying-move are already handled above
			if Db::Move.sound_attack?(symbol)
				set_move_factor(1.25,470) #La grotte fait résonner cette attaque !
			elsif type == ROCK
				set_move_factor(1.25,468) #La caverne amplifie l’attaque !
			elsif type == GROUND
				set_move_factor(1.25,469) #La caverne augmente la force de l’attaque tellurique !
			end
		end
	end

	def water_surface_factor(symbol,type)
		if %i[spikes toxic_spikes sticky_web].include?(symbol) && sea_field?
			set_move_nullified(542) #Impossible de poser un piège sur le sol lorsqu’il n’y a que de l’eau !
		elsif type == GROUND || symbol == :shore_up
			if sea_field?
				set_move_nullified(541) #Impossible de faire une attaque tellurique au milieu de la mer !
			elsif battlefield_exterior? #Neutral impact in Aquatic Cave
				set_move_factor(0.25,530) #La surface de l’eau absorbe l’impact tellurique de l’attaque !
				@announce_move_forced = true if symbol == :shore_up && !sandstorm?
			end
		elsif type == ROCK
			if sea_field?
				set_move_factor(0.25,540) #La mer empêche l’attaque rocheuse de trouver un point d’appui !
			elsif battlefield_exterior? #Neutral impact in Aquatic Cave
				set_move_factor(0.5,530) #La surface de l’eau absorbe l’impact tellurique de l’attaque !
			end
		elsif type == WATER
			if harsh_sun? #Not nullified in water surface
				if symbol == :hydro_steam #Ignore weather factor in this case for Hydro Steam
					set_move_factor(1.5,sea_field? ? 536 : 525) #La mer rend cette attaque torrentielle ! / La surface de l’eau rend cette attaque torrentielle
				else
					set_move_factor(0.5,684) #La chaleur du soleil affaiblit l’attaque !
				end
				@calc_weather_factor = false
			elsif symbol == :hydro_steam && sunny? #Partial stacking
				set_move_factor(1.8,sea_field? ? 536 : 525) #La mer rend cette attaque torrentielle ! / La surface de l’eau rend cette attaque torrentielle
				@calc_weather_factor = false
			elsif hail? #Partial stacking
				set_move_factor(1.65,sea_field? ? 536 : 525) #La mer rend cette attaque torrentielle ! / La surface de l’eau rend cette attaque torrentielle !
				@calc_weather_factor = false	
			elsif rainy_weather? #Partial stacking
				set_move_factor(heavy_rain? ? 2 : 1.75,sea_field? ? 537 : 526) # La mer et la pluie rendent cette attaque torrentielle ! / La surface de l’eau et la pluie rendent cette attaque torrentielle !
				@calc_weather_factor = false
			else
				set_move_factor(1.5,sea_field? ? 536 : 525) #La mer rend cette attaque torrentielle ! / La surface de l’eau rend cette attaque torrentielle !
			end
		elsif type == ELECTRIC
			if stormy_weather?
				set_move_factor(1.8,528) #L’orage combiné à l’eau rendent cette attaque électrique dévastatrice !
				@calc_weather_factor = false
			else
				set_move_factor(1.4,sea_field? ? 538 : 527) #La mer conduit l’électricité et augmente l’intensité du choc ! / L’eau conduit l’électricité et augmente l’intensité du choc !
			end
		elsif type == FIRE
			set_move_factor(0.5,sea_field? ? 539 : 529) #La mer affaiblit l’attaque ardente ! / La surface de l’eau affaiblit l’attaque ardente !
		end
		if cave_or_interior? #Aquatic cave - only some effets from cave battlefields
			no_flying_cave_factor(symbol,type)
		end
	end

	def beach_factor(symbol,type)
		if type == GROUND || symbol == :shore_up || symbol == :sand_attack
			set_move_factor(1.2,517) #Le sable de la plage se mélange à la force tellurique de l’attaque !
			@announce_move_forced = true if symbol == :shore_up || symbol == :sand_attack
		elsif type == WATER
			if heavy_rain? #Partial stacking
				set_move_factor(1.8,519) #La pluie se combine aux embruns de la mer et rend cette attaque torrentielle !
				@calc_weather_factor = false
			elsif rainy_weather? #Partial stacking
				set_move_factor(1.6,519) #La pluie se combine aux embruns de la mer et rend cette attaque torrentielle !
				@calc_weather_factor = false
			else #Normal stacking with other weathers, including hail
				set_move_factor(1.2,518) #La proximité de la mer renforce cette attaque aquatique !
			end
		end
	end

	def desert_factor(symbol,type)
		if type == GROUND || symbol == :shore_up || symbol == :sand_attack
			set_move_factor(1.4,506) #Le désert renforce la puissance tellurique de l’attaque !
			@announce_move_forced = true if symbol == :shore_up || symbol == :sand_attack
		elsif type == FIRE
			if sunny_weather? #Partial stacking
				set_move_factor(harsh_sun? ? 2 : 1.75,508) #Le soleil du désert rend ces flammes dévorantes !
				@calc_weather_factor = false
			else
				set_move_factor(1.25,507) #L’air asséché du désert intensifie la chaleur de l’attaque !
			end
		elsif type == WATER #Normal stacking with sunny weather
			set_move_factor(0.5,sunny_weather ? 510 : 509) #Le soleil du désert ne laisse passer qu’un maigre filet d’eau… / Le désert assèche l’attaque !
		elsif type == ELECTRIC
			set_move_factor(0.5,511) #L’air asséché par le sable réduit la conductivité électrique !
		end
	end

	def swamp_factor(symbol,type)
		if %i[mud_bomb mud_shot mud_slap].include?(symbol)
			if battlefield_exterior?
				set_move_factor(1.5,498) #La vase rend cette attaque encore plus boueuse !
			else
				set_move_factor(1.875,500) #La grotte vaseuse rend cette attaque dévastatrice !
			end
		elsif %i[earthquake bulldoze magnitude].include?(symbol) #No penalty in a swamp cave
			set_move_factor(0.5,499) if battlefield_exterior? #Le marais absorbe l’impact de l’attaque tellurique !
		elsif type == POISON
			if cursed_place? #Overstacking (total : ×1.8)
				set_move_factor(1.5, 492) #Le marécage fétide rend cette attaque mortelle !
			else
				set_move_factor(1.4,491) #La putréfaction du marais augmente la toxicité de cette attaque !
			end
		elsif type == BUG
			set_move_factor(1.4,493) #Les insectes prospèrent dans les marais !
		elsif type == ELECTRIC
			if stormy_weather? #Partial stacking
				set_move_factor(1.8,495) #L’humidité du marais combinée à l’orage intensifie l’attaque électrique !
				@calc_weather_factor = false
			else
				set_move_factor(1.4,494) # L’humidité du marais augmente la conductivité électrique !
			end
		elsif type == WATER
			if hail? #Partial stacking
				set_move_factor(1.5,497) #L’humidité du marais et la pluie rendent cette attaque torrentielle !
				@calc_weather_factor = false	
			elsif rainy_weather? #Partial stacking
				set_move_factor(heavy_rain? ? 1.8 : 1.6,497) #L’humidité du marais et la pluie rendent cette attaque torrentielle !
				@calc_weather_factor = false
			else
				set_move_factor(1.2,496) #L’humidité du marais renforce cette attaque aquatique !
			end
		end
		if cave_or_interior? #Swamp cave - cherry picking of cave effects
			if %i[fly bounce sky_drop].include?(symbol)
				set_move_nullified(471) #Impossible de s’envoler haut dans cet espace restreint !
			elsif type == ROCK
				set_move_factor(1.25,468) #La caverne amplifie l’attaque !
			elsif type == GROUND
				set_move_factor(1.25,469) #La caverne augmente la force de l’attaque tellurique !
			elsif type == FLYING
				set_move_factor(0.75,472) #L’espace restreint empêche l’attaque aérienne d’avoir son plein potentiel !
			end
		end
	end

	def forest_factor(symbol,type)
		if %i[earthquake bulldoze magnitude].include?(symbol)
			set_move_factor(cave_or_interior? ? 0.75 : 0.5,484) #La végétation absorbe l’attaque tellurique !
		elsif symbol == :defend_order || symbol == :heal_order
			set_move_factor(cave_or_interior? ? 1.35 : 1.5,480) #La force de la forêt amplifie l’attaque !
			@announce_move_forced = true
		elsif type == BUG
			set_move_factor(cave_or_interior? ? 1.35 : 1.5,479) # L’attaque se propage à travers la forêt !
		elsif type == GRASS || %i[coil rototiller growth flower_shield sweet_scent floral_healing].include?(symbol)
			set_move_factor(cave_or_interior? ? 1.35 : 1.3,480) #La force de la forêt amplifie l’attaque !
			@announce_move_forced = true if %i[jungle_healing coil rototiller growth flower_shield sweet_scent floral_healing].include?(symbol)
		elsif type == FIRE
			set_move_factor(1.2,481) #La végétation propage le feu !
		elsif type == WATER
			set_move_factor(0.8,482) #Le sol herbu absorbe une partie de l’eau !
		elsif cave_or_interior? #Rock and Ground-type move are not handicapped (and Earthquake / Bulldoze / Magnitude half as much)
			no_flying_cave_factor(symbol,type)
		else
			if type == ROCK
				set_move_factor(0.8,483) #La végétation atténue la force de cette attaque rocheuse !
			elsif type == GROUND
				set_move_factor(0.75,484) #La végétation absorbe l’attaque tellurique !
			end
		end
	end

	def meadow_factor(symbol,type)
		if %i[earthquake bulldoze magnitude].include?(symbol)
			set_move_factor(0.5,484) #La végétation absorbe l’attaque tellurique !
		elsif type == GRASS || %i[coil rototiller growth flower_shield sweet_scent floral_healing].include?(symbol)
			set_move_factor(1.4,478) #La végétation luxuriante amplifie l’attaque !
			@announce_move_forced = true if %i[coil rototiller growth flower_shield sweet_scent floral_healing].include?(symbol)
		elsif type == BUG
			set_move_factor(1.2,478) # La végétation luxuriante amplifie l’attaque !
		elsif type == FIRE
			set_move_factor(1.2,481) # La végétation propage le feu !
		elsif type == WATER
			set_move_factor(0.8,482) # Le sol herbu absorbe une partie de l’eau !
		elsif type == ROCK
			set_move_factor(0.8,483) # La végétation atténue la force de cette attaque rocheuse !
		elsif type == GROUND
			set_move_factor(0.75,484) #La végétation absorbe l’attaque tellurique !
		end
	end

	def rocky_factor(symbol,type)
		if cave_or_interior? #Cave
			if %i[fly bounce sky_drop].include?(symbol)
				return set_move_nullified(471) #Impossible de s’envoler haut dans cet espace restreint !
			elsif type == ROCK
				set_move_factor(1.5,468) #La caverne amplifie l’attaque !
			elsif type == GROUND
				set_move_factor(1.4,469) #La caverne augmente la force de l’attaque tellurique !
			elsif type == FIGHTING
				set_move_factor(1.25,462) #Le sol pierreux rend le coup plus fracassant !
			elsif type == FLYING
				set_move_factor(0.75,472) #L’espace restreint empêche l’attaque aérienne d’avoir son plein potentiel !
			end
			if Db::Move.sound_attack?(symbol)
				set_move_factor(1.25,470) #La grotte fait résonner cette attaque !
			end
		else #Exterior
			if type == ROCK
				set_move_factor(1.3,459) #Le terrain rocheux amplifie l’attaque !
			elsif type == GROUND
				set_move_factor(1.25,460) #La montagne augmente la force de l’attaque tellurique !
			elsif type == FIGHTING
				set_move_factor(1.25,462) #Le sol pierreux rend le coup plus fracassant !
			elsif type == FLYING
				set_move_factor(1.2, blizzard? || stormy_weather? || strong_winds? ? 623 : 461) #L’air vivifiant rend l’attaque aérienne dévastatrice ! / L’air de la montagne augmente la grâce de l’attaque aérienne !
			end
		end
	end

	#Factorisation pour un check commun dans les grottes
	def no_flying_cave_factor(symbol,type)
		if %i[fly bounce sky_drop].include?(symbol)
			set_move_nullified(471) #Impossible de s’envoler haut dans cet espace restreint !
		elsif type == FLYING
			set_move_factor(0.75,472) #L’espace restreint empêche l’attaque aérienne d’avoir son plein potentiel !
		end
	end

	def holy_place_factor(symbol,type)
		if %i[spectral_curse nightmare dream_eater].include?(symbol)
			set_move_nullified(453) #Le lieu saint a protégé [Pokémon] de cette malédiction !
		elsif [GHOST,DARK,SHADOW].include?(type)
			set_move_factor(0.6,452) #Le lieu saint réduit la puissance de cette attaque malveillante !
		elsif type == LIGHT
			set_move_factor(1.4,451) #L’attaque résonne avec les énergies de ce lieu saint !
		elsif [PSYCHIC,FAIRY].include?(type) || %i[return sacred_fire mystical_fire judgment life_dew meditate synthesis morning_sun moonlight].include?(symbol)
			set_move_factor(1.2,451) #L’attaque résonne avec les énergies de ce lieu saint !
		elsif type == DRAGON
			set_move_factor(1.2,450) #L’énergie draconique résonne avec le haut taux vibratoire !
		end
		@announce_move_forced = true if %i[life_dew meditate synthesis morning_sun moonlight].include?(symbol)
	end

	def cursed_place_factor(symbol,type)
		if [GHOST,DARK,SHADOW].include?(type)
			set_move_factor(1.3,441) #Le faible taux vibratoire intensifie cette attaque malveillante !
		elsif Db::Move.wrath_move?(symbol)
			set_move_factor(1.2,441) #Le faible taux vibratoire intensifie cette attaque malveillante !
		elsif type == POISON
			set_move_factor(1.2,441) #Le faible taux vibratoire intensifie cette attaque malveillante !
		elsif type == LIGHT
			set_move_factor(0.6,442) #Les énergies maléfiques de ce lieu désacralisent l’attaque !
		elsif type == FAIRY || symbol == :moonlight
			set_move_factor(0.75,443) #Les énergies maléfiques de ce lieu affaiblissent la magie féerique !
			@announce_move_forced = true if symbol == :moonlight
		elsif (type == PSYCHIC && symbol != :dream_eater) || %i[meditate synthesis morning_sun].include?(symbol)
			set_move_factor(0.75,444) #Le faible taux vibratoire atténue la puissance spirituelle de l’attaque !
			@announce_move_forced = true if %i[meditate synthesis morning_sun].include?(symbol)
		end
	end

	# Facteur de météo
	def weather_factor(symbol,type)
		mult = 1.0
		if harsh_sun? #Soleil caniculaire (climat de niveau 2)		
			if type == FIRE
				mult *= 1.6
			elsif type == WATER
				return set_move_nullified(687) #Le soleil brille si intensément que toute attaque de type Eau s’évapore !
			elsif type == ICE
				mult *= 0.65
			end
		elsif sunny? #Soleil normal (climat de niveau 1)
			if type == FIRE
				mult *= 1.4
			elsif type == WATER
				mult *= symbol == :hydro_steam ? 1.5 : 0.5
			elsif type == ICE
				mult *= 0.85
			end
		elsif heavy_rain? #Pluie diluvienne (climat de niveau 2)
			return set_move_nullified(685) if type == FIRE #La pluie diluvienne empêche toute attaque de type Feu !
			mult *= 1.6 if type == WATER #partial stacking with water surface battlefield
		elsif rainy_weather? #Pluie ou Pluie Orageuse
			mult *= 0.5 if type == FIRE
			mult *= 1.4 if type == WATER #partial stacking with water surface battlefield
		elsif misty?
			mult *= 1.3 if type == FAIRY
			mult *= 0.5 if type == DRAGON
		elsif fog? #Brouillard (climat de niveau 2)
			mult *= 1.4 if type == FAIRY
			mult *= 0.5 if type == DRAGON
		elsif shadow_sky?
			mult *= 1.3 if type == SHADOW
		elsif blizzard? #Blizzard (climat de niveau 2)
			mult *= 1.5 if type == ICE
			mult *= 1.25 if type == FLYING
			mult *= 0.6 if type == FIRE
		elsif freezing_weather? #Neige ou Grêle
			mult *= 1.15 if type == ICE
			if hail? #Seulement la Grêle
				mult *= 1.25 if type == WATER #Cap à +65% en terrain aquatique
				mult *= 0.6 if type == FIRE #-40% sous la grêle ou le blizzard
			else #Neige (Snowing)
				mult *= 0.9 if type == FIRE #-10% sous la neige
			end
		elsif strong_winds? #Compense le fait que Méga-Rayquaza doit tenir sa Méga-Gemme Sacrée pour méga évoluer (il reste donc Anything Goes)
			mult *= 1.3 if type == FLYING
		end
		if stormy_weather? #On casse la chaine conditionnelle, car il faut rechecker ici en cas de pluie orageuse pour les bonus de type Électrik et Vol
			mult *= 1.4 if type == ELECTRIC #partial stacking with magnetic battlefield
			mult *= 1.2 if type == FLYING
		end
		return if mult == 1
		set_move_factor(mult) #Pas de citation pour les météos
	end

	def psychic_aura_factor(type,symbol)
		if psychic_aura? #Blocking of priority moves is hardcoded, because its requires an instantiated skill + the launcher
			if %i[meditate cosmic_power calm_mind].include?(symbol)
				set_move_factor(1.3,678) #L’aura psychique accroit la force méditative !
				@announce_move_forced = true
			elsif type == PSYCHIC || symbol == :magical_leaf || symbol == :mystical_fire
				set_move_factor(1.3,677) if type == PSYCHIC #L’aura psychique accroit la force magique de l’attaque !
			elsif type == FAIRY
				return set_move_factor(1.2,679) #L’aura propice à la méditation accroit la magie féerique !
			else
				return 1
			end
		end
	end

	def sigil_of_light_factor(type,symbol)
		if sigil_of_light?
			return set_move_factor(1.3) if type == LIGHT
			#return set_move_factor(1.2) if type == FAIRY
			return set_move_factor(1.2) if %i[return sacred_fire mystical_fire judgment life_dew lunar_blessing synthesis morning_sun moonlight].include?(symbol) #Status moves listed for the energy factor
		end
		return 1
	end

	#Pré-check si une capacité peut altérer le terrain (utilisée pour forcer l'animation si le Pokémon a raté sa cible)
	def can_alter_field?(skill)
		return false unless skill.damage_field?
		case skill.original_type
		when FIRE
			return fire_elemental_damage_factor > 0
		when WATER
			return water_elemental_damage_factor > 0
		when ICE
			return ice_elemental_damage_factor > 0
		when POISON
			return poison_elemental_damage_factor > 0
		else
			return collapsible_cave?
		end
	end

	#Méthode appliquant les dégâts élémentaux des capacités au champ de bataille (3 variables d'instance de BattleEngine.state sont requises pour calculer les dégâts)
	#Retourne booléan (true = au moins un message a été affiché)
	def field_elemental_damage(launcher,field_damage_power,field_damage_type,offensive_stat_value)
		return false if field_damage_power < 1 || offensive_stat_value == 0 || BattleEngine.battle_finished
		case field_damage_type
		when FIRE
			return false unless (vulnerability_factor = fire_elemental_damage_factor) > 0
			power = calc_elemental_field_damage(offensive_stat_value,field_damage_power,vulnerability_factor,field_damage_type)
			if BattleEngine._AI?
				return apply_fire_transition(@field_temperature + power >= FIELD_MAX_DAMAGE,launcher)
			else
				cc 0x06
				pc("Elemental fire field damage increased from #{@field_temperature} to #{@field_temperature + power}")
				cc 0x07
				@field_temperature += power
				@water_elemental_damage = [@water_elemental_damage-power/2,0].max #Interference with Water elemental damage
				return apply_fire_transition(@field_temperature >= FIELD_MAX_DAMAGE,launcher)
			end
		when WATER
			return false unless (vulnerability_factor = water_elemental_damage_factor) > 0
			power = calc_elemental_field_damage(offensive_stat_value,field_damage_power,vulnerability_factor,field_damage_type)
			if BattleEngine._AI?
				return apply_water_transition(@water_elemental_damage + power >= FIELD_MAX_DAMAGE,launcher)
			else
				cc 0x06
				pc("Elemental water field damage increased from #{@water_elemental_damage} to #{@water_elemental_damage + power}")
				cc 0x07
				@water_elemental_damage += power
				@field_temperature = [@water_elemental_damage-power/2,0].max if @field_temperature > 0 #Interference with Fire elemental damage
				@poison_elemental_damage = [@poison_elemental_damage-power/4,0].max #Interference with Poison elemental damage
				return apply_water_transition(@water_elemental_damage >= FIELD_MAX_DAMAGE,launcher)
			end
		when ICE		
			return false unless (vulnerability_factor = ice_elemental_damage_factor) > 0
			power = calc_elemental_field_damage(offensive_stat_value,field_damage_power,vulnerability_factor,field_damage_type)
			if BattleEngine._AI?
				return apply_ice_transition(@field_temperature - power <= -FIELD_MAX_DAMAGE,launcher)
			else
				cc 0x06
				pc("Elemental ice field damage increased from #{-@field_temperature} to #{-@field_temperature - power}")
				cc 0x07
				@field_temperature -= power
				@water_elemental_damage = [@water_elemental_damage-power/2,0].max #Interference with Water elemental damage
				return apply_ice_transition(@field_temperature <= -FIELD_MAX_DAMAGE,launcher)
			end
		when POISON
			return false unless (vulnerability_factor = poison_elemental_damage_factor) > 0
			power = calc_elemental_field_damage(offensive_stat_value,field_damage_power,vulnerability_factor,field_damage_type)
			if BattleEngine._AI?
				return apply_poison_transition(@poison_elemental_damage + power >= FIELD_MAX_DAMAGE,launcher)
			else
				cc 0x06
				pc("Elemental poison field damage increased from #{@poison_elemental_damage} to #{@poison_elemental_damage + power}")
				cc 0x07
				@poison_elemental_damage += power
				return apply_poison_transition(@poison_elemental_damage >= FIELD_MAX_DAMAGE,launcher)
			end
		else #Telluric elemental damage (cave collapse)
			return false unless collapsible_cave?
			power = calc_elemental_field_damage(offensive_stat_value,field_damage_power,2,field_damage_type) #vulnerability_factor at the standard rate of 2
			return check_cave_collapsing(power)
		end
	end
	
	#The argument "type" is just for debug
	def calc_elemental_field_damage(offensive_stat_value,field_damage_power,vulnerability_factor,type)
		value = (offensive_stat_value**0.5 * field_damage_power * vulnerability_factor /2).to_i
		unless BattleEngine._AI?
			cc 0x06
			pc("Elemental field damage of type ##{type} inflicted to the field : #{value} ! (Offensive power : #{offensive_stat_value}, Move power : #{field_damage_power}, field vulnerability : #{vulnerability_factor})")
			cc 0x07
		end
		return value
	end
	
	def apply_fire_transition(apply,launcher_or_duration)
		return false if fire_elemental_damage_factor == 0 || !apply
		return change_battlefield(fire_elemental_transition,launcher_or_duration)
	end
	
	def apply_water_transition(apply,launcher_or_duration)
		return false if water_elemental_damage_factor == 0 || !apply
		return change_battlefield(water_elemental_transition,launcher_or_duration)
	end

	def apply_ice_transition(apply,launcher_or_duration)
		return false if ice_elemental_damage_factor == 0 || !apply
		return change_battlefield(ice_elemental_transition,launcher_or_duration)
	end

	def apply_poison_transition(apply,launcher_or_duration)
		return false if poison_elemental_damage_factor == 0 || !apply
		return change_battlefield(poison_elemental_transition,launcher_or_duration)
	end
	
	def check_cave_collapsing(power)
		if BattleEngine._AI? #ToDo : coded the AI for it understand the collapse consequences, including the type of its damage (damage must be added to the original damages inflicted by the move)
			return BattleEngine::_mp([:ai_cave_collapsing,battlefield_interior_type]) if @telluric_elemental_damage + power >= FIELD_MAX_DAMAGE
			return false
		else
			cc 0x06
			pc("Elemental telluric field damage increased from #{@telluric_elemental_damage} to #{@telluric_elemental_damage + power}")
			cc 0x07
			old_cave_damage_tier = @telluric_elemental_damage*4/FIELD_MAX_DAMAGE
			@telluric_elemental_damage += power
			new_cave_damage_tier = [@telluric_elemental_damage*4/FIELD_MAX_DAMAGE,4].min
			return false if old_cave_damage_tier == new_cave_damage_tier #No quotation
			if new_cave_damage_tier < 4
				push_field_effect_text(391 + new_cave_damage_tier) #Les parois de la cavité commencent à s’effriter… / Des fissures apparaissent sur le plafond de la cavité. / Le plafond de la cavité est sur le point de s’effondrer !
				return true
			else #Collapsing
				return apply_cave_collapse
			end
		end
	end
	
	def apply_cave_collapse
		push_field_effect_text(395) #Le plafond de la grotte s’écroule à cause de l’attaque !
		BattleEngine::_mp([:global_animation, battlefield_interior_type == 4 ? 508 : 507])
		@telluric_elemental_damage = 0 #Reset the gauge
		battlers = BattleEngine.get_battlers
		damage_type = battlefield_interior_type == 4 ? ICE : ROCK #No Water-type damage here
		battlers.each do |battler|
			next BattleEngine::_msgtp(986 - Db::CSV_BASE, 396, battler) if battler.battle_effect.has_protect_effect? || BattleEngine.has_wide_guard?(battler) || BattleEngine.has_mat_block?(battler) #Pokémon s’est protégé de l’éboulement !
			next BattleEngine::_msgtp(986 - Db::CSV_BASE, 397, battler) if battler.battle_effect.has_out_of_reach_effect? #Pokémon est hors de portée de l’éboulement !
			if BattleEngine::Abilities.has_abilities(battler, :magic_guard, :rock_head, :ram_breaker, :bulletproof, :solid_rock, :prism_armor)
				BattleEngine::_mp([:ability_display, battler])
				BattleEngine::_msgtp(986 - Db::CSV_BASE, 398, battler) #[Talent] a protégé Pokémon de l’éboulement !
				next
			end
			next BattleEngine::_msgtp(986 - Db::CSV_BASE, 399, battler) if BattleEngine.has_sacred_veil?(battler) #Le Voile Sacré a protégé Pokémon de l’éboulement !
			BattleEngine::_msgtp(986 - Db::CSV_BASE, 400, battler) unless BattleEngine.cave_collapse_damage(battler,damage_type) #Si aucun dégâts => Pokémon n’est pas affecté par l’éboulement ! 
		end
		return true
	end
	
end

# ---------- Legacy scripts from $env - : Instance the FieldEffects module for the battle scene, to make it independant from class Environnement and module Palkia ---------- #
# ---------- Heavy modded to include the 15 climates of Sacred Phoenix and give precedence to Palkia module ---------- #

module PFM
	# Environment management (Weather, Zone, etc...)
	# The global Environment object is stored in $env and $pokemon_party.env
	class Environnement
		include Rayquaza
		# Unkonw location text
		#UNKNOWN_ZONE = 'Zone ???'
		include GameData::SystemTags
		# The master zone (zone that show the pannel like city, unlike house of city)
		# @note Master zone are used inside Pokemon data
		# @return [Integer]
		attr_reader :master_zone
		# Last visited map ID
		# @return [Integer]
		attr_reader :last_map_id
		# Custom markers on worldmap
		# @return [Array]
		attr_reader :worldmap_custom_markers
		# Return the modified worldmap position or nil
		# @return [Array, nil]
		attr_reader :modified_worldmap_position
		attr_reader :battle_weather
		attr_reader :battle_weather_instance_1
		attr_reader :battle_weather_instance_2
		
		# Create a new Environnement object

		def initialize
			@weather = 0
			reset_battle_weather
			# Zone where the player currently is
			@zone = 0
			# Zone where the current zone is a child of
			@master_zone = 0
			@warp_zone = 0
			@last_map_id = 0
			@visited_zone = []
			@visited_worldmap = []
			@deleted_events = {}
			# Worldmap where the player currently is
			@worldmap = 0
			@worldmap_custom_markers = []
		end

		# Update the zone informations, return the ID of the zone when the player enter in an other zone
		#
		# Add the zone to the visited zone Array if the zone has not been visited yet
		# @return [Integer, false] false = player was in the zone
		def update_zone
			return false if @last_map_id == $game_map.map_id
			@last_map_id = map_id = $game_map.map_id
			Palkia.set_last_map_id(last_zone = @zone)
			load_zone_information(map_id) if Db::Map::MAPS.include?(map_id)
			return false if last_zone == @zone
			unless Palkia.same_area?(@zone) #Sort de "Flûte Noire"
				$game_switches[Sw::NaturePeace] = false 
				$game_map.battleback_name == "" #Reset de la variable
			end
			return @zone
		end

		# Load the zone information
		# @param data [GameData::Map] the current zone data
		# @param index [Integer] the index of the zone in the stack
		def load_zone_information(index)
			@zone = index
			# We store this zone as the zone where to warp if it's possible
			@warp_zone = index if Db::Map.fly_coord(index) # data.warp_x && data.warp_y
			# We store this zone as the master zone if there's a pannel
			master_zone = Palkia.set_master_zone(index) #index if data.panel_id&.>(0)
			# We memorize the fact we visited this zone
			@visited_zone << index unless @visited_zone.include?(index)
			# We memorize the fact we visited this worldmap
			@visited_worldmap << Palkia.get_worldmap unless @visited_worldmap.include?(Palkia.get_worldmap) # data.worldmap_id unless @visited_worldmap.include?(data.worldmap_id)
			# We store the zone worldmap
			@worldmap = Palkia.get_worldmap #data.worldmap_id
			# We store the new switch info
			$game_switches[Sw::Env_CanFly] = Palkia.can_fly?(index) #(!data.warp_disallowed && data.fly_allowed)
			$game_switches[Sw::Env_CanDig] = Palkia.can_dig?(index) #(!data.warp_disallowed && !data.fly_allowed)
			$game_switches[Sw::MapWithToneEnabled] = Palkia.tone_enabled?(index)
			reset_battle_weather unless Palkia.same_area?(@zone) #Change the map resets the persistant battle weather in overworld
			@forced_weather = nil if @master_zone != master_zone #Weather set manually, overwrite the natural weather (for scenario)
			@master_zone = master_zone
			@duration = 0 #Change the map reset the persistant Battle weather in overworld
			if Palkia.weather_map? || false #false : Météo scriptée dans l'intérieur - ToDo
				refresh_weather
			else
				clear_weather_in_overworld #To ensure no weather indoors (warning: the outside weather is forgotten! ToDo or set it in event-making)
			end
		end

		# Reset the zone informations to get the zone id with update_zone (Panel display)
		def reset_zone
			@last_map_id = -1
			@zone = -1
		end

		# Return the current zone in which the player is
		# @return [Integer] the zone ID in the database
		def current_zone
			return @zone
		end
		alias get_current_zone current_zone

		# Return the zone name in which the player is (master zone) #Moddé
		# @return [String]
		def current_zone_name
			return Palkia.map_name(@master_zone)
		end

		# Return the warp zone ID (where the player will teleport with skills)
		# @return [Integer] the ID of the zone in the database
		def warp_zone
			return @warp_zone
		end
		alias get_warp_zone warp_zone

		# Check if a zone has been visited
		# @param zone [Integer] the zone id in the database
		# @return [Boolean]
		def visited_zone?(zone)
			return @visited_zone.include?(zone) || @visited_zone.include?(Palkia.master_zone(zone))
		end

		# Get the worldmap from the zone
		# @param zone [Integer] <default : current zone>
		# @return [Integer]
		def get_worldmap(zone = @zone)
			if @modified_worldmap_position && @modified_worldmap_position[2]
				return @modified_worldmap_position[2]
			else
				return Db::Map.origin_worldmap(zone)
			end
		end

		# Test if the given world map has been visited
		# @param worldmap [Integer]
		# @return [Boolean]
		def visited_worldmap?(worldmap)
			return @visited_worldmap.include?(worldmap)
		end

		# [Array of Integers] Getter pour @visited_worldmap
		def visited_worldmap
			return @visited_worldmap
		end

		# Return the zone type
		# Utilisé par les tables de rencontre des Pokémons sauvages (dans 06504 Encounter rate evolved.rb)
		# @param ice_prio [Boolean] when on snow for background, return ice ID if player is on ice
		# @return [Integer] 1 = tall grass, 2 = taller grass, 3 = cave, 4 = mount, 5 = sand, 6 = pond, 7 = sea, 8 = underwater, 9 = snow, 10 = ice, 0 = building
		def get_zone_type(ice_prio = false)
			if Palkia.tall_grass?
				return 1
			elsif Palkia.very_tall_grass?
				return 2
			elsif Palkia.cave?
				return 3
			elsif Palkia.mount?
				return 4
			elsif Palkia.sand?
				return 5
			elsif Palkia.pond?
				return 6
			elsif Palkia.sea?
				return 7
			elsif Palkia.underwater?
				return 8
			elsif Palkia.snow?
				return ((ice_prio && Palkia.ice?) ? 10 : 9)
			elsif Palkia.ice?
				return 10
			else
				return 0
			end
		end

		# Convert a system_tag to a zone_type
		# @param system_tag [Integer] the system tag
		# @return [Integer] same as get_zone_type
		def convert_zone_type(system_tag)
			case system_tag
			when TGrass, TGrass2
				return 1
			when TTallGrass
				return 2
			when TCave
				return 3
			when TMount
				return 4
			when TSand, TSandUp, TSandRight, TSandDown, TSandLeft
				return 5
			when TPond
				return 6
			when TSea
				return 7
			when TUnderWater
				return 8
			when TSnow
				return 9
			when TIce
				return 10
			else
				return 0
			end
		end

		# Can the player fish ?
		# @return [Boolean]
		def can_fish?
			tag = $game_player.front_system_tag
			return (tag == TPond or tag == TSea)
		end

		# Set the delete state of an event
		# @param event_id [Integer] id of the event
		# @param map_id [Integer] id of the map where the event is
		# @param state [Boolean] new delete state of the event
		def set_event_delete_state(event_id, map_id = $game_map.map_id, state = true)
			deleted_events = @deleted_events = {} unless (deleted_events = @deleted_events)
			deleted_events[map_id] = {} unless deleted_events[map_id]
			deleted_events[map_id][event_id] = state
		end

		# Get the delete state of an event
		# @param event_id [Integer] id of the event
		# @param map_id [Integer] id of the map where the event is
		# @return [Boolean] if the event is deleted
		def get_event_delete_state(event_id, map_id = $game_map.map_id)
			return false unless (deleted_events = @deleted_events)
			return false unless deleted_events[map_id]
			return deleted_events[map_id][event_id]
		end

		# Add the custom marker to the worldmap
		# @param filename [String] the name of the icon in the interface/worldmap/icons directory
		# @param worldmap_id [Integer] the id of the worldmap
		# @param x [Integer] coord x on the worldmap
		# @param y [Integer] coord y on the wolrdmap
		# @param ox_mode [Symbol, :center] :center (the icon will be centered on the tile center), :base
		# @param oy_mode [Symbol, :center] :center (the icon will be centered on the tile center), :base
		def add_worldmap_custom_icon(filename, worldmap_id, x, y, ox_mode = :center, oy_mode = :center)
			@worldmap_custom_markers ||= []
			@worldmap_custom_markers[worldmap_id] ||= []
			@worldmap_custom_markers[worldmap_id].push [filename, x, y, ox_mode, oy_mode]
		end

		# Remove all custom worldmap icons on the coords
		# @param filename [String] the name of the icon in the interface/worldmap/icons directory
		# @param worldmap_id [Integer] the id of the worldmap
		# @param x [Integer] coord x on the worldmap
		# @param y [Integer] coord y on the wolrdmap
		def remove_worldmap_custom_icon(filename, worldmap_id, x, y)
			return unless @worldmap_custom_markers[worldmap_id]

			@worldmap_custom_markers[worldmap_id].delete_if { |i| i[0] == filename && i[1] == x && i[2] == y }
		end

		# Overwrite the zone worldmap position
		# @param new_x [Integer] the new x coords on the worldmap
		# @param new_y [Integer] the new y coords on the worldmap
		# @param new_worldmap_id [Integer, nil] the new worldmap id
		def set_worldmap_position(new_x, new_y, new_worldmap_id = nil)
			@modified_worldmap_position = [new_x, new_y, new_worldmap_id]
		end

		# Reset the modified worldmap position
		def reset_worldmap_position
			@modified_worldmap_position = nil
		end

		###----------------- System tags (appelés en alias sur le module Palkia pour la plupart) -----------------###
		# Tous les checks liés à une map ou des coordonnées précises ne sont que sur le module Palkia!

		# Is the player on a underwater tile?
		# @return [Boolean]
		def underwater?
			return $game_player.system_tag == TUnderWater
		end

		# Is the player on a sea tile?
		# @return [Boolean]
		def sea?
			return $game_player.system_tag == TSea
		end

		# Is the player on ice tile?
		# @return [Boolean]
		def ice?
			return $game_player.system_tag == TIce
		end

		# Is the player on snow tile?
		# @return [Boolean]
		def snow?
			return $game_player.system_tag == TSnow
		end

		# Is the player on a pond/river 
		# @return [Boolean]
		def pond? # Etang / Rivière etc...
			return $game_player.system_tag == TPond
		end

		# Is the player on sand tile?
		# @return [Boolean]
		def sand?
			return $game_player.system_tag == TSand || wet_sand?
		end

		# Is the player on mud tile?
		# @return [Boolean]
		def mud?
			return $game_player.system_tag == SwampBorder || $game_player.system_tag == DeepSwamp
		end

		# Is the player on wet_sand tile?
		# @return [Boolean]
		def wet_sand?
			return $game_player.system_tag == TWetSand
		end

		# Is the player on a mount tile?
		# @return [Boolean]
		def mount?
			return $game_player.system_tag == TMount
		end

		# Is the player in a cave tile?
		# @return [Boolean]
		def cave?
			return $game_player.system_tag == TCave
		end

		# Is the player standing in taller grass tile?
		# @return [Boolean]
		def very_tall_grass?
			return $game_player.system_tag == TTallGrass
		end

		# Is the player inside a building (and not on a systemtag)
		# @return [Boolean]
		def building?
			return Palkia.interior_map? && $game_player.system_tag == 0
		end

		# Is the player standing in neutral exterior tile ?
		# @return [Boolean]
		def grass?
			return Palkia.exterior_map? && $game_player.system_tag == 0
		end
		alias neutral_terrain? grass?
		
		# Is the player standing in tall grass tile?
		# @return [Boolean]
		def tall_grass?
			return $game_player.system_tag == TGrass || $game_player.system_tag == TGrass2
		end

		#If the player is on a dark place?
		#Used for sleep probability and Dark Ball
		def dark_place?
			cave? || (Dialga.night? && Dialga.apply_exterior_tones)
		end


		###----------------- Weathers -----------------###

		# Apply a new weather to the current environment
		# @param id [Integer] ID of the weather : 0 = None, 1 = Rain, 2 = Sun/Zenith, 3 = Darud Sandstorm, 4 = Hail, 5 = Foggy
		# Duration [Integer, false, nil] the total duration of summomed weather, 1 time unit = 1 minutes in game = 2 seconds in map (4 if dialogues, paused in menu), false to show no logs
		def apply_weather(id, duration = nil, forced = false)
			log_debug("apply_weather called for weather ##{id}, forced ? #{forced}") unless duration == false
			@weather = id #unless $game_temp.in_battle && !$game_switches[Sw::MixWeather]
			@forced_weather = id if forced #Overwrite the natural weather of this map (used for scenarisation reasons)
			if duration
				if duration == 0
					@duration = 0
				else
					@duration = duration + $game_variables[Var::MinutesElapsed]
				end
			end
			ajust_weather_switches
		end

		#Setter appelé depuis le module FieldEffects en fin de combat
		#Quasi alias de apply_weather, mais set sur une autre variable
		def set_battle_weather_in_overworld(battle_weather,instance_1,instance_2,duration)
			log_debug("set_battle_weather_in_overworld called with weather ##{battle_weather} and a duration of #{duration*3} minutes (#{duration} turn#{duration == 1 ? '' : 's'})")
			@battle_weather = battle_weather #unless $game_temp.in_battle && !$game_switches[Sw::MixWeather] - checked upstream
			@battle_weather_instance_1 = instance_1
			@battle_weather_instance_2 = instance_2
			@duration = duration*3 + $game_variables[Var::MinutesElapsed] #Persistance of 3 minutes (6 seconds in game) for each remaining turn
			$game_screen.weather(false, nil, 0, psdk_weather: @battle_weather, forced: false) #The first argument is a flag to no call apply_weather from $game_screen
			ajust_weather_switches
			$wild_battle.load_groups
		end

		# Ajust the weather switches to put the game in the correct state
		def ajust_weather_switches
			weather = current_weather
			return if weather == @old_weather
			WEATHER_SWITCHES_MATRIX[weather].each_index do |i|
				$game_switches[Sw::WT_Sunny+i] = WEATHER_SWITCHES_MATRIX[weather][i]
			end
			@old_weather = weather
		end

		# Return the current weather duration (0 in absence of artificial weather)
		def weather_duration
			return 0 if @duration <= $game_variables[Var::MinutesElapsed]
			return @duration - $game_variables[Var::MinutesElapsed]
		end
		alias get_weather_duration weather_duration


		# Decrease the weather duration, set it to normal (none = 0) if the duration is less than 0
		# @return [Boolean] true = the weather stopped
		# Called each minute from Dialga module
		def decrease_battle_weather_in_overworld #Moddé
			return false if @duration == 0
			if weather_duration == 0
				call_natural_weather
				$wild_battle.load_groups
				return true
			end
			return false
		end

		#Méthode à appeler pour clear la météo persistante de combat (ne fera rien s'il n'y en a pas)
		def clear_battle_weather
			return @battle_weather && call_natural_weather
		end

		#Getter pour la météo naturelle de la map (basée sur les modules Dialga et Db::Map)
		def call_natural_weather
			reset_battle_weather
			apply_weather(natural_weather,false)
			$game_screen.weather(nil, nil, 40, psdk_weather: natural_weather, forced: false)
			return true
		end

		def clear_weather_in_overworld
			reset_battle_weather
			return if @weather == CLEAR
			apply_weather(0)
			$game_screen.weather(0, 0, Palkia.weather_map? ? 40 : 0, forced: false)
			@weather = CLEAR
			return true
		end

		#Setter permettant de refresh automatiquement l'écran avec le climat réel
		def refresh_weather
			weather_quierred = current_weather
			#log_debug("refresh_weather called but rejected") if @weather == weather_quierred
			return if @weather == weather_quierred
			#log_debug("refresh_weather called")
			$game_screen.weather(nil, nil, 40, psdk_weather: weather_quierred, forced: false)
		end

		#Setter permettant de reset les 4 variables d'instance liées à la météo de combat persistance
		def reset_battle_weather
			@battle_weather = nil #Not used in battle - will be used to see the persistance (some seconds) of a weather in overworld changed from battle
			@battle_weather_instance_1 = nil
			@battle_weather_instance_2 = nil
			@duration = 0 #Used to set the duration of the persistance of a battle weather in map
		end

		# Return the natural weather id, including the battle weather that temporally extend in this map
		def current_weather
			return @battle_weather || natural_weather
		end

		# Return the current natural weather id
		def natural_weather
			return @forced_weather || Rayquaza.get_natural_weather #manual set weather || @weather
		end

		# Is it sunny?
		# @return [Boolean]
		def sunny?
			return current_weather == SUNNY || harsh_sun?
		end

		#Scorching sun
		def harsh_sun?
			return current_weather == HARSH_SUN
		end

		# Is it raining?
		# @return [Boolean]
		def rain?
			return current_weather == RAIN || current_weather == STORMY_RAIN || heavy_rain?
		end

		#Torrential rain
		def heavy_rain?
			return current_weather == HEAVY_RAIN
		end

		#Thunderstorm weather
		def storm?
			return current_weather == THUNDERSTORM || stormy_rain?
		end

		#Thunderstorm weather with rain
		def stormy_rain?
			return current_weather == STORMY_RAIN
		end

		# Is it sandstorm?
		# @return [Boolean]
		def sandstorm?
			return current_weather == SANDSTORM
		end

		#Snowing weather (not hail or blizzard)
		def snowing?
			return current_weather == SNOWING
		end

		# Does it hail ?
		# @return [Boolean]
		def hail?
			return current_weather == HAIL
		end

		#Blizzard weather (not Snowing or hail)
		def blizzard?
			return current_weather == BLIZZARD
		end

		def freezing_weather?
			return snowing? || hail? || blizzard?
		end

		# Is it misty ?
		# @return [Boolean]
		def misty?
			return current_weather == MISTY
		end

		# Is it foggy ?
		# @return [Boolean]
		def fog?
			return current_weather == FOG
		end

		# Is the weather normal
		# @return [Boolean]
		def normal?
			return current_weather == CLEAR
		end

		#Strong winds weather
		def strong_winds?
			return current_weather == STRONG_WINDS
		end
	end

	class Pokemon_Party
		# The environment informations
		# @return [PFM::Environnement]
		attr_accessor :env
		on_player_initialize(:env) { @env = PFM::Environnement.new }
		on_expand_global_variables(:env) do
			# Variable containing all the environment related information (current zone, weather...)
			$env = @env
		end
	end
end


class Game_Screen

	#Getter pour l'intensité météorologique
	def weather_power
		return 0 if @weather_max_target == 0 || @weather_max_target == nil
		return @weather_max_target/4-1
	end

	# starts a weather change process
	# @param type [Integer] the type of the weather. False = no set the weather on $env beacause it's already set (for no loop on infinite loop)
	# @param power [Numeric] The power of the weather
	# @param duration [Integer] the time it takes to change the weather
	# @param psdk_weather [Integer, Symbol, nil] the PSDK weather type
	def weather(type, power = nil, duration = 0, psdk_weather: nil, forced: true)
		#> Set weather to PSDK
		apply = type != false
		if psdk_weather 
			case psdk_weather
			when 1, :sunny, :sun
				power ||= 5
				if power > 7
					type = FieldEffects::HARSH_SUN
				else
					type = FieldEffects::SUNNY
				end
			when 2, :harsh_sun
				type = FieldEffects::HARSH_SUN
				power = 9 if !power || power < 8
			when 3, :rain, :rainy
				power ||= 5
				if power > 7
					type = FieldEffects::HEAVY_RAIN
				else
					type = FieldEffects::RAIN
				end
			when 4, :heavy_rain
				type = FieldEffects::HEAVY_RAIN
				power = 9 if !power || power < 8
			when 5, :thunderstorm, :storm
				power ||= 5
				if power > 5
					type = FieldEffects::STORMY_RAIN
					power = power*2-9 #3 to 9 in Power
				else
					type = FieldEffects::THUNDERSTORM
					power = power*2-1 #Ruse pour faire varier la fréquence des éclairs (5 crans)
				end
			when 6, :stormy_rain
				power ||= 8
				type = FieldEffects::STORMY_RAIN
				power += 4 if power < 6
			when 7, :sandstorm
				power ||= 5
				type = FieldEffects::SANDSTORM
			when 8, :misty, :mist
				power ||= 4
				if power < 6
					type = FieldEffects::MISTY
				else
					type = FieldEffects::FOG
				end
			when 9, :fog
				power ||= 8
				type = FieldEffects::FOG
				power += 4 if power < 6
			when 10, :snowing, :snow
				power ||= 3
				if power < 6
					type = FieldEffects::SNOWING
				elsif power < 8
					type = FieldEffects::HAIL
				else
					type = FieldEffects::BLIZZARD
				end
			when 11, :hail, :freezing_rain
				power ||= 6
				if power < 8
					type = FieldEffects::HAIL
					power = 6 if power < 6
				else
					type = FieldEffects::BLIZZARD
				end
			when 12, :blizzard
				type = FieldEffects::BLIZZARD
				power = 9 if !power || power < 8
			when 14, :strong_winds, :windy, :celestial_winds
				power ||= 5
				type = FieldEffects::STRONG_WINDS
			else
				type = 0
				power = 0
				$env.apply_weather(0,0,forced)
				apply = false
			end
			$env.apply_weather(type,nil,forced) if apply
		else #from RPG Maker XP command
			case type
			when 1 #Rain
				if power > 7
					type = FieldEffects::HEAVY_RAIN
				else
					type = FieldEffects::RAIN
				end
			when 2 #Storm - Débridage partiel de PSDK
				if power > 5
					type = FieldEffects::STORMY_RAIN
					power = power*2-9 #3 to 9 in Power
				else
					type = FieldEffects::THUNDERSTORM
					power = power*2-1 #Ruse pour faire varier la fréquence des éclairs (5 crans)
				end
			when 3 # Snow
				if power < 6
					type = FieldEffects::SNOWING
				elsif power < 8
					type = FieldEffects::HAIL
				else
					type = FieldEffects::BLIZZARD
				end
			else
				$env.apply_weather(0,0,forced)
				type = 0
				power = 0
				apply = false
			end
			$env.apply_weather(type,nil,forced) if apply
		end

		#> Define Weather
		@weather_type_target = type
		if @weather_type_target != 0
			@weather_type = @weather_type_target
		end
		if @weather_type_target == 0
			@weather_max_target = 0.0
		else
			@weather_max_target = (power + 1) * 4.0
		end
		@weather_duration = duration
		if @weather_duration == 0
			@weather_type = @weather_type_target
			@weather_max = @weather_max_target
		end
	end
end

module RPG
	# Class that display weather
	class Weather
		# Array containing all the texture initializer in the order of the type
		remove_const :INIT_TEXTURE
		INIT_TEXTURE = %i[none init_zenith init_zenith init_rain init_rain none init_rain init_sand_storm init_fog init_fog init_snow init_snow init_snow none none]
		# Array containing all the weather update methods in the order of the type
		remove_const :UPDATE_METHODS
		UPDATE_METHODS = %i[none update_zenith update_harsh_zenith update_rain update_rain update_storm update_rain_storm update_sandstorm update_fog update_fog update_snow update_snow update_snow none none]

		# Change the Weather type
		# @param type [Integer]
		def type=(type)
			@last_type = @type
			return if @type == type
			puts "Weather type demandé : #{type} pour l'ancient type @last_type : #{@last_type} et la variable @type : #{@type}"
			@type = type
			@special_type = type #Flag for a special animation of rain, sandstorm and fog
			# Init the bitmap
			send(symbol = INIT_TEXTURE[type])
			log_debug("init_texture called : #{symbol}")
			# Call the set type proc
			send(symbol = SET_TYPE_METHODS[type])
			log_debug("set_type called : #{symbol}")
			#if [FieldEffects::SUNNY,FieldEffects::HARSH_SUN].include?(@last_type) && !$game_switches[Sw::TJN_Enabled] #SET_TYPE_PSDK_MANAGED[2] && 
			#	$game_screen.start_tone_change(Yuki::TJN::TONE[3], 40)
			#end
		ensure
			if @last_type != @type
				@sprites.first.set_origin(@ox, @oy) unless @type == FieldEffects::MISTY || @type == FieldEffects::FOG # @type != 5 && SET_TYPE_PSDK_MANAGED[5] #Fog
				Yuki::TJN.force_update_tone(0)  unless @type == FieldEffects::SUNNY || @type == FieldEffects::HARSH_SUN # if @type != 2 && SET_TYPE_PSDK_MANAGED[2] #Sun
			end
		end

		def none
			return nil
		end
		
		# Update the sunny weather
		def update_zenith
			sprite = @sprites.first
			sprite.counter += 1
			sprite.counter = 0 if sprite.counter > 320
			current_tone = Dialga.current_tone_arr #Fix un conflit avec les tons de la journée
			$game_screen.tone.red = current_tone[0] + Integer(10 * Math.sin(Math::PI * sprite.counter / 80))
			$game_screen.tone.green = current_tone[1] + Integer(5 * Math.sin(Math::PI * sprite.counter / 80))
		end

		# Update the harsh sun weather
		def update_harsh_zenith
			sprite = @sprites.first
			sprite.counter += 1
			sprite.counter = 0 if sprite.counter > 320
			current_tone = Dialga.current_tone_arr #Fix un conflit avec les tons de la journée
			$game_screen.tone.red = current_tone[0] + Integer(20 * Math.sin(Math::PI * sprite.counter / 80))
			$game_screen.tone.green = current_tone[1] + Integer(10 * Math.sin(Math::PI * sprite.counter / 80))
		end

		def update_rain_storm
			update_rain
			update_storm
		end
	
		def update_storm
			@storm_effect_timer ||= $game_variables[Var::TotalTicks] + rand(512)
			@lighting_effect_timer ||= $game_variables[Var::TotalTicks] + rand(512)
			if @storm_effect_timer < $game_variables[Var::TotalTicks]
				power = $game_screen.weather_power/2 #0 to 4
				Audio.se_play("Audio/SE/Thunderclap_#{rand(5)+1}.ogg",20+power*5+rand(64),72+rand(64))
				@storm_effect_timer = $game_variables[Var::TotalTicks] + 64 + rand(1408-power*256)
			end
			if @lighting_effect_timer < $game_variables[Var::TotalTicks]
				power ||= $game_screen.weather_power/2 #0 to 4
				$game_system.map_interpreter.flash_screen(255,255,153,alpha: 128+rand(128),frames: 8+rand(16))
				@lighting_effect_timer = $game_variables[Var::TotalTicks] + 64 + rand(1408-power*256)
			end
		end
	
		#(Tentative de) restauration de l'animation d'orage issue \pokemonsdk\scripts\00001 RMXP_DATA.rb
		def init_storm
			@storm_bitmap = Bitmap.new(34, 64)
			for i in 0..31
				@storm_bitmap.fill_rect(33-i, i*2, 1, 2, color2)
				@storm_bitmap.fill_rect(32-i, i*2, 1, 2, color1)
				@storm_bitmap.fill_rect(31-i, i*2, 1, 2, color2)
			end
			@storm_bitmap.update
		end

		# Called when type= is called with sunny id
		def set_type_sunny
			#$game_screen.start_tone_change(SunnyTone, @last_type == @type ? 1 : 40) #SunnyTone est bugué, regarder ce que ça fait...
			set_type_reset_sprite(nil)
		end

		# Called when type= is called with snow id
		def set_type_storm
			set_type_reset_sprite(@storm_bitmap)
		end

		# Called when type= is called with snow id
		def set_type_stormy_rain
			set_type_storm
			set_type_rain
		end

		# Set the weather type as rain (special animation)
		def set_type_rain
			@type = @special_type #1 => Fix
			bitmap = @rain_bitmap
			@sprites.each_with_index do |sprite, i|
				sprite.visible = (i <= @max)
				sprite.bitmap = bitmap
				sprite.src_rect.set(0, 0, 16, 32)
				sprite.counter = 0
			end
		end

		# Set the weather type as sandstorm (different bitmaps)
		def set_type_sandstorm
			@type = @special_type #3 => Fix
			big = @sand_storm_bitmaps.first
			sm = @sand_storm_bitmaps.last
			49.times do |i|
				next unless (sprite = @sprites[i])
				sprite.visible = true
				sprite.bitmap = big
				sprite.opacity = (7 - (i % 7)) * 128 / 7
				sprite.x = 64 * (i % 7) - 64 + @ox
				sprite.y = 64 * (i / 7) - 80 + @oy
			end
			49.upto(MAX_SPRITE - 1) do |i|
				next unless (sprite = @sprites[i])
				sprite.bitmap = sm
				sprite.x = -999 + @ox
			end
		end
		# Set the weather type as fog
		def set_type_fog
			@type = @special_type #5 => Fix
			sprite = @sprites.first
			sprite.bitmap = @fog_bitmap
			sprite.set_origin(0, 0)
			sprite.set_position(0, 0)
			sprite.src_rect.set(0, 0, 320, 240)
			sprite.opacity = 0
			1.upto(MAX_SPRITE - 1) do |i|
				next unless (sprite = @sprites[i])
				sprite.bitmap = nil
			end
		end


		class << self
			# Register a new type= method call
			# @param type [Integer] the type of weather
			# @param symbol [Symbol] if the name of the method to call
			# @param psdk_managed [Boolean] if it's managed by PSDK (some specific code in the type= method)
			def register_set_type(type, symbol, psdk_managed)
				SET_TYPE_METHODS[type] = symbol
				SET_TYPE_PSDK_MANAGED[type] = psdk_managed
			end
		end

		register_set_type(0, :set_type_none, true)
		register_set_type(1, :set_type_sunny, true)
		register_set_type(2, :set_type_sunny, true)
		register_set_type(3, :set_type_rain, true)
		register_set_type(4, :set_type_rain, true)
		register_set_type(5, :set_type_storm, true)
		register_set_type(6, :set_type_stormy_rain, true)
		register_set_type(7, :set_type_sandstorm, true)
		register_set_type(8, :set_type_fog, true)
		register_set_type(9, :set_type_fog, true)
		register_set_type(10, :set_type_snow, true)
		register_set_type(11, :set_type_snow, true)
		register_set_type(12, :set_type_snow, true)
		register_set_type(13, :set_type_none, true)
		register_set_type(14, :set_type_none, true)
	end
end
