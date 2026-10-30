module ColorsHelper
  def input_color(form_builder, field_name)
    target = form_builder.object
    color_value = "##{target.send(field_name)}"

    form_builder.input(field_name, wrapper: :append_color, color_html: {
      data: { color: color_value, "color-format" => "hex" }
    }) do
      form_builder.input_field(field_name, class: "input-mini", readonly: :readonly, value: color_value) +
        content_tag(:span, "<i></i>".html_safe, class: "add-on")
    end
  end

  def color_box(hex_color_str, checked = false)
    css_class = "color-box"
    css_class << " checked" if checked
    style_str = gradient("top left", hex_color_str)
    content_tag(:div, "", class: css_class, style: style_str)
  end

  def gradient(start_position, hex_color_str)
    gradient_style = "background-color: ##{hex_color_str};"
    differ = 8
    gradient_style << linear_gradient(start_position, lighten(hex_color_str, differ), darken(hex_color_str, differ))
    gradient_style
  end

  def hsl(hex_color_str)
    r, g, b = rgb_components(hex_color_str).map { |value| value / 255.0 }
    max = [r, g, b].max
    min = [r, g, b].min
    lightness = (max + min) / 2.0
    delta = max - min

    if delta.zero?
      hue = 0.0
      saturation = 0.0
    else
      saturation = lightness > 0.5 ? delta / (2.0 - max - min) : delta / (max + min)
      hue = case max
            when r then (g - b) / delta + (g < b ? 6 : 0)
            when g then (b - r) / delta + 2
            else (r - g) / delta + 4
            end
      hue /= 6.0
    end

    [hue * 360.0, saturation * 100.0, lightness * 100.0]
  end

  [:darken, :lighten].each do |helper_name|
    define_method(helper_name) do |hex_color_str, amount|
      hue, saturation, lightness = hsl(hex_color_str)
      lightness += helper_name == :lighten ? amount : -amount
      lightness = [[lightness, 0].max, 100].min
      rgb_to_hex(hsl_to_rgb(hue, saturation, lightness))
    end
  end

  private

  def rgb_components(hex_color_str)
    hex_color_str.to_s.delete("#").scan(/../).map { |slice| slice.hex }
  end

  def rgb_to_hex(rgb)
    "##{rgb.map { |value| value.round.clamp(0, 255).to_s(16).rjust(2, "0") }.join}"
  end

  def hsl_to_rgb(hue, saturation, lightness)
    hue = (hue % 360.0) / 360.0
    saturation /= 100.0
    lightness /= 100.0

    if saturation.zero?
      value = lightness * 255.0
      return [value, value, value]
    end

    q = lightness < 0.5 ? lightness * (1.0 + saturation) : lightness + saturation - lightness * saturation
    p = 2.0 * lightness - q

    [hue + 1.0 / 3.0, hue, hue - 1.0 / 3.0].map do |component|
      component += 1.0 if component.negative?
      component -= 1.0 if component > 1.0

      value = if component < 1.0 / 6.0
                p + (q - p) * 6.0 * component
              elsif component < 0.5
                q
              elsif component < 2.0 / 3.0
                p + (q - p) * (2.0 / 3.0 - component) * 6.0
              else
                p
              end
      value * 255.0
    end
  end

  def linear_gradient(start_position, start_color, end_color)
    ["-webkit-", "-moz-", "-o-", ""].inject("") do |acc, prefix|
      acc << "background-image: #{prefix}linear-gradient(#{start_position}, #{start_color}, #{end_color});"
    end
  end
end
