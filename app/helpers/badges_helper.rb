module BadgesHelper
  def badge_label(product)
    if product.badge
      content_tag(:div, class: 'badge-wrapper') do
        style = gradient('left bottom', product.badge.color)
        content_tag(:div, product.badge.name, class: 'special-badge', style: style)
      end
    end
  end
end
