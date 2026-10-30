class AddDefaultBadges < ActiveRecord::Migration[7.2]
  def up
    Badge.create!(identifier: "nova", name: "Новинка", color: "00cd00")
    Badge.create!(identifier: "sale", name: "Скидка", color: "ff8c00")
  end

  def down
    Badge.where(identifier: %w[nova sale]).delete_all
  end
end
