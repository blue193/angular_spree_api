$(document).ready(function () {
  'use strict';

  // run at first load
  evalSelectType();

  // When input_type != 'selection', hide select_type dropdown
  $( "#new_line_item_input_type" ).on( "click", function() {
    evalSelectType();
  });

  function evalSelectType() {
    if ($('#new_line_item_input_type').val() == 'selection') {
      $('#div_new_line_item_select_type').show();
    } else {
      $('#div_new_line_item_select_type').hide();
    }
  }
});
