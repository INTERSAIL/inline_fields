ready = ->
  $('form').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    event.preventDefault()

  $('form').on 'click', '.row-remove', (event) ->
    div = $("#"+$(this).data("target"))
    fld = div.find("input[data-destroy-field=1]")
    if(fld.val() == '1')
      fld.val('0')
      div.removeClass('destroyed')
      div.find('.row-data input[type!=hidden]').removeAttr('disabled')
    else
      fld.val('1')
      div.addClass('destroyed')
      div.find('.row-data input[type!=hidden]').attr('disabled', 'disabled')

  $('form').on 'click', '.row-edit', (event) ->
    url = $(this).data("edit-url")
    div = $("#"+$(this).data("target"))
    params = {}
    div.find("*[data-name]").each (index) ->
      params[$(this).data('name')] = $(this).val()
    $.get url, params, (data, textStatus, jqXHR) ->
      modal = $('#mainModal')
      modal.find('.modal-body').html(data)
      modal.find('.btn-primary').one 'click', ->
        modalSubmit modal, url, div

      modal.on 'keypress', (event) ->
        if (event.keyCode == 13)
          modalSubmit modal, url, div
          false

      modal.one 'hidden.bs.modal', ->
        modal.off 'keypress'

      modal.modal()

modalSubmit = (modal, url, div) ->
  q = modal.find('*').filter(':input').serialize()
  $.post url, q, (data, textStatus, jqXHR) ->
    div.replaceWith(data)
    modal.find('.btn-default').off
    modal.modal('hide')

$(document).ready(ready)
$(document).on('page:load', ready)
