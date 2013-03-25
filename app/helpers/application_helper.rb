# coding: utf-8

module ApplicationHelper
  def full_title
    return @full_title if @full_title
    @full_title = ''
    if content_for?(:title)
      @full_title << content_for(:title)
      @full_title << ' – '
    end
    @full_title << t('default_title')
    @full_title
  end

  def title(text)
    content_for(:title, text)
    wiselinks_title(full_title)

    content_tag(:h2, text)
  end

  def title_tag
    content_tag(:title, full_title)
  end

  def encoding_meta_tag
    tag(:meta, charset: 'utf-8')
  end

  def device_meta_tag
    tag(:meta, name: 'viewport', content: 'width=device-width, initial-scale=1.0')
  end

  def no_follow_this_page
    content_for(:head, tag(:meta, name: 'robots', content: 'nofollow'))
  end

  def url_helper_value(path)
    cut_path = path
    cut_path[0] = ''
    "#{root_url}#{cut_path}"
  end

  def hidden_tag_unless(tag, condition, attributes = {}, &block)
    attributes[:style] = 'display: none' unless condition
    content_tag(tag, attributes, &block)
  end

  def alert_tag(text, additional_class = nil)
    if text
      content_tag(:div, class: "alert #{additional_class}") do
        button_tag('&times;'.html_safe, :class => 'close', 'data-dismiss' => 'alert') + text
      end
    end
  end

  def currency_price(price)
    number_to_currency(price, precision: 0)
  end

  def append_icon(text, icon_class)
    "#{content_tag(:i, '', class: icon_class)} #{text}".html_safe
  end

  def add_button(model_class_or_title, path)
    title =
      if model_class_or_title.is_a? String
        model_class_or_title
      else
        t('actions.add', model: t("activerecord.models.#{model_class_or_title.to_s.underscore}"))
      end
    link_to(path, class: 'btn btn-primary', data: { push: true }) do
      append_icon(title, 'icon-plus icon-white')
    end
  end

  def show_button(path)
    link_to(t('actions.show'), path, class: 'btn btn-mini', data: { push: true })
  end

  def edit_button(path)
    link_to(t('actions.edit'), path, class: 'btn btn-mini btn-warning', data: { push: true })
  end

  def delete_button(path, options = {})
    options = {
      method: :delete,
      data: { confirm: t('actions.are_u_sure') }, class: 'btn btn-mini btn-danger'
    }.merge(options)
    link_to(t('actions.destroy'), path, options)
  end

  def cancel_button
    link_to(t('actions.go_back'), 'javascript:history.go(-1)', class: 'btn')
  end

  def input_with_append(form_builder, field_name, append_text, input_options = {})
    form_builder.input(field_name, wrapper: :append) do
      form_builder.input_field(field_name, input_options) + content_tag(:span, append_text, class: 'add-on')
    end
  end

  def title_with_edit_button(title_text, edit_path, &block)
    result = ''
    if user_signed_in?
      if block_given?
        result << content_tag(:div, class: 'front-actions btn-group') do
          edit_button(edit_path) + capture(&block)
        end
      else
        result << content_tag(:div, edit_button(edit_path), class: 'front-actions')
      end
    end
    result << title(title_text)
    result.html_safe
  end

  def social_meta_tags(image_path, description)
    content_for :head do
      tags = [
        tag('meta', property: 'og:image', content: image_path),
        tag('meta', property: 'og:title', content: full_title),
      ]
      unless description.blank?
        tags << tag('meta', property: 'og:description', content: description)
        tags << tag('meta', name: 'description', content: description)
      end
      tags.join("\n").html_safe
    end
  end

  def social_share(image, description)
    full_image_path = (URI.parse(root_url) + image.url).to_s
    social_meta_tags(full_image_path, description)
    data = {
      title: full_title,
      image: full_image_path
    }
    data[:description] = description unless description.blank?
    content_tag(:div, nil, id: 'social-yashare', data: data)
  end
end
