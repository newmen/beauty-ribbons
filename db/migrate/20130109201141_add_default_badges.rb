# coding: utf-8

class AddDefaultBadges < ActiveRecord::Migration
  def up
    Badge.attr_accessible :identifier # little hack for resolv mass-assign protected attributes
    Badge.create(identifier: 'nova', name: 'Новинка', color: '00cd00')
    Badge.create(identifier: 'sale', name: 'Скидка', color: 'ff8c00')
  end

  def down
    Badge.nova.delete if Badge.nova
    Badge.sale.delete if Badge.sale
  end
end
