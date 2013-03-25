@clicable_page_images = ->
  $('#page-images a.image-inserter').click ->
    $image = $(this).children('img')
    append_text = '![alt](' + $image.data('thumb') + ' "")'
    $.markItUp
      target: 'textarea#page_markdown'
      replaceWith: append_text
    false

$ ->
  on_reload ->
    clicable_page_images()

    $('textarea#page_markdown').markItUp()
