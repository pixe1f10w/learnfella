# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $('textarea[max_length]').each( ->
    id = $(this).attr( 'id' )
    $(this).after '<span id="count_' + id + '"></span>'
    $(this).keyup ->
      id = $(this).attr 'id'
      max = $(this).attr 'max_length'
      left = max - $(this).val().length
      left = 0 if left < 0
      $('#count_' + id).text left + ' characters remaining.'
  ).keyup()
