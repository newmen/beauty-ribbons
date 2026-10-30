class AddDefaultPages < ActiveRecord::Migration[7.2]
  def up
    Page.create!(identifier: "welcome", title: "Добро пожаловать!", markdown: "Вашему вниманию представлены изделия ручной работы")
    Page.create!(identifier: "delivery", title: "Доставка", markdown: "Доставка осуществляется по почте, наложным платежём")
  end

  def down
    Page.delete_all
  end
end
