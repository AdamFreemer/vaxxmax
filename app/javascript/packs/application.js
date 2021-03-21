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


  $("#state-select-rite-aid").on('change', function(){
    var state_dropdown_value = $("#state-select-rite-aid").val();

    $.get( "/set_state_rite_aid/" + state_dropdown_value +  "/" + localStorage['zipcode'], function( data ) {
      $( ".result" ).html( data );
      location.reload();
    });
  });

  $("#state-select-walgreens").on('change', function(){
    var state_dropdown_value = $("#state-select-walgreens").val();

    $.get( "/set_state_walgreens/" + state_dropdown_value, function( data ) {
      $( ".result" ).html( data );
      location.reload();
    });
  });

  $("#state-select-cvs").on('change', function(){
    var state_dropdown_value = $("#state-select-cvs").val();

    $.get( "/set_state_cvs/" + state_dropdown_value, function( data ) {
      $( ".result" ).html( data );
      location.reload();
    });
  });

  $("#state-select-health-mart").on('change', function(){
    var state_dropdown_value = $("#state-select-health-mart").val();

    $.get( "/set_state_health_mart/" + state_dropdown_value, function( data ) {
      $( ".result" ).html( data );
      location.reload();
    });
  });

  $("#provider").on('change', function(){
    console.log("provider onchangexx: " + $("#provider").val())
    if ($("#provider").val() == "healthmart") {
      localStorage['provider'] = "healthmart";
      document.location.href = '/health_mart';
    }
    
    if ($("#provider").val() == "walgreens") {
      localStorage['provider'] = "walgreens";
      document.location.href = '/walgreens';
    }
    if ($("#provider").val() == "riteaid") {
      localStorage['provider'] = "riteaid";
      document.location.href = '/riteaid';
    }
    if ($("#provider").val() == "cvs") {
      localStorage['provider'] = "cvs";
      document.location.href = '/cvs';
    }
  });
});
