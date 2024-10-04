=begin

CHINESE_NAME_CONVERT = {
  "小智" => "xiaozhi",
  "小霞" => "xiaoxia",
  "小刚" => "xiaogang"
}

def SetTrainerEffect(trainer_effect)
  $player.trainer_effect = trainer_effect
end

def trainer_effect_list
  return $player.trainer_effect_list
end

def AddTrainerEffect(trainer_effect)
  trainer_effect_list.push(trainer_effect)
end

class Player < Trainer
  attr_accessor :trainer_effect
  attr_accessor :trainer_effect_list

  alias trainer_effect_initialize initialize
  def initialize(name, trainer_type)
    trainer_effect_initialize(name, trainer_type)
	@trainer_effect = nil
	@trainer_effect_list = []
  end
end

MenuHandlers.add(:pause_menu, :trainer_effect, {
  "name"      => _INTL("角色效果"),
  "order"     => 51,
  "condition" => proc { next trainer_effect_list.any? },
  "effect"    => proc { |menu|
    list = []
	trainer_effect_list.each do |trainer_effect| 
	  list.push(trainer_effect)
    end
	list.push(_INTL("取消"))
	choice = pbShowCommands(nil, list)
    next if choice == list.size - 1
	SetTrainerEffect(list[choice])
	next false
  }
})

class Battle::ActiveSide
  attr_accessor :trainer_effect

  alias trainer_effect_initialize initialize
  def initialize
    trainer_effect_initialize
	@trainer_effect = []
  end

  def add_trainer_effect(trainer_name)
    @trainer_effect.push(trainer_name)
  end
end

class Battle
  alias trainer_effect_pbStartBattleSendOut pbStartBattleSendOut
  def pbStartBattleSendOut(sendOuts)
    trainer_effect_pbStartBattleSendOut(sendOuts)
	@player.each_with_index do |trainer, index|
	  if index == 0
	    trainer_effect = trainer.trainer_effect ? trainer.trainer_effect : trainer.name
		@sides[0].add_trainer_effect(trainer_effect) 
	  else
	    @sides[0].add_trainer_effect(trainer.name)
	  end
    end
	if trainerBattle?
	  @opponent.each do |trainer|
        @sides[1].add_trainer_effect(trainer.name)
      end
	end
	all_trainer_effect = sides[1].trainer_effect | sides[0].trainer_effect
    @trainer_effect = TrainerEffect.new(self)
    all_trainer_effect.each do |trainer_name|
	  if trainer_name.match(/[\u4e00-\u9fff]/)
	    convert_name = CHINESE_NAME_CONVERT[trainer_name]
		next if !convert_name
		class_name = sprintf("%s_trainer_effect", convert_name.upcase)
	  else
	    class_name = sprintf("%s_trainer_effect", trainer_name.upcase)
	  end
	  next if !Object.const_defined?("#{Battle}::#{class_name}")
	  trainer_effect = Object.const_get("#{Battle}::#{class_name}").new(self, trainer_name)
      @trainer_effect.add_trainer_effect(trainer_effect)
	  next if !trainer_effect.message || trainer_effect.message.empty?
	  pbDisplay(_INTL("{1}: {2}", trainer_name, trainer_effect.message))
    end
  end

  def trigger_trainer_effect(key, *args)
    @trainer_effect.trigger_effect(key, *args)
  end

  alias trainer_effect_pbOnAllBattlersEnteringBattle pbOnAllBattlersEnteringBattle
  def pbOnAllBattlersEnteringBattle
    trigger_trainer_effect(:start_battle)
    trainer_effect_pbOnAllBattlersEnteringBattle
  end

  alias trainer_effect_pbEffectsOnBattlerEnteringPosition pbEffectsOnBattlerEnteringPosition
  def pbEffectsOnBattlerEnteringPosition(battler)
    trigger_trainer_effect(:switch_in, battler)
    trainer_effect_pbEffectsOnBattlerEnteringPosition(battler)
  end
end

class Battle::TrainerEffect
  attr_accessor :trainer_effect_keys
  attr_accessor :message

  def initialize(battle)
	@battle = battle
    @trainer_effect = []
	@trainer_effect_keys = {}
  end

  def add_trainer_effect(trainer_effect)
    @trainer_effect.push(trainer_effect)
  end

  def trigger_effect(key, *args)
    @trainer_effect.each do |trainer_effect|
	  next if !trainer_effect.trainer_effect_keys.has_key?(key)
      trainer_effect.trainer_effect_keys[key].call(*args)
    end
  end
end

class Battle::BLUE_trainer_effect < Battle::TrainerEffect
  def initialize(battle, trainer_name)
    super(battle)
	@message = "小样准备受死吧！"
    @trainer_effect_keys[:start_battle] = proc {
	  effect_name = "骤降"
	  next if @battle.field.weather == :Hail
	  @battle.pbDisplay(_INTL("{1}让温度急速变低！", effect_name))
	  @battle.pbStartWeather(nil, :Hail)
	}
    @trainer_effect_keys[:switch_in] = proc { |battler|
	  next if !battler.hasTrainerEffect?(trainer_name)
	  effect_name = "盛气凌人"
      buffable_stats = []
	  GameData::Stat.each_battle do |stat|
	    next if !battler.pbCanRaiseStatStage?(stat.id, battler)
	    buffable_stats.push(stat.id)
	  end
      next if buffable_stats.empty?
	  if buffable_stats.length == 1
	    msg = _INTL("{1}增加了{2}的一项随机能力！", effect_name, battler.pbThis)
	  else
	    msg = _INTL("{1}增加了{2}的两项随机能力！", effect_name, battler.pbThis)
	  end
	  @battle.pbDisplay(msg)
	  stats_to_buff = buffable_stats.sample(2)
	  anim = true
	  stats_to_buff.each do |stat|
	    battler.pbRaiseStatStageByAbility(stat, 1, battler, false, anim)
		anim = false
	  end
    }
  end
end

class Battle::Battler
  def hasTrainerEffect?(trainer_effect)
    return pbOwnSide.trainer_effect.include?(trainer_effect)
  end

  def hasTrainerEffectOpposing?(trainer_effect)
    return pbOpposingSide.trainer_effect.include?(trainer_effect)
  end

  def hasTrainerEffectGlobal?(trainer_effect)
    return hasTrainerEffect?(trainer_effect) || hasTrainerEffectOpposing?(trainer_effect)
  end
end

=end