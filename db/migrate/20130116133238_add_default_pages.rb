# coding: utf-8

class AddDefaultPages < ActiveRecord::Migration
  def up
    Page.attr_accessible :identifier # little hack for resolv mass-assign protected attributes
    Page.create(identifier: 'welcome', title: 'Добро пожаловать!', markdown: 'Вашему вниманию представлены изделия ручной работы')
    Page.create(identifier: 'delivery', title: 'Доставка', markdown: 'Доставка осуществляется по почте, наложным платежём')
  end

  def down
    Page.delete_all
  end
end
