$ ->
  on_append_down ->
    $('.special-badge').off('click').on(
      'click'
      ->
        window.location = $(this).closest('.thumbnail').find('a.image').attr('href')
    )