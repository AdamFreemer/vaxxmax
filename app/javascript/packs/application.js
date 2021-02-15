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
  $("#fetch-button").click(function(){
    $("#loading").show();
    $("#fetch-button").hide();
    $.get( "/update_records", function( data ) {
      $( ".result" ).html( data );
      alert( "Load was performed." );
      location.reload(); 
    });
  }); 

  $("#state-select").on('change', function(){
    var state_dropdown_value = $("#state-select").val();

    $.get( "/set_state/" + state_dropdown_value, function( data ) {
      $( ".result" ).html( data );
      location.reload();
    });
  });

  $('#locations').DataTable(
    {
      "iDisplayLength": 100,
      "order": [[ 9, "desc" ]]
    }
  );
});
