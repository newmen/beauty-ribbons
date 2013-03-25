module OrdersHelper
  def order_state(order)
    plur_name = order.class.to_s.underscore.pluralize
    human_state = humanize_state(plur_name, order.state)

    textize = -> state do
      content_tag(:span, state, class: 'texted')
    end

    if order.canceled?
      textize[human_state]
    else
      has_each_button = false
      curr_state =
        if order.next_state
          has_each_button = true
          link_to(human_state,
                  update_order_state_path(order, order.state),
                  method: :put,
                  remote: true,
                  class: 'dynamic-order btn btn-success btn-small',
                  'data-next_state' => humanize_state(plur_name, order.next_state))
        else
          textize[human_state]
        end

      result = curr_state + link_to(humanize_state(plur_name, 'canceled'),
                                    cancel_order_path(order),
                                    method: :delete,
                                    remote: true,
                                    confirm: t('actions.do_you_really_want_to_cancel_order'),
                                    class: 'btn btn-danger btn-small')
      has_each_button ? content_tag(:div, result.html_safe, class: 'btn-group') : result.html_safe
    end
  end

  def humanize_state(plur_order_type, state)
    t("#{plur_order_type}.state.#{state}")
  end

  def like_a_form(&block)
    content_tag(:div, class: 'like_a simple_form', &block)
  end

  def form_row(label_text, controls_text_or_row_css_class_with_block = nil, row_css_class = nil, &controls_block)
    row_css_classes = 'control-group'
    if block_given?
      row_css_classes << " #{controls_text_or_row_css_class_with_block}" if controls_text_or_row_css_class_with_block
    else
      row_css_classes << " #{row_css_class}" if row_css_class
    end
    content_tag(:div, class: row_css_classes) do
      controls_css_classes = 'controls with_text'
      content_tag(:label, label_text, class: 'control-label') +
      if block_given?
        content_tag(:div, class: controls_css_classes, &controls_block)
      else
        content_tag(:div, controls_text_or_row_css_class_with_block, class: controls_css_classes)
      end
    end
  end
end
