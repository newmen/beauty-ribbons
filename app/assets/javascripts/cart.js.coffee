visible_cart_height = 96 # same as css .cart.shifted-down transitionx property
top_cart_amendment = 56 # 1 pixel larger than css botton shift of $cart()

@$cart = ->
  $('.cart')

$wrapper = ->
  $("#wrapper")

wrapper_border_width = ->
  parseInt($wrapper().css("border-left-width"))

lover_limit = 0
update_lover_limit = ->
  lover_limit = $wrapper().offset().top + $wrapper().height() - wrapper_border_width()

must_be_fixed = ->
  $(window).scrollTop() + $(window).height() < lover_limit + top_cart_amendment

fix_cart_if_need = ->
  if must_be_fixed()
    $cart().css
      position: 'fixed'
      top: $(window).height() - visible_cart_height
      left: original_cart_left + $wrapper().offset().left + wrapper_border_width()
      bottom: 'inherit'
  else
    $cart().css
      position: 'absolute'
      top: 'inherit'
      left: original_cart_left
      bottom: original_cart_bottom

auto_fix_unfix_cart = ->
  fix_cart_if_need()
  $(document).on 'scroll', ->
    fix_cart_if_need()

cart_pathes = ['cart', 'postal_order', 'pre_order', 'users']
hide_cart_if_need = ->
  current_path = window.location.pathname
  is_cart_path = false
  for path in cart_pathes
    if current_path.substr(1, path.length) == path
      is_cart_path = true
      break
  if is_cart_path
    $cart().hide()
  else if $cart().find('.quantity').html() != '(0)'
    $cart().show()

cart_animation_duration = 200
cart_animation_easing = 'easeOutSine'

@show_cart = ->
  if must_be_fixed()
    $cart().css('top', $(window).height())
    $cart().show()
    $cart().animate
      top: ($(window).height() - visible_cart_height).toString() + 'px'
    , cart_animation_duration, cart_animation_easing
  else
    $cart().css('opacity', 0)
    $cart().show()
    $cart().fadeTo(cart_animation_duration, 1, cart_animation_easing)

@hide_cart = ->
  if must_be_fixed()
    $cart().animate
      top: $(window).height()
    , cart_animation_duration, cart_animation_easing, ->
      $cart().hide()
  else
    $cart().fadeTo cart_animation_duration, 0, cart_animation_easing, ->
      $cart().hide()
      $cart().css('opacity', 1)

order_buttons_clicks = ->
  $('.add_to_cart').off('click').on(
    'click'
    ->
      $(this).hide()
      $(this).parent().find('.remove_from_cart').show()
  )
  $('.remove_from_cart').off('click').on(
    'click'
    ->
      $(this).hide()
      $(this).parent().find('.add_to_cart').show()
  )

original_cart_left = 0
original_cart_bottom = 0

$ ->
  original_cart_left = parseInt($cart().css('left'))
  original_cart_bottom = parseInt($cart().css('bottom'))

  on_append_down ->
    update_lover_limit()
    order_buttons_clicks()

  on_reload ->
    hide_cart_if_need()
    auto_fix_unfix_cart()

  on_resize ->
    fix_cart_if_need()
