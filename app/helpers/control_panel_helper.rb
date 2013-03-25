module ControlPanelHelper
  def has_admin_menu(&block)
    no_follow_this_page
    content_tag(:div, class: 'row') do
      content_tag(:div, admin_menu, class: 'span2') +
      content_tag(:div, class: 'span10', &block)
    end
  end
end
