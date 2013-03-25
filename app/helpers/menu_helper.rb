module MenuHelper
  def main_menu
    string_with_links = convert_to_links(main_menu_items)
    content_tag(:nav) do
      content_tag(:ul, raw(string_with_links))
    end
  end

  def bottom_menu
    items = main_menu_items
    if user_signed_in?
      items << [t('control_panel.index.title'), control_panel_path]
      items << [t('devise.shared_links.sign_out'), destroy_user_session_path, { method: :delete }]
    else
      items << [t('devise.shared_links.sign_in'), new_user_session_path, { rel: 'nofollow' }]
    end

    string_with_links = convert_to_links(items)
    content_tag(:nav) do
      content_tag(:ul, raw(string_with_links))
    end
  end

  def admin_menu
    is_admin = current_user && current_user.admin?
    items = []
    items << [t('control_panel.menu.pages'), pages_path]
    items << [t('control_panel.menu.categories'), categories_path]
    items << [t('control_panel.menu.products'), products_path]
    items << [t('control_panel.menu.badges'), badges_path]
    items << [t('control_panel.menu.colors'), colors_path]
    items << [t('control_panel.menu.postal_orders'), postal_orders_path]
    items << [t('control_panel.menu.pre_orders'), pre_orders_path]
    items << [t('control_panel.menu.personal_data'), edit_current_user_path] unless is_admin
    items << [t('control_panel.menu.users'), users_path] if is_admin

    string_with_links = convert_to_links(items, 'icon-chevron-right pull-right')
    content_tag(:nav, class: 'control-panel-menu') do
      content_tag(:ul, raw(string_with_links), class: 'nav nav-tabs nav-pills nav-stacked')
    end
  end

  private

  def main_menu_items
    items = []
    # items << [t('static_products.novelties'), novelties_path] if Product.novelties.exists?
    Category.all.each { |category| items << [category.name, category_path(category)] }
    items << [t('static_products.sales'), sales_path] if Product.sales.exists?
    items << [t('static_products.archived'), archived_path] if Product.archived.exists?
    items << [Page.delivery.title, delivery_path]
  end

  def wrap_menu_item(item, url)
    if request.fullpath =~ /\A#{url.gsub('/', '\/')}/
      content_tag(:li, raw(item), class: 'active')
    else
      content_tag(:li, raw(item))
    end
  end

  def convert_to_links(items, icon_class = nil)
    items.map do |title, url, options|
      title = append_icon(title, icon_class) if icon_class
      options = { data: { push: true } }.merge(options || {}) unless options && options[:method]
      link_tag = link_to(title, url, options)
      wrap_menu_item(link_tag, url)
    end.join("\n")
  end

end
