$(document).ready(function () {
  'use strict';

  function formatLineItemOptionType(line_item_option_type) {
    return Select2.util.escapeMarkup(line_item_option_type.presentation + ' (' + line_item_option_type.name + ')');
  }

  if ($('#product_line_item_option_type_ids').length > 0) {
    $('#product_line_item_option_type_ids').select2({
      placeholder: Spree.translations.line_item_option_type_placeholder,
      multiple: true,
      initSelection: function (element, callback) {
        var url = Spree.url(Spree.routes.line_item_option_type_search, {
          ids: element.val(),
          token: Spree.api_key
        });
        return $.getJSON(url, null, function (data) {
          return callback(data);
        });
      },
      ajax: {
        url: Spree.routes.line_item_option_type_search,
        quietMillis: 200,
        datatype: 'json',
        data: function (term) {
          return {
            q: {
              name_cont: term
            },
            token: Spree.api_key
          };
        },
        results: function (data) {
          return {
            results: data
          };
        }
      },
      formatResult: formatLineItemOptionType,
      formatSelection: formatLineItemOptionType
    });
  }
});
