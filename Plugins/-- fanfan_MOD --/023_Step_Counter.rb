class PokeBattle_Battle
  def tick_down_step_counter(priority)
    return unless Settings::STEP_RECOVERY
    priority.each do |b|
      next if b.fainted?
      step_counter = b.tracker_get(:step_counter)
      next if step_counter.empty?
      stat_changes = Hash.new(0)
      step_counter.each do |stat, counters|
        next if counters.empty? # [[increment1, remaining1], [increment2, remaining2], [increment3, remaining3], ...]
        counters.each do |counter| # [increment1, remaining1]
          counter[1] -= 1
          if counter[1] == 0
            b.steps[stat] -= counter[0]
            stat_changes[stat] += counter[0]
          end
        end
        counters.reject! { |counter| counter[1] == 0 }
      end
      next if stat_changes.empty?
      change_desc = []
      stat_changes.each do |stat, amount|
        next if amount.zero?
        stat_name = GameData::Stat.get(stat).name
        if amount > 0
          change_desc << _INTL("raised {1} recovered by {2}", stat_name, amount)
        else
          change_desc << _INTL("lowered {1} recovered by {2}", stat_name, amount.abs)
        end
      end
      description = change_desc.join(_INTL(", "))
      pbDisplay(_INTL("{1}'s {2}.", b.pbThis, description))
    end
  end
end

class PokeBattle_Battler
  def update_step_counter(stat, increment, raised = true)
    return unless Settings::STEP_RECOVERY
    step_counter = tracker_get(:step_counter)
    step_counter[stat] = [] unless step_counter[stat]
    step_counter[stat] << [raised ? increment : -increment, Settings::STEP_RECOVERY_TURN]
  end

  def clear_step_counter(section = 2) # 0 for pos, 1 for neg, 2 for all
    if section == 2
      tracker_clear(:step_counter)
    else
      step_counter = tracker_get(:step_counter)
      return if step_counter.empty?
      step_counter.each do |stat, counters|
        next if counters.empty? # [[increment1, remaining1], [increment2, remaining2], [increment3, remaining3], ...]
        counters.each do |counter| # [increment1, remaining1]
          counter[1] = 0 if counter[0] > 0 && section == 0
          counter[1] = 0 if counter[0] < 0 && section == 1
        end
        counters.reject! { |counter| counter[1] == 0 }
      end
    end
  end

  def reverse_step_counter
    step_counter = tracker_get(:step_counter)
    step_counter.each do |stat, counters|
      counters.each do |counter|
        counter[0] = -counter[0]
      end
    end
  end

  def deep_clone_step_counter(battler)
    source_data = battler.tracker_get(:step_counter)
    copied_data = {}
    source_data.each do |stat, counters|
      copied_data[stat] = counters.map(&:dup)
    end
    copied_data
  end

  def copy_step_counter(battler)
    tracker_set(:step_counter, deep_clone_step_counter(battler))
  end

  def swap_step_counter(battler)
    self_counter = deep_clone_step_counter(self)
    other_counter = deep_clone_step_counter(battler)
    self.tracker_set(:step_counter, other_counter)
    battler.tracker_set(:step_counter, self_counter)
  end

  def record_stat_steps
    battle_tracker_get(:steps_before_switching).replace(@steps)
    battle_tracker_get(:steps_counter_before_switching).replace(deep_clone_step_counter(self))
  end

  def apply_remained_stat_steps
    strategy = get_strategy
    return unless strategy
    stat_steps = battle_tracker_get(:steps_before_switching)
    tracker_set(:step_counter, battle_tracker_get(:steps_counter_before_switching))
    case strategy
    when :positive
      stat_steps.each { |stat, step| @steps[stat] = step if step > 0 }
      clear_step_counter(1)
    when :negative
      stat_steps.each { |stat, step| @steps[stat] = step if step < 0 }
      clear_step_counter(0)
    when :positive_half
      stat_steps.each { |stat, step| @steps[stat] = step / 2 if step > 0 }
    when :negative_half
      stat_steps.each { |stat, step| @steps[stat] = step / 2 if step < 0 }
    when :positive_full_negative_half
      stat_steps.each do |stat, step|
        next if step == 0
        @steps[stat] = step > 0 ? step : step / 2
      end
    when :negative_full_positive_half
      stat_steps.each do |stat, step|
        next if step == 0
        @steps[stat] = step < 0 ? step : step / 2
      end
    else
      stat_steps.each { |stat, step| @steps[stat] = step }
    end
  end

  def get_strategy
    return :positive if hasActiveAbility?(:BACKUP)
    return nil
  end
end