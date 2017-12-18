# changes: add js related to: LineItemOptionType / LineItemOptionValue

$(document).ready ->
  #handle edit click
  $('a.edit-line-item').click toggleLineItemEdit

  #handle cancel click
  $('a.cancel-line-item').click toggleLineItemEdit

  #handle save click
  $('a.save-line-item').click ->
    save = $ this
    line_item_id = save.data('line-item-id')
    quantity = parseInt(save.parents('tr').find('input.line_item_quantity').val())

    # construct line_item_detail_records_attributes object
    line_item_detail_records_attributes = []

    for position in [1..quantity]
      lidra = {}
      lidra.position = position
      lidra.line_item_option_value_detail_records_attributes = []

      selection_inputs = save.parents('tr').find('select[data-liov-input-type="selection"][data-li-id="' + line_item_id + '"][data-lidr-position="' + position + '"]')
      selection_inputs.each (item) ->
        liovdra = {}
        liovdra.id = $(this).data('liovdr-id')
        liovdra.line_item_option_value_id = $(this).val()

        lidra.line_item_option_value_detail_records_attributes.push liovdra

      text_inputs = save.parents('tr').find('input[data-liov-input-type="text"][data-li-id="' + line_item_id + '"][data-lidr-position="' + position + '"]')
      text_inputs.each (item) ->
        liovdra = {}
        liovdra.id = $(this).data('liovdr-id')
        liovdra.line_item_option_value_id = $(this).data('liov-id')
        liovdra.text = $(this).val()

        lidra.line_item_option_value_detail_records_attributes.push liovdra

      # # allow only line_item#create to handle liovdrd creation
      # # on admin GUI, use separate function to upload documents

      # file_inputs = save.parents('tr').find('input[data-liov-input-type="file"][data-li-id="' + line_item_id + '"][data-lidr-position="' + position + '"]')
      # file_inputs.each (item) ->
      #   liovdra = {}
      #   liovdra.id = $(this).data('liovdr-id')
      #   liovdra.line_item_option_value_id = $(this).data('liov-id')
      #   liovdra.document_data = []
      #
      #   # test
      #   if ($(this).prop('files').length != 0)
      #     file = $(this).prop('files')[0]
      #     reader = new FileReaderSync()

        # liovdra.document_data.push({
        #   name: 'denture-complete.jpg',
        #   file_base: 'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQEAYABgAAD//gA7Q1JFQVRPUjogZ2QtanBlZyB2MS4wICh1c2luZyBJSkcgSlBFRyB2ODApLCBxdWFsaXR5ID0gNzUK/9sAQwAIBgYHBgUIBwcHCQkICgwUDQwLCwwZEhMPFB0aHx4dGhwcICQuJyAiLCMcHCg3KSwwMTQ0NB8nOT04MjwuMzQy/9sAQwEJCQkMCwwYDQ0YMiEcITIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIy/8AAEQgAqADcAwEiAAIRAQMRAf/EAB8AAAEFAQEBAQEBAAAAAAAAAAABAgMEBQYHCAkKC//EALUQAAIBAwMCBAMFBQQEAAABfQECAwAEEQUSITFBBhNRYQcicRQygZGhCCNCscEVUtHwJDNicoIJChYXGBkaJSYnKCkqNDU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6g4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2drh4uPk5ebn6Onq8fLz9PX29/j5+v/EAB8BAAMBAQEBAQEBAQEAAAAAAAABAgMEBQYHCAkKC//EALURAAIBAgQEAwQHBQQEAAECdwABAgMRBAUhMQYSQVEHYXETIjKBCBRCkaGxwQkjM1LwFWJy0QoWJDThJfEXGBkaJicoKSo1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoKDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uLj5OXm5+jp6vLz9PX29/j5+v/aAAwDAQACEQMRAD8A9+qKaeOBcuwHoO5qO8ultYs8FzworDeZpXLOxJNTKVjanSc9ehbuNQklJWP92nt1NVPMbOdxz65qNmphesnI7YUklZIvwahLERlt6+hrYgnjnTch+o7iuY31PbXL28odD9R604z7mdXDpq63OlpaihmWeMOh4NSVscDVhaKKYZEXq6j6mgB9JUTXESKWMi49jmq/9pRZ+6/14/xpXKUW9i7RVI6nCCMKxFN/tOLPCP8ApRdByS7F+iqQ1KE9Q4/CnjULc/xEfUUXQcsuxaxS1BHcwynCSAn06VPTJtYKKKKACiikoAWiiigAopKKAFooooA57VJS14R2QYFUifWrF3hruUk9WNVX+WueW56tFLlSEL0wtUbvUZkx3rNs6owJ99PV+aqCQVIj56VKY3A2dPvPIk5PyNwf8a0JtRRRiIbj6npWFCMDJqUuTXRGTSPOqUU53LUl1LIfmcn2qHd71HnNBODihyGqaQ/cTRg0i08e9IHoIBS5FISKTAphYU4pBn1pcUcUCFBIqwl7Og4fI9+arZpN3tTuS4JmnFqYPEqY91q3FcxTfccE+h4NYH4YpQ5U5BII7impsiVGL2OlorLtdQ6JN+Df41pAgjIORVppnPKDi7MdRSUtMkKKSopLiKI4eRVPpQCV9iaimI6SLuRgw9QadQBzV0pFxJ6bjVdgGGDVy/4eQj++ao7s1zy0Z6tG7imVpoGALIcjuO9Ui5zitaqtxaiQ71wH/nWMo9jtp1LaSKsfJyauQDJFVApRtrAg1ct+cetTHcuq9C4OBSg5qPdhvapE5NbnA1ZDwDS7falApwqrGTYgXFLS0UyBhWlHFLRSKCk+tLRigBKKDTScUDSFIFJgCml6YZBSuUotkvQ1esr0xEI5yn8qyxJmnGT0HNNStqTKk5aM6gMpUEHIPeoJLy3j4aUZ9Ac/yrnWnkZNrSNt/u54qPNU6vYiOD/mZtXGrRhSsIJJ/iPQVlF2diSSSe9RZFSRAuwAHWs3JyN40o01oaukqwaQ54xz9a1agtYBBAF/iPJ+tT10RVkebOXNJs53UX2zyL6sazW4ORVvW8peN78/pVJXDR5rlm/eseth42ppjw9PBBqtnB9qerVCZu4krRhhzyPemBNjfL0p4amuabJV9iQAsvH506Nmj6mkif5BSMdxqvMyabumTo/rT93FVxIQMbaPMOeB+dVzGbpstg8UpIHU1TLEDlsD2poZWY/zo5gVEu7h6ilqn8tKOOjEUcweyLeaaWqv5jjrg0hdj7UcwvZsnLj1qF39KYfrSZFJs0jCwHcTQE9TRvA6Cml/ep0NEmScKKYz1G0mKiaSk5FxgT7vWmmQCoDJxUe/mp5jRUy2Hya1tGg8yZpSOE6fWsJGywrrNIi8uxVj1clq1o6yOPGvkp27mhRUAuoS+wSDPSpq6jyLHJ66xa7Zuw4rJRyENbesx/v5B3zmsVYz5R4/irz6jfOz3sJJOkkOSTPB607fg+9VmJRgacTk8VCkdfKW1kp5IYVSD4608SEVSkQ4FteOpqTeKpiQ+tL5g9armM3AtGQAdaaZx61XLg0m4CjmGqZKZCx5pyMRUO+l8ylcHEnDml3mq/mUeZT5hchZ3e9G73qt5lHm0cwchY3U0vVcy0wy0nIaplkyVG0lVzL71GZfepcjRUidpKYXqAyU0ycgVPMaqmWC9M381GDlqVEZ5MKKTY7JF2zRpZkReWYgCuwuWFrYrGp7BBWDoVqBfKzHlQTitHUZ99yIweEGPxrro6QueJjJe0qqK2RCTmte0k862Rj16Gser2nyhIGX/bNbJ6nNON1oUtYGblx7CseL5gy46VuawmLkH1UVlQR7Wkb1xXFVv7RnTQnamZsw+fGO9SRRg9elPuk2zZqe1hHl7nGc9qxjueg6toJlORAM4NQhiOK0rqNSuVGDWWw5pNtM0o1FNEgYk8UEsozSxAYFTlcDkED1xT5inNJ2KYmzwaf5lRzpg7hUURLNz2pc5skmrk5mwcU4PxSLbu53Y4pJEaMcg07sn3Xoh3mUCXJxVUlmYKKuwW6gAt1pKd2E+WK1E3GmmT3qeWNADjiqRPz496cpWFBqRMA7/dHFRSMVODwa0reMsn4Vl6iwinweOKlysripTU58o0vmkz1q9p8Csodhkn1p+qBY7XcB3ovpzDdZe09mkZgPNTRQPIcgcVHZIJpcn7oreRBt4GKUXzCxFf2bsjNeDyLd5D94dKmsU+TJ6nvVuaIPbyKeeKZbLtQU2nzLscUq7lBmhZyi2mEp6AHj14pquZJCzHJJyaryPhT+QogbANddN6WOdQ0cupezT4AWQn/aNVg/yFq1NLTNqx9X/oK6I6swn7quLq0W6NJAOhwayEXAauivcfZJM9MVzqN+8KnuKyrxXNczotuNircRFnGO5xVkLtUAU9kyRQRXNy2udDndJEEoyhrKlXDke9bDDtVCaL94Pesp9zooTsx1nDxvI+lWpBwMiljXaoFOYZq0rIznNylcyruIIePumq0CYkwOcmtO6j3REVVsYiZSSOlYy0lY7adX927l1bfp8x6c1VvFZFw3I7GtMDnpVa7j8yFhitJKy0OanVfOrmPGAXGBzWzBGqhSRk1l2cR807uxrajUcVnSd9TXFVNbIguog0bEDBArCiJluPYGulkAKn6ViwW+y5fjjNKsndWDDVbQkmatuMLWFraFtRiA6bf61vx8LWbqMXmXcbegIp1Yv2dkTh6nLUuT2K4iWnatH5mnSAdcZFPt12KB6Ut4w+zPnpiqUf3bRm5v2qku5maZFtUfStlQAKpWiqIwRVpnCISaKMbRCvJzkOZhtPtVeOTgAA5qub5XkMQBBBwc1bjAwDV8yk9CeRwWoP8A6smkRvlpZCChUHmo4hkVrA2gvd1LIbICjtXUWkXk2qIeoHP1rB0y3866XI+VPmb+ldJXbSWlzzcXNXUUUdVlEdsF7uwFYKnMrH0q7rMxe7WMHhcD8etZ0D7pJvwrCu7yRpRhancla4ZCNwGM8mrGARkVl3cu1cd6sxyHyVYHqM1zxnq0zWVP3U0WStQvFllNNS5JcqQOKc03zDI4FN8rRKUkx4XApCtOWVH5VgadxT5b7Cu1uQOmVIqK2i2M31q1IyoCSR9KgglUlgxwc96zcVzIuLfKyY0yQZXFPLJ3dfzpkkigYBBJ9KpolXKcUW2QnFXVHFVWZkORzSxX8TAg5Vh1BFZw5Y6Gs1KWpPMwVCTVGFg+X7k1I0hmYcYXPSopIzHlkOOM0pO7utioKys9y2HwtZ1zI/nLIBlRUVrfyXMeCFz6iryRbouanmVRe6Vy+yfvEcd9D0LhW9DxRNILjCjlO9ZGoxmK5Qr2q3ZTBuDUqpJ+7I1lRSipxLSxtF/qycelWFV2xvNPTGM0b1U9a1UUjmcmzHuk8u/c+4P6VfinAiyWFU9Q5uS3qKiUHbSUbN2PR9mqlONy0s7M5x0NXYuFqnbR963tHsvPn81x+7jP5tXTSi3oc+InGnFs19NtDbW43D52+Zvb2q/SUtd6VlY8CUnJ3Zyd0xe4lf1YkVTibZK5PdauXamO4kRhggnHuKzpGAY/SuOqevSjeNivdPvY1ds23WCZ6jI/Ws5/marls4S1K56GuRKzudNWHuJIbDL/AKcB2bIq5MdorKDbJ0f0YGtG6ceVkHtUx0izOpD3okVlJvaRfQ1O525rP099t2Qf4xV27O1CaUfguKcbVLFeCXfM65q0V5rKtHKXi56Nwa2WwFzSp6rUddcskinLIFmQE1aUVk3T7pifQ1o2swkjHrTg9WFSDUEyWRBisiKUfbZF98VtPjyz9K5p8x37P2LVNbSzRWGXMpI6CJBSXmEtJW/2TTbaQMgOaj1F82rLnqK1v7plGLdRIxNNfy59vaukjI21zEOUkDe9bkMrbOSKypLl0OvF0ru6KWrgGfPtVS3k2sOce9WdQcOQAcmqA61TjqdNGF6STNxJ/k61Xe5+fjn3qkrNjBJp4FVYiNCMXcfIxkcEip4k4FRxR7iM9K0bW1kuJlijXLHv2A9TWsI3YqtRU0T2Fm91KI4+B1Zuyiuvt4Et4ViQYVRUVlZpZQCNeT1Zu5NWRXoU4cqPncTXdWWmw6ikpa0Ocq3dlFdph1+YDhh1FchfWslrO0Ug5HQ+oruKq3ljDex7ZV+hHUVlUp8y0OnDYh0nrscLtw2aN2ARW9N4amBJhmRh6MMVTbQL/OBCp994rkdKS6HqxxVGS+Iyhyald90eK0B4c1BuojX6v/hTJNA1CMZESuP9kg1DpStsX7ei38SMoAhgR1B4q1LOZYcEc1FJBLC+2WN429GGKbk9Kz5ehs7SsyILggjqDmtZZQ0OSe1Z2MU8MAuDmko22Jqw57FaYEyMe2akt5CjDB60kg3dKYMip5bGtrxsavm7krIu4wZDxVhbgqKruxdsmm1cijTcJXLVq5ROtNvJNyYzVZWZehxSNljk0JWVi1SXPzEABBqdXcLjcabilAppG7sxj5PPekWLPOal20qpTsPmsNCkdqkSMk5NSIuBWjp+lT375UbIwfmcjj8PWtIwb0Rz1KygrydkQ2dtLczLFAm5j+QHqa7HT9PSwg2jlz95vU/4VJZ2MNlCI4lx6k9WPvVrpXdTpcur3PAxWLdZ2WwtFJRWpyC0UlLQAUUUUAFFFFABRRRQBFJFHMhSRFZT2YZFZdz4espiSgaJvVOn5UUUpQT3KjVnD4WZNx4cuosmFklHp901nSWc8Rw9vID9DRRXLUpxWqPTw+KqSdmxY7C6nOIreQ+5GB+ZrRtvC88pDXMixr/dX5j/AIUUUU6UXqxYjF1YO0XY0v8AhGdP8vbtl3f3t/P+FZdz4UuFJNtMrr2D8GiitnRg+hyU8bXi781/UzpdF1GL71q591Ib+VVjaXS/ftpV+qEUUVyzpRjsepQxc5rVIZ5Mv/POT/vk05bW4b7tvK30UmiioUU2dU60krlmHRdQmxttXA9Wwv8AOtKDwrctgzzRoPRcsf6UUV0wowZ5VfH1k7LQ2LXw/Y22CymVh/z0OR+XStZVCqFUAAdAKKK6FFLY86VWdR+87jqKKKYgooooAKKKKAP/2Q=='
        # })
        # liovdra.document_data.push({
        #   name: 'denture-single.jpg',
        #   file_base: 'data:image/jpeg;base64,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'
        # })

        # lidra.line_item_option_value_detail_records_attributes.push liovdra

      line_item_detail_records_attributes.push lidra

    toggleItemEdit()
    adjustLineItem(line_item_id, quantity, line_item_detail_records_attributes)
    false

  # handle delete click
  $('a.delete-line-item').click ->
    if confirm(Spree.translations.are_you_sure_delete)
      del = $(this);
      line_item_id = del.data('line-item-id');

      toggleItemEdit()
      deleteLineItem(line_item_id)

  $('a.delete-line-item-option-value-detail-record-document').click ->
    if confirm(Spree.translations.are_you_sure_delete)
      del = $(this);
      liovdrd_id = del.data('line-item-option-value-detail-record-document-id');

      # toggleItemEdit()
      deleteLineItemOptionValueDetailRecordDocument(liovdrd_id)

  # when liovdr-input has a file, show corresponding upload button
  $('input.line_item_option_value_detail_record_file_input').each (item) ->
    line_item_id = $(this).data('li-id')
    position = $(this).data('lidr-position')

    # hide at initial load
    $('button.line_item_option_value_detail_record_file_upload[data-li-id="' + line_item_id + '"][data-lidr-position="' + position + '"]').hide()

    $(this).change ->
      if ($(this).val())
        $('button.line_item_option_value_detail_record_file_upload[data-li-id="' + line_item_id + '"][data-lidr-position="' + position + '"]').show()
      else
        $('button.line_item_option_value_detail_record_file_upload[data-li-id="' + line_item_id + '"][data-lidr-position="' + position + '"]').hide()

  # when liovdr-upload is clicked, upload file
  $('button.line_item_option_value_detail_record_file_upload').each (item) ->
    line_item_id = $(this).data('li-id')
    position = $(this).data('lidr-position')

    # hide at initial load
    $(this).click ->
      input = $('input.line_item_option_value_detail_record_file_input[data-li-id="' + line_item_id + '"][data-lidr-position="' + position + '"]')
      if (input.prop('files').length > 0)
        file = input.prop('files')[0]
        reader = new FileReader()
        liovdr_id = $(this).data('liovdr-id');

        proceedWithCreate = ->
          createLineItemOptionValueDetailRecordDocument(file.name, reader.result, liovdr_id)

        reader.addEventListener('load', proceedWithCreate)
        reader.readAsDataURL(file);


toggleLineItemEdit = ->
  link = $(this);
  link.parent().find('a.edit-line-item').toggle();
  link.parent().find('a.cancel-line-item').toggle();
  link.parent().find('a.save-line-item').toggle();
  link.parent().find('a.delete-line-item').toggle();
  link.parents('tr').find('td.line-item-qty-show').toggle();
  link.parents('tr').find('td.line-item-qty-edit').toggle();

  link.parents('tr').find('td.line-item-order-details-show').toggle();
  link.parents('tr').find('td.line-item-order-details-edit').toggle();

  false

lineItemURL = (line_item_id) ->
  url = Spree.routes.orders_api + "/" + order_number + "/line_items/" + line_item_id + ".json"

lineItemOptionValueDetailRecordDocumentURL = (liovdrd_id) ->
  url = Spree.routes.liovdrd_api + "/" + liovdrd_id

# TODO: handle failed create
createLineItemOptionValueDetailRecordDocument = (name, file_base, liovdr_id) ->
  console.log('createLineItemOptionValueDetailRecordDocument called: ' + name + ' / ' + liovdr_id + ' / ' + file_base + ' / ');

  url = Spree.routes.liovdrd_api
  $.ajax(
    type: "POST",
    url: Spree.url(url),
    data:
      line_item_option_value_detail_record_document:
        name: name,
        upload_file_name: name,
        file_base: file_base,
        line_item_option_value_detail_record_id: liovdr_id
      token: Spree.api_key
  ).done (msg) ->
    window.location.reload();

adjustLineItem = (line_item_id, quantity, line_item_detail_records_attributes) ->
  url = lineItemURL(line_item_id)
  $.ajax(
    type: "PUT",
    url: Spree.url(url),
    data:
      line_item:
        quantity: quantity,
        line_item_detail_records_attributes: line_item_detail_records_attributes
      token: Spree.api_key
  ).done (msg) ->
    window.Spree.advanceOrder()

deleteLineItem = (line_item_id) ->
  url = lineItemURL(line_item_id)
  $.ajax(
    type: "DELETE"
    url: Spree.url(url)
    data:
      token: Spree.api_key
  ).done (msg) ->
    $('#line-item-' + line_item_id).remove()
    if $('.line-items tr.line-item').length == 0
      $('.line-items').remove()
    window.Spree.advanceOrder()

deleteLineItemOptionValueDetailRecordDocument = (liovdrd_id) ->
  url = lineItemOptionValueDetailRecordDocumentURL(liovdrd_id)
  $.ajax(
    type: "DELETE"
    url: Spree.url(url)
    data:
      token: Spree.api_key
  ).done (msg) ->
    $('div[data-line-item-option-value-detail-record-document-id="' + liovdrd_id + '"]').each (item) ->
      $(this).remove()

