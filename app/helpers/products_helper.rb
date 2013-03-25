module ProductsHelper
  def filter_title(filter_name)
    content_tag(:h6, t("categories.show.filter.#{filter_name}"))
  end

  def common_tags_list(products)
    items = common_list(products, Tag) do |tag, local_params, checked|
      content_tag(:li, checked ? { class: 'checked' } : {}) do
        filter_link_to(tag.name, local_params)
      end
    end
    unless items.blank?
      content_tag(:div, class: 'tags') do
        filter_title('tags') + content_tag(:ul, items)
      end
    end
  end

  def common_colors_list(products)
    items = common_list(products, Color) do |color, local_params, checked|
      filter_link_to(local_params) do
        color_box(color.value, checked)
      end
    end
    unless items.blank?
      content_tag(:div, class: 'colors') do
        filter_title('colors') + content_tag(:div, items, class: 'colors-list')
      end
    end
  end

  def price_form(products)
    prices = {}
    %w(min max).each do |agr|
      prices[agr.to_sym] =
        if ap = params["#{agr}_price"]
          ap
        else
          agr_expr = "#{agr.upcase}(price_cents)"
          product = Product.where("price_cents = (#{products.select(agr_expr).to_sql})").first
          product.price.to_f.to_i if product
        end
    end
    hidden_params = filter_params.reject { |k, _| %w(controller action slug).include?(k) || k =~ /price\Z/ }
    render('products/price_form', prices: prices, hidden_params: hidden_params)
  end

  def cancel_filter_link
    params_dup = params.dup
    return unless params_dup.reject! { |k, _| filter_names.include?(k) }
    content_tag(:div, class: 'cancel') do
      filter_link_to(t('categories.show.filter.cancel'), params_dup, class: 'btn btn-small btn-warning')
    end
  end

  def sorting_links
    current_sort = filter_params['sort_by'] || Settings.sorting.default
    Settings.sorting.fields.map do |sort_name|
      is_current_sort = current_sort =~ /\A#{sort_name}/
      sort_direct =
        if is_current_sort
          current_direct = current_sort.split('-').last
          current_direct && current_direct == 'asc' ? 'desc' : 'asc'
        else
          'asc'
        end
      local_params = filter_params.dup
      local_sort = "#{sort_name}-#{sort_direct}"
      if local_sort == Settings.sorting.default
        local_params.delete('sort_by')
      else
        local_params.merge!('sort_by' => local_sort)
      end
      filter_link_to(local_params) do
        sort_class =
          if is_current_sort
            sort_direct == 'asc' ? 'desc' : 'asc'
          else
            'none'
          end
        (t("categories.show.sorting.#{sort_name}") + content_tag(:i, '', class: sort_class)).html_safe
      end
    end.join("\n").html_safe
  end

  private

  def filter_link_to(*args, &block)
    options =
      if (block_given? && args.size > 1) || (!block_given? && args.size > 2)
        args.extract_options!
      else
        {}
      end
    options = options.merge(rel: 'nofollow', data: { push: true })
    link_to(*args, options, &block)
  end

  def filter_names
    %w(tags colors min_price max_price)
  end

  def filter_params
    return @filter_params if @filter_params
    valid_keys = %w(
      controller action slug
      sort_by
    ) + Product::STATIC_SCOPES + filter_names
    @filter_params = params.select do |k, _|
      valid_keys.include?(k)
    end
  end

  def common_list(products, filter_model, &block)
    table_name = filter_model.to_s.underscore.pluralize
    params_wo_list = filter_params.dup
    list = params_wo_list.delete(table_name)
    list = list ? list.split(',').map(&:to_i) : []

    scope = filter_model.most_common(products)
    scope = filter_model.where(id: list) if scope.empty? && !list.empty?
    scope.map do |filter_obj|
      local_list = list.dup
      checked = local_list.include?(filter_obj.id)
      checked ? local_list.delete(filter_obj.id) : (local_list << filter_obj.id)

      local_params = params_wo_list
      unless local_list.empty?
        local_params = local_params.merge(table_name => local_list.map(&:to_s).join(','))
      end

      block.call(filter_obj, local_params, checked)
    end.join("\n").html_safe
  end

end
