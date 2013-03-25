@select_product_image = ($product_image) ->
  $('#product-images .thumbnail').each ->
    $(this).removeClass('selected')
    $(this).children('input:radio').removeAttr('checked')
  $product_image.parent('.thumbnail').addClass('selected')
  $product_image.children('input:radio').attr('checked', 'checked')

@clicable_product_image = ->
  $('#product-images a.image-selector').off('click').on(
    'click'
    ->
      select_product_image $(this)
      false
  )

fade_duration = 120

cover_zoom = ->
  $('.cover').zoom({
    url: $('.cover img.preview').data('original')
    duration: fade_duration
  })

public_previews_hover = ->
  $('#public_previews a.thumbnail').off('mouseenter').on(
    'mouseenter'
    ->
      # alert('change image')
      $cover = $('.cover img.preview')
      if $cover.data('original') != $(this).attr('href')
        $img = $(this).find('img')
        $cover.fadeOut(fade_duration, ->
          $cover.attr('src', $img.data('preview'))
        ).fadeIn(fade_duration)
        $cover.data('original', $(this).attr('href'))
        cover_zoom()
  )

fancybox_options = {
  openEffect: 'none',
  closeEffect: 'none'
}

enable_fancybox = ->
  $('#public_previews a.thumbnail').fancybox(fancybox_options)

cover_click_deligate_fancybox = ->
  $('.cover').off('click').on(
    'click'
    (e) ->
      e.preventDefault()
      $cover = $(this).find('img.preview')
      $thumb = $('#public_previews a.thumbnail[href="' + $cover.data('original') + '"]')
      if $thumb.size() > 0
        $thumb.trigger('click')
      else
        $zoom_img = $(this).find('.zoomImg')
        if $('#single-cover').size() == 0
          $zoom_img.wrap('<a href="' + $zoom_img.attr('src') + '" id="single-cover" />')
        $('#single-cover').fancybox(fancybox_options)
  )

ya_share = null
social_share_init = ->
  element_css_class = 'social-yashare'
  $element = $('.' + element_css_class)

  params =
    element: element_css_class
    elementStyle:
      type: 'none'
      quickServices: ['vkontakte', 'facebook', 'twitter', 'odnoklassniki', 'moimir', 'lj', 'moikrug', 'gplus']

    image: $element.data('image')
    title: $element.data('title')

  description = $element.data('description')
  params['description'] = description if description != undefined

  ya_share = new Ya.share(params)

$ ->
  on_reload ->
    # index
    append_when_scroll_to_bottom $('#products')

    # form
    clicable_product_image()

    # show
    cover_zoom()
    public_previews_hover()
    enable_fancybox()
    cover_click_deligate_fancybox()

    social_share_init()
