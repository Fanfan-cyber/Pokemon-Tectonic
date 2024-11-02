=begin

INNATE_SET = {
  :DEFAULT       => [   [:PUREHEART,         :FORTIFICATION,   :SUPERLUCK,       ],   [      ],   ],

  :BULBASAUR     => [   [:OVERGROW,          :THICKFAT,        :POISONENGULF,    ],   [      ],   ], # 妙蛙种子
  :IVYSAUR       => [   [:OVERGROW,          :THICKFAT,        :POISONENGULF,    ],   [      ],   ],
  :VENUSAUR      => [   [:OVERGROW,          :THICKFAT,        :POISONENGULF,    ],   [      ],   ],
  :VENUSAUR_1    => [   [:FORESTRAGE,        :THICKFAT,        :POISONENGULF,    ],   [      ],   ],

  :CHARMANDER    => [   [:BLAZE,             :FIREIZE,         :SOLARPOWER,      ],   [      ],   ], # 小火龙
  :CHARMELEON    => [   [:BLAZE,             :FIREIZE,         :SOLARPOWER,      ],   [      ],   ],
  :CHARIZARD     => [   [:BLAZE,             :LEVITATE,        :SUNWORSHIP,      ],   [      ],   ],
  :CHARIZARD_1   => [   [:HELLBLAZE,         :LEVITATE,        :DISCIPLINE,      ],   [      ],   ],
  :CHARIZARD_2   => [   [:HELLBLAZE,         :LEVITATE,        :SOLARPOWER,      ],   [      ],   ],

  :SQUIRTLE      => [   [:TORRENT,           :SHELLARMOR,      :WATERVEIL,       ],   [      ],   ], # 杰尼龟
  :WARTORTLE     => [   [:TORRENT,           :SHELLARMOR,      :WATERVEIL,       ],   [      ],   ],
  :BLASTOISE     => [   [:TORRENT,           :SHELLARMOR,      :MEGALAUNCHER,    ],   [      ],   ],
  :BLASTOISE_1   => [   [:RIPTIDE,           :SHELLARMOR,      :MEGALAUNCHER,    ],   [      ],   ],

  :CATERPIE      => [   [:SWARM,             :SHIELDDUST,      :GLUTTONY,        ],   [      ],   ], # 绿毛虫
  :METAPOD       => [   [:SWARM,             :SHIELDDUST,      :OVERCOAT,        ],   [      ],   ],
  :BUTTERFREE    => [   [:MAJESTICMOTH,      :COMPOUNDEYES,    :LEVITATE,        ],   [      ],   ],

  :WEEDLE        => [   [:SWARM,             :SHIELDDUST,      :GLUTTONY,        ],   [      ],   ], #  独角虫
  :KAKUNA        => [   [:SWARM,             :SHIELDDUST,      :OVERCOAT,        ],   [      ],   ],
  :BEEDRILL      => [   [:HYPERAGGRESSIVE,   :MERCILESS,       :LEVITATE,        ],   [      ],   ],
  :BEEDRILL_1    => [   [:HYPERAGGRESSIVE,   :MERCILESS,       :LEVITATE,        ],   [      ],   ],

  :PIDGEY        => [   [:FLIGHT,            :KEENEYE,         :EARLYBIRD,       ],   [      ],   ], # 波波
  :PIDGEOTTO     => [   [:FLIGHT,            :KEENEYE,         :EARLYBIRD,       ],   [      ],   ],
  :PIDGEOT       => [   [:FLIGHT,            :KEENEYE,         :GIANTWINGS,      ],   [      ],   ],
  :PIDGEOT_1     => [   [:FLIGHT,            :MAJESTICBIRD,    :GIANTWINGS,      ],   [      ],   ],

  :RATTATA       => [   [:GUTS,              :RUNAWAY,         :GLUTTONY,        ],   [      ],   ], # 小拉达
  :RATTATA_1     => [   [:THICKFAT,          :RUNAWAY,         :GLUTTONY,        ],   [      ],   ],
  :RATICATE      => [   [:GUTS,              :QUICKFEET,       :GROWINGTOOTH,    ],   [      ],   ],
  :RATICATE_1    => [   [:THICKFAT,          :GLUTTONY,        :GROWINGTOOTH,    ],   [      ],   ],

  :SPEAROW       => [   [:AMBUSH,            :SNIPER,          :ACCELERATE,      ],   [      ],   ], # 烈雀
  :FEAROW        => [   [:AMBUSH,            :INTIMIDATE,      :ACCELERATE,      ],   [      ],   ],

  :EKANS         => [   [:SOLENOGLYPHS,      :SHEDSKIN,        :COILUP,          ],   [      ],   ], # 阿柏蛇
  :ARBOK         => [   [:SOLENOGLYPHS,      :SHEDSKIN,        :COILUP,          ],   [      ],   ],

  :PICHU         => [   [:SHORTCIRCUIT,      :PLUS,            :GROUNDSHOCK,     ],   [      ],   ], # 皮丘
  :PIKACHU       => [   [:SHORTCIRCUIT,      :STATIC,          :GROUNDSHOCK,     ],   [      ],   ],
  :RAICHU        => [   [:SHORTCIRCUIT,      :STATIC,          :GROUNDSHOCK,     ],   [      ],   ],
  :RAICHU_1      => [   [:SURGESURFER,       :LEVITATE,        :GROUNDSHOCK,     ],   [      ],   ],

  :SANDSHREW     => [   [:DEFENCEROLL,       :SANDRUSH,        :BATTLEARMOR,     ],   [      ],   ], # 穿山鼠
  :SANDSHREW_1   => [   [:DEFENCEROLL,       :SLUSHRUSH,       :BATTLEARMOR,     ],   [      ],   ],
  :SANDSLASH     => [   [:DEFENCEROLL,       :LOOSEQUILLS,     :TOUGHCLAWS,      ],   [      ],   ],
  :SANDSLASH_1   => [   [:DEFENCEROLL,       :TOUGHCLAWS,      :IRONBARBS,       ],   [      ],   ],

  :NIDORANfE     => [   [:POISONPOINT,       :THICKFAT,        :QUEENLYMAJESTY,  ],   [      ],   ], # 尼多兰
  :NIDORINA      => [   [:POISONPOINT,       :THICKFAT,        :QUEENLYMAJESTY,  ],   [      ],   ],
  :NIDOQUEEN     => [   [:POISONPOINT,       :THICKFAT,        :QUEENLYMAJESTY,  ],   [      ],   ],

  :NIDORANmA     => [   [:RIVALRY,           :POISONPOINT,     :INTOXICATE,      ],   [      ],   ], # 尼多朗
  :NIDORINO      => [   [:RIVALRY,           :POISONPOINT,     :INTOXICATE,      ],   [      ],   ],
  :NIDOKING      => [   [:RIVALRY,           :POISONPOINT,     :INTOXICATE,      ],   [      ],   ],

  :CLEFFA        => [   [:CUTECHARM,         :HEALER,          :NATURALCURE,     ],   [      ],   ], # 皮宝宝
  :CLEFAIRY      => [   [:CUTECHARM,         :FLUFFY,          :NATURALCURE,     ],   [      ],   ],
  :CLEFABLE      => [   [:CUTECHARM,         :FLUFFY,          :NATURALCURE,     ],   [      ],   ],

  :VULPIX        => [   [:QUICKFEET,         :FIREIZE,         :SUNVEIL,         ],   [      ],   ], # 六尾
  :VULPIX_1      => [   [:QUICKFEET,         :REFRIGERATE,     :AURORA,          ],   [      ],   ],
  :NINETALES     => [   [:PYROMANCY,         :FLASHFIRE,       :QUEENLYMAJESTY,  ],   [      ],   ],
  :NINETALES_1   => [   [:SERENEGRACE,       :ICEDEW,          :QUEENLYMAJESTY,  ],   [      ],   ],

  :IGGLYBUFF     => [   [:CUTECHARM,         :INFLATABLE,      :DEFENCEROLL,     ],   [      ],   ], # 宝宝丁
  :JIGGLYPUFF    => [   [:CUTECHARM,         :INFLATABLE,      :DEFENCEROLL,     ],   [      ],   ],
  :WIGGLYTUFF    => [   [:CUTECHARM,         :INFLATABLE,      :FURCOAT,         ],   [      ],   ],

  :ZUBAT         => [   [:SNIPER,            :NOCTURNAL,       :MOUNTAINEER,     ],   [      ],   ], # 超音蝠
  :GOLBAT        => [   [:INFILTRATOR,       :SNIPER,          :NOCTURNAL,       ],   [      ],   ],
  :CROBAT        => [   [:INFILTRATOR,       :DISHEARTEN,      :NOCTURNAL,       ],   [      ],   ],

  :ODDISH        => [   [:REGENERATOR,       :GRASSPELT,       :NATURALCURE,     ],   [      ],   ], # 走路草
  :GLOOM         => [   [:REGENERATOR,       :GRASSPELT,       :NATURALCURE,     ],   [      ],   ],
  :VILEPLUME     => [   [:REGENERATOR,       :GRASSPELT,       :NATURALCURE,     ],   [      ],   ],
  :BELLOSSOM     => [   [:PIXILATE,          :HEALER,          :TRIAGE,          ],   [      ],   ],

  :PARAS         => [   [:EFFECTSPORE,       :DRYSKIN,         :MAGICALDUST,     ],   [      ],   ], # 派拉斯
  :PARASECT      => [   [:EFFECTSPORE,       :PHANTOM,         :OPPORTUNIST2,    ],   [      ],   ],

  :VENONAT       => [   [:COMPOUNDEYES,      :NOCTURNAL,       :GLUTTONY,        ],   [      ],   ], # 毛球
  :VENOMOTH      => [   [:COMPOUNDEYES,      :MAJESTICMOTH,    :LEVITATE,        ],   [      ],   ],

  :DIGLETT       => [   [:SANDRUSH,          :RUNAWAY,         :GLUTTONY,        ],   [      ],   ], # 地鼠
  :DIGLETT_1     => [   [:TANGLINGHAIR,      :SANDRUSH,        :GLUTTONY,        ],   [      ],   ],
  :DUGTRIO       => [   [:MULTIHEADED,       :SANDFORCE,       :SPEEDFORCE,      ],   [      ],   ],
  :DUGTRIO_1     => [   [:MULTIHEADED,       :SANDFORCE,       :SPEEDFORCE,      ],   [      ],   ],

  :MEOWTH        => [   [:PERFECTIONIST,     :TECHNICIAN,      :OPPORTUNIST2,    ],   [      ],   ], # 喵喵
  :MEOWTH_1      => [   [:PERFECTIONIST,     :TECHNICIAN,      :OPPORTUNIST2,    ],   [      ],   ],
  :MEOWTH_2      => [   [:TOUGHCLAWS,        :OPPORTUNIST2,    :PERFECTIONIST,   ],   [      ],   ],
  :PERSIAN       => [   [:PERFECTIONIST,     :TECHNICIAN,      :OPPORTUNIST2,    ],   [      ],   ],
  :PERSIAN_1     => [   [:PERFECTIONIST,     :COWARD,          :FURCOAT,         ],   [      ],   ],
  :PERRSERKER    => [   [:BATTLEARMOR,       :TOUGHCLAWS,      :STEELYSPIRIT,    ],   [      ],   ],

  :PSYDUCK       => [   [:WEATHERCONTROL,    :PSYCHICMIND,     :DAMP,            ],   [      ],   ], # 可达鸭
  :GOLDUCK       => [   [:WEATHERCONTROL,    :PSYCHICMIND,     :SWIFTSWIM,       ],   [      ],   ],

  :MANKEY        => [   [:IRONFIST,          :INFILTRATOR,     :HYPERAGGRESSIVE, ],   [      ],   ], # 猴怪
  :PRIMEAPE      => [   [:IRONFIST,          :INFILTRATOR,     :HYPERAGGRESSIVE, ],   [      ],   ],
  :ANNIHILAPE    => [   [:HYPERAGGRESSIVE,   :VITALSPIRIT,     :VENGEFULSPIRIT,  ],   [      ],   ],

  :GROWLITHE     => [   [:FURCOAT,           :FLASHFIRE,       :GUARDDOG,        ],   [      ],   ], # 卡蒂狗
  :GROWLITHE_1   => [   [:RECKLESS,          :PREDATOR,        :VIOLENTRUSH,     ],   [      ],   ],
  :ARCANINE      => [   [:GUARDDOG,          :FLASHFIRE,       :PREDATOR,        ],   [      ],   ],
  :ARCANINE_1    => [   [:RECKLESS,          :VIOLENTRUSH,     :PREDATOR,        ],   [      ],   ],

  :POLIWAG       => [   [:HYPNOTIST,         :SWIFTSWIM,       :HYDRATION,       ],   [      ],   ], # 蚊香蝌蚪
  :POLIWHIRL     => [   [:HYPNOTIST,         :HYDRATE,         :WATERABSORB,     ],   [      ],   ],
  :POLIWRATH     => [   [:HYPNOTIST,         :IRONFIST,        :WATERABSORB,     ],   [      ],   ],
  :POLITOED      => [   [:DAMP,              :HYDRATION,       :DRIZZLE,         ],   [      ],   ],

  :ABRA          => [   [:PSYCHICMIND,       :HYPNOTIST,       :MAGICGUARD,      ],   [      ],   ], # 凯西
  :KADABRA       => [   [:PSYCHICMIND,       :INNERFOCUS,      :MAGICGUARD,      ],   [      ],   ],
  :ALAKAZAM      => [   [:PSYCHICMIND,       :INNERFOCUS,      :MAGICGUARD,      ],   [      ],   ],
  :ALAKAZAM_1    => [   [:PSYCHICMIND,       :PSYCHICSURGE,    :MAGICGUARD,      ],   [      ],   ],

  :MACHOP        => [   [:NOGUARD,           :STEADFAST,       :GUTS,            ],   [      ],   ], # 腕力
  :MACHOKE       => [   [:NOGUARD,           :STEADFAST,       :GUTS,            ],   [      ],   ],
  :MACHAMP       => [   [:NOGUARD,           :IRONFIST,        :GUTS,            ],   [      ],   ],

  :BELLSPROUT    => [   [:CHLOROPHYLL,       :GLUTTONY,        :CORROSION,       ],   [      ],   ], # 喇叭芽
  :WEEPINBELL    => [   [:CHLOROPHYLL,       :GLUTTONY,        :CORROSION,       ],   [      ],   ],
  :VICTREEBEL    => [   [:BIGLEAVES,         :PREDATOR,        :CORROSION,       ],   [      ],   ],

  :TENTACOOL     => [   [:CLEARBODY,         :POISONTOUCH,     :WATERABSORB,     ],   [      ],   ], # 玛瑙水母
  :TENTACRUEL    => [   [:CLEARBODY,         :WATERABSORB,     :MERCILESS,       ],   [      ],   ],

  :GEODUDE       => [   [:DEFENCEROLL,       :STURDY,          :SOLIDROCK,       ],   [      ],   ], # 小拳石
  :GEODUDE_1     => [   [:DEFENCEROLL,       :STURDY,          :GALVANIZE,       ],   [      ],   ],
  :GRAVELER      => [   [:DEFENCEROLL,       :STURDY,          :SOLIDROCK,       ],   [      ],   ],
  :GRAVELER_1    => [   [:DEFENCEROLL,       :STURDY,          :GALVANIZE,       ],   [      ],   ],
  :GOLEM         => [   [:DEFENCEROLL,       :STURDY,          :MINERALIZE,      ],   [      ],   ],
  :GOLEM_1       => [   [:DEFENCEROLL,       :STURDY,          :GALVANIZE,       ],   [      ],   ],

  :PONYTA        => [   [:SPEEDFORCE,        :FLASHFIRE,       :FLAMEBODY,       ],   [      ],   ], # 小火马
  :PONYTA_1      => [   [:QUICKFEET,         :PSYCHICMIND,     :NATURALCURE,     ],   [      ],   ],
  :RAPIDASH      => [   [:FIREIZE,           :SPEEDFORCE,      :FLAMEBODY,       ],   [      ],   ],
  :RAPIDASH_1    => [   [:PIXILATE,          :STRIKER,         :MIGHTYHORN,      ],   [      ],   ],

  :SLOWPOKE      => [   [:OBLIVIOUS,         :OWNTEMPO,        :GLUTTONY,        ],   [      ],   ], # 呆呆兽
  :SLOWPOKE_1    => [   [:OBLIVIOUS,         :PRESSURE,        :CURIOUSMEDICINE, ],   [      ],   ],
  :SLOWBRO       => [   [:OBLIVIOUS,         :OWNTEMPO,        :SHELLARMOR,      ],   [      ],   ],
  :SLOWBRO_1     => [   [:OBLIVIOUS,         :MEGALAUNCHER,    :UNAWARE,         ],   [      ],   ],
  :SLOWBRO_2     => [   [:REGENERATOR,       :FORTKNOX,        :SHELLARMOR,      ],   [      ],   ],
  :SLOWKING      => [   [:OBLIVIOUS,         :OWNTEMPO,        :SHELLARMOR,      ],   [      ],   ],
  :SLOWKING_1    => [   [:SPITEFUL,          :PRESSURE,        :PERMANENCE,      ],   [      ],   ],

  :MAGNEMITE     => [   [:GALVANIZE,         :STURDY,          :MAGNETPULL,      ],   [      ],   ], # 小磁怪
  :MAGNETON      => [   [:GALVANIZE,         :MULTIHEADED,     :MAGNETPULL,      ],   [      ],   ],
  :MAGNEZONE     => [   [:GALVANIZE,         :MULTIHEADED,     :MAGNETPULL,      ],   [      ],   ],

  :FARFETCHD     => [   [:HYPERCUTTER,       :FIELDEXPLORER,   :KEENEYE,         ],   [      ],   ], # 大葱鸭
  :FARFETCHD_1   => [   [:SCRAPPY,           :SNIPER,          :KEENEYE,         ],   [      ],   ],
  :SIRFETCHD     => [   [:SCRAPPY,           :SHARPNESS,       :RAMPAGE,         ],   [      ],   ],

  :DODUO         => [   [:MULTIHEADED,       :GROUNDED,        :MOXIE,           ],   [      ],   ], # 嘟嘟
  :DODRIO        => [   [:MULTIHEADED,       :GROUNDED,        :MOXIE,           ],   [      ],   ],

  :SEEL          => [   [:THICKFAT,          :FURCOAT,         :ICEBODY,         ],   [      ],   ], # 小海狮
  :DEWGONG       => [   [:THICKFAT,          :WATERVEIL,       :AURORA,          ],   [      ],   ],

  :GRIMER        => [   [:LIQUIFIED,          :STENCH,         :STICKYHOLD,      ],   [      ],   ], # 臭泥
  :GRIMER_1      => [   [:POISONTOUCH,       :LIQUIFIED,       :GLUTTONY,        ],   [      ],   ],
  :MUK           => [   [:LIQUIFIED,         :CORROSION,       :STICKYHOLD,      ],   [      ],   ],
  :MUK_1         => [   [:POISONTOUCH,       :LIQUIFIED,       :CORROSION,       ],   [      ],   ],

  :SHELLDER      => [   [:SHELLARMOR,        :SKILLLINK,       :STURDY,          ],   [      ],   ], # 大舌贝
  :CLOYSTER      => [   [:SHELLARMOR,        :SKILLLINK,       :STURDY,          ],   [      ],   ],

  :GASTLY        => [   [:LEVITATE,          :CURSEDBODY,      :HAUNTEDSPIRIT,   ],   [      ],   ], # 鬼斯
  :HAUNTER       => [   [:LEVITATE,          :CURSEDBODY,      :HAUNTEDSPIRIT,   ],   [      ],   ],
  :GENGAR        => [   [:LEVITATE,          :CURSEDBODY,      :HAUNTEDSPIRIT,   ],   [      ],   ],
  :GENGAR_1      => [   [:VENGEANCE,         :SOULEATER,       :HAUNTEDSPIRIT,   ],   [      ],   ],

  :ONIX          => [   [:STURDY,            :ROUGHSKIN,       :SOLIDROCK,       ],   [      ],   ], # 大岩蛇
  :STEELIX       => [   [:LEADCOAT,          :TECTONIZE,       :STRONGJAW,       ],   [      ],   ],
  :STEELIX_1     => [   [:LEADCOAT,          :IMPENETRABLE,    :STRONGJAW,       ],   [      ],   ],

  :DROWZEE       => [   [:HYPNOTIST,         :DREAMCATCHER,    :INSOMNIA,        ],   [      ],   ], # 催眠貘
  :HYPNO         => [   [:HYPNOTIST,         :DREAMCATCHER,    :INSOMNIA,        ],   [      ],   ],

  :KRABBY        => [   [:SHELLARMOR,        :HYPERCUTTER,     :GRIPPINCER,      ],   [      ],   ], # 大钳蟹
  :KINGLER       => [   [:SHELLARMOR,        :HYPERCUTTER,     :GRIPPINCER,      ],   [      ],   ],

  :VOLTORB       => [   [:SPEEDFORCE,        :SHORTCIRCUIT,    :MOMENTUM,        ],   [      ],   ],
  :VOLTORB_1     => [   [:IMPENETRABLE,      :AFTERMATH,       :GRASSYSURGE,     ],   [      ],   ],
  :ELECTRODE     => [   [:AFTERMATH,         :ELECTRICSURGE,   :SOUNDPROOF,      ],   [      ],   ],
  :ELECTRODE_1   => [   [:IMPENETRABLE,      :AFTERMATH,       :GRASSYSURGE,     ],   [      ],   ],

  :EXEGGCUTE     => [   [:SOLARPOWER,        :CHLOROPHYLL,     :TELEPATHY,       ],   [      ],   ], # 蛋蛋
  :EXEGGUTOR     => [   [:HARVEST,           :MULTIHEADED,     :CHLOROPLAST,     ],   [      ],   ],
  :EXEGGUTOR_1   => [   [:LONGREACH,         :MULTIHEADED,     :BIGLEAVES,       ],   [      ],   ],

  :CUBONE        => [   [:BONEZONE,          :BATTLEARMOR,     :ROCKHEAD,        ],   [      ],   ], # 卡拉卡拉
  :MAROWAK       => [   [:BONEZONE,          :BATTLEARMOR,     :ROCKHEAD,        ],   [      ],   ],
  :MAROWAK_1     => [   [:BONEZONE,          :EARLYGRAVE,      :ROCKHEAD,        ],   [      ],   ],

  :TYROGUE       => [   [:GUTS,              :VITALSPIRIT,     :SUPERLUCK,       ],   [      ],   ], # 无畏小子
  :HITMONTOP     => [   [:TECHNICIAN,        :INTIMIDATE,      :SCRAPPY,         ],   [      ],   ],
  :HITMONLEE     => [   [:LIMBER,            :RECKLESS,        :STRIKER,         ],   [      ],   ],
  :HITMONCHAN    => [   [:INNERFOCUS,        :FATALPRECISION,  :PERFECTIONIST,   ],   [      ],   ],

  :LICKITUNG     => [   [:GLUTTONY,          :THICKFAT,        :OWNTEMPO,        ],   [      ],   ], # 大舌头
  :LICKILICKY    => [   [:UNAWARE,           :LONGREACH,       :THICKFAT,        ],   [      ],   ],

  :KOFFING       => [   [:LEVITATE,          :INFLATABLE,      :RUNAWAY,         ],   [      ],   ], # 瓦斯弹
  :WEEZING       => [   [:LEVITATE,          :MULTIHEADED,     :INFLATABLE,      ],   [      ],   ],
  :WEEZING_1     => [   [:LEVITATE,          :MULTIHEADED,     :POISONENGULF,    ],   [      ],   ],

  :RHYHORN       => [   [:SOLIDROCK,         :ROCKHEAD,        :ROUGHSKIN,       ],   [      ],   ], # 独角犀牛
  :RHYDON        => [   [:SOLIDROCK,         :ROCKHEAD,        :ROUGHSKIN,       ],   [      ],   ],
  :RHYPERIOR     => [   [:SOLIDROCK,         :STAMINA,         :MEGALAUNCHER,    ],   [      ],   ],

  :HAPPINY       => [   [:NATURALCURE,       :HEALER,          :SUPERLUCK,       ],   [      ],   ], # 小福蛋
  :CHANSEY       => [   [:HEALER,            :NATURALCURE,     :SERENEGRACE,     ],   [      ],   ],
  :BLISSEY       => [   [:NATURALCURE,       :HEALER,          :SELFHEAL,        ],   [      ],   ],

  :TANGELA       => [   [:REGENERATOR,       :SEAWEED,         :TANGLINGHAIR,    ],   [      ],   ], # 蔓藤怪
  :TANGROWTH     => [   [:REGENERATOR,       :SEAWEED,         :SELFHEAL,        ],   [      ],   ],

  :KANGASKHAN    => [   [:PARENTALBOND,      :SCRAPPY,         :AVENGER,         ],   [      ],   ], # 袋兽
  :KANGASKHAN_1  => [   [:PARENTALBOND,      :SCRAPPY,         :AVENGER,         ],   [      ],   ],

  :HORSEA        => [   [:POISONPOINT,       :SNIPER,          :RUNAWAY,         ],   [      ],   ], # 墨海马
  :SEADRA        => [   [:POISONPOINT,       :SNIPER,          :MEGALAUNCHER,    ],   [      ],   ],
  :KINGDRA       => [   [:PRISMSCALES,       :MEGALAUNCHER,    :MULTISCALE,      ],   [      ],   ],

  :GOLDEEN       => [   [:LIGHTNINGROD,      :MULTISCALE,      :FIELDEXPLORER,   ],   [      ],   ], # 角金鱼
  :SEAKING       => [   [:LIGHTNINGROD,      :MULTISCALE,      :FIELDEXPLORER,   ],   [      ],   ],

  :STARYU        => [   [:NATURALCURE,       :REGENERATOR,     :ANALYTIC,        ],   [      ],   ], # 海星星
  :STARMIE       => [   [:NATURALCURE,       :MYSTICPOWER,     :VICTORYSTAR,     ],   [      ],   ],

  :MIMEJR        => [   [:SOUNDPROOF,        :TECHNICIAN,      :SYNCHRONIZE,     ],   [      ],   ], # 魔尼尼
  :MRMIME        => [   [:MAGICBOUNCE,       :SOUNDPROOF,      :HYPNOTIST,       ],   [      ],   ],
  :MRMIME_1      => [   [:SCREENCLEANER,     :ICEBODY,         :OBLIVIOUS,       ],   [      ],   ],
  :MRRIME        => [   [:SCREENCLEANER,     :ICEBODY,         :OBLIVIOUS,       ],   [      ],   ],

  :SCYTHER       => [   [:SHARPNESS,         :SWARM,           :AERILATE,        ],   [      ],   ], # 飞天螳螂
  :SCIZOR        => [   [:TECHNICIAN,        :HYPERCUTTER,     :POLLINATE,       ],   [      ],   ],
  :SCIZOR_1      => [   [:TECHNICIAN,        :HYPERCUTTER,     :TOUGHCLAWS,      ],   [      ],   ],
  :KLEAVOR       => [   [:TECHNICIAN,        :SHARPNESS,       :FOSSILIZED,      ],   [      ],   ],

  :SMOOCHUM      => [   [:DRYSKIN,           :REFRIGERATE,     :RUNAWAY,         ],   [      ],   ], # 迷唇娃
  :JYNX          => [   [:DRYSKIN,           :REFRIGERATE,     :AMPLIFIER,       ],   [      ],   ],

  :ELEKID        => [   [:MINUS,             :MOTORDRIVE,      :RUNAWAY,         ],   [      ],   ], # 电击怪
  :ELECTABUZZ    => [   [:VITALSPIRIT,       :HYPERAGGRESSIVE, :MOTORDRIVE,      ],   [      ],   ],
  :ELECTIVIRE    => [   [:GROUNDSHOCK,       :TRANSISTOR,      :MOTORDRIVE,      ],   [      ],   ],

  :MAGBY         => [   [:FLASHFIRE,         :GLUTTONY,        :RUNAWAY,         ],   [      ],   ], # 鸭嘴宝宝
  :MAGMAR        => [   [:MOLTENDOWN,        :FLAMEBODY,       :FLASHFIRE,       ],   [      ],   ],
  :MAGMORTAR     => [   [:MOLTENDOWN,        :FLASHFIRE,       :DUALWIELD,       ],   [      ],   ],

  :PINSIR        => [   [:SWARM,             :HYPERCUTTER,     :GRIPPINCER,      ],   [      ],   ], # 凯罗斯
  :PINSIR_1      => [   [:HYPERCUTTER,       :GRIPPINCER,      :AERILATE,        ],   [      ],   ],

  :TAUROS        => [   [:HYPERAGGRESSIVE,   :ANGERPOINT,      :SCRAPPY,         ],   [      ],   ], # 肯泰罗
  :TAUROS_1      => [   [:HYPERAGGRESSIVE,   :ANGERPOINT,      :SCRAPPY,         ],   [      ],   ],
  :TAUROS_2      => [   [:HYPERAGGRESSIVE,   :ANGERPOINT,      :SCRAPPY,         ],   [      ],   ],
  :TAUROS_3      => [   [:HYPERAGGRESSIVE,   :ANGERPOINT,      :SCRAPPY,         ],   [      ],   ],

  :MAGIKARP      => [   [:SWIFTSWIM,         :LIMBER,          :OBLIVIOUS,       ],   [      ],   ], # 鲤鱼王
  :GYARADOS      => [   [:LEVITATE,          :AERILATE,        :OVERWHELM,       ],   [      ],   ],
  :GYARADOS_1    => [   [:MOLDBREAKER,       :BEASTBOOST,      :LEVITATE,        ],   [      ],   ],

  :LAPRAS        => [   [:HALFDRAKE,         :SHELLARMOR,      :SELFHEAL,        ],   [      ],   ], # 拉普拉斯

  :DITTO         => [   [:LIQUIFIED,         :COWARD,          :RATTLED,         ],   [      ],   ], # 百变怪

  :EEVEE         => [   [:CUTECHARM,         :PUREHEART,       :RUNAWAY,         ],   [      ],   ], # 伊布
  :VAPOREON      => [   [:WATERVEIL,         :WATERABSORB,     :HYDRATE,         ],   [      ],   ],
  :JOLTEON       => [   [:SHORTCIRCUIT,      :LIGHTNINGROD,    :GALVANIZE,       ],   [      ],   ],
  :FLAREON       => [   [:FLASHFIRE,         :DROUGHT,         :FIREIZE,         ],   [      ],   ],
  :LEAFEON       => [   [:SHARPNESS,         :BIGLEAVES,       :GRASSAZE,        ],   [      ],   ],
  :GLACEON       => [   [:SNOWWARNING,       :SLUSHRUSH,       :REFRIGERATE,     ],   [      ],   ],
  :EEVEON        => [   [:PROTEAN,           :NORMALIMMUNITY,  :NATURALCURE,     ],   [      ],   ],
  :MANEON        => [   [:SCRAPPY,           :NEUTRALIZEFORCE, :FIGHTITE,        ],   [      ],   ],
  :HAWKEON       => [   [:AIRBLOWER,         :AERODYNAMICS,    :AERILATE,        ],   [      ],   ],
  :BRISTLEON     => [   [:SANDSTREAM,        :EARTHEATER,      :TECTONIZE,       ],   [      ],   ],
  :ZIRCONEON     => [   [:SANDSTREAM,        :MOUNTAINEER,     :MINERALIZE,      ],   [      ],   ],
  :TITANEON      => [   [:IMPENETRABLE,      :COMBINATION,     :STEELIZE,        ],   [      ],   ],
  :EPHEMEON      => [   [:TECHNICIAN,        :BUGEATER,        :POLLINATE,       ],   [      ],   ],
  :TOXEON        => [   [:CORROSION,         :POISONENGULF,    :INTOXICATE,      ],   [      ],   ],
  :KITSUNEON     => [   [:ILLWILL,           :EXORCISE,        :SPECTRALIZE,     ],   [      ],   ],
  :DREKEON       => [   [:MULTISCALE,        :DRAGONSLAYER,    :DRAGONIZE,       ],   [      ],   ],
  :ESPEON        => [   [:MAGICBOUNCE,       :AVENGER,         :PSYCHICMIND,     ],   [      ],   ],
  :UMBREON       => [   [:PREDATOR,          :NOCTURNAL,       :SELFHEAL,        ],   [      ],   ],
  :SYLVEON       => [   [:PIXILATE,          :DRAGONSLAYER,    :OPPORTUNIST2,    ],   [      ],   ],

  :PORYGON       => [   [:ANALYTIC,          :SELFREPAIR,      :LEVITATE,        ],   [      ],   ], # 多边兽
  :PORYGON2      => [   [:ANALYTIC,          :SELFREPAIR,      :LEVITATE,        ],   [      ],   ],
  :PORYGONZ      => [   [:DEADEYE,           :ADAPTABILITY,    :LEVITATE,        ],   [      ],   ],

  :OMANYTE       => [   [:FOSSILIZED,        :ACCELERATE,      :SHELLARMOR,      ],   [      ],   ], # 菊石兽
  :OMASTAR       => [   [:FOSSILIZED,        :ACCELERATE,      :SHELLARMOR,      ],   [      ],   ],

  :KABUTO        => [   [:FOSSILIZED,        :OVERCOAT,        :RUNAWAY,         ],   [      ],   ], # 化石盔
  :KABUTOPS      => [   [:FOSSILIZED,        :BATTLEARMOR,     :DUALWIELD,       ],   [      ],   ],

  :AERODACTYL    => [   [:FOSSILIZED,        :ROCKHEAD,        :HALFDRAKE,       ],   [      ],   ], # 化石翼龙
  :AERODACTYL_1  => [   [:FOSSILIZED,        :ROCKHEAD,        :TOUGHCLAWS,      ],   [      ],   ],

  :MUNCHLAX      => [   [:IMMUNITY,          :THICKFAT,        :GLUTTONY,        ],   [      ],   ], # 小卡比兽
  :SNORLAX       => [   [:SELFHEAL,          :THICKFAT,        :GLUTTONY,        ],   [      ],   ],

  :ARTICUNO      => [   [:ANTARCTICBIRD,     :MAJESTICBIRD,    :PERMAFROST,      ],   [      ],   ], # 急冻鸟
  :ARTICUNO_1    => [   [:AURORABOREALIS,    :PERMAFROST,      :REFRIGERATE,     ],   [      ],   ],

  :ZAPDOS        => [   [:VOLTABSORB,        :GROUNDSHOCK,     :STATIC,          ],   [      ],   ], # 闪电鸟
  :ZAPDOS_1      => [   [:STRIKER,           :SPEEDBOOST,      :ROUNDHOUSE,      ],   [      ],   ],

  :MOLTRES       => [   [:FLASHFIRE,         :MOLTENDOWN,      :PYROMANCY,       ],   [      ],   ], # 火焰鸟
  :MOLTRES_1     => [   [:DARKAURA,          :SHADOWSHIELD,    :TIPPINGPOINT,    ],   [      ],   ],

  :DRATINI       => [   [:MULTISCALE,        :MARVELSCALE,     :SHEDSKIN,        ],   [      ],   ], # 迷你龙
  :DRAGONAIR     => [   [:MULTISCALE,        :MARVELSCALE,     :SHEDSKIN,        ],   [      ],   ],
  :DRAGONITE     => [   [:MULTISCALE,        :OVERWHELM,       :RAMPAGE,         ],   [      ],   ],

  :MEWTWO        => [   [:PSYCHICMIND,       :PRESSURE,        :FATALPRECISION,  ],   [      ],   ], # 超梦
  :MEWTWO_1      => [   [:PSYCHICMIND,       :RAGINGBOXER,     :FATALPRECISION,  ],   [      ],   ],
  :MEWTWO_2      => [   [:PSYCHICMIND,       :NEUROFORCE,      :FATALPRECISION,  ],   [      ],   ],

  :MEW           => [   [:PSYCHICMIND,       :UNAWARE,         :PRANKSTER,       ],   [      ],   ], # 梦幻

  :CHIKORITA     => [   [:GRASSPELT,         :SWEETDREAMS,     :NATURALCURE,     ],   [      ],   ], # 菊草叶
  :BAYLEEF       => [   [:GRASSPELT,         :SWEETDREAMS,     :NATURALCURE,     ],   [      ],   ],
  :MEGANIUM      => [   [:OVERGROW,          :BIGLEAVES,       :PIXILATE,        ],   [      ],   ],

  :CYNDAQUIL     => [   [:BLAZE,             :SANDRUSH,        :TECTONIZE,       ],   [      ],   ], # 火球鼠
  :QUILAVA       => [   [:BLAZE,             :BERSERK,         :TECTONIZE,       ],   [      ],   ],
  :TYPHLOSION    => [   [:BLAZE,             :BERSERK,         :FLAMINGSOUL,     ],   [      ],   ],
  :TYPHLOSION_1  => [   [:BLAZE,             :SERENEGRACE,     :SOULEATER,       ],   [      ],   ],

  :TOTODILE      => [   [:TORRENT,           :STRONGJAW,       :ROUGHSKIN,       ],   [      ],   ], # 小锯鳄
  :CROCONAW      => [   [:TORRENT,           :STRONGJAW,       :ROUGHSKIN,       ],   [      ],   ],
  :FERALIGATR    => [   [:TORRENT,           :STRONGJAW,       :ROUGHSKIN,       ],   [      ],   ],

  :SENTRET       => [   [:KEENEYE,           :FIELDEXPLORER,   :FURCOAT,         ],   [      ],   ], # 尾立
  :FURRET        => [   [:SCRAPPY,           :FIELDEXPLORER,   :FURCOAT,         ],   [      ],   ],

  :HOOTHOOT      => [   [:NOCTURNAL,         :KEENEYE,         :EARLYBIRD,       ],   [      ],   ], # 咕咕
  :NOCTOWL       => [   [:NOCTURNAL,         :INSOMNIA,        :MAJESTICBIRD,    ],   [      ],   ],

  :LEDYBA        => [   [:SWARM,             :EARLYBIRD,       :KEENEYE,         ],   [      ],   ], # 芭瓢虫
  :LEDIAN        => [   [:RAGINGBOXER,       :IRONFIST,        :LEVITATE,        ],   [      ],   ],

  :SPINARAK      => [   [:INFILTRATOR,       :MERCILESS,       :RUNAWAY,         ],   [      ],   ], # 圆丝蛛
  :ARIADOS       => [   [:POISONTOUCH,       :MERCILESS,       :OPPORTUNIST2,    ],   [      ],   ],

  :CHINCHOU      => [   [:ILLUMINATE,        :WATERABSORB,     :VOLTABSORB,      ],   [      ],   ], # 灯笼鱼
  :LANTURN       => [   [:ILLUMINATE,        :WATERABSORB,     :VOLTABSORB,      ],   [      ],   ],

  :TOGEPI        => [   [:SUPERLUCK,         :SELFHEAL,        :RUNAWAY,         ],   [      ],   ], # 波克比
  :TOGETIC       => [   [:SHIELDDUST,        :SELFHEAL,        :AERODYNAMICS,    ],   [      ],   ],
  :TOGEKISS      => [   [:SUPERLUCK,         :SERENEGRACE,     :GIANTWINGS,      ],   [      ],   ],

  :NATU          => [   [:KEENEYE,           :FOREWARN,        :MAGICBOUNCE,     ],   [      ],   ], # 天然雀
  :XATU          => [   [:KEENEYE,           :FOREWARN,        :MAGICBOUNCE,     ],   [      ],   ],

  :MAREEP        => [   [:MINUS,             :FLUFFY,          :RUNAWAY,         ],   [      ],   ], # 咩利羊
  :FLAAFFY       => [   [:MINUS,             :FLUFFY,          :RUNAWAY,         ],   [      ],   ],
  :AMPHAROS      => [   [:DAZZLING,          :SHORTCIRCUIT,    :OVERWHELM,       ],   [      ],   ],
  :AMPHAROS_1    => [   [:FLUFFY,            :OVERCHARGE,      :TRANSISTOR,      ],   [      ],   ],

  :AZURILL       => [   [:THICKFAT,          :SWIFTSWIM,       :RUNAWAY,         ],   [      ],   ], # 露力丽
  :MARILL        => [   [:THICKFAT,          :HYDRATION,       :HUGEPOWER,       ],   [      ],   ],
  :AZUMARILL     => [   [:THICKFAT,          :WATERVEIL,       :HUGEPOWER,       ],   [      ],   ],

  :BONSLY        => [   [:RAWWOOD,           :OVERCOAT,        :RUNAWAY,         ],   [      ],   ], # 盆才怪
  :SUDOWOODO     => [   [:RAWWOOD,           :FORTKNOX,        :STURDY,          ],   [      ],   ],

  :HOPPIP        => [   [:CHLOROPHYLL,       :AERODYNAMICS,    :RUNAWAY,         ],   [      ],   ], # 毽子草
  :SKIPLOOM      => [   [:CHLOROPHYLL,       :AERODYNAMICS,    :RUNAWAY,         ],   [      ],   ],
  :JUMPLUFF      => [   [:FLUFFY,            :AERODYNAMICS,    :COTTONDOWN,      ],   [      ],   ],

  :AIPOM         => [   [:TECHNICIAN,        :SKILLLINK,       :MOODY,           ],   [      ],   ], # 长尾怪手
  :AMBIPOM       => [   [:SKILLLINK,         :TECHNICIAN,      :LONGREACH,       ],   [      ],   ],

  :SUNKERN       => [   [:CHLOROPHYLL,       :EARLYBIRD,       :RUNAWAY,         ],   [      ],   ], # 向日种子
  :SUNFLORA      => [   [:DROUGHT,           :SOLARPOWER,      :GRASSPELT,       ],   [      ],   ],

  :YANMA         => [   [:SPEEDBOOST,        :COMPOUNDEYES,    :SWARM,           ],   [      ],   ], # 蜻蜻蜓
  :YANMEGA       => [   [:SPEEDBOOST,        :HYPERAGGRESSIVE, :PREDATOR,        ],   [      ],   ],

  :WOOPER        => [   [:UNAWARE,           :WATERABSORB,     :RUNAWAY,         ],   [      ],   ], # 乌波
  :WOOPER_1      => [   [:UNAWARE,           :WATERABSORB,     :POISONPOINT,     ],   [      ],   ],
  :QUAGSIRE      => [   [:UNAWARE,           :WATERABSORB,     :OBLIVIOUS,       ],   [      ],   ],
  :CLODSIRE      => [   [:UNAWARE,           :WATERABSORB,     :ROUGHSKIN,       ],   [      ],   ],

  :MURKROW       => [   [:KEENEYE,           :NOCTURNAL,       :SUPERLUCK,       ],   [      ],   ], # 黑暗鸦
  :HONCHKROW     => [   [:BIGPECKS,          :OVERCOAT,        :PREDATOR,        ],   [      ],   ],

  :MISDREAVUS    => [   [:LEVITATE,          :PERISHBODY,      :PIXILATE,        ],   [      ],   ], # 梦妖
  :MISDREAVUS_1  => [   [:LEVITATE,          :PERISHBODY,      :FIREIZE,         ],   [      ],   ],
  :MISMAGIUS     => [   [:LEVITATE,          :PIXILATE,        :BADDREAMS,       ],   [      ],   ],
  :MISMAGIUS_1   => [   [:LEVITATE,          :FIREIZE,         :BADDREAMS,       ],   [      ],   ],

  :UNOWN         => [   [:PSYCHICSURGE,      :PRANKSTER,       :LEVITATE,        ],   [      ],   ], # 未知图腾

  :WYNAUT        => [   [:MAGICGUARD,        :TELEPATHY,       :STICKYHOLD,      ],   [      ],   ], # 小果然
  :WOBBUFFET     => [   [:STICKYHOLD,        :INNARDSOUT,      :SHADOWTAG,       ],   [      ],   ],

  :GIRAFARIG     => [   [:MULTIHEADED,       :NOCTURNAL,       :STRONGJAW,       ],   [      ],   ], # 麒麟奇
  :FARIGIRAF     => [   [:ARMORTAIL,         :MINDCRUSH,       :PRIMALMAW,       ],   [      ],   ],

  :PINECO        => [   [:OVERCOAT,          :HEATPROOF,       :STICKYHOLD,      ],   [      ],   ], # 榛果球
  :FORRETRESS    => [   [:OVERCOAT,          :LEADCOAT,        :HEATPROOF,       ],   [      ],   ],

  :DUNSPARCE     => [   [:SUPERLUCK,         :RUNAWAY,         :COWARD,          ],   [      ],   ], # 土龙弟弟
  :DUDUNSPARCE   => [   [:SERENEGRACE,       :DEFENCEROLL,     :SUPERLUCK,       ],   [      ],   ],

  :GLIGAR        => [   [:HYPERCUTTER,       :SANDVEIL,        :ROUGHSKIN,       ],   [      ],   ], # 天蝎
  :GLISCOR       => [   [:HYPERCUTTER,       :POISONHEAL,      :ROUGHSKIN,       ],   [      ],   ],

  :SNUBBULL      => [   [:RUNAWAY,           :QUICKFEET,       :STRONGJAW,       ],   [      ],   ], # 布鲁
  :GRANBULL      => [   [:PIXILATE,          :STRONGJAW,       :QUICKFEET,       ],   [      ],   ],

  :QWILFISH      => [   [:LOOSEQUILLS,       :INFLATABLE,      :POISONPOINT,     ],   [      ],   ], # 千针鱼
  :QWILFISH_1    => [   [:MERCILESS,         :AFTERMATH,       :TOXICDEBRIS,     ],   [      ],   ],
  :OVERQWIL      => [   [:MERCILESS,         :AFTERMATH,       :TOXICDEBRIS,     ],   [      ],   ],

  :SHUCKLE       => [   [:SHELLARMOR,        :OBLIVIOUS,       :SOLIDROCK,       ],   [      ],   ], # 壶壶

  :HERACROSS     => [   [:SWARM,             :BATTLEARMOR,     :GUTS,            ],   [      ],   ], # 赫拉克罗斯
  :HERACROSS_1   => [   [:FIGHTITE,          :BATTLEARMOR,     :SHIELDDUST,      ],   [      ],   ],

  :SNEASEL       => [   [:TOUGHCLAWS,        :INNERFOCUS,      :INFILTRATOR,     ],   [      ],   ], # 狃拉
  :SNEASEL_1     => [   [:TOUGHCLAWS,        :INTOXICATE,      :UNBURDEN,        ],   [      ],   ],
  :WEAVILE       => [   [:TOUGHCLAWS,        :PREDATOR,        :TECHNICIAN,      ],   [      ],   ],
  :SNEASLER      => [   [:TOUGHCLAWS,        :INTOXICATE,      :UNBURDEN,        ],   [      ],   ],

  :TEDDIURSA     => [   [:GUTS,              :QUICKFEET,       :FURCOAT,         ],   [      ],   ], # 熊宝宝
  :URSARING      => [   [:GUTS,              :QUICKFEET,       :FURCOAT,         ],   [      ],   ],
  :URSALUNA      => [   [:GUTS,              :PREDATOR,        :OVERCOAT,        ],   [      ],   ],
  :URSALUNA_1    => [   [:MINDSEYE,          :MOONSPIRIT,      :DISHEARTEN,      ],   [      ],   ],

  :SLUGMA        => [   [:MOLTENDOWN,        :FLASHFIRE,       :MAGMAARMOR,      ],   [      ],   ], # 熔岩虫
  :MAGCARGO      => [   [:MOLTENDOWN,        :FLASHFIRE,       :MAGMAARMOR,      ],   [      ],   ],

  :SWINUB        => [   [:SLUSHRUSH,         :SNOWCLOAK,       :THICKFAT,        ],   [      ],   ], # 小山猪
  :PILOSWINE     => [   [:SLUSHRUSH,         :THICKFAT,        :GROWINGTOOTH,    ],   [      ],   ],
  :MAMOSWINE     => [   [:SLUSHRUSH,         :THICKFAT,        :GROWINGTOOTH,    ],   [      ],   ],

  :CORSOLA       => [   [:REGENERATOR,       :NATURALCURE,     :SOLIDROCK,       ],   [      ],   ], # 太阳珊瑚
  :CORSOLA_1     => [   [:CURSEDBODY,        :STURDY,          :RATTLED,         ],   [      ],   ],
  :CURSOLA       => [   [:CURSEDBODY,        :STURDY,          :RATTLED,         ],   [      ],   ],

  :MANTYKE       => [   [:RAINDISH,          :HYDRATION,       :RUNAWAY,         ],   [      ],   ], # 小球飞鱼
  :MANTINE       => [   [:RAINDISH,          :WATERABSORB,     :GIANTWINGS,      ],   [      ],   ],

  :REMORAID      => [   [:ARTILLERY,         :SWIFTSWIM,       :GOOEY,           ],   [      ],   ], # 铁炮鱼
  :OCTILLERY     => [   [:ARTILLERY,         :SUCTIONCUPS,     :MEGALAUNCHER,    ],   [      ],   ],

  :DELIBIRD      => [   [:THICKFAT,          :MAGICBOUNCE,     :CHRISTMASSPIRIT, ],   [      ],   ], # 信使鸟

  :SKARMORY      => [   [:GIANTWINGS,        :FULLMETALBODY,   :BATTLEARMOR,     ],   [      ],   ], # 盔甲鸟

  :HOUNDOUR      => [   [:NOCTURNAL,         :FAEHUNTER,       :EQUINOX,         ],   [      ],   ], # 戴鲁比
  :HOUNDOOM      => [   [:NOCTURNAL,         :FAEHUNTER,       :EQUINOX,         ],   [      ],   ],
  :HOUNDOOM_1    => [   [:EQUINOX,           :PYROMANCY,       :HYPERAGGRESSIVE, ],   [      ],   ],

  :PHANPY        => [   [:DEFENCEROLL,       :ROUGHSKIN,       :PICKUP,          ],   [      ],   ], # 小小象
  :DONPHAN       => [   [:DEFENCEROLL,       :ROUGHSKIN,       :BATTLEARMOR,     ],   [      ],   ],

  :STANTLER      => [   [:SAPSIPPER,         :VIOLENTRUSH,     :HYPNOTIST,       ],   [      ],   ], # 惊角鹿
  :WYRDEER       => [   [:AURORA,            :MIGHTYHORN,      :ILLUMINATE,      ],   [      ],   ],

  :SMEARGLE      => [   [:OWNTEMPO,          :TECHNICIAN,      :SKILLLINK,       ],   [      ],   ], # 图图犬

  :MILTANK       => [   [:THICKFAT,          :SAPSIPPER,       :JUGGERNAUT,      ],   [      ],   ], # 大奶罐

  :RAIKOU        => [   [:OVERCHARGE,        :BEASTBOOST,      :ELECTRICSURGE,   ],   [      ],   ], # 雷公

  :ENTEI         => [   [:VOLCANORAGE,       :BEASTBOOST,      :MOLTENDOWN,      ],   [      ],   ], # 炎帝

  :SUICUNE       => [   [:AURORABOREALIS,    :WATERVEIL,       :SEAGUARDIAN,     ],   [      ],   ], # 水君

  :LARVITAR      => [   [:SOLIDROCK,         :MOUNTAINEER,     :ROUGHSKIN,       ],   [      ],   ], # 幼基拉斯
  :PUPITAR       => [   [:SOLIDROCK,         :MOUNTAINEER,     :ROUGHSKIN,       ],   [      ],   ],
  :TYRANITAR     => [   [:IMPENETRABLE,      :JUGGERNAUT,      :RAMPAGE,         ],   [      ],   ],
  :TYRANITAR_1   => [   [:STRONGJAW,         :JUGGERNAUT,      :PRIMALARMOR,     ],   [      ],   ],

  :LUGIA         => [   [:LEVITATE,          :MULTISCALE,      :SEAGUARDIAN,     ],   [      ],   ], # 洛奇亚

  :HOOH          => [   [:LEVITATE,          :MAJESTICBIRD,    :PRISMSCALES,     ],   [      ],   ], # 凤王

  :CELEBI        => [   [:FOREWARN,          :NATURALRECOVERY, :GRASSYSURGE,     ],   [      ],   ], # 时拉比

  :TREECKO       => [   [:OVERGROW,          :STICKYHOLD,      :INNERFOCUS,      ],   [      ],   ], # 木守宫
  :GROVYLE       => [   [:OVERGROW,          :SKILLLINK,       :INNERFOCUS,      ],   [      ],   ],
  :SCEPTILE      => [   [:OVERGROW,          :SKILLLINK,       :SHARPNESS,       ],   [      ],   ],
  :SCEPTILE_1    => [   [:FORESTRAGE,        :SPEEDFORCE,      :SHARPNESS,       ],   [      ],   ],

  :TORCHIC       => [   [:BLAZE,             :FLAMEBODY,       :AVENGER,         ],   [      ],   ], # 火稚鸡
  :COMBUSKEN     => [   [:BLAZE,             :FLAMEBODY,       :STRIKER,         ],   [      ],   ],
  :BLAZIKEN      => [   [:BLAZE,             :FLAMEBODY,       :STRIKER,         ],   [      ],   ],
  :BLAZIKEN_1    => [   [:HELLBLAZE,         :ROUNDHOUSE,      :STRIKER,         ],   [      ],   ],

  :MUDKIP        => [   [:TORRENT,           :DRYSKIN,         :RUNAWAY,         ],   [      ],   ], # 水跃鱼
  :MARSHTOMP     => [   [:TORRENT,           :DRYSKIN,         :BATTLEARMOR,     ],   [      ],   ],
  :SWAMPERT      => [   [:TORRENT,           :DRYSKIN,         :REGENERATOR,     ],   [      ],   ],
  :SWAMPERT_1    => [   [:RIPTIDE,           :IRONFIST,        :REGENERATOR,     ],   [      ],   ],

  :POOCHYENA     => [   [:PREDATOR,          :STRONGJAW,       :NOCTURNAL,       ],   [      ],   ], # 土狼犬
  :MIGHTYENA     => [   [:PREDATOR,          :STRONGJAW,       :STAKEOUT,        ],   [      ],   ],

  :ZIGZAGOON     => [   [:GLUTTONY,          :QUICKFEET,       :MOMENTUM,        ],   [      ],   ], # 蛇纹熊
  :ZIGZAGOON_1   => [   [:SCRAPPY,           :LIMBER,          :MOMENTUM,        ],   [      ],   ],
  :LINOONE       => [   [:FIELDEXPLORER,     :SPEEDFORCE,      :QUICKFEET,       ],   [      ],   ],
  :LINOONE_1     => [   [:SCRAPPY,           :HYPERAGGRESSIVE, :MOMENTUM,        ],   [      ],   ],
  :OBSTAGOON     => [   [:PICKUP,            :GUTS,            :POISONHEAL,      ],   [      ],   ],

  :WURMPLE       => [   [:SWARM,             :RUNAWAY,         :SAPSIPPER,       ],   [      ],   ], # 刺尾虫
  :SILCOON       => [   [:SWARM,             :BATTLEARMOR,     :SAPSIPPER,       ],   [      ],   ],
  :BEAUTIFLY     => [   [:MAJESTICMOTH,      :DAZZLING,        :LEVITATE,        ],   [      ],   ],
  :CASCOON       => [   [:SWARM,             :BATTLEARMOR,     :SAPSIPPER,       ],   [      ],   ],
  :DUSTOX        => [   [:MAJESTICMOTH,      :NOCTURNAL,       :LEVITATE,        ],   [      ],   ],

  :LOTAD         => [   [:SEAWEED,           :RAINDISH,        :HYDRATION,       ],   [      ],   ], # 莲叶童子
  :LOMBRE        => [   [:SEAWEED,           :RAINDISH,        :HYDRATION,       ],   [      ],   ],
  :LUDICOLO      => [   [:SEAWEED,           :RAINDISH,        :HYDRATION,       ],   [      ],   ],

  :SEEDOT        => [   [:OVERGROW,          :CHLOROPHYLL,     :PICKPOCKET,      ],   [      ],   ], # 橡实果
  :NUZLEAF       => [   [:OVERGROW,          :CHLOROPHYLL,     :NOCTURNAL,       ],   [      ],   ],
  :SHIFTRY       => [   [:OVERGROW,          :WINDRIDER,       :NOCTURNAL,       ],   [      ],   ],

  :TAILLOW       => [   [:FLIGHT,            :KEENEYE,         :GUTS,            ],   [      ],   ], # 傲骨燕
  :SWELLOW       => [   [:FLIGHT,            :KEENEYE,         :GUTS,            ],   [      ],   ],

  :WINGULL       => [   [:KEENEYE,           :RAINDISH,        :FLIGHT,          ],   [      ],   ], # 长翅鸥
  :PELIPPER      => [   [:KEENEYE,           :RAINDISH,        :FLIGHT,          ],   [      ],   ],

  :RALTS         => [   [:SYNCHRONIZE,       :TELEPATHY,       :MAGICGUARD,      ],   [      ],   ], # 拉鲁拉丝
  :KIRLIA        => [   [:SERENEGRACE,       :SYNCHRONIZE,     :MAGICGUARD,      ],   [      ],   ],
  :GARDEVOIR     => [   [:SERENEGRACE,       :MAGICGUARD,      :DREAMCATCHER,    ],   [      ],   ],
  :GARDEVOIR_1   => [   [:SERENEGRACE,       :MAGICGUARD,      :SOULHEART,       ],   [      ],   ],
  :GALLADE       => [   [:DUALWIELD,         :FATALPRECISION,  :AVENGER,         ],   [      ],   ],
  :GALLADE_1     => [   [:DUALWIELD,         :FATALPRECISION,  :AVENGER,         ],   [      ],   ],

  :SURSKIT       => [   [:COMPOUNDEYES,      :RAINDISH,        :STICKYHOLD,      ],   [      ],   ], # 溜溜糖球
  :MASQUERAIN    => [   [:COMPOUNDEYES,      :MAJESTICMOTH,    :LEVITATE,        ],   [      ],   ],

  :SHROOMISH     => [   [:EFFECTSPORE,       :TOXICBOOST,      :QUICKFEET,       ],   [      ],   ], # 蘑蘑菇
  :BRELOOM       => [   [:EFFECTSPORE,       :TOXICBOOST,      :TECHNICIAN,      ],   [      ],   ],

  :SLAKOTH       => [   [:COMATOSE,          :UNAWARE,         :OBLIVIOUS,       ],   [      ],   ], # 懒人獭
  :VIGOROTH      => [   [:ANGERPOINT,        :HYPERAGGRESSIVE, :VITALSPIRIT,     ],   [      ],   ],
  :SLAKING       => [   [:COMATOSE,          :UNAWARE,         :MOLDBREAKER,     ],   [      ],   ],

  :NINCADA       => [   [:COMPOUNDEYES,      :SHEDSKIN,        :DRYSKIN,         ],   [      ],   ], # 土居忍士
  :NINJASK       => [   [:COMPOUNDEYES,      :INFILTRATOR,     :SPEEDBOOST,      ],   [      ],   ],
  :SHEDINJA      => [   [:WONDERSKIN,        :LEVITATE,        :CURSEDBODY,      ],   [      ],   ],

  :WHISMUR       => [   [:SCRAPPY,           :RATTLED,         :RUNAWAY,         ],   [      ],   ], # 咕妞妞
  :LOUDRED       => [   [:SCRAPPY,           :LOUDBANG,        :AMPLIFIER,       ],   [      ],   ],
  :EXPLOUD       => [   [:SCRAPPY,           :LOUDBANG,        :AMPLIFIER,       ],   [      ],   ],

  :MAKUHITA      => [   [:THICKFAT,          :GUTS,            :SHEERFORCE,      ],   [      ],   ], # 幕下力士
  :HARIYAMA      => [   [:THICKFAT,          :GUTS,            :VITALSPIRIT,     ],   [      ],   ],

  :NOSEPASS      => [   [:SOLIDROCK,         :SANDFORCE,       :SANDFORCE,       ],   [      ],   ], # 朝北鼻
  :PROBOPASS     => [   [:MULTIHEADED,       :LEVITATE,        :SOLIDROCK,       ],   [      ],   ],

  :SKITTY        => [   [:CUTECHARM,         :WONDERSKIN,      :SERENEGRACE,     ],   [      ],   ], # 向尾喵
  :DELCATTY      => [   [:PRIMANDPROPER,     :DAZZLING,        :NOCTURNAL,       ],   [      ],   ],

  :SABLEYE       => [   [:ANALYTIC,          :WONDERSKIN,      :NOCTURNAL,       ],   [      ],   ], # 勾魂眼
  :SABLEYE_1     => [   [:ANALYTIC,          :MAGICBOUNCE,     :NOCTURNAL,       ],   [      ],   ],

  :MAWILE        => [   [:MULTIHEADED,       :STRONGJAW,       :GRIPPINCER,      ],   [      ],   ], # 大嘴娃
  :MAWILE_1      => [   [:MULTIHEADED,       :STRONGJAW,       :GRIPPINCER,      ],   [      ],   ],

  :ARON          => [   [:LEADCOAT,          :ROCKHEAD,        :IRONBARBS,       ],   [      ],   ], # 可可多拉
  :LAIRON        => [   [:LEADCOAT,          :JUGGERNAUT,      :IMPENETRABLE,    ],   [      ],   ],
  :AGGRON        => [   [:LEADCOAT,          :FILTER,          :IMPENETRABLE,    ],   [      ],   ],
  :AGGRON_1      => [   [:LEADCOAT,          :PRIMALARMOR,     :IMPENETRABLE,    ],   [      ],   ],

  :MEDITITE      => [   [:PSYCHICMIND,       :TECHNICIAN,      :TELEPATHY,       ],   [      ],   ], # 玛沙那
  :MEDICHAM      => [   [:TECHNICIAN,        :COMBATSPECIALIST,:LIMBER,          ],   [      ],   ],
  :MEDICHAM_1    => [   [:COMBATSPECIALIST,  :ENLIGHTENED,     :TECHNICIAN,      ],   [      ],   ],

  :ELECTRIKE     => [   [:PLUS,              :QUICKFEET,       :ILLUMINATE,      ],   [      ],   ], # 落雷兽
  :MANECTRIC     => [   [:STATIC,            :LIGHTNINGROD,    :OVERCHARGE,      ],   [      ],   ],
  :MANECTRIC_1   => [   [:VOLTRUSH,          :GROUNDSHOCK,     :OVERCHARGE,      ],   [      ],   ],

  :PLUSLE        => [   [:PLUS,              :COMPETITIVE,     :SPEEDBOOST,      ],   [      ],   ], # 正电拍拍

  :MINUN         => [   [:MINUS,             :DEFIANT,         :SPEEDBOOST,      ],   [      ],   ], # 负电拍拍

  :VOLBEAT       => [   [:SWARM,             :RECKLESS,        :ELECTROCYTES,    ],   [      ],   ], # 电萤虫

  :ILLUMISE      => [   [:PRANKSTER,         :ILLUMINATE,      :CUTECHARM,       ],   [      ],   ], # 甜甜萤

  :GULPIN        => [   [:STICKYHOLD,        :LIQUIFIED,       :GLUTTONY,        ],   [      ],   ], # 溶食兽
  :SWALOT        => [   [:STICKYHOLD,        :LIQUIFIED,       :CORROSION,       ],   [      ],   ],

  :CARVANHA      => [   [:STRONGJAW,         :SWIFTSWIM,       :ROUGHSKIN,       ],   [      ],   ], # 利牙鱼
  :SHARPEDO      => [   [:STRONGJAW,         :HYPERAGGRESSIVE, :JAWSOFCARNAGE,   ],   [      ],   ],
  :SHARPEDO_1    => [   [:STRONGJAW,         :SPEEDFORCE,      :VIOLENTRUSH,     ],   [      ],   ],

  :WAILMER       => [   [:LIQUIDVOICE,       :THICKFAT,        :PRESSURE,        ],   [      ],   ], # 吼吼鲸
  :WAILORD       => [   [:LIQUIDVOICE,       :THICKFAT,        :PRESSURE,        ],   [      ],   ],

  :NUMEL         => [   [:OWNTEMPO,          :OBLIVIOUS,       :SOLIDROCK,       ],   [      ],   ], # 呆火驼
  :CAMERUPT      => [   [:MAGMAARMOR,        :SOLIDROCK,       :MOLTENDOWN,      ],   [      ],   ],
  :CAMERUPT_1    => [   [:MAGMAARMOR,        :ARTILLERY,       :MOLTENDOWN,      ],   [      ],   ],

  :TORKOAL       => [   [:SHELLARMOR,        :WHITESMOKE,      :MOUNTAINEER,     ],   [      ],   ], # 煤炭龟

  :SPOINK        => [   [:GLUTTONY,          :RATTLED,         :THICKFAT,        ],   [      ],   ], # 跳跳猪
  :GRUMPIG       => [   [:FOREWARN,          :THICKFAT,        :FURCOAT,         ],   [      ],   ],

  :SPINDA        => [   [:UNAWARE,           :SIMPLE,          :FIELDEXPLORER,   ],   [      ],   ], # 晃晃斑

  :TRAPINCH      => [   [:HYPERCUTTER,       :STRONGJAW,       :SWARM,           ],   [      ],   ], # 大颚蚁
  :VIBRAVA       => [   [:DRAGONFLY,         :TECTONIZE,       :SWARM,           ],   [      ],   ],
  :FLYGON        => [   [:DRAGONFLY,         :TECTONIZE,       :TINTEDLENS,      ],   [      ],   ],

  :CACNEA        => [   [:NOCTURNAL,         :WATERABSORB,     :LIMBER,          ],   [      ],   ], # 刺球仙人掌
  :CACTURNE      => [   [:NOCTURNAL,         :ROUGHSKIN,       :SOULEATER,       ],   [      ],   ],

  :SWABLU        => [   [:NATURALCURE,       :FLUFFY,          :CLOUDNINE,       ],   [      ],   ], # 青绵鸟
  :ALTARIA       => [   [:NATURALCURE,       :FLUFFY,          :SWEETDREAMS,     ],   [      ],   ],
  :ALTARIA_1     => [   [:NATURALCURE,       :FLUFFY,          :LEVITATE,        ],   [      ],   ],

  :ZANGOOSE      => [   [:TOXICBOOST,        :FATALPRECISION,  :TOUGHCLAWS,      ],   [      ],   ], # 猫鼬斩

  :SEVIPER       => [   [:STRONGJAW,         :SOLENOGLYPHS,    :COILUP,          ],   [      ],   ], # 饭匙蛇

  :LUNATONE      => [   [:LEVITATE,          :NOCTURNAL,       :LUNARECLIPSE,    ],   [      ],   ], # 月石

  :SOLROCK       => [   [:LEVITATE,          :STURDY,          :SOLARFLARE,      ],   [      ],   ], # 太阳岩

  :BARBOACH      => [   [:ELECTROCYTES,      :GALVANIZE,       :ANTICIPATION,    ],   [      ],   ], # 泥泥鳅
  :WHISCASH      => [   [:TRANSISTOR,        :AFTERSHOCK,      :EARTHEATER,      ],   [      ],   ],

  :CORPHISH      => [   [:HYPERCUTTER,       :SHELLARMOR,      :SELFHEAL,        ],   [      ],   ], # 龙虾小兵
  :CRAWDAUNT     => [   [:HYPERCUTTER,       :SHELLARMOR,      :GRIPPINCER,      ],   [      ],   ],

  :BALTOY        => [   [:LEVITATE,          :ANCIENTIDOL,     :CLAYFORM,        ],   [      ],   ], # 天秤偶
  :CLAYDOL       => [   [:LEVITATE,          :MYSTICPOWER,     :SANDFORCE,       ],   [      ],   ],

  :LILEEP        => [   [:FOSSILIZED,        :AMPHIBIOUS,      :SEAWEED,         ],   [      ],   ], # 触手百合
  :CRADILY       => [   [:BATTLEARMOR,       :AMPHIBIOUS,      :SEAWEED,         ],   [      ],   ],

  :ANORITH       => [   [:FOSSILIZED,        :AMPHIBIOUS,      :SWIFTSWIM,       ],   [      ],   ], # 太古羽虫
  :ARMALDO       => [   [:FOSSILIZED,        :AMPHIBIOUS,      :HYPERCUTTER,     ],   [      ],   ],

  :FEEBAS        => [   [:MARVELSCALE,       :ADAPTABILITY,    :OBLIVIOUS,       ],   [      ],   ], # 丑丑鱼
  :MILOTIC       => [   [:PRISMSCALES,       :ADAPTABILITY,    :SELFHEAL,        ],   [      ],   ],

  :CASTFORM      => [   [:LEVITATE,          :WEATHERCONTROL,  :ADAPTABILITY,    ],   [      ],   ], # 飘浮泡泡

  :KECLEON       => [   [:COLORCHANGE,       :PROTEAN,         :CHEAPTACTICS,    ],   [      ],   ], # 变隐龙

  :SHUPPET       => [   [:VENGEANCE,         :HAUNTEDSPIRIT,   :LEVITATE,        ],   [      ],   ], # 怨影娃娃
  :BANETTE       => [   [:DISHEARTEN,        :HAUNTEDSPIRIT,   :SOULEATER,       ],   [      ],   ],
  :BANETTE_1     => [   [:INTIMIDATE,        :MAGICGUARD,      :SOULEATER,       ],   [      ],   ],

  :DUSKULL       => [   [:LEVITATE,          :NOCTURNAL,       :RUNAWAY,         ],   [      ],   ], # 夜巡灵
  :DUSCLOPS      => [   [:IRONFIST,          :NOCTURNAL,       :SOULEATER,       ],   [      ],   ],
  :DUSKNOIR      => [   [:CURSEDBODY,        :SHADOWSHIELD,    :SOULEATER,       ],   [      ],   ],

  :TROPIUS       => [   [:AERIALIST,         :GIANTWINGS,      :BIGLEAVES,       ],   [      ],   ], # 热带龙

  :CHINGLING     => [   [:LEVITATE,          :FRIENDGUARD,     :RUNAWAY,         ],   [      ],   ], # 铃铛响
  :CHIMECHO      => [   [:LEVITATE,          :DREAMCATCHER,    :METALLIC,        ],   [      ],   ],

  :ABSOL         => [   [:SUPERLUCK,         :MOUNTAINEER,     :SHARPNESS,       ],   [      ],   ], # 阿勃梭鲁
  :ABSOL_1       => [   [:SUPERLUCK,         :SHARPNESS,       :MAGICGUARD,      ],   [      ],   ],

  :SNORUNT       => [   [:ICEBODY,           :SNOWCLOAK,       :INNERFOCUS,      ],   [      ],   ], # 雪童子
  :GLALIE        => [   [:STURDY,            :FREEZINGPOINT,   :IMPENETRABLE,    ],   [      ],   ],
  :GLALIE_1      => [   [:SNOWFORCE,         :REFRIGERATE,     :IMPENETRABLE,    ],   [      ],   ],
  :FROSLASS      => [   [:ICEBODY,           :CURSEDBODY,      :SLUSHRUSH,       ],   [      ],   ],

  :SPHEAL        => [   [:THICKFAT,          :ICEBODY,         :DEFENCEROLL,     ],   [      ],   ], # 海豹球
  :SEALEO        => [   [:THICKFAT,          :ICEBODY,         :DEFENCEROLL,     ],   [      ],   ],
  :WALREIN       => [   [:THICKFAT,          :ARCTICFUR,       :GROWINGTOOTH,    ],   [      ],   ],

  :CLAMPERL      => [   [:SHELLARMOR,        :HYDRATION,       :SWIFTSWIM,       ],   [      ],   ], # 珍珠贝
  :HUNTAIL       => [   [:WATERVEIL,         :STRONGJAW,       :PREDATOR,        ],   [      ],   ],
  :GOREBYSS      => [   [:DAZZLING,          :ADAPTABILITY,    :PREDATOR,        ],   [      ],   ],

  :RELICANTH     => [   [:FOSSILIZED,        :IMPENETRABLE,    :PRIMALARMOR,     ],   [      ],   ], # 古空棘鱼

  :LUVDISC       => [   [:SOULHEART,         :MULTISCALE,      :SERENEGRACE,     ],   [      ],   ], # 爱心鱼

  :BAGON         => [   [:ROCKHEAD,          :ANGERPOINT,      :RECKLESS,        ],   [      ],   ], # 宝贝龙
  :SHELGON       => [   [:SHELLARMOR,        :OVERCOAT,        :IMPENETRABLE,    ],   [      ],   ],
  :SALAMENCE     => [   [:OVERWHELM,         :ANGERPOINT,      :RECKLESS,        ],   [      ],   ],
  :SALAMENCE_1   => [   [:RECKLESS,          :AERILATE,        :PREDATOR,        ],   [      ],   ],

  :BELDUM        => [   [:LEVITATE,          :FULLMETALBODY,   :MAGNETPULL,      ],   [      ],   ], # 铁哑铃
  :METANG        => [   [:LEVITATE,          :DOWNLOAD,        :FULLMETALBODY,   ],   [      ],   ],
  :METAGROSS     => [   [:PRISMARMOR,        :DOWNLOAD,        :FULLMETALBODY,   ],   [      ],   ],
  :METAGROSS_1   => [   [:PREDATOR,          :FULLMETALBODY,   :LEVITATE,        ],   [      ],   ],

  :REGIROCK      => [   [:POWERCORE,         :IMPENETRABLE,    :SELFHEAL,        ],   [      ],   ], # 雷吉洛克

  :REGICE        => [   [:POWERCORE,         :IMPENETRABLE,    :SELFHEAL,        ],   [      ],   ], # 雷吉艾斯

  :REGISTEEL     => [   [:POWERCORE,         :IMPENETRABLE,    :SELFHEAL,        ],   [      ],   ], # 雷吉斯奇鲁

  :LATIAS        => [   [:LEVITATE,          :PRISMARMOR,      :MYSTICPOWER,     ],   [      ],   ], # 拉帝亚斯
  :LATIAS_1      => [   [:LEVITATE,          :PRISMARMOR,      :MYSTICPOWER,     ],   [      ],   ],

  :LATIOS        => [   [:LEVITATE,          :VIOLENTRUSH,     :MYSTICPOWER,     ],   [      ],   ], # 拉帝欧斯
  :LATIOS_1      => [   [:LEVITATE,          :MULTISCALE,      :ARCANEFORCE,     ],   [      ],   ],

  :KYOGRE        => [   [:DRIZZLE,           :SELFHEAL,        :SEAGUARDIAN,     ],   [      ],   ], # 盖欧卡
  :KYOGRE_1      => [   [:PRIMORDIALSEA,     :SWIFTSWIM,       :PRIMALARMOR,     ],   [      ],   ],

  :GROUDON       => [   [:DROUGHT,           :SELFHEAL,        :SUNWORSHIP,      ],   [      ],   ], # 固拉多
  :GROUDON_1     => [   [:DESOLATELAND,      :MOLTENDOWN,      :PRIMALARMOR,     ],   [      ],   ],

  :RAYQUAZA      => [   [:AIRLOCK,           :WEATHERCONTROL,  :RAMPAGE,         ],   [      ],   ], # 烈空坐
  :RAYQUAZA_1    => [   [:DELTASTREAM,       :DRAGONSMAW,      :AERILATE,        ],   [      ],   ],

  :JIRACHI       => [   [:STEELWORKER,       :SERENEGRACE,     :LEVITATE,        ],   [      ],   ], # 基拉祈

  :DEOXYS        => [   [:INNERFOCUS,        :FATALPRECISION,  :PSYCHICMIND,     ],   [      ],   ], # 代欧奇希斯
  :DEOXYS_1      => [   [:INNERFOCUS,        :FATALPRECISION,  :PSYCHICMIND,     ],   [      ],   ],
  :DEOXYS_2      => [   [:INNERFOCUS,        :STAMINA,         :REGENERATOR,     ],   [      ],   ],
  :DEOXYS_3      => [   [:LEVITATE,          :FATALPRECISION,  :PSYCHICMIND,     ],   [      ],   ],

  :TURTWIG       => [   [:OVERGROW,          :SHELLARMOR,      :CHLOROPLAST,     ],   [      ],   ], # 草苗龟
  :GROTLE        => [   [:OVERGROW,          :SHELLARMOR,      :CHLOROPLAST,     ],   [      ],   ],
  :TORTERRA      => [   [:OVERGROW,          :IMPENETRABLE,    :BIGLEAVES,       ],   [      ],   ],

  :CHIMCHAR      => [   [:BLAZE,             :PRANKSTER,       :DEFIANT,         ],   [      ],   ], # 小火焰猴
  :MONFERNO      => [   [:BLAZE,             :PRANKSTER,       :DEFIANT,         ],   [      ],   ],
  :INFERNAPE     => [   [:BLAZE,             :DISCIPLINE,      :DEFIANT,         ],   [      ],   ],

  :PIPLUP        => [   [:TORRENT,           :THICKFAT,        :SWIFTSWIM,       ],   [      ],   ], # 波加曼
  :PRINPLUP      => [   [:TORRENT,           :ANTARCTICBIRD,   :SWIFTSWIM,       ],   [      ],   ],
  :EMPOLEON      => [   [:TORRENT,           :ANTARCTICBIRD,   :IMPENETRABLE,    ],   [      ],   ],

  :STARLY        => [   [:FLIGHT,            :KEENEYE,         :RUNAWAY,         ],   [      ],   ], # 姆克儿
  :STARAVIA      => [   [:FLIGHT,            :KEENEYE,         :GUTS,            ],   [      ],   ],
  :STARAPTOR     => [   [:PREDATOR,          :RECKLESS,        :INTIMIDATE,      ],   [      ],   ],

  :BIDOOF        => [   [:UNAWARE,           :GROWINGTOOTH,    :FIELDEXPLORER,   ],   [      ],   ], # 大牙狸
  :BIBAREL       => [   [:UNAWARE,           :GROWINGTOOTH,    :FIELDEXPLORER,   ],   [      ],   ],

  :KRICKETOT     => [   [:SWARM,             :PICKUP,          :SOUNDPROOF,      ],   [      ],   ], # 圆法师
  :KRICKETUNE    => [   [:MOUNTAINEER,       :TECHNICIAN,      :SOUNDPROOF,      ],   [      ],   ],

  :SHINX         => [   [:SHORTCIRCUIT,      :ILLUMINATE,      :GUTS,            ],   [      ],   ], # 小猫怪
  :LUXIO         => [   [:SHORTCIRCUIT,      :ILLUMINATE,      :GUTS,            ],   [      ],   ],
  :LUXRAY        => [   [:SHORTCIRCUIT,      :INTIMIDATE,      :PREDATOR,        ],   [      ],   ],

  :BUDEW         => [   [:NATURALCURE,       :CHLOROPHYLL,     :LEAFGUARD,       ],   [      ],   ], # 含羞苞
  :ROSELIA       => [   [:NATURALCURE,       :CHLOROPHYLL,     :POISONPOINT,     ],   [      ],   ],
  :ROSERADE      => [   [:NATURALCURE,       :MERCILESS,       :AROMAVEIL,       ],   [      ],   ],

  :CRANIDOS      => [   [:FOSSILIZED,        :RECKLESS,        :ROCKHEAD,        ],   [      ],   ], # 头盖龙
  :RAMPARDOS     => [   [:FOSSILIZED,        :RECKLESS,        :ROCKHEAD,        ],   [      ],   ],

  :SHIELDON      => [   [:FOSSILIZED,        :IMPENETRABLE,    :PRIMALARMOR,     ],   [      ],   ], # 盾甲龙
  :BASTIODON     => [   [:DAUNTLESSSHIELD,   :IMPENETRABLE,    :PRIMALARMOR,     ],   [      ],   ],

  :BURMY         => [   [:SWARM,             :ANALYTIC,        :OVERCOAT,        ],   [      ],   ], # 结草儿
  :WORMADAM      => [   [:ADAPTABILITY,      :BATTLEARMOR,     :COWARD,          ],   [      ],   ],
  :WORMADAM_1    => [   [:ADAPTABILITY,      :BATTLEARMOR,     :TECTONIZE,       ],   [      ],   ],
  :WORMADAM_2    => [   [:ADAPTABILITY,      :BATTLEARMOR,     :SCRAPYARD,       ],   [      ],   ],
  :MOTHIM        => [   [:TINTEDLENS,        :MAJESTICMOTH,    :COMPOUNDEYES,    ],   [      ],   ],

  :COMBEE        => [   [:SWARM,             :MULTIHEADED,     :HONEYGATHER,     ],   [      ],   ], # 三蜜蜂
  :VESPIQUEN     => [   [:QUEENSMOURNING,    :QUEENLYMAJESTY,  :SELFHEAL,        ],   [      ],   ],

  :PACHIRISU     => [   [:FURCOAT,           :REGENERATOR,     :VOLTABSORB,      ],   [      ],   ], # 帕奇利兹

  :BUIZEL        => [   [:PICKUP,            :FIELDEXPLORER,   :WATERVEIL,       ],   [      ],   ], # 泳圈鼬
  :FLOATZEL      => [   [:SWIFTSWIM,         :HYDRATE,         :INFLATABLE,      ],   [      ],   ],

  :CHERUBI       => [   [:CHLOROPHYLL,       :ANTICIPATION,    :SOLARPOWER,      ],   [      ],   ], # 樱花宝
  :CHERRIM       => [   [:CHLOROPHYLL,       :SOLARPOWER,      :SOLARFLARE,      ],   [      ],   ],

  :SHELLOS       => [   [:STICKYHOLD,        :SELFHEAL,        :LIMBER,          ],   [      ],   ], # 无壳海兔
  :GASTRODON     => [   [:STICKYHOLD,        :SELFHEAL,        :SHELLARMOR,      ],   [      ],   ],

  :DRIFLOON      => [   [:INFLATABLE,        :FLAREBOOST,      :SOULEATER,       ],   [      ],   ], # 飘飘球
  :DRIFBLIM      => [   [:INFLATABLE,        :FLAREBOOST,      :SOULEATER,       ],   [      ],   ],

  :BUNEARY       => [   [:LIMBER,            :FURCOAT,         :RUNAWAY,         ],   [      ],   ], # 卷卷耳
  :LOPUNNY       => [   [:LIMBER,            :FURCOAT,         :STRIKER,         ],   [      ],   ],
  :LOPUNNY_1     => [   [:LIMBER,            :FURCOAT,         :STRIKER,         ],   [      ],   ],

  :GLAMEOW       => [   [:HYPNOTIST,         :LIMBER,          :QUICKFEET,       ],   [      ],   ], # 魅力喵
  :PURUGLY       => [   [:HYPERAGGRESSIVE,   :FURCOAT,         :THICKFAT,        ],   [      ],   ],

  :STUNKY        => [   [:AFTERMATH,         :STENCH,          :KEENEYE,         ],   [      ],   ], # 臭鼬噗
  :SKUNTANK      => [   [:CORROSION,         :STENCH,          :GLUTTONY,        ],   [      ],   ],

  :BRONZOR       => [   [:LEVITATE,          :LEADCOAT,        :HEATPROOF,       ],   [      ],   ], # 铜镜怪
  :BRONZONG      => [   [:STEELWORKER,       :HEATPROOF,       :BULLETPROOF,     ],   [      ],   ],

  :CHATOT        => [   [:ADAPTABILITY,      :AMPLIFIER,       :MOLDBREAKER,     ],   [      ],   ], # 聒噪鸟

  :SPIRITOMB     => [   [:SOULEATER,         :BADDREAMS,       :SHADOWSHIELD,    ],   [      ],   ], # 花岩怪

  :GIBLE         => [   [:HYPERAGGRESSIVE,   :SANDVEIL,        :ROUGHSKIN,       ],   [      ],   ], # 圆陆鲨
  :GABITE        => [   [:HYPERAGGRESSIVE,   :SANDFORCE,       :ROUGHSKIN,       ],   [      ],   ],
  :GARCHOMP      => [   [:HYPERAGGRESSIVE,   :SPEEDFORCE,      :ROUGHSKIN,       ],   [      ],   ],
  :GARCHOMP_1    => [   [:HYPERAGGRESSIVE,   :PREDATOR,        :ROUGHSKIN,       ],   [      ],   ],

  :RIOLU         => [   [:INNERFOCUS,        :QUICKFEET,       :RUNAWAY,         ],   [      ],   ], # 利欧路
  :LUCARIO       => [   [:INNERFOCUS,        :FATALPRECISION,  :VITALSPIRIT,     ],   [      ],   ],
  :LUCARIO_1     => [   [:INNERFOCUS,        :IRONFIST,        :FIGHTITE,        ],   [      ],   ],

  :HIPPOPOTAS    => [   [:SANDFORCE,         :BATTLEARMOR,     :STAMINA,         ],   [      ],   ], # 沙河马
  :HIPPOWDON     => [   [:SANDGUARD,         :PREDATOR,        :STRONGJAW,       ],   [      ],   ],

  :SKORUPI       => [   [:SHELLARMOR,        :GRIPPINCER,      :GROUNDED,        ],   [      ],   ], # 钳尾蝎
  :DRAPION       => [   [:SHELLARMOR,        :GRIPPINCER,      :NOCTURNAL,       ],   [      ],   ],

  :CROAGUNK      => [   [:DRYSKIN,           :AMPHIBIOUS,      :MERCILESS,       ],   [      ],   ], # 不良蛙
  :TOXICROAK     => [   [:DRYSKIN,           :POISONTOUCH,     :MERCILESS,       ],   [      ],   ],

  :CARNIVINE     => [   [:LEVITATE,          :STRONGJAW,       :PREDATOR,        ],   [      ],   ], # 尖牙笼

  :FINNEON       => [   [:SWIFTSWIM,         :ILLUMINATE,      :SERENEGRACE,     ],   [      ],   ], # 荧光鱼
  :LUMINEON      => [   [:MAJESTICMOTH,      :STORMDRAIN,      :ILLUMINATE,      ],   [      ],   ],

  :SNOVER        => [   [:ICEBODY,           :SNOWCLOAK,       :PERMAFROST,      ],   [      ],   ], # 雪笠怪
  :ABOMASNOW     => [   [:ICEBODY,           :FREEZINGPOINT,   :PERMAFROST,      ],   [      ],   ],
  :ABOMASNOW_1   => [   [:SNOWWARNING,       :SNOWFORCE,       :PERMAFROST,      ],   [      ],   ],

  :ROTOM         => [   [:LEVITATE,          :CURSEDBODY,      :MOTORDRIVE,      ],   [      ],   ], # 洛托姆
  :ROTOM_1       => [   [:LEVITATE,          :FURNACE,         :PHANTOM,         ],   [      ],   ], # 微波炉
  :ROTOM_2       => [   [:LEVITATE,          :DAMP,            :PHANTOM,         ],   [      ],   ], # 洗衣机
  :ROTOM_3       => [   [:LEVITATE,          :REFRIGERATOR,    :PHANTOM,         ],   [      ],   ], # 冰箱
  :ROTOM_4       => [   [:LEVITATE,          :WINDRIDER,       :PHANTOM,         ],   [      ],   ], # 电风扇
  :ROTOM_5       => [   [:LEVITATE,          :HYPERCUTTER,     :PHANTOM,         ],   [      ],   ], # 割草机

  :UXIE          => [   [:LEVITATE,          :PSYCHICMIND,     :NATURALCURE,     ],   [      ],   ], # 由克希

  :MESPRIT       => [   [:LEVITATE,          :PSYCHICMIND,     :NATURALCURE,     ],   [      ],   ], # 艾姆利多

  :AZELF         => [   [:LEVITATE,          :PSYCHICMIND,     :NATURALCURE,     ],   [      ],   ], # 亚克诺姆

  :DIALGA        => [   [:PRIMALARMOR,       :IMPENETRABLE,    :POWERCORE,       ],   [      ],   ], # 帝牙卢卡
  :DIALGA_1      => [   [:MEGALAUNCHER,      :IMPENETRABLE,    :POWERCORE,       ],   [      ],   ],

  :PALKIA        => [   [:PRIMALARMOR,       :OVERWHELM,       :POWERCORE,       ],   [      ],   ], # 帕路奇亚
  :PALKIA_1      => [   [:PRISMARMOR,        :SEAGUARDIAN,     :POWERCORE,       ],   [      ],   ],

  :HEATRAN       => [   [:MAGMAARMOR,        :MOUNTAINEER,     :FLASHFIRE,       ],   [      ],   ], # 席多蓝恩

  :REGIGIGAS     => [   [:POWERCORE,         :IMPENETRABLE,    :JUGGERNAUT,      ],   [      ],   ], # 雷吉奇卡斯

  :GIRATINA      => [   [:SHADOWSHIELD,      :SHADOWTAG,       :SOULEATER,       ],   [      ],   ], # 骑拉帝纳
  :GIRATINA_1    => [   [:LEVITATE,          :SHADOWTAG,       :SOULEATER,       ],   [      ],   ],

  :CRESSELIA     => [   [:LEVITATE,          :MOONSPIRIT,      :PEACEFULSLUMBER, ],   [      ],   ], # 克雷色利亚

  :PHIONE        => [   [:SEAGUARDIAN,       :FIELDEXPLORER,   :HIGHTIDE,        ],   [      ],   ], # 霏欧纳

  :MANAPHY       => [   [:CHANGEOFHEART,     :PARENTALBOND,    :HIGHTIDE,        ],   [      ],   ], # 玛纳霏

  :DARKRAI       => [   [:LEVITATE,          :BADDREAMS,       :DREAMCATCHER,    ],   [      ],   ], # 达克莱伊

  :SHAYMIN       => [   [:NATURALRECOVERY,   :POISONENGULF,    :GRASSYSURGE,     ],   [      ],   ], # 谢米
  :SHAYMIN_1     => [   [:NATURALCURE,       :SERENEGRACE,     :SPEEDBOOST,      ],   [      ],   ],

  :ARCEUS        => [   [:POWERCORE,         :PRESSURE,        :MYSTICPOWER,     ],   [      ],   ], # 阿尔宙斯
  :ARCEUS_1      => [   [:POWERCORE,         :PRESSURE,        :LEVITATE,        ],   [      ],   ],
  :ARCEUS_2      => [   [:POWERCORE,         :PRESSURE,        :LEVITATE,        ],   [      ],   ],
  :ARCEUS_3      => [   [:POWERCORE,         :PRESSURE,        :LEVITATE,        ],   [      ],   ],
  :ARCEUS_4      => [   [:POWERCORE,         :PRESSURE,        :LEVITATE,        ],   [      ],   ],
  :ARCEUS_5      => [   [:POWERCORE,         :PRESSURE,        :LEVITATE,        ],   [      ],   ],
  :ARCEUS_6      => [   [:POWERCORE,         :PRESSURE,        :LEVITATE,        ],   [      ],   ],
  :ARCEUS_7      => [   [:POWERCORE,         :PRESSURE,        :LEVITATE,        ],   [      ],   ],
  :ARCEUS_8      => [   [:POWERCORE,         :PRESSURE,        :LEVITATE,        ],   [      ],   ],
  :ARCEUS_9      => [   [:POWERCORE,         :PRESSURE,        :LEVITATE,        ],   [      ],   ],
  :ARCEUS_10     => [   [:POWERCORE,         :PRESSURE,        :LEVITATE,        ],   [      ],   ],
  :ARCEUS_11     => [   [:POWERCORE,         :PRESSURE,        :LEVITATE,        ],   [      ],   ],
  :ARCEUS_12     => [   [:POWERCORE,         :PRESSURE,        :LEVITATE,        ],   [      ],   ],
  :ARCEUS_13     => [   [:POWERCORE,         :PRESSURE,        :LEVITATE,        ],   [      ],   ],
  :ARCEUS_14     => [   [:POWERCORE,         :PRESSURE,        :LEVITATE,        ],   [      ],   ],
  :ARCEUS_15     => [   [:POWERCORE,         :PRESSURE,        :LEVITATE,        ],   [      ],   ],
  :ARCEUS_16     => [   [:POWERCORE,         :PRESSURE,        :LEVITATE,        ],   [      ],   ],
  :ARCEUS_17     => [   [:POWERCORE,         :PRESSURE,        :LEVITATE,        ],   [      ],   ],
  :ARCEUS_18     => [   [:POWERCORE,         :PRESSURE,        :LEVITATE,        ],   [      ],   ],

  :VICTINI       => [   [:VICTORYSTAR,       :MAGICGUARD,      :PSYCHICMIND,     ],   [      ],   ], # 比克提尼

  :SNIVY         => [   [:OVERGROW,          :SHEDSKIN,        :CHLOROPHYLL,     ],   [      ],   ], # 藤藤蛇
  :SERVINE       => [   [:OVERGROW,          :SHEDSKIN,        :CHLOROPHYLL,     ],   [      ],   ],
  :SERPERIOR     => [   [:OVERGROW,          :SHEDSKIN,        :CHLOROPLAST,     ],   [      ],   ],

  :TEPIG         => [   [:BLAZE,             :THICKFAT,        :GLUTTONY,        ],   [      ],   ], # 暖暖猪
  :PIGNITE       => [   [:BLAZE,             :THICKFAT,        :GLUTTONY,        ],   [      ],   ],
  :EMBOAR        => [   [:BLAZE,             :RECKLESS,        :JUGGERNAUT,      ],   [      ],   ],

  :OSHAWOTT      => [   [:TORRENT,           :SHELLARMOR,      :SHARPNESS,       ],   [      ],   ], # 水水獭
  :DEWOTT        => [   [:TORRENT,           :SHELLARMOR,      :SHARPNESS,       ],   [      ],   ],
  :SAMUROTT      => [   [:TORRENT,           :SHELLARMOR,      :VIOLENTRUSH,     ],   [      ],   ],
  :SAMUROTT_1    => [   [:SHARPNESS,         :MERCILESS,       :TORRENT,         ],   [      ],   ],

  :PATRAT        => [   [:KEENEYE,           :ANALYTIC,        :QUICKFEET,       ],   [      ],   ], # 探探鼠
  :WATCHOG       => [   [:STAKEOUT,          :ANALYTIC,        :ILLUMINATE,      ],   [      ],   ],

  :LILLIPUP      => [   [:OVERCOAT,          :PICKUP,          :RUNAWAY,         ],   [      ],   ], # 小约克
  :HERDIER       => [   [:OVERCOAT,          :FURCOAT,         :FILTER,          ],   [      ],   ],
  :STOUTLAND     => [   [:OVERCOAT,          :FURCOAT,         :FILTER,          ],   [      ],   ],

  :PURRLOIN      => [   [:LIMBER,            :PRANKSTER,       :SNIPER,          ],   [      ],   ], # 扒手猫
  :LIEPARD       => [   [:LIMBER,            :PRANKSTER,       :OPPORTUNIST2,    ],   [      ],   ],

  :PANSAGE       => [   [:OVERGROW,          :PRANKSTER,       :PLUS,            ],   [      ],   ], # 花椰猴
  :SIMISAGE      => [   [:OVERGROW,          :GRASSAZE,        :GLUTTONY,        ],   [      ],   ],

  :PANSEAR       => [   [:BLAZE,             :PRANKSTER,       :PLUS,            ],   [      ],   ], # 爆香猴
  :SIMISEAR      => [   [:BLAZE,             :PRANKSTER,       :FLASHFIRE,       ],   [      ],   ],

  :PANPOUR       => [   [:TORRENT,           :PRANKSTER,       :PLUS,            ],   [      ],   ], # 冷水猴
  :SIMIPOUR      => [   [:TORRENT,           :STORMDRAIN,      :HEALER,          ],   [      ],   ],

  :MUNNA         => [   [:DREAMCATCHER,      :SWEETDREAMS,     :LEVITATE,        ],   [      ],   ], # 食梦梦
  :MUSHARNA      => [   [:DREAMCATCHER,      :COMATOSE,        :LEVITATE,        ],   [      ],   ],

  :PIDOVE        => [   [:KEENEYE,           :BIGPECKS,        :RIVALRY,         ],   [      ],   ], # 豆豆鸽
  :TRANQUILL     => [   [:KEENEYE,           :BIGPECKS,        :RIVALRY,         ],   [      ],   ],
  :UNFEZANT      => [   [:KEENEYE,           :BIGPECKS,        :ACCELERATE,      ],   [      ],   ],

  :BLITZLE       => [   [:ILLUMINATE,        :MOTORDRIVE,      :SAPSIPPER,       ],   [      ],   ], # 斑斑马
  :ZEBSTRIKA     => [   [:ILLUMINATE,        :MOTORDRIVE,      :SAPSIPPER,       ],   [      ],   ],

  :ROGGENROLA    => [   [:POWERCORE,         :IMPENETRABLE,    :SANDFORCE,       ],   [      ],   ], # 石丸子
  :BOLDORE       => [   [:POWERCORE,         :IMPENETRABLE,    :SANDFORCE,       ],   [      ],   ],
  :GIGALITH      => [   [:POWERCORE,         :STURDY,          :SANDFORCE,       ],   [      ],   ],

  :WOOBAT        => [   [:UNAWARE,           :SOUNDPROOF,      :RUNAWAY,         ],   [      ],   ], # 滚滚蝙蝠
  :SWOOBAT       => [   [:UNAWARE,           :AERODYNAMICS,    :LOUDBANG,        ],   [      ],   ],

  :DRILBUR       => [   [:SANDRUSH,          :SANDFORCE,       :RUNAWAY,         ],   [      ],   ], # 螺钉地鼠
  :EXCADRILL     => [   [:SANDRUSH,          :SANDFORCE,       :EARTHBOUND,      ],   [      ],   ],

  :AUDINO        => [   [:HEALER,            :REGENERATOR,     :SERENEGRACE,     ],   [      ],   ], # 差不多娃娃
  :AUDINO_1      => [   [:PURELOVE,          :REGENERATOR,     :SERENEGRACE,     ],   [      ],   ],

  :TIMBURR       => [   [:GUTS,              :IRONFIST,        :QUICKFEET,       ],   [      ],   ], # 搬运小匠
  :GURDURR       => [   [:GUTS,              :IRONFIST,        :QUICKFEET,       ],   [      ],   ],
  :CONKELDURR    => [   [:GUTS,              :IRONFIST,        :JUGGERNAUT,      ],   [      ],   ],

  :TYMPOLE       => [   [:WATERABSORB,       :HYDRATION,       :RATTLED,         ],   [      ],   ], # 圆蝌蚪
  :PALPITOAD     => [   [:WATERABSORB,       :HYDRATION,       :RATTLED,         ],   [      ],   ],
  :SEISMITOAD    => [   [:WATERABSORB,       :EARTHBOUND,      :POISONTOUCH,     ],   [      ],   ],

  :THROH         => [   [:JUGGERNAUT,        :ANALYTIC,        :IRONFIST,        ],   [      ],   ], # 投摔鬼

  :SAWK          => [   [:FIGHTER,           :IRONFIST,        :FATALPRECISION,  ],   [      ],   ], # 打击鬼

  :SEWADDLE      => [   [:SWARM,             :CHLOROPHYLL,     :OVERCOAT,        ],   [      ],   ], # 虫宝包
  :SWADLOON      => [   [:SWARM,             :CHLOROPHYLL,     :OVERCOAT,        ],   [      ],   ],
  :LEAVANNY      => [   [:SHARPNESS,         :SUPERLUCK,       :OVERCOAT,        ],   [      ],   ],

  :VENIPEDE      => [   [:SWARM,             :SOLENOGLYPHS,    :HYPERAGGRESSIVE, ],   [      ],   ], # 百足蜈蚣
  :WHIRLIPEDE    => [   [:DEFENCEROLL,       :COILUP,          :SHELLARMOR,      ],   [      ],   ],
  :SCOLIPEDE     => [   [:DEFENCEROLL,       :SOLENOGLYPHS,    :HYPERAGGRESSIVE, ],   [      ],   ],

  :COTTONEE      => [   [:INFILTRATOR,       :CHLOROPHYLL,     :FLUFFY,          ],   [      ],   ], # 木棉球
  :WHIMSICOTT    => [   [:INFILTRATOR,       :COTTONDOWN,      :FLUFFY,          ],   [      ],   ],

  :PETILIL       => [   [:CHLOROPHYLL,       :NATURALCURE,     :OVERGROW,        ],   [      ],   ], # 百合根娃娃
  :LILLIGANT     => [   [:CHLOROPHYLL,       :NATURALCURE,     :OVERGROW,        ],   [      ],   ],
  :LILLIGANT_1   => [   [:SHARPNESS,         :SPEEDFORCE,      :FILTER,          ],   [      ],   ],

  :BASCULIN      => [   [:RECKLESS,          :ADAPTABILITY,    :HYPERAGGRESSIVE, ],   [      ],   ], # 野蛮鲈鱼
  :BASCULIN_1    => [   [:ROCKHEAD,          :ADAPTABILITY,    :HYPERAGGRESSIVE, ],   [      ],   ],
  :BASCULIN_2    => [   [:RATTLED,           :ADAPTABILITY,    :HYPERAGGRESSIVE, ],   [      ],   ],
  :BASCULEGION   => [   [:VENGEANCE,         :RECKLESS,        :SPECTRALIZE,     ],   [      ],   ],

  :SANDILE       => [   [:SANDRUSH,          :SCAVENGER,       :STRONGJAW,       ],   [      ],   ], # 黑眼鳄
  :KROKOROK      => [   [:SANDRUSH,          :SCAVENGER,       :STRONGJAW,       ],   [      ],   ],
  :KROOKODILE    => [   [:HYPERAGGRESSIVE,   :PREDATOR,        :STRONGJAW,       ],   [      ],   ],

  :DARUMAKA      => [   [:FLAMEBODY,         :INNERFOCUS,      :RATTLED,         ],   [      ],   ],
  :DARUMAKA_1    => [   [:FLAMEBODY,         :INNERFOCUS,      :RATTLED,         ],   [      ],   ],
  :DARUMAKA_2    => [   [:MOLDBREAKER,       :INNERFOCUS,      :RATTLED,         ],   [      ],   ],
  :DARMANITAN    => [   [:FLAMEBODY,         :IRONFIST,        :TURBOBLAZE,      ],   [      ],   ],
  :DARMANITAN_1  => [   [:INNERFOCUS,        :IMPENETRABLE,    :CLEARBODY,       ],   [      ],   ],
  :DARMANITAN_2  => [   [:MOLDBREAKER,       :IRONFIST,        :HEATPROOF,       ],   [      ],   ],
  :DARMANITAN_3  => [   [:MOLDBREAKER,       :IRONFIST,        :POWERFISTS,      ],   [      ],   ],

  :MARACTUS      => [   [:ROUGHSKIN,         :CHLOROPHYLL,     :HUGEPOWER,       ],   [      ],   ], # 沙铃仙人掌

  :DWEBBLE       => [   [:SOLIDROCK,         :SHELLARMOR,      :CLAYFORM,        ],   [      ],   ], # 石居蟹
  :CRUSTLE       => [   [:SOLIDROCK,         :SHELLARMOR,      :GRIPPINCER,      ],   [      ],   ],

  :SCRAGGY       => [   [:SHEDSKIN,          :ROCKHEAD,        :RECKLESS,        ],   [      ],   ], # 滑滑小子
  :SCRAFTY       => [   [:SHEDSKIN,          :ROCKHEAD,        :RECKLESS,        ],   [      ],   ],

  :SIGILYPH      => [   [:WONDERSKIN,        :TINTEDLENS,      :LEVITATE,        ],   [      ],   ], # 象征鸟

  :YAMASK        => [   [:VENGEANCE,         :CURSEDBODY,      :HAUNTEDSPIRIT,   ],   [      ],   ], # 哭哭面具
  :YAMASK_1      => [   [:HAUNTEDSPIRIT,     :CURSEDBODY,      :VENGEANCE,       ],   [      ],   ],
  :COFAGRIGUS    => [   [:VENGEANCE,         :CURSEDBODY,      :HAUNTEDSPIRIT,   ],   [      ],   ],
  :RUNERIGUS     => [   [:HAUNTEDSPIRIT,     :SPITEFUL,        :SOLIDROCK,       ],   [      ],   ],

  :TIRTOUGA      => [   [:FOSSILIZED,        :SHELLARMOR,      :SOLIDROCK,       ],   [      ],   ], # 原盖海龟
  :CARRACOSTA    => [   [:STRONGJAW,         :SHELLARMOR,      :SOLIDROCK,       ],   [      ],   ],

  :ARCHEN        => [   [:FOSSILIZED,        :ROCKHEAD,        :RATTLED,         ],   [      ],   ], # 始祖小鸟
  :ARCHEOPS      => [   [:DEFEATIST,         :FOSSILIZED,      :ROCKHEAD,        ],   [      ],   ],

  :TRUBBISH      => [   [:STENCH,            :ADAPTABILITY,    :POISONENGULF,    ],   [      ],   ], # 破破袋
  :GARBODOR      => [   [:STENCH,            :SCAVENGER,       :TOXICSPILL,      ],   [      ],   ],

  :ZORUA         => [   [:AMBUSH,            :INSOMNIA,        :OPPORTUNIST2,    ],   [      ],   ], # 索罗亚
  :ZORUA_1       => [   [:VENGEANCE,         :OPPORTUNIST2,    :EXPLOITWEAKNESS, ],   [      ],   ],
  :ZOROARK       => [   [:AMBUSH,            :EXPLOITWEAKNESS, :OPPORTUNIST2,    ],   [      ],   ],
  :ZOROARK_1     => [   [:VENGEANCE,         :OPPORTUNIST2,    :EXPLOITWEAKNESS, ],   [      ],   ],

  :MINCCINO      => [   [:TECHNICIAN,        :CUTECHARM,       :OVERCOAT,        ],   [      ],   ], # 泡沫栗鼠
  :CINCCINO      => [   [:TECHNICIAN,        :CUTECHARM,       :OVERCOAT,        ],   [      ],   ],

  :GOTHITA       => [   [:NOCTURNAL,         :PSYCHICMIND,     :RATTLED,         ],   [      ],   ], # 哥德宝宝
  :GOTHORITA     => [   [:NOCTURNAL,         :PSYCHICMIND,     :OVERCOAT,        ],   [      ],   ],
  :GOTHITELLE    => [   [:NOCTURNAL,         :PSYCHICMIND,     :MAGICBOUNCE,     ],   [      ],   ],

  :SOLOSIS       => [   [:REGENERATOR,       :LIQUIFIED,       :MAGICGUARD,      ],   [      ],   ], # 单卵细胞球
  :DUOSION       => [   [:REGENERATOR,       :LIQUIFIED,       :MAGICGUARD,      ],   [      ],   ],
  :REUNICLUS     => [   [:REGENERATOR,       :LIQUIFIED,       :MAGICGUARD,      ],   [      ],   ],

  :DUCKLETT      => [   [:FLIGHT,            :KEENEYE,         :BIGPECKS,        ],   [      ],   ], # 鸭宝宝
  :SWANNA        => [   [:FLIGHT,            :KEENEYE,         :MAJESTICBIRD,    ],   [      ],   ],

  :VANILLITE     => [   [:PERMAFROST,        :ICEBODY,         :SLUSHRUSH,       ],   [      ],   ], # 迷你冰
  :VANILLISH     => [   [:PERMAFROST,        :ICEBODY,         :SLUSHRUSH,       ],   [      ],   ],
  :VANILLUXE     => [   [:MULTIHEADED,       :ICEBODY,         :SLUSHRUSH,       ],   [      ],   ],

  :DEERLING      => [   [:SAPSIPPER,         :VIOLENTRUSH,     :QUICKFEET,       ],   [      ],   ], # 四季鹿
  :DEERLING_1    => [   [:SAPSIPPER,         :VIOLENTRUSH,     :QUICKFEET,       ],   [      ],   ],
  :DEERLING_2    => [   [:SAPSIPPER,         :VIOLENTRUSH,     :QUICKFEET,       ],   [      ],   ],
  :DEERLING_3    => [   [:SAPSIPPER,         :VIOLENTRUSH,     :QUICKFEET,       ],   [      ],   ],
  :DEERLING_4    => [   [:SAPSIPPER,         :VIOLENTRUSH,     :QUICKFEET,       ],   [      ],   ],
  :SAWSBUCK      => [   [:MIGHTYHORN,        :VIOLENTRUSH,     :RIVALRY,         ],   [      ],   ],
  :SAWSBUCK_1    => [   [:SAPSIPPER,         :VIOLENTRUSH,     :RIVALRY,         ],   [      ],   ],
  :SAWSBUCK_2    => [   [:SAPSIPPER,         :VIOLENTRUSH,     :RIVALRY,         ],   [      ],   ],
  :SAWSBUCK_3    => [   [:SAPSIPPER,         :VIOLENTRUSH,     :RIVALRY,         ],   [      ],   ],
  :SAWSBUCK_4    => [   [:MIGHTYHORN,        :VIOLENTRUSH,     :RIVALRY,         ],   [      ],   ],

  :EMOLGA        => [   [:STATIC,            :MOTORDRIVE,      :AERODYNAMICS,    ],   [      ],   ], # 电飞鼠

  :KARRABLAST    => [   [:SWARM,             :SHEDSKIN,        :STICKYHOLD,      ],   [      ],   ], # 盖盖虫
  :ESCAVALIER    => [   [:SWARM,             :SHELLARMOR,      :SPEEDBOOST,      ],   [      ],   ],

  :FOONGUS       => [   [:REGENERATOR,       :EFFECTSPORE,     :DRYSKIN,         ],   [      ],   ], # 哎呀球菇
  :AMOONGUSS     => [   [:REGENERATOR,       :EFFECTSPORE,     :DRYSKIN,         ],   [      ],   ],

  :FRILLISH      => [   [:WATERABSORB,       :LIMBER,          :POISONTOUCH,     ],   [      ],   ], # 轻飘飘
  :JELLICENT     => [   [:WATERBUBBLE,       :SOULEATER,       :POISONTOUCH,     ],   [      ],   ],

  :ALOMOMOLA     => [   [:HEALER,            :REGENERATOR,     :SELFHEAL,        ],   [      ],   ], # 保姆曼波

  :JOLTIK        => [   [:OPPORTUNIST2,      :SWARM,           :COMPOUNDEYES,    ],   [      ],   ], # 电电虫
  :GALVANTULA    => [   [:MERCILESS,         :TECHNICIAN,      :COMPOUNDEYES,    ],   [      ],   ],

  :FERROSEED     => [   [:IRONBARBS,         :DEFENCEROLL,     :BATTLEARMOR,     ],   [      ],   ], # 种子铁球
  :FERROTHORN    => [   [:IRONBARBS,         :DEFENCEROLL,     :BATTLEARMOR,     ],   [      ],   ],

  :KLINK         => [   [:PLUS,              :MULTIHEADED,     :FULLMETALBODY,   ],   [      ],   ], # 齿轮儿
  :KLANG         => [   [:PLUS,              :MULTIHEADED,     :FULLMETALBODY,   ],   [      ],   ],
  :KLINKLANG     => [   [:TECHNICIAN,        :MULTIHEADED,     :IMPENETRABLE,    ],   [      ],   ],

  :TYNAMO        => [   [:PLUS,              :LEVITATE,        :AQUATIC,         ],   [      ],   ], # 麻麻鳗
  :EELEKTRIK     => [   [:PLUS,              :LEVITATE,        :AQUATIC,         ],   [      ],   ],
  :EELEKTROSS    => [   [:LEVITATE,          :ELECTROCYTES,    :ARTILLERY,       ],   [      ],   ],

  :ELGYEM        => [   [:ANALYTIC,          :PSYCHICMIND,     :NEUROFORCE,      ],   [      ],   ], # 小灰怪
  :BEHEEYEM      => [   [:ANALYTIC,          :GIFTEDMIND,      :NEUROFORCE,      ],   [      ],   ],

  :LITWICK       => [   [:FLASHFIRE,         :SOULEATER,       :ILLUMINATE,      ],   [      ],   ], # 烛光灵
  :LAMPENT       => [   [:LEVITATE,          :SOULEATER,       :ILLUMINATE,      ],   [      ],   ],
  :CHANDELURE    => [   [:LEVITATE,          :PYROMANCY,       :ILLUMINATE,      ],   [      ],   ],

  :AXEW          => [   [:RIVALRY,           :MOLDBREAKER,     :GROWINGTOOTH,    ],   [      ],   ], # 牙牙
  :FRAXURE       => [   [:RIVALRY,           :MOLDBREAKER,     :SHELLARMOR,      ],   [      ],   ],
  :HAXORUS       => [   [:BEASTBOOST,        :PREDATOR,        :DISCIPLINE,      ],   [      ],   ],

  :CUBCHOO       => [   [:SLUSHRUSH,         :SNOWCLOAK,       :SWIFTSWIM,       ],   [      ],   ], # 喷嚏熊
  :BEARTIC       => [   [:TOUGHCLAWS,        :QUICKFEET,       :FURCOAT,         ],   [      ],   ],

  :CRYOGONAL     => [   [:LEVITATE,          :ICEBODY,         :PERMAFROST,      ],   [      ],   ], # 几何雪花

  :SHELMET       => [   [:SWARM,             :SHELLARMOR,      :OVERCOAT,        ],   [      ],   ], # 小嘴蜗
  :ACCELGOR      => [   [:SWARM,             :PERFECTIONIST,   :PROTEAN,         ],   [      ],   ],

  :STUNFISK      => [   [:UNAWARE,           :AMPHIBIOUS,      :DRYSKIN,         ],   [      ],   ], # 泥巴鱼
  :STUNFISK_1    => [   [:MIMICRY,           :SCRAPYARD,       :IRONBARBS,       ],   [      ],   ],

  :MIENFOO       => [   [:INNERFOCUS,        :RECKLESS,        :SPEEDFORCE,      ],   [      ],   ], # 功夫鼬
  :MIENSHAO      => [   [:COMBATSPECIALIST,  :SCRAPPY,         :CHEAPTACTICS,    ],   [      ],   ],

  :DRUDDIGON     => [   [:AMBUSH,            :SOLIDROCK,       :PREDATOR,        ],   [      ],   ], # 赤面龙

  :GOLETT        => [   [:POWERCORE,         :NOGUARD,         :HAUNTEDSPIRIT,   ],   [      ],   ], # 泥偶小人
  :GOLURK        => [   [:POWERCORE,         :SHADOWSHIELD,    :SELFREPAIR,      ],   [      ],   ],

  :PAWNIARD      => [   [:INNERFOCUS,        :SHARPNESS,       :BATTLEARMOR,     ],   [      ],   ], # 驹刀小兵
  :BISHARP       => [   [:NOGUARD,           :SHARPNESS,       :BATTLEARMOR,     ],   [      ],   ],
  :KINGAMBIT     => [   [:SUPREMEOVERLORD,   :HYPERCUTTER,     :BATTLEARMOR,     ],   [      ],   ],

  :BOUFFALANT    => [   [:VIOLENTRUSH,       :FURCOAT,         :ROCKHEAD,        ],   [      ],   ], # 爆炸头水牛

  :RUFFLET       => [   [:FLIGHT,            :KEENEYE,         :BIGPECKS,        ],   [      ],   ], # 毛头小鹰
  :BRAVIARY      => [   [:FLIGHT,            :GIANTWINGS,      :BIGPECKS,        ],   [      ],   ],
  :BRAVIARY_1    => [   [:TINTEDLENS,        :GIANTWINGS,      :KEENEYE,         ],   [      ],   ],

  :VULLABY       => [   [:FLIGHT,            :KEENEYE,         :SCAVENGER,       ],   [      ],   ], # 秃鹰丫头
  :MANDIBUZZ     => [   [:OVERCOAT,          :STAMINA,         :SCAVENGER,       ],   [      ],   ],

  :HEATMOR       => [   [:WHITESMOKE,        :TOUGHCLAWS,      :FATALPRECISION,  ],   [      ],   ], # 熔蚁兽

  :DURANT        => [   [:SWARM,             :STRONGJAW,       :COMPOUNDEYES,    ],   [      ],   ], # 铁蚁
  :DURANT_1      => [   [:SWARM,             :STRONGJAW,       :COMPOUNDEYES,    ],   [      ],   ],

  :DEINO         => [   [:GLUTTONY,          :HYPERAGGRESSIVE, :RUNAWAY,         ],   [      ],   ], # 单首龙
  :ZWEILOUS      => [   [:MULTIHEADED,       :GLUTTONY,        :PREDATOR,        ],   [      ],   ],
  :HYDREIGON     => [   [:MULTIHEADED,       :LEVITATE,        :PREDATOR,        ],   [      ],   ],

  :LARVESTA      => [   [:SWARM,             :FLAMEBODY,       :FLASHFIRE,       ],   [      ],   ], # 燃烧虫
  :VOLCARONA     => [   [:SWARM,             :MAJESTICMOTH,    :LEVITATE,        ],   [      ],   ],

  :COBALION      => [   [:SHARPNESS,         :SWEEPINGEDGE,    :MIRRORARMOR,     ],   [      ],   ], # 勾帕路翁

  :TERRAKION     => [   [:SHARPNESS,         :MOLDBREAKER,     :SOLIDROCK,       ],   [      ],   ], # 代拉基翁

  :VIRIZION      => [   [:MIGHTYHORN,        :ABSORBANT,       :SHARPNESS,       ],   [      ],   ], # 毕力吉翁

  :TORNADUS      => [   [:PRANKSTER,         :WEATHERCONTROL,  :KEENEYE,         ],   [      ],   ], # 龙卷云
  :TORNADUS_1    => [   [:REGENERATOR,       :WEATHERCONTROL,  :KEENEYE,         ],   [      ],   ],

  :THUNDURUS     => [   [:OVERCHARGE,        :WEATHERCONTROL,  :VOLTABSORB,      ],   [      ],   ], # 雷电云
  :THUNDURUS_1   => [   [:OVERCHARGE,        :WEATHERCONTROL,  :VOLTABSORB,      ],   [      ],   ],

  :RESHIRAM      => [   [:TURBOBLAZE,        :COMBUSTION,      :WHITESMOKE,      ],   [      ],   ], # 莱希拉姆

  :ZEKROM        => [   [:TERAVOLT,          :TRANSISTOR,      :CLEARBODY,       ],   [      ],   ], # 捷克罗姆

  :LANDORUS      => [   [:SANDFORCE,         :INTIMIDATE,      :REGENERATOR,     ],   [      ],   ], # 土地云
  :LANDORUS_1    => [   [:SANDFORCE,         :INTIMIDATE,      :REGENERATOR,     ],   [      ],   ],

  :KYUREM        => [   [:ICESCALES,         :PERMAFROST,      :SNOWFORCE,       ],   [      ],   ], # 酋雷姆
  :KYUREM_1      => [   [:TURBOBLAZE,        :PERMAFROST,      :SNOWFORCE,       ],   [      ],   ],
  :KYUREM_2      => [   [:TERAVOLT,          :PERMAFROST,      :SNOWFORCE,       ],   [      ],   ],
  :KYUREM_3      => [   [:TURBOBLAZE,        :PERMAFROST,      :SNOWFORCE,       ],   [      ],   ],
  :KYUREM_4      => [   [:TERAVOLT,          :PERMAFROST,      :SNOWFORCE,       ],   [      ],   ],

  :KELDEO        => [   [:STEADFAST,         :FIELDEXPLORER,   :SHARPNESS,       ],   [      ],   ], # 凯路迪欧
  :KELDEO_1      => [   [:STEADFAST,         :FIELDEXPLORER,   :SHARPNESS,       ],   [      ],   ],

  :MELOETTA      => [   [:SERENEGRACE,       :INNERFOCUS,      :PRANKSTER,       ],   [      ],   ], # 美洛耶塔
  :MELOETTA_1    => [   [:SERENEGRACE,       :INNERFOCUS,      :STRIKER,         ],   [      ],   ],

  :GENESECT      => [   [:MEGALAUNCHER,      :PREDATOR,        :FULLMETALBODY,   ],   [      ],   ], # 盖诺赛克特
  :GENESECT_1    => [   [:MEGALAUNCHER,      :PREDATOR,        :FULLMETALBODY,   ],   [      ],   ],
  :GENESECT_2    => [   [:MEGALAUNCHER,      :PREDATOR,        :FULLMETALBODY,   ],   [      ],   ],
  :GENESECT_3    => [   [:MEGALAUNCHER,      :PREDATOR,        :FULLMETALBODY,   ],   [      ],   ],
  :GENESECT_4    => [   [:MEGALAUNCHER,      :PREDATOR,        :FULLMETALBODY,   ],   [      ],   ],

  :CHESPIN       => [   [:OVERGROW,          :SHELLARMOR,      :BULLETPROOF,     ],   [      ],   ], # 哈力栗
  :QUILLADIN     => [   [:OVERGROW,          :SHELLARMOR,      :BULLETPROOF,     ],   [      ],   ],
  :CHESNAUGHT    => [   [:OVERGROW,          :SHELLARMOR,      :LOOSEQUILLS,     ],   [      ],   ],

  :FENNEKIN      => [   [:BLAZE,             :PYROMANCY,       :PSYCHICMIND,     ],   [      ],   ], # 火狐狸
  :BRAIXEN       => [   [:BLAZE,             :PYROMANCY,       :PSYCHICMIND,     ],   [      ],   ],
  :DELPHOX       => [   [:BLAZE,             :MAGICGUARD,      :PSYCHICMIND,     ],   [      ],   ],
  :DELPHOX_1     => [   [:BLAZE,             :MAGICGUARD,      :PSYCHICMIND,     ],   [      ],   ],
  :DELPHOX_2     => [   [:BLAZE,             :MAGICGUARD,      :PSYCHICMIND,     ],   [      ],   ],

  :FROAKIE       => [   [:TORRENT,           :SKILLLINK,       :LONGREACH,       ],   [      ],   ], # 呱呱泡蛙
  :FROGADIER     => [   [:TORRENT,           :SKILLLINK,       :LONGREACH,       ],   [      ],   ],
  :GRENINJA      => [   [:TORRENT,           :SKILLLINK,       :LONGREACH,       ],   [      ],   ],
  :GRENINJA_1    => [   [:TORRENT,           :SKILLLINK,       :LONGREACH,       ],   [      ],   ],
  :GRENINJA_2    => [   [:TORRENT,           :SKILLLINK,       :LONGREACH,       ],   [      ],   ],

  :BUNNELBY      => [   [:HUGEPOWER,         :GROWINGTOOTH,    :QUICKFEET,       ],   [      ],   ], # 掘掘兔
  :DIGGERSBY     => [   [:HUGEPOWER,         :GROWINGTOOTH,    :SHEERFORCE,      ],   [      ],   ],

  :FLETCHLING    => [   [:FLIGHT,            :KEENEYE,         :GALEWINGS,       ],   [      ],   ], # 小箭雀
  :FLETCHINDER   => [   [:FLIGHT,            :KEENEYE,         :GALEWINGS,       ],   [      ],   ],
  :TALONFLAME    => [   [:FLIGHT,            :VIOLENTRUSH,     :GALEWINGS,       ],   [      ],   ],

  :SCATTERBUG    => [   [:SHIELDDUST,        :COMPOUNDEYES,    :QUICKFEET,       ],   [      ],   ], # 粉蝶虫
  :SPEWPA        => [   [:SHIELDDUST,        :COMPOUNDEYES,    :SHEDSKIN,        ],   [      ],   ],
  :VIVILLON      => [   [:SHIELDDUST,        :COMPOUNDEYES,    :MAJESTICMOTH,    ],   [      ],   ],

  :LITLEO        => [   [:RIVALRY,           :QUICKFEET,       :RUNAWAY,         ],   [      ],   ], # 小狮狮
  :PYROAR        => [   [:HUBRIS,            :OPPORTUNIST2,    :PREDATOR,        ],   [      ],   ],

  :FLABEBE       => [   [:NATURALCURE,       :ABSORBANT,       :PUREHEART,       ],   [      ],   ], # 花蓓蓓
  :FLOETTE       => [   [:NATURALCURE,       :ABSORBANT,       :PUREHEART,       ],   [      ],   ],
  :FLORGES       => [   [:NATURALCURE,       :REGENERATOR,     :PUREHEART,       ],   [      ],   ],

  :SKIDDO        => [   [:SAPSIPPER,         :MOUNTAINEER,     :FURCOAT,         ],   [      ],   ], # 坐骑小羊
  :GOGOAT        => [   [:SAPSIPPER,         :MOUNTAINEER,     :FURCOAT,         ],   [      ],   ],

  :PANCHAM       => [   [:SCRAPPY,           :ANGERPOINT,      :HYPERAGGRESSIVE, ],   [      ],   ], # 顽皮熊猫
  :PANGORO       => [   [:SCRAPPY,           :ANGERPOINT,      :HYPERAGGRESSIVE, ],   [      ],   ],

  :FURFROU       => [   [:FURCOAT,           :OVERCOAT,        :FLUFFY,          ],   [      ],   ], # 多丽米亚

  :ESPURR        => [   [:KEENEYE,           :OWNTEMPO,        :PSYCHICMIND,     ],   [      ],   ], # 妙喵
  :MEOWSTIC      => [   [:PSYCHICMIND,       :INFILTRATOR,     :SOULHEART,       ],   [      ],   ],
  :MEOWSTIC_1    => [   [:PSYCHICMIND,       :COMPETITIVE,     :HYPERAGGRESSIVE, ],   [      ],   ],

  :HONEDGE       => [   [:LEVITATE,          :SHARPNESS,       :SOULEATER,       ],   [      ],   ], # 独剑鞘
  :DOUBLADE      => [   [:LEVITATE,          :SHARPNESS,       :MULTIHEADED,     ],   [      ],   ],
  :AEGISLASH     => [   [:LEVITATE,          :SHARPNESS,       :STANCECHANGE,    ],   [      ],   ],

  :SPRITZEE      => [   [:HEALER,            :PIXILATE,        :SOOTHINGAROMA,   ],   [      ],   ], # 粉香香
  :AROMATISSE    => [   [:HEALER,            :PIXILATE,        :SOOTHINGAROMA,   ],   [      ],   ],

  :SWIRLIX       => [   [:GOOEY,             :PIXILATE,        :STICKYHOLD,      ],   [      ],   ], # 绵绵泡芙
  :SLURPUFF      => [   [:GOOEY,             :PIXILATE,        :STICKYHOLD,      ],   [      ],   ],

  :INKAY         => [   [:HYPNOTIST,         :CONTRARY,        :ILLUMINATE,      ],   [      ],   ], # 好啦鱿
  :MALAMAR       => [   [:HYPNOTIST,         :CONTRARY,        :BIGPECKS,        ],   [      ],   ],

  :BINACLE       => [   [:MULTIHEADED,       :TOUGHCLAWS,      :SNIPER,          ],   [      ],   ], # 龟脚脚
  :BARBARACLE    => [   [:MULTIHEADED,       :TOUGHCLAWS,      :SNIPER,          ],   [      ],   ],

  :SKRELP        => [   [:ADAPTABILITY,      :POISONTOUCH,     :CONTRARY,        ],   [      ],   ], # 垃垃藻
  :DRAGALGE      => [   [:ADAPTABILITY,      :CONTRARY,        :AQUATIC,         ],   [      ],   ],

  :CLAUNCHER     => [   [:SWIFTSWIM,         :SHELLARMOR,      :MEGALAUNCHER,    ],   [      ],   ], # 铁臂枪虾
  :CLAWITZER     => [   [:HYDRATE,           :SHELLARMOR,      :MEGALAUNCHER,    ],   [      ],   ],

  :HELIOPTILE    => [   [:PLUS,              :DRYSKIN,         :SANDVEIL,        ],   [      ],   ], # 伞电蜥
  :HELIOLISK     => [   [:LIGHTNINGROD,      :SHORTCIRCUIT,    :GENERATOR,       ],   [      ],   ],

  :TYRUNT        => [   [:FOSSILIZED,        :STRONGJAW,       :HYPERAGGRESSIVE, ],   [      ],   ], # 宝宝暴龙
  :TYRANTRUM     => [   [:PREDATOR,          :JUGGERNAUT,      :HYPERAGGRESSIVE, ],   [      ],   ],

  :AMAURA        => [   [:FOSSILIZED,        :PRIMALARMOR,     :PERMAFROST,      ],   [      ],   ], # 冰雪龙
  :AURORUS       => [   [:PRIMALARMOR,       :ICEBODY,         :PERMAFROST,      ],   [      ],   ],

  :HAWLUCHA      => [   [:LIMBER,            :NOGUARD,         :AERODYNAMICS,    ],   [      ],   ], # 摔角鹰人

  :DEDENNE       => [   [:RETRIEVER,         :ELECTROCYTES,    :GLUTTONY,        ],   [      ],   ], # 咚咚鼠

  :CARBINK       => [   [:CLEARBODY,         :IMPENETRABLE,    :MOUNTAINEER,     ],   [      ],   ], # 小碎钻

  :GOOMY         => [   [:AMPHIBIOUS,        :POISONHEAL,      :HYDRATE,         ],   [      ],   ], # 黏黏宝
  :SLIGGOO       => [   [:AMPHIBIOUS,        :POISONHEAL,      :STICKYHOLD,      ],   [      ],   ],
  :SLIGGOO_1     => [   [:SHELLARMOR,        :IMPENETRABLE,    :FILTER,          ],   [      ],   ],
  :GOODRA        => [   [:AMPHIBIOUS,        :POISONHEAL,      :HYDRATE,         ],   [      ],   ],
  :GOODRA_1      => [   [:SHELLARMOR,        :IMPENETRABLE,    :FILTER,          ],   [      ],   ],

  :KLEFKI        => [   [:PRANKSTER,         :FULLMETALBODY,   :IRONBARBS,       ],   [      ],   ], # 钥圈儿

  :PHANTUMP      => [   [:NATURALCURE,       :HARVEST,         :HAUNTEDSPIRIT,   ],   [      ],   ], # 小木灵
  :TREVENANT     => [   [:TOUGHCLAWS,        :HARVEST,         :HAUNTEDSPIRIT,   ],   [      ],   ],

  :PUMPKABOO     => [   [:INSOMNIA,          :CURSEDBODY,      :HAUNTEDSPIRIT,   ],   [      ],   ], # 南瓜精
  :GOURGEIST     => [   [:INSOMNIA,          :CURSEDBODY,      :HAUNTEDSPIRIT,   ],   [      ],   ],
  :GOURGEIST_1   => [   [:PICKUP,            :DISHEARTEN,      :MONSTERMASH,     ],   [      ],   ], # 普通尺寸
  :GOURGEIST_2   => [   [:INSOMNIA,          :CURSEDBODY,      :HAUNTEDSPIRIT,   ],   [      ],   ], # 大尺寸
  :GOURGEIST_3   => [   [:INSOMNIA,          :CURSEDBODY,      :HAUNTEDSPIRIT,   ],   [      ],   ], # 特大尺寸

  :BERGMITE      => [   [:PERMAFROST,        :IMPENETRABLE,    :SELFHEAL,        ],   [      ],   ], # 冰宝
  :AVALUGG       => [   [:PERMAFROST,        :IMPENETRABLE,    :SELFHEAL,        ],   [      ],   ],

  :NOIBAT        => [   [:LOUDBANG,          :HYPERAGGRESSIVE, :NOCTURNAL,       ],   [      ],   ], # 嗡蝠
  :NOIVERN       => [   [:LOUDBANG,          :NOCTURNAL,       :HYPERAGGRESSIVE, ],   [      ],   ],

  :XERNEAS       => [   [:FAIRYAURA,         :ILLUMINATE,      :SOULHEART,       ],   [      ],   ], # 哲尔尼亚斯
  :XERNEAS_1     => [   [:FAIRYAURA,         :ILLUMINATE,      :SOULHEART,       ],   [      ],   ],

  :YVELTAL       => [   [:DARKAURA,          :AIRBLOWER,       :GIANTWINGS,      ],   [      ],   ], # 伊裴尔塔尔

  :ZYGARDE       => [   [:PRIMALARMOR,       :EARTHBOUND,      :POWERCORE,       ],   [      ],   ], # 基格尔德
  :ZYGARDE_1     => [   [:PRIMALARMOR,       :EARTHBOUND,      :POWERCORE,       ],   [      ],   ],
  :ZYGARDE_2     => [   [:PRIMALARMOR,       :EARTHBOUND,      :POWERCORE,       ],   [      ],   ],
  :ZYGARDE_3     => [   [:PRIMALARMOR,       :EARTHBOUND,      :POWERCORE,       ],   [      ],   ],

  :DIANCIE       => [   [:CLEARBODY,         :LEVITATE,        :MOUNTAINEER,     ],   [      ],   ], # 蒂安希
  :DIANCIE_1     => [   [:CLEARBODY,         :LEVITATE,        :MAGICGUARD,      ],   [      ],   ],

  :HOOPA         => [   [:PRANKSTER,         :VENGEANCE,       :HYPNOTIST,       ],   [      ],   ], # 胡帕
  :HOOPA_1       => [   [:SOULEATER,         :HYPERAGGRESSIVE, :INFILTRATOR,     ],   [      ],   ],

  :VOLCANION     => [   [:ARTILLERY,         :STORMDRAIN,      :FLASHFIRE,       ],   [      ],   ], # 波尔凯尼恩

  :ROWLET        => [   [:OVERGROW,          :NOCTURNAL,       :CHLOROPHYLL,     ],   [      ],   ], # 木木枭
  :DARTRIX       => [   [:OVERGROW,          :FATALPRECISION,  :SHARPNESS,       ],   [      ],   ],
  :DECIDUEYE     => [   [:OVERGROW,          :SNIPER,          :AERODYNAMICS,    ],   [      ],   ],
  :DECIDUEYE_1   => [   [:OVERGROW,          :SNIPER,          :AERODYNAMICS,    ],   [      ],   ],
  :DECIDUEYE_2   => [   [:OVERGROW,          :SNIPER,          :AERODYNAMICS,    ],   [      ],   ],
  :DECIDUEYE_3   => [   [:OVERGROW,          :SNIPER,          :ARCHER,          ],   [      ],   ],

  :LITTEN        => [   [:BLAZE,             :FLAMEBODY,       :RUNAWAY,         ],   [      ],   ], # 火斑喵
  :TORRACAT      => [   [:BLAZE,             :FLAMEBODY,       :STRIKER,         ],   [      ],   ],
  :INCINEROAR    => [   [:BLAZE,             :COMBATSPECIALIST,:ANGERPOINT,      ],   [      ],   ],

  :POPPLIO       => [   [:TORRENT,           :SERENEGRACE,     :DANCER,          ],   [      ],   ], # 球球海狮
  :BRIONNE       => [   [:TORRENT,           :PIXILATE,        :DANCER,          ],   [      ],   ],
  :PRIMARINA     => [   [:TORRENT,           :LIQUIDVOICE,     :SERENEGRACE,     ],   [      ],   ],

  :PIKIPEK       => [   [:FLIGHT,            :KEENEYE,         :SKILLLINK,       ],   [      ],   ], # 小笃儿
  :TRUMBEAK      => [   [:FLIGHT,            :KEENEYE,         :SKILLLINK,       ],   [      ],   ],
  :TOUCANNON     => [   [:FLIGHT,            :KEENEYE,         :SKILLLINK,       ],   [      ],   ],

  :YUNGOOS       => [   [:STAKEOUT,          :STRONGJAW,       :PREDATOR,        ],   [      ],   ], # 猫鼬少
  :GUMSHOOS      => [   [:STAKEOUT,          :STRONGJAW,       :PREDATOR,        ],   [      ],   ],

  :GRUBBIN       => [   [:SWARM,             :SAPSIPPER,       :RUNAWAY,         ],   [      ],   ], # 强颚鸡母虫
  :CHARJABUG     => [   [:SWARM,             :BATTERY,         :MINUS,           ],   [      ],   ],
  :VIKAVOLT      => [   [:SWARM,             :LEVITATE,        :ELECTROCYTES,    ],   [      ],   ],

  :CRABRAWLER    => [   [:GRIPPINCER,        :ANGERPOINT,      :MOXIE,           ],   [      ],   ], # 好胜蟹
  :CRABOMINABLE  => [   [:GRIPPINCER,        :ANGERPOINT,      :PERMAFROST,      ],   [      ],   ],

  :ORICORIO      => [   [:SERENEGRACE,       :FLASHFIRE,       :FLIGHT,          ],   [      ],   ], # 花舞鸟
  :ORICORIO_1    => [   [:SERENEGRACE,       :LIGHTNINGROD,    :FLIGHT,          ],   [      ],   ], # 啪滋啪滋
  :ORICORIO_2    => [   [:SERENEGRACE,       :PSYCHICMIND,     :FLIGHT,          ],   [      ],   ], # 呼拉呼拉
  :ORICORIO_3    => [   [:SERENEGRACE,       :PHANTOMPAIN,     :FLIGHT,          ],   [      ],   ], # 轻盈轻盈

  :CUTIEFLY      => [   [:LEVITATE,          :SHIELDDUST,      :EFFECTSPORE,     ],   [      ],   ], # 萌虻
  :RIBOMBEE      => [   [:LEVITATE,          :SHIELDDUST,      :EFFECTSPORE,     ],   [      ],   ],

  :ROCKRUFF      => [   [:KEENEYE,           :OPPORTUNIST2,    :ROCKHEAD,        ],   [      ],   ], # 岩狗狗
  :LYCANROC      => [   [:OPPORTUNIST2,      :SANDRUSH,        :ROCKHEAD,        ],   [      ],   ],
  :LYCANROC_1    => [   [:NOGUARD,           :NOCTURNAL,       :HYPERAGGRESSIVE, ],   [      ],   ],
  :LYCANROC_2    => [   [:OPPORTUNIST2,      :FATALPRECISION,  :ROCKHEAD,        ],   [      ],   ],
  :LYCANROC_3    => [   [:OPPORTUNIST2,      :FATALPRECISION,  :ROCKHEAD,        ],   [      ],   ],
  :LYCANROC_4    => [   [:NOGUARD,           :NOCTURNAL,       :HYPERAGGRESSIVE, ],   [      ],   ],

  :WISHIWASHI    => [   [:WATERVEIL,         :REGENERATOR,     :MULTISCALE,      ],   [      ],   ], # 弱丁鱼

  :MAREANIE      => [   [:POISONPOINT,       :REGENERATOR,     :ROUGHSKIN,       ],   [      ],   ], # 好坏星
  :TOXAPEX       => [   [:POISONPOINT,       :REGENERATOR,     :ROUGHSKIN,       ],   [      ],   ],

  :MUDBRAY       => [   [:STAMINA,           :BATTLEARMOR,     :WATERCOMPACTION, ],   [      ],   ], # 泥驴仔
  :MUDSDALE      => [   [:STAMINA,           :BATTLEARMOR,     :WATERCOMPACTION, ],   [      ],   ],

  :DEWPIDER      => [   [:WATERABSORB,       :SPIDERLAIR,      :RUNAWAY,         ],   [      ],   ], # 滴蛛
  :ARAQUANID     => [   [:WATERBUBBLE,       :WATERABSORB,     :PREDATOR,        ],   [      ],   ],

  :FOMANTIS      => [   [:CHLOROPHYLL,       :OPPORTUNIST2,    :LEAFGUARD,       ],   [      ],   ], # 伪螳草
  :LURANTIS      => [   [:SHARPNESS,         :OPPORTUNIST2,    :HYPERCUTTER,     ],   [      ],   ],

  :MORELULL      => [   [:EFFECTSPORE,       :DRYSKIN,         :ILLUMINATE,      ],   [      ],   ], # 睡睡菇
  :SHIINOTIC     => [   [:POISONENGULF,      :FAIRYAURA,       :BADDREAMS,       ],   [      ],   ],

  :SALANDIT      => [   [:CORROSION,         :POISONTOUCH,     :POISONENGULF,    ],   [      ],   ], # 夜盗火蜥
  :SALAZZLE      => [   [:CORROSION,         :QUEENLYMAJESTY,  :HALFDRAKE,       ],   [      ],   ],

  :STUFFUL       => [   [:FLUFFY,            :GUTS,            :CUTECHARM,       ],   [      ],   ], # 童偶熊
  :BEWEAR        => [   [:FLUFFY,            :UNAWARE,         :LUMBERJACK,      ],   [      ],   ],

  :BOUNSWEET     => [   [:LEAFGUARD,         :SWEETVEIL,       :RECKLESS,        ],   [      ],   ], # 甜竹竹
  :STEENEE       => [   [:LEAFGUARD,         :SWEETVEIL,       :RECKLESS,        ],   [      ],   ],
  :TSAREENA      => [   [:PREDATOR,          :STRIKER,         :QUEENLYMAJESTY,  ],   [      ],   ],

  :COMFEY        => [   [:NATURALCURE,       :HEALER,          :REGENERATOR,     ],   [      ],   ], # 花疗环环

  :ORANGURU      => [   [:INNERFOCUS,        :PSYCHICMIND,     :HEALER,          ],   [      ],   ], # 智挥猩

  :PASSIMIAN     => [   [:HARVEST,           :AVENGER,         :DEFIANT,         ],   [      ],   ], # 投掷猴

  :WIMPOD        => [   [:SHELLARMOR,        :COWARD,          :PREDATOR,        ],   [      ],   ], # 胆小虫
  :GOLISOPOD     => [   [:SHELLARMOR,        :COWARD,          :HYPERCUTTER,     ],   [      ],   ],

  :SANDYGAST     => [   [:WATERCOMPACTION,   :SANDFORCE,       :SANDVEIL,        ],   [      ],   ], # 沙丘娃
  :PALOSSAND     => [   [:WATERCOMPACTION,   :SANDGUARD,       :SELFHEAL,        ],   [      ],   ],

  :PYUKUMUKU     => [   [:UNAWARE,           :PRESSURE,        :PERISHBODY,      ],   [      ],   ], # 拳海参

  :TYPENULL      => [   [:BATTLEARMOR,       :ANGERPOINT,      :PRISMARMOR,      ],   [      ],   ], # 属性：空
  :SILVALLY      => [   [:ADAPTABILITY,      :ANGERPOINT,      :PRIMALARMOR,     ],   [      ],   ],

  :MINIOR        => [   [:WEAKARMOR,         :POWERCORE,       :LOOSEROCKS,      ],   [      ],   ], # 小陨星
  :MINIOR_7      => [   [:ACCELERATE,        :POWERCORE,       :EQUINOX,         ],   [      ],   ],
  :MINIOR_8      => [   [:ACCELERATE,        :POWERCORE,       :EQUINOX,         ],   [      ],   ],
  :MINIOR_9      => [   [:ACCELERATE,        :POWERCORE,       :EQUINOX,         ],   [      ],   ],
  :MINIOR_10     => [   [:ACCELERATE,        :POWERCORE,       :EQUINOX,         ],   [      ],   ],
  :MINIOR_11     => [   [:ACCELERATE,        :POWERCORE,       :EQUINOX,         ],   [      ],   ],
  :MINIOR_12     => [   [:ACCELERATE,        :POWERCORE,       :EQUINOX,         ],   [      ],   ],
  :MINIOR_13     => [   [:ACCELERATE,        :POWERCORE,       :EQUINOX,         ],   [      ],   ],

  :KOMALA        => [   [:COMATOSE,          :POISONENGULF,    :SAPSIPPER,       ],   [      ],   ], # 树枕尾熊

  :TURTONATOR    => [   [:SHELLARMOR,        :IRONBARBS,       :DAUNTLESSSHIELD, ],   [      ],   ], # 爆焰龟兽

  :TOGEDEMARU    => [   [:IRONBARBS,         :LIGHTNINGROD,    :LOOSEQUILLS,     ],   [      ],   ], # 托戈德玛尔

  :MIMIKYU       => [   [:VENGEANCE,         :SPITEFUL,        :PHANTOMPAIN,     ],   [      ],   ], # 谜拟Ｑ

  :BRUXISH       => [   [:STRONGJAW,         :WONDERSKIN,      :PSYCHICMIND,     ],   [      ],   ], # 磨牙彩皮鱼

  :DRAMPA        => [   [:AVENGER,           :RAMPAGE,         :FLUFFY,          ],   [      ],   ], # 老翁龙

  :DHELMISE      => [   [:METALLIC,          :SEAWEED,         :STEELWORKER,     ],   [      ],   ], # 破破舵轮

  :JANGMOO       => [   [:OVERCOAT,          :BATTLEARMOR,     :MOUNTAINEER,     ],   [      ],   ], # 心鳞宝
  :HAKAMOO       => [   [:OVERCOAT,          :BATTLEARMOR,     :MOUNTAINEER,     ],   [      ],   ],
  :KOMMOO        => [   [:PRISMSCALES,       :BATTLEARMOR,     :PRISMARMOR,      ],   [      ],   ],

  :TAPUKOKO      => [   [:LEVITATE,          :ELECTRICSURGE,   :DRIZZLE,         ],   [      ],   ], # 卡璞·鸣鸣

  :TAPULELE      => [   [:BERSERK,           :PSYCHICSURGE,    :MULTISCALE,      ],   [      ],   ], # 卡璞·蝶蝶

  :TAPUBULU      => [   [:MIGHTYHORN,        :GRASSYSURGE,     :REGENERATOR,     ],   [      ],   ], # 卡璞·哞哞

  :TAPUFINI      => [   [:SERENEGRACE,       :MISTYSURGE,      :SHELLARMOR,      ],   [      ],   ], # 卡璞·鳍鳍

  :COSMOG        => [   [:LEVITATE,          :POWERCORE,       :SHELLARMOR,      ],   [      ],   ], # 科斯莫古
  :COSMOEM       => [   [:LEVITATE,          :POWERCORE,       :SHELLARMOR,      ],   [      ],   ],
  :SOLGALEO      => [   [:SOLARFLARE,        :FULLMETALBODY,   :PRISMARMOR,      ],   [      ],   ],
  :LUNALA        => [   [:LUNARECLIPSE,      :SHADOWSHIELD,    :DREAMCATCHER,    ],   [      ],   ],

  :NIHILEGO      => [   [:BEASTBOOST,        :LEVITATE,        :HYPERAGGRESSIVE, ],   [      ],   ], # 虚吾伊德

  :BUZZWOLE      => [   [:BEASTBOOST,        :IRONFIST,        :RAGINGBOXER,     ],   [      ],   ], # 爆肌蚊

  :PHEROMOSA     => [   [:BEASTBOOST,        :SPEEDBOOST,      :STRIKER,         ],   [      ],   ], # 费洛美螂

  :XURKITREE     => [   [:BEASTBOOST,        :VOLTRUSH,        :INFILTRATOR,     ],   [      ],   ], # 电束木

  :CELESTEELA    => [   [:BEASTBOOST,        :BATTLEARMOR,     :LEADCOAT,        ],   [      ],   ], # 铁火辉夜

  :KARTANA       => [   [:BEASTBOOST,        :HYPERCUTTER,     :SWEEPINGEDGE,    ],   [      ],   ], # 纸御剑

  :GUZZLORD      => [   [:BEASTBOOST,        :THICKFAT,        :JAWSOFCARNAGE,   ],   [      ],   ], # 恶食大王

  :NECROZMA      => [   [:PRISMARMOR,        :METALLIC,        :FILTER,          ],   [      ],   ], # 奈克洛兹玛
  :NECROZMA_1    => [   [:SOLARFLARE,        :IMPENETRABLE,    :PRISMARMOR,      ],   [      ],   ], # 黄昏之鬃
  :NECROZMA_2    => [   [:LUNARECLIPSE,      :SHADOWSHIELD,    :LEVITATE,        ],   [      ],   ], # 拂晓之翼
  :NECROZMA_3    => [   [:BEASTBOOST,        :NEUROFORCE,      :LEVITATE,        ],   [      ],   ],
  :NECROZMA_4    => [   [:BEASTBOOST,        :NEUROFORCE,      :LEVITATE,        ],   [      ],   ],

  :MAGEARNA      => [   [:MIRRORARMOR,       :SOULHEART,       :POWERCORE,       ],   [      ],   ], # 玛机雅娜
  :MAGEARNA_1    => [   [:CLEARBODY,         :SOULHEART,       :POWERCORE,       ],   [      ],   ],

  :MARSHADOW     => [   [:COMBATSPECIALIST,  :PHANTOMTHIEF,    :UNSEENFIST,      ],   [      ],   ], # 玛夏多

  :POIPOLE       => [   [:BEASTBOOST,        :LEVITATE ,       :ANALYTIC,        ],   [      ],   ], # 毒贝比
  :NAGANADEL     => [   [:BEASTBOOST,        :LEVITATE,        :MERCILESS,       ],   [      ],   ],

  :STAKATAKA     => [   [:BEASTBOOST,        :LEADCOAT,        :FORTKNOX,        ],   [      ],   ], # 垒磊石

  :BLACEPHALON   => [   [:BEASTBOOST,        :RECKLESS,        :PYROMANCY,       ],   [      ],   ], # 砰头小丑

  :ZERAORA       => [   [:SPEEDFORCE,        :VOLTABSORB,      :TOUGHCLAWS,      ],   [      ],   ], # 捷拉奥拉

  :MELTAN        => [   [:STURDY,            :GALVANIZE,       :IRONFIST,        ],   [      ],   ], # 美录坦
  :MELMETAL      => [   [:MAGNETPULL,        :IRONFIST,        :JUGGERNAUT,      ],   [      ],   ],

  :GROOKEY       => [   [:OVERGROW,          :SOUNDPROOF,      :VIOLENTRUSH,     ],   [      ],   ], # 敲音猴
  :THWACKEY      => [   [:OVERGROW,          :SOUNDPROOF,      :VIOLENTRUSH,     ],   [      ],   ],
  :RILLABOOM     => [   [:OVERGROW,          :SOUNDPROOF,      :GRASSYSURGE,     ],   [      ],   ],

  :SCORBUNNY     => [   [:BLAZE,             :STRIKER,         :LIMBER,          ],   [      ],   ], # 炎兔儿
  :RABOOT        => [   [:BLAZE,             :STRIKER,         :LIMBER,          ],   [      ],   ],
  :CINDERACE     => [   [:BLAZE,             :STRIKER,         :LIBERO,          ],   [      ],   ],

  :SOBBLE        => [   [:TORRENT,           :IMMUNITY,        :RUNAWAY,         ],   [      ],   ], # 泪眼蜥
  :DRIZZILE      => [   [:TORRENT,           :IMMUNITY,        :DEADEYE,         ],   [      ],   ],
  :INTELEON      => [   [:TORRENT,           :MOMENTUM,        :SNIPER,          ],   [      ],   ],

  :SKWOVET       => [   [:GLUTTONY,          :PICKUP,          :HARVEST,         ],   [      ],   ], # 贪心栗鼠
  :GREEDENT      => [   [:GLUTTONY,          :RIPEN,           :HARVEST,         ],   [      ],   ],

  :ROOKIDEE      => [   [:INTIMIDATE,        :FLIGHT,          :UNNERVE,         ],   [      ],   ], # 稚山雀
  :CORVISQUIRE   => [   [:INTIMIDATE,        :FLIGHT,          :UNNERVE,         ],   [      ],   ],
  :CORVIKNIGHT   => [   [:PRESSURE,          :GIANTWINGS,      :MIRRORARMOR,     ],   [      ],   ],

  :BLIPBUG       => [   [:COMPOUNDEYES,      :SIMPLE,          :ANALYTIC,        ],   [      ],   ], # 索侦虫
  :DOTTLER       => [   [:COMPOUNDEYES,      :SHELLARMOR,      :MAGICBOUNCE,     ],   [      ],   ],
  :ORBEETLE      => [   [:ANALYTIC,          :GRAVITYWELL,     :MAGICBOUNCE,     ],   [      ],   ],

  :NICKIT        => [   [:PICKUP,            :CHEAPTACTICS,    :PICKPOCKET,      ],   [      ],   ], # 偷儿狐
  :THIEVUL       => [   [:PICKUP,            :CHEAPTACTICS,    :PICKPOCKET,      ],   [      ],   ],

  :GOSSIFLEUR    => [   [:EFFECTSPORE,       :REGENERATOR,     :SUNWORSHIP,      ],   [      ],   ], # 幼棉棉
  :ELDEGOSS      => [   [:FLUFFY,            :REGENERATOR,     :EFFECTSPORE,     ],   [      ],   ],

  :WOOLOO        => [   [:DEFENCEROLL,       :FLUFFY,          :ROCKHEAD,        ],   [      ],   ], # 毛辫羊
  :DUBWOOL       => [   [:DEFENCEROLL,       :ROCKHEAD,        :FLUFFY,          ],   [      ],   ],

  :CHEWTLE       => [   [:STRONGJAW,         :SHELLARMOR,      :GROWINGTOOTH,    ],   [      ],   ], # 咬咬龟
  :DREDNAW       => [   [:LONGREACH,         :PREDATOR,        :STRONGJAW,       ],   [      ],   ],

  :YAMPER        => [   [:RUNAWAY,           :ELECTROCYTES,    :STRONGJAW,       ],   [      ],   ], # 来电汪
  :BOLTUND       => [   [:STRONGJAW,         :SPEEDBOOST,      :SHORTCIRCUIT,    ],   [      ],   ],

  :ROLYCOLY      => [   [:STEAMENGINE,       :JUGGERNAUT,      :MAGMAARMOR,      ],   [      ],   ], # 小炭仔
  :CARKOL        => [   [:STEAMENGINE,       :JUGGERNAUT,      :MAGMAARMOR,      ],   [      ],   ],
  :COALOSSAL     => [   [:STEAMENGINE,       :JUGGERNAUT,      :MAGMAARMOR,      ],   [      ],   ],

  :APPLIN        => [   [:GLUTTONY,          :SHELLARMOR,      :REGENERATOR,     ],   [      ],   ], # 啃果虫
  :FLAPPLE       => [   [:LEVITATE,          :REGENERATOR,     :CORROSION,       ],   [      ],   ],
  :APPLETUN      => [   [:HARVEST,           :RIPEN,           :THICKFAT,        ],   [      ],   ],
  :DIPPLIN       => [   [:STICKYHOLD,        :SHELLARMOR,      :SUPERHOTGOO,     ],   [      ],   ],
  :HYDRAPPLE     => [   [:MULTIHEADED,       :SHELLARMOR,      :SUPERHOTGOO,     ],   [      ],   ],

  :SILICOBRA     => [   [:SANDSPIT,          :SHEDSKIN,        :MEGALAUNCHER,    ],   [      ],   ], # 沙包蛇
  :SANDACONDA    => [   [:SANDSPIT,          :SHEDSKIN,        :MEGALAUNCHER,    ],   [      ],   ],

  :CRAMORANT     => [   [:SELFHEAL,          :FIELDEXPLORER,   :SWIFTSWIM,       ],   [      ],   ], # 古月鸟

  :ARROKUDA      => [   [:PROPELLERTAIL,     :SPEEDFORCE,      :RECKLESS,        ],   [      ],   ], # 刺梭鱼
  :BARRASKEWDA   => [   [:SPEEDBOOST,        :SPEEDFORCE,      :RECKLESS,        ],   [      ],   ],

  :TOXEL         => [   [:PLUS,              :WATERABSORB,     :POISONTOUCH,     ],   [      ],   ], # 毒电婴
  :TOXTRICITY    => [   [:BASSBOOSTED,       :LOUDBANG,        :WATERABSORB,     ],   [      ],   ],
  :TOXTRICITY_1  => [   [:BASSBOOSTED,       :LOUDBANG,        :WATERABSORB,     ],   [      ],   ], # 低调的样子
  :TOXTRICITY_2  => [   [:BASSBOOSTED,       :LOUDBANG,        :WATERABSORB,     ],   [      ],   ],

  :SIZZLIPEDE    => [   [:FLASHFIRE,         :WHITESMOKE,      :FLAMEBODY,       ],   [      ],   ], # 烧火蚣
  :CENTISKORCH   => [   [:COILUP,            :HYPERAGGRESSIVE, :MOLTENDOWN,      ],   [      ],   ],

  :CLOBBOPUS     => [   [:LIMBER,            :GRAPPLER,        :REGENERATOR,     ],   [      ],   ], # 拳拳蛸
  :GRAPPLOCT     => [   [:LIMBER,            :GRAPPLER,        :REGENERATOR,     ],   [      ],   ],

  :SINISTEA      => [   [:CURSEDBODY,        :SELFHEAL,        :WATERABSORB,     ],   [      ],   ], # 来悲茶
  :POLTEAGEIST   => [   [:CURSEDBODY,        :LIQUIFIED,       :WATERABSORB,     ],   [      ],   ],

  :HATENNA       => [   [:PIXILATE,          :MAGICBOUNCE,     :HEALER,          ],   [      ],   ], # 迷布莉姆
  :HATTREM       => [   [:PIXILATE,          :HYPERAGGRESSIVE, :MAGICBOUNCE,     ],   [      ],   ],
  :HATTERENE     => [   [:PIXILATE,          :MAGICBOUNCE,     :HYPERAGGRESSIVE, ],   [      ],   ],

  :IMPIDIMP      => [   [:DISHEARTEN,        :PICKPOCKET,      :FRISK,           ],   [      ],   ], # 捣蛋小妖
  :MORGREM       => [   [:DISHEARTEN,        :PICKPOCKET,      :FRISK,           ],   [      ],   ],
  :GRIMMSNARL    => [   [:FURCOAT,           :INTIMIDATE,      :DISHEARTEN,      ],   [      ],   ],

  :MILCERY       => [   [:FLUFFY,            :AROMAVEIL,       :SELFHEAL,        ],   [      ],   ], # 小仙奶
  :ALCREMIE      => [   [:FLUFFY,            :AROMAVEIL,       :SELFHEAL,        ],   [      ],   ],

  :FALINKS       => [   [:MIGHTYHORN,        :FIGHTITE,        :FATALPRECISION,  ],   [      ],   ], # 列阵兵

  :PINCURCHIN    => [   [:ELECTROMORPHOSIS,  :LOOSEQUILLS,     :ELECTRICSURGE,   ],   [      ],   ], # 啪嚓海胆

  :SNOM          => [   [:ICESCALES,         :SWARM,           :OVERCOAT,        ],   [      ],   ], # 雪吞虫
  :FROSMOTH      => [   [:ICESCALES,         :MAJESTICMOTH,    :LEVITATE,        ],   [      ],   ],

  :STONJOURNER   => [   [:STRIKER,           :POWERSPOT,       :SOLIDROCK,       ],   [      ],   ], # 巨石丁
  :STONJOURNER_1 => [   [:STRIKER,           :POWERSPOT,       :SOLIDROCK,       ],   [      ],   ],

  :EISCUE        => [   [:ICEFACE,           :ANTARCTICBIRD,   :AMPHIBIOUS,      ],   [      ],   ], # 冰砌鹅

  :INDEEDEE      => [   [:PSYCHICSURGE,      :SYNCHRONIZE,     :INNERFOCUS,      ],   [      ],   ], # 爱管侍
  :INDEEDEE_1    => [   [:PSYCHICSURGE,      :SYNCHRONIZE,     :INNERFOCUS,      ],   [      ],   ], # 雌性

  :MORPEKO       => [   [:CHEEKPOUCH,        :GLUTTONY,        :SPEEDFORCE,      ],   [      ],   ], # 莫鲁贝可

  :CUFANT        => [   [:HEAVYMETAL,        :LEADCOAT,        :SAPSIPPER,       ],   [      ],   ], # 铜象
  :COPPERAJAH    => [   [:HEAVYMETAL,        :LEADCOAT,        :SAPSIPPER,       ],   [      ],   ],

  :DRACOZOLT     => [   [:ELECTROCYTES,      :DRAGONSMAW,      :PREDATOR,        ],   [      ],   ], # 雷鸟龙

  :ARCTOZOLT     => [   [:FOSSILIZED,        :PREDATOR,        :ICEDEW,          ],   [      ],   ], # 雷鸟海兽

  :DRACOVISH     => [   [:FOSSILIZED,        :DRAGONSMAW,      :PREDATOR,        ],   [      ],   ], # 鳃鱼龙

  :ARCTOVISH     => [   [:FOSSILIZED,        :ICESCALES,       :PREDATOR,        ],   [      ],   ], # 鳃鱼海兽

  :DURALUDON     => [   [:MEGALAUNCHER,      :FULLMETALBODY,   :STEELBARREL,     ],   [      ],   ], # 铝钢龙
  :ARCHALUDON    => [   [:STEELBARREL,       :MEGALAUNCHER,    :FULLMETALBODY,   ],   [      ],   ],

  :DREEPY        => [   [:LEVITATE,          :CLEARBODY,       :CURSEDBODY,      ],   [      ],   ], # 多龙梅西亚
  :DRAKLOAK      => [   [:LEVITATE,          :CLEARBODY,       :CURSEDBODY,      ],   [      ],   ],
  :DRAGAPULT     => [   [:LEVITATE,          :CLEARBODY,       :HAUNTEDSPIRIT,   ],   [      ],   ],

  :ZACIAN        => [   [:INTREPIDSWORD,     :ANGERPOINT,      :SHARPNESS,       ],   [      ],   ], # 苍响
  :ZACIAN_1      => [   [:STEELWORKER,       :BATTLEARMOR,     :SHARPNESS,       ],   [      ],   ],
  :ZACIAN_2      => [   [:STEELWORKER,       :BATTLEARMOR,     :SHARPNESS,       ],   [      ],   ],

  :ZAMAZENTA     => [   [:DAUNTLESSSHIELD,   :STAMINA,         :FIGHTITE,        ],   [      ],   ], # 藏玛然特
  :ZAMAZENTA_1   => [   [:STEELWORKER,       :BATTLEARMOR,     :LEADCOAT,        ],   [      ],   ],
  :ZAMAZENTA_2   => [   [:STEELWORKER,       :BATTLEARMOR,     :LEADCOAT,        ],   [      ],   ],

  :ETERNATUS     => [   [:LEVITATE,          :MEGALAUNCHER,    :PRIMALARMOR,     ],   [      ],   ], # 无极汰那

  :KUBFU         => [   [:UNSEENFIST,        :FIGHTITE,        :INNERFOCUS,      ],   [      ],   ], # 熊徒弟
  :URSHIFU       => [   [:UNSEENFIST,        :COMBATSPECIALIST,:INNERFOCUS,      ],   [      ],   ],
  :URSHIFU_1     => [   [:UNSEENFIST,        :COMBATSPECIALIST,:INNERFOCUS,      ],   [      ],   ], # 连击流

  :ZARUDE        => [   [:TOUGHCLAWS,        :LEAFGUARD,       :OVERGROW,        ],   [      ],   ], # 萨戮德

  :REGIELEKI     => [   [:TRANSISTOR,        :GROUNDSHOCK,     :STATIC,          ],   [      ],   ], # 雷吉艾勒奇

  :REGIDRAGO     => [   [:DRAGONSMAW,        :MEGALAUNCHER,    :OVERWHELM,       ],   [      ],   ], # 雷吉铎拉戈

  :GLASTRIER     => [   [:PERMAFROST,        :STAMINA,         :SNOWFORCE,       ],   [      ],   ], # 雪暴马

  :SPECTRIER     => [   [:SHADOWSHIELD,      :DISHEARTEN,      :SPEEDBOOST,      ],   [      ],   ], # 灵幽马

  :CALYREX       => [   [:HARVEST,           :GRASSYSURGE,     :KINGSWRATH,      ],   [      ],   ], # 蕾冠王
  :CALYREX_1     => [   [:PERMAFROST,        :STAMINA,         :SNOWFORCE,       ],   [      ],   ], # 骑白马的样子
  :CALYREX_2     => [   [:SHADOWSHIELD,      :FEARMONGER,      :SPEEDBOOST,      ],   [      ],   ],

  :ENAMORUS      => [   [:CUTECHARM,         :CONTRARY,        :SERENEGRACE,     ],   [      ],   ], # 眷恋云
  :ENAMORUS_1    => [   [:CUTECHARM,         :CONTRARY,        :SERENEGRACE,     ],   [      ],   ],

  :SPRIGATITO    => [   [:OVERGROW,          :PROTEAN,         :LONGREACH,       ],   [      ],   ], # 新叶喵
  :FLORAGATO     => [   [:OVERGROW,          :PROTEAN,         :LONGREACH,       ],   [      ],   ],
  :MEOWSCARADA   => [   [:OVERGROW,          :PROTEAN,         :LONGREACH,       ],   [      ],   ],

  :FUECOCO       => [   [:BLAZE,             :UNAWARE,         :AMPLIFIER,       ],   [      ],   ], # 呆火鳄
  :CROCALOR      => [   [:BLAZE,             :UNAWARE,         :AMPLIFIER,       ],   [      ],   ],
  :SKELEDIRGE    => [   [:BLAZE,             :UNAWARE,         :AMPLIFIER,       ],   [      ],   ],

  :QUAXLY        => [   [:TORRENT,           :STRIKER,         :WATERVEIL,       ],   [      ],   ], # 润水鸭
  :QUAXWELL      => [   [:TORRENT,           :STRIKER,         :WATERVEIL,       ],   [      ],   ],
  :QUAQUAVAL     => [   [:TORRENT,           :STRIKER,         :WATERVEIL,       ],   [      ],   ],

  :LECHONK       => [   [:THICKFAT,          :GLUTTONY,        :PASTELVEIL,      ],   [      ],   ], # 爱吃豚
  :OINKOLOGNE    => [   [:THICKFAT,          :GLUTTONY,        :PASTELVEIL,      ],   [      ],   ],
  :OINKOLOGNE_1  => [   [:THICKFAT,          :GLUTTONY,        :PASTELVEIL,      ],   [      ],   ],

  :TAROUNTULA    => [   [:AMBUSH,            :EXPLOITWEAKNESS, :STAKEOUT,        ],   [      ],   ], # 团珠蛛
  :SPIDOPS       => [   [:AMBUSH,            :EXPLOITWEAKNESS, :STAKEOUT,        ],   [      ],   ],

  :NYMBLE        => [   [:VIOLENTRUSH,       :SWARM,           :STRIKER,         ],   [      ],   ], # 豆蟋蟀
  :LOKIX         => [   [:SHOWDOWNMODE,      :SWARM,           :STRIKER,         ],   [      ],   ],

  :PAWMI         => [   [:VOLTABSORB,        :FURCOAT,         :AVENGER,         ],   [      ],   ], # 布拨
  :PAWMO         => [   [:VOLTABSORB,        :FURCOAT,         :AVENGER,         ],   [      ],   ],
  :PAWMOT        => [   [:VOLTABSORB,        :FURCOAT,         :AVENGER,         ],   [      ],   ],

  :TANDEMAUS     => [   [:QUICKFEET,         :PARENTALBOND,    :TECHNICIAN,      ],   [      ],   ], # 一对鼠
  :MAUSHOLD      => [   [:QUICKFEET,         :PARENTALBOND,    :TECHNICIAN,      ],   [      ],   ],

  :FIDOUGH       => [   [:WELLBAKEDBODY,     :SHIELDDUST,      :SELFHEAL,        ],   [      ],   ], # 狗仔包
  :DACHSBUN      => [   [:WELLBAKEDBODY,     :SHIELDDUST,      :SELFHEAL,        ],   [      ],   ],

  :SMOLIV        => [   [:CHLOROPHYLL,       :CHLOROPLAST,     :OVERCOAT,        ],   [      ],   ], # 迷你芙
  :DOLLIV        => [   [:CHLOROPHYLL,       :CHLOROPLAST,     :OVERCOAT,        ],   [      ],   ],
  :ARBOLIVA      => [   [:BIGLEAVES,         :SEEDSOWER,       :OVERCOAT,        ],   [      ],   ],

  :SQUAWKABILLY  => [   [:AIRBORNE,          :FLIGHT,          :PARROTING,       ],   [      ],   ], # 怒鹦哥

  :NACLI         => [   [:PURIFYINGSALT,     :LOOSEROCKS,      :IMPENETRABLE,    ],   [      ],   ], # 盐石宝
  :NACLSTACK     => [   [:PURIFYINGSALT,     :LOOSEROCKS,      :IMPENETRABLE,    ],   [      ],   ],
  :GARGANACL     => [   [:PURIFYINGSALT,     :LOOSEROCKS,      :IMPENETRABLE,    ],   [      ],   ],

  :CHARCADET     => [   [:FLASHFIRE,         :BATTLEARMOR,     :DUALWIELD,       ],   [      ],   ], # 炭小侍
  :ARMAROUGE     => [   [:FLASHFIRE,         :ARTILLERY,       :BATTLEARMOR,     ],   [      ],   ],
  :CERULEDGE     => [   [:MOXIE,             :DUALWIELD,       :BATTLEARMOR,     ],   [      ],   ],

  :TADBULB       => [   [:ELECTROMORPHOSIS,  :DRYSKIN,         :STATIC,          ],   [      ],   ], # 光蚪仔
  :BELLIBOLT     => [   [:ELECTROMORPHOSIS,  :DRYSKIN,         :STATIC,          ],   [      ],   ],

  :WATTREL       => [   [:VOLTABSORB,        :TERMINALVELOCITY,:AIRBLOWER,       ],   [      ],   ], # 电海燕
  :KILOWATTREL   => [   [:VOLTABSORB,        :TERMINALVELOCITY,:WINDPOWER,       ],   [      ],   ],

  :MASCHIFF      => [   [:GUARDDOG,          :STRONGJAW,       :JAWSOFCARNAGE,   ],   [      ],   ], # 偶叫獒
  :MABOSSTIFF    => [   [:GUARDDOG,          :STRONGJAW,       :JAWSOFCARNAGE,   ],   [      ],   ],

  :SHROODLE      => [   [:POISONTOUCH,       :CHEAPTACTICS,    :SCRAPPY,         ],   [      ],   ], # 滋汁鼹
  :GRAFAIAI      => [   [:POISONTOUCH,       :CHEAPTACTICS,    :SCRAPPY,         ],   [      ],   ],

  :BRAMBLIN      => [   [:WINDRIDER,         :DEFENCEROLL,     :NOSFERATU,       ],   [      ],   ], # 纳噬草
  :BRAMBLEGHAST  => [   [:WINDRIDER,         :DEFENCEROLL,     :NOSFERATU,       ],   [      ],   ],

  :TOEDSCOOL     => [   [:EARTHBOUND,        :ABSORBANT,       :MYCELIUMMIGHT,   ],   [      ],   ], # 原野水母
  :TOEDSCRUEL    => [   [:EARTHBOUND,        :ABSORBANT,       :MYCELIUMMIGHT,   ],   [      ],   ],

  :KLAWF         => [   [:SHELLARMOR,        :REGENERATOR,     :FATALPRECISION,  ],   [      ],   ], # 毛崖蟹

  :CAPSAKID      => [   [:WATERABSORB,       :CHLOROPLAST,     :PYROMANCY,       ],   [      ],   ], # 热辣娃
  :SCOVILLAIN    => [   [:WATERABSORB,       :MULTIHEADED,     :PYROMANCY,       ],   [      ],   ],

  :RELLOR        => [   [:DEFENCEROLL,       :SWARM,           :SHEDSKIN,        ],   [      ],   ], # 虫滚泥
  :RABSCA        => [   [:PARENTALBOND,      :PSYCHICMIND,     :LEVITATE,        ],   [      ],   ],

  :FLITTLE       => [   [:LEVITATE,          :OPPORTUNIST,     :PSYCHICMIND,     ],   [      ],   ], # 飘飘雏
  :ESPATHRA      => [   [:OPPORTUNIST,       :SPEEDBOOST,      :PSYCHICMIND,     ],   [      ],   ],

  :TINKATINK     => [   [:SUPERSLAMMER,      :RATTLED,         :MOLDBREAKER,     ],   [      ],   ], # 小锻匠
  :TINKATUFF     => [   [:SUPERSLAMMER,      :LONGREACH,       :MOLDBREAKER,     ],   [      ],   ],
  :TINKATON      => [   [:SUPERSLAMMER,      :LONGREACH,       :MOLDBREAKER,     ],   [      ],   ],

  :WIGLETT       => [   [:GOOEY,             :FIELDEXPLORER,   :RATTLED,         ],   [      ],   ], # 海地鼠
  :WUGTRIO       => [   [:GOOEY,             :FIELDEXPLORER,   :MULTIHEADED,     ],   [      ],   ],

  :BOMBIRDIER    => [   [:KEENEYE,           :ROCKYPAYLOAD,    :RETRIEVER,       ],   [      ],   ], # 下石鸟

  :FINIZEN       => [   [:ADAPTABILITY,      :DAMP,            :TIDALRUSH,       ],   [      ],   ], # 波普海豚
  :PALAFIN       => [   [:JUSTIFIED,         :DAMP,            :TIDALRUSH,       ],   [      ],   ],
  :PALAFIN_1     => [   [:JUSTIFIED,         :AVENGER,         :ADAPTABILITY,    ],   [      ],   ],

  :VAROOM        => [   [:SPEEDBOOST,        :FILTER,          :OVERCOAT,        ],   [      ],   ], # 噗隆隆
  :REVAVROOM     => [   [:SPEEDBOOST,        :FILTER,          :OVERCOAT,        ],   [      ],   ],

  :CYCLIZAR      => [   [:SHEDSKIN,          :FIELDEXPLORER,   :REGENERATOR,     ],   [      ],   ], # 摩托蜥

  :ORTHWORM      => [   [:EARTHEATER,        :EARTHBOUND,      :UNAWARE,         ],   [      ],   ], # 拖拖蚓

  :GLIMMET       => [   [:TOXICDEBRIS,       :MERCILESS,       :ACCELERATE,      ],   [      ],   ], # 晶光芽
  :GLIMMORA      => [   [:TOXICDEBRIS,       :MERCILESS,       :ACCELERATE,      ],   [      ],   ],

  :GREAVARD      => [   [:PICKUP,            :CURSEDBODY,      :SOULEATER,       ],   [      ],   ], # 墓仔狗
  :HOUNDSTONE    => [   [:DISHEARTEN,        :HAUNTEDSPIRIT,   :SOULEATER,       ],   [      ],   ],

  :FLAMIGO       => [   [:VITALSPIRIT,       :FLIGHT,          :AERILATE,        ],   [      ],   ], # 缠红鹤

  :CETODDLE      => [   [:THICKFAT,          :FREEZINGPOINT,   :SCAVENGER,       ],   [      ],   ], # 走鲸
  :CETITAN       => [   [:THICKFAT,          :DEFENCEROLL,     :PREDATOR,        ],   [      ],   ],

  :VELUZA        => [   [:SHARPNESS,         :TORRENT,         :HYPERCUTTER,     ],   [      ],   ], # 轻身鳕

  :DONDOZO       => [   [:WATERVEIL,         :PREDATOR,        :JUGGERNAUT,      ],   [      ],   ], # 吃吼霸

  :TATSUGIRI     => [   [:TORRENT,           :HIGHTIDE,        :OPPORTUNIST2,    ],   [      ],   ], # 米立龙

  :GREATTUSK     => [   [:PROTOSYNTHESIS,    :MIGHTYHORN,      :AFTERSHOCK,      ],   [      ],   ], # 雄伟牙

  :SCREAMTAIL    => [   [:PROTOSYNTHESIS,    :NOSFERATU,       :TANGLINGHAIR,    ],   [      ],   ], # 吼叫尾

  :BRUTEBONNET   => [   [:PROTOSYNTHESIS,    :REGENERATOR,     :SOLARPOWER,      ],   [      ],   ], # 猛恶菇

  :FLUTTERMANE   => [   [:PROTOSYNTHESIS,    :LEVITATE,        :ILLWILL,         ],   [      ],   ], # 振翼发

  :SLITHERWING   => [   [:PROTOSYNTHESIS,    :MAJESTICMOTH,    :POWDERBURST,     ],   [      ],   ], # 爬地翅

  :SANDYSHOCKS   => [   [:PROTOSYNTHESIS,    :MULTIHEADED,     :TRANSISTOR,      ],   [      ],   ], # 沙铁皮

  :IRONTREADS    => [   [:QUARKDRIVE,        :IMPENETRABLE,    :MEGALAUNCHER,    ],   [      ],   ], # 铁辙迹

  :IRONBUNDLE    => [   [:QUARKDRIVE,        :COLDREBOUND,     :IMPULSE,         ],   [      ],   ], # 铁包袱

  :IRONHANDS     => [   [:QUARKDRIVE,        :POWERCORE,       :STATIC,          ],   [      ],   ], # 铁臂膀

  :IRONJUGULIS   => [   [:QUARKDRIVE,        :MULTIHEADED,     :RAPIDRESPONSE,   ],   [      ],   ], # 铁脖颈

  :IRONMOTH      => [   [:QUARKDRIVE,        :MAJESTICMOTH,    :OVERCOAT,        ],   [      ],   ], # 铁毒蛾

  :IRONTHORNS    => [   [:QUARKDRIVE,        :SHARPEDGES,      :SELFREPAIR,      ],   [      ],   ], # 铁荆棘

  :FRIGIBAX      => [   [:THERMALEXCHANGE,   :HEATPROOF,       :CUTECHARM,       ],   [      ],   ], # 凉脊龙
  :ARCTIBAX      => [   [:THERMALEXCHANGE,   :HEATPROOF,       :OVERWHELM,       ],   [      ],   ],
  :BAXCALIBUR    => [   [:THERMALEXCHANGE,   :HEATPROOF,       :OVERWHELM,       ],   [      ],   ],

  :GIMMIGHOUL    => [   [:PRANKSTER,         :GOODASGOLD,      :SUPERLUCK,       ],   [      ],   ], # 索财灵
  :GHOLDENGO     => [   [:GOODASGOLD,        :STEELWORKER,     :SUPERLUCK,       ],   [      ],   ],

  :WOCHIEN       => [   [:TABLETSOFRUIN,     :SPITEFUL,        :ABSORBANT,       ],   [      ],   ], # 古简蜗

  :CHIENPAO      => [   [:SWORDOFRUIN,       :ARCTICFUR,       :STRONGJAW,       ],   [      ],   ], # 古剑豹

  :TINGLU        => [   [:VESSELOFRUIN,      :PRESSURE,        :THICKSKIN,       ],   [      ],   ], # 古鼎鹿

  :CHIYU         => [   [:BEADSOFRUIN,       :TURBOBLAZE,      :MOLTENDOWN,      ],   [      ],   ], # 古玉鱼

  :ROARINGMOON   => [   [:PROTOSYNTHESIS,    :OVERWHELM,       :FEARMONGER,      ],   [      ],   ], # 轰鸣月

  :IRONVALIANT   => [   [:QUARKDRIVE,        :LONGREACH,       :GALLANTRY,       ],   [      ],   ], # 铁武者

  :KORAIDON      => [   [:ORICHALCUMPULSE,   :SUNBASKING,      :WINGEDKING,      ],   [      ],   ], # 故勒顿

  :MIRAIDON      => [   [:HADRONENGINE,      :LEVITATE,        :IRONSERPENT,     ],   [      ],   ], # 密勒顿

  :WALKINGWAKE   => [   [:PROTOSYNTHESIS,    :OVERWHELM,       :MULTISCALE,      ],   [      ],   ], # 波荡水

  :IRONLEAVES    => [   [:QUARKDRIVE,        :SURGESURFER,     :MOMENTUM,        ],   [      ],   ], # 铁斑叶

  :POLTCHAGEIST  => [   [:CURSEDBODY,        :SOULEATER,       :HEATPROOF,       ],   [      ],   ], # 斯魔茶
  :SINISTCHA     => [   [:HEATPROOF,         :CURSEDBODY,      :SOULEATER,       ],   [      ],   ],

  :OKIDOGI       => [   [:TOXICCHAIN,        :GUARDDOG,        :ANGERPOINT,      ],   [      ],   ], # 够赞狗

  :MUNKIDORI     => [   [:TOXICCHAIN,        :MONKEYBUSINESS,  :PSYCHICMIND,     ],   [      ],   ], # 愿增猿

  :FEZANDIPITI   => [   [:TOXICCHAIN,        :PRANKSTER,       :MAJESTICBIRD,    ],   [      ],   ], # 吉雉鸡

  :OGERPON       => [   [:LONGREACH,         :OVERGROW,        :SUPERSLAMMER,    ],   [      ],   ], # 厄诡碰
  :OGERPON_1     => [   [:LONGREACH,         :TORRENT,         :SUPERSLAMMER,    ],   [      ],   ], # 水井面具
  :OGERPON_2     => [   [:LONGREACH,         :BLAZE,           :SUPERSLAMMER,    ],   [      ],   ], # 火灶面具
  :OGERPON_3     => [   [:LONGREACH,         :ROCKYPAYLOAD,    :SUPERSLAMMER,    ],   [      ],   ], # 础石面具
  :OGERPON_4     => [   [:LONGREACH,         :OVERGROW,        :SUPERSLAMMER,    ],   [      ],   ], # 碧草面具2
  :OGERPON_5     => [   [:LONGREACH,         :TORRENT,         :SUPERSLAMMER,    ],   [      ],   ], # 水井面具2
  :OGERPON_6     => [   [:LONGREACH,         :BLAZE,           :SUPERSLAMMER,    ],   [      ],   ], # 火灶面具2
  :OGERPON_7     => [   [:LONGREACH,         :ROCKYPAYLOAD,    :SUPERSLAMMER,    ],   [      ],   ], # 础石面具2
  :OGERPON_8     => [   [:LONGREACH,         :PRANKSTER,       :SUPERSLAMMER,    ],   [      ],   ],
  :OGERPON_9     => [   [:LONGREACH,         :WATERVEIL,       :SUPERSLAMMER,    ],   [      ],   ],
  :OGERPON_10    => [   [:LONGREACH,         :HYPERAGGRESSIVE, :SUPERSLAMMER,    ],   [      ],   ],
  :OGERPON_11    => [   [:LONGREACH,         :ROCKYPAYLOAD,    :SUPERSLAMMER,    ],   [      ],   ],

  :GOUGINGFIRE   => [   [:PROTOSYNTHESIS,    :TOUGHCLAWS,      :TURBOBLAZE,      ],   [      ],   ], # 破空焰

  :RAGINGBOLT    => [   [:PROTOSYNTHESIS,    :OVERWHELM,       :TERAVOLT,        ],   [      ],   ], # 猛雷鼓

  :IRONBOULDER   => [   [:QUARKDRIVE,        :MIGHTYHORN,      :SOLIDROCK,       ],   [      ],   ], # 铁磐岩

  :IRONCROWN     => [   [:QUARKDRIVE,        :MYSTICBLADES,    :SWEEPINGEDGE,    ],   [      ],   ], # 铁头壳

  :TERAPAGOS     => [   [:JUGGERNAUT,        :MEGALAUNCHER,    :PRIMALARMOR,     ],   [      ],   ], # 太乐巴戈斯

  :PECHARUNT     => [   [:POISONPUPPETEER,   :JUGGERNAUT,      :BATTLEARMOR,     ],   [      ],   ], # 桃歹郎

  :PANFADE       => [   [:CURSEDBODY,        :WONDERSKIN,      :FURCOAT,         ],   [      ],   ], # 隐咒猿

  :CEPHARANT     => [   [:SOLIDROCK,         :STURDY,          :SAPSIPPER,       ],   [      ],   ], # 盾蚁

  :ROYARANT      => [   [:QUEENLYMAJESTY,    :INTIMIDATE,      :SWARM,           ],   [      ],   ], # 罗亚蚁后

  :CRAGGYCLAWS   => [   [:PROTOSYNTHESIS,    :STRONGJAW,       :JUGGERNAUT,      ],   [      ],   ], # 峭爪龙虾

  :IRONOBSERVER  => [   [:QUARKDRIVE,        :MYSTICPOWER,     :LIGHTNINGROD,    ],   [      ],   ], # 铁浮游
}

all_id = GameData::Ability.all_id
INNATE_SET.each do |species, sets|
  sets.map! do |set|
    set.reject! { |innate| !all_id.include?(innate) }
    set
  end
end

=end