attach_colorpicker = ->
  $input_color_wrapper = $('.controls .color')
  $input_color_wrapper.colorpicker()

  $input_color_wrapper.parents('form').off('submit').on(
    'submit'
    ->
      $input_color = $input_color_wrapper.children('input')
      $input_color.val $input_color.val().substr(1)
  )

checkable_color_boxes = ->
  $colorbox = $('.controls.colors-list .color-box')
  $colorbox.each ->
    if $(this).next().attr('checked') == 'checked'
      $(this).addClass('checked')

  $colorbox.off('click').on(
    'click'
    ->
      $(this).toggleClass('checked')
      $checkbox = $(this).next()
      $checkbox.prop('checked', !$checkbox[0].checked);
  )

$ ->
  on_reload ->
    attach_colorpicker()
    checkable_color_boxes()
