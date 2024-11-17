class Pokemon
  # 生成精灵的ID
  def regenerate_unique_id(digits = 8)
    @unique_id = generate_unique_id(digits)
  end

  # 精灵的ID
  def unique_id
    @unique_id ||= generate_unique_id
  end
end