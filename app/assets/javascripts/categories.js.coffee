$go_up = ->
  $('.go-up')

$go_up_container = ->
  $go_up().parent()

lover_limit = 0
update_lover_limit = ->
  if $go_up_container().length > 0
    lover_limit = $go_up_container().offset().top + $go_up_container().height()

scroll_over_limit = ->
  $(window).scrollTop() >= lover_limit

show_go_up = ->
  $go_up().css
    display: 'block'
    width: $go_up_container().width()

hide_go_up = ->
  $go_up().hide()

recount_go_up = ->
  if scroll_over_limit()
    $main_row = $go_up_container().parent()
    $go_up().css
      height: $main_row.offset().top + $main_row.height() - $(window).scrollTop()
      left: $go_up_container().offset().left
    if $go_up().is(':hidden')
      show_go_up()
  else if $go_up().is(':visible')
    hide_go_up()

auto_show_hide_go_up = ->
  if $go_up().length > 0
    recount_go_up()
    $(document).on('scroll', recount_go_up)

go_up_mouse_oo = ->
  fade_time = 200
  $go_up().off('mouseenter').on(
    'mouseenter'
    ->
      if scroll_over_limit()
        $(this).fadeTo(fade_time, 0.618)
  ).off('mouseleave').on(
    'mouseleave'
    ->
      if scroll_over_limit()
        $(this).fadeTo(fade_time, original_go_up_opacity)
  )

go_up_click = ->
  $go_up().off('click').on(
    'click'
    ->
      scroll_to_top()
      $go_up().css('opacity', original_go_up_opacity)
      hide_go_up()
  )

original_go_up_opacity = 0

$ ->
  original_go_up_opacity = parseFloat($go_up().css('opacity'))

  on_append_down ->
    update_lover_limit()

  on_reload ->
    auto_show_hide_go_up()
    go_up_mouse_oo()
    go_up_click()

  on_resize ->
    if $go_up().length > 0
      recount_go_up()
