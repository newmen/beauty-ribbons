@setup_dynamic_orders = ->
  $('.dynamic-order').hover ->
    $(this).data 'state', $(this).html()
    $(this).html $(this).data('next_state')
  , ->
    $(this).html $(this).data('state')

$ ->
  on_reload ->
    setup_dynamic_orders()
