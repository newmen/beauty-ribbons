module ColorsHelper
  def input_color(form_builder, field_name)
    target = form_builder.object
    color_value = "##{target.send(field_name)}"

    form_builder.input(field_name, wrapper: :append_color, color_html: {
      data: { color: color_value, 'color-format' => 'hex' }
    }) do
      form_builder.input_field(field_name, class: 'input-mini', readonly: :readonly, value: color_value) +
      content_tag(:span, '<i></i>'.html_safe, class: 'add-on')
    end
  end

  def color_box(hex_color_str, checked = false)
    css_class = 'color-box'
    css_class << ' checked' if checked
    style_str = gradient('top left', hex_color_str)
    content_tag(:div, '', class: css_class, style: style_str)
  end

  def sass_color(hex_color_str)
    rgb_array = hex_color_str.scan(/../).map { |slice| slice.hex.to_s(10) }
    Sass::Script::Color.new(rgb_array)
  end

  def gradient(start_position, hex_color_str)
    gradient_style = "background-color: ##{hex_color_str};"
    differ = 8
    gradient_style << linear_gradient(start_position, lighten(hex_color_str, differ), darken(hex_color_str, differ))
    gradient_style
  end

  private

  def linear_gradient(start_position, start_color, end_color)
    ['-webkit-', '-moz-', '-o-', ''].inject('') do |acc, prefix|
      acc << "background-image: #{prefix}linear-gradient(#{start_position}, #{start_color}, #{end_color});"
    end
  end

  [:darken, :lighten].each do |helper_name|
    define_method(helper_name) do |hex_color_str, amount|
      ec = Sass::Script::Functions::EvaluationContext.new({})
      color = ec.send(helper_name, sass_color(hex_color_str), Sass::Script::Number.new(amount))
      color.options = {}
      color.to_s
    end
  end
end
