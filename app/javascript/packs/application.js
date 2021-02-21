// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import 'bootstrap'
import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

$(document).ready(function() {
  $("#state-select").on('change', function(){
    var state_dropdown_value = $("#state-select").val();

    $.get( "/set_state/" + state_dropdown_value, function( data ) {
      $( ".result" ).html( data );
      location.reload();
    });
  });

  $('#locations').DataTable(
    {
      "iDisplayLength": 25,
      "order": [[ 7, "desc" ]],
      "oLanguage": {
        "sSearch": "Search: "
      }
    }
  );

  $('#logs').DataTable(
    {
      "iDisplayLength": 25,
      "order": [[ 0, "asc" ]],
      "oLanguage": {
        "sSearch": "Search: "
      }
    }
  );
});
