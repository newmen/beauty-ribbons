# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# the compiled file.
#
# WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
# GO AFTER THE REQUIRES BELOW.
#
#= require jquery
#= require jquery_ujs
#= require jquery.easing
#= require jquery-fileupload/basic
#= require jquery.zoom
#= require jquery.mousewheel
#= require jquery.fancybox
#= require bootstrap-alert
#= require bootstrap-colorpicker
#= require wiselinks
#= require markitup
#= require markitup/sets/xbbcode/set
#= require_tree .

@append_when_scroll_to_bottom = ($target) ->
  if ($target.size() == 0) then return

  processing = false
  current_page = 1

  $(document).on(
    'scroll'
    ->
      if processing then return false
      if $(window).scrollTop() >= ($(document).height() - $(window).height() - 500)
        processing = true

        params = { page: (current_page + 1) }
        window.location.search.replace(
          new RegExp("([^?=&]+)(?:=([^&]*))?", "g")
          ($0, $1, $2) ->
            params[$1] = $2
        )

        $.ajax(
          type: 'get'
          url: window.location.pathname
          data: params
          beforeSend: (xhr, settings) ->
            # includes this in order to Rails can identify the request as JS
            xhr.setRequestHeader('accept', '*/*;q=0.5, ' + settings.accepts.script)
          success: (data) ->
            append_data = eval(data)
            if append_data != ''
              $target.append(append_data)
              call_on_append_down_funcs()
              processing = false
              current_page++
        )
  )

call_each = (funcs) ->
  if funcs.length > 0
    for func in funcs
      func()
  true

on_append_down_funcs = []
@on_append_down = (func) ->
  on_append_down_funcs.push(func)

call_on_append_down_funcs = ->
  call_each on_append_down_funcs

on_reload_funcs = []
@on_reload = (func) ->
  on_reload_funcs.push(func)

call_on_reload_funcs = ->
  call_on_append_down_funcs()
  call_each on_reload_funcs

on_resize_funcs = []
@on_resize = (func) ->
  on_resize_funcs.push(func)

window.onresize = ->
  call_each on_resize_funcs

handle_wiselinks_breadcrumbs = ->
  set_breadcrumbs = (xhr) ->
    crumbs = xhr.getResponseHeader('X-Wiselinks-Breadcrumbs') ? ''
    $('.crumbs').html decodeURI(crumbs)
  _super = Wiselinks::_set_title
  Wiselinks::_set_title = (xhr) ->
    _super(xhr)
    set_breadcrumbs(xhr)
handle_wiselinks_breadcrumbs()

select_current_menu_item = (items_list_selector, first_level_path) ->
  selected_css_class_name = 'active'
  $items_list = $(items_list_selector)
  $items_list.find('li').removeClass(selected_css_class_name)
  unless first_level_path == '/'
    $items_list.find('a[href^="' + first_level_path + '"]').parent().addClass(selected_css_class_name)

handle_logo = ->
  $logo = $('#logo-front')
  $link = $logo.find('a')
  if window.location.pathname == '/'
    if $link.length != 0
      text = $link.html()
      $link.remove()
      $logo.append(text)
  else
    if $link.length == 0
      text = $logo.html()
      $logo.empty()
      $logo.append('<a data-push="true" href="/">' + text + '</a>')

handle_menu_switch = ->
  path_parts = window.location.pathname.split('/')
  first_level_path = '/' + path_parts[1]
  select_current_menu_item('header nav ul', first_level_path)
  select_current_menu_item('footer nav ul', first_level_path)

scroll_to_top = ->
  $('html, body').scrollTop(75)

$(document).off('page:done').on(
  'page:done'
  (event, $target, status, url, data) ->
    $(document).off('scroll')
    call_on_reload_funcs()

    handle_logo()
    handle_menu_switch()
    scroll_to_top()

    _gaq.push(['_trackPageview', url])
)

$ ->
  window.wiselinks = new Wiselinks($('.container'))

  call_on_reload_funcs()
