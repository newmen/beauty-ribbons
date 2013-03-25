module CartHelper
  def stored_product_ids
    session[:product_ids] ||= []
    session[:product_ids]
  end

  def has_stored_products?
    !stored_product_ids.empty?
  end

  def stored_products_num
    stored_product_ids.size
  end

  def ordered_products
    stored_products[:ordered]
  end

  def desired_products
    stored_products[:desired]
  end

  def ids_corresponds_to_products(ids_str, products)
    ids_str.map(&:to_i).to_set == products.map(&:id).to_set
  end

  def unstore_products(products)
    product_ids = products.map(&:id)
    stored_product_ids.reject! { |id| product_ids.include?(id) }
  end

  def total_price
    total = ordered_products && ordered_products.map(&:price).map(&:to_f).inject(:+)
    if total
      currency_price(total)
    elsif desired_products
      t('cart.buttons.pre_order')
    end
  end

  def postal_order_icon_css_class
    'icon-shopping-cart'
  end

  def pre_order_icon_css_class
    'icon-tag'
  end

  def cart_bottom_icons
    icons = []
    ops = ordered_products ? ordered_products.size : 0
    dps = desired_products ? desired_products.size : 0
    (ops > 4 ? 4 : ops).times do
      icons << content_tag(:i, nil, class: "#{postal_order_icon_css_class} icon-white")
    end
    unless ops > 4
      (ops + dps > 4 ? 4 - ops : dps).times do
        icons << content_tag(:i, nil, class: "#{pre_order_icon_css_class} icon-white")
      end
    end
    icons.join.html_safe
  end

  def checkout_button(product)
    product.is_archived? ? pre_order_button(product) : buy_button(product)
  end

  def buy_button(product)
    hide_add, hide_remove = show_hide_buttons(product)
    icon_css_classes = "#{postal_order_icon_css_class} icon-white"

    result = ''
    result << add_to_cart_button(product, hide_add, 'btn-primary') do
      append_icon(t('cart.buttons.buy'), icon_css_classes)
    end
    result << remove_from_cart_button(product, hide_remove, 'btn-danger') do
      append_icon(t('actions.cancel'), icon_css_classes)
    end
    result.html_safe
  end

  def pre_order_button(product)
    hide_add, hide_remove = show_hide_buttons(product)

    result = ''
    result << add_to_cart_button(product, hide_add, 'btn-info') do
      append_icon(t('cart.buttons.pre_order'), "#{pre_order_icon_css_class} icon-white")
    end
    result << remove_from_cart_button(product, hide_remove) do
      append_icon(t('actions.cancel'), pre_order_icon_css_class)
    end
    result.html_safe
  end

  def products_mosaic(products, max_in_line = 4)
    products = products.dup

    template = products.size <= max_in_line / 2 ? 'welcome_product' : 'product'
    result = ''
    append_following_slice = -> do
      result << render('products_slice', products: products.slice!(0...max_in_line), product_template: template)
    end

    append_following_slice.call while products.size >= max_in_line * 2
    max_in_line -= 1 if (rest = products.size % max_in_line) > 0 && rest <= max_in_line / 2
    append_following_slice.call until products.empty?

    result.html_safe
  end

  private

  def show_hide_buttons(product)
    stored_product_ids.include?(product.id) ? [true, false] : [false, true]
  end

  def extend_options_if_hidden(is_hidden, options)
    options[:style] = 'display: none;' if is_hidden
  end

  def add_to_cart_button(product, is_hidden, special_css_btn_class = nil, &block)
    btn_css_classes = 'add_to_cart btn'
    btn_css_classes << " #{special_css_btn_class}" if special_css_btn_class
    options = { class: btn_css_classes, rel: 'nofollow', remote: true, method: :post }
    extend_options_if_hidden(is_hidden, options)
    link_to(add_to_cart_path(product), options, &block)
  end

  def remove_from_cart_button(product, is_hidden, special_css_btn_class = nil, &block)
    btn_css_classes = 'remove_from_cart btn'
    btn_css_classes << " #{special_css_btn_class}" if special_css_btn_class
    options = { class: btn_css_classes, rel: 'nofollow', remote: true, method: :delete }
    extend_options_if_hidden(is_hidden, options)
    link_to(add_to_cart_path(product), options, &block)
  end

  def stored_products
    unless @stored_products
      products = stored_product_ids.empty? ? [] : Product.where(id: stored_product_ids)
      grouped_products = products.group_by { |product| product.is_archived }
      @stored_products = { ordered: grouped_products[false], desired: grouped_products[true] }
    end
    @stored_products
  end

end
