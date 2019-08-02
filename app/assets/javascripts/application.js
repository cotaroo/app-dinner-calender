// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .
//= require jquery

/* フラッシュ ================================ */
$(function(){
    $("#notice").css("display", "none");
    
    if($('#notice').text() != ''){
      $("#notice").css({
        'display' : 'block',
        'width' : '100%',
        'position': 'fixed',
        'top' : '-60px',
        'background-color' : '#FE9933',
        'color': '#FFFFFF',
        'z-index': '-1',
        'border-radius': '16px',
        'font-size': '40px',
        'padding': '28px 0',
        'text-align': 'center',
      }).animate({
        'top' : '158px',
      },1000).delay(3000).animate({
        'top' : '-60px',
        'z-index': '-1'
      },1000);
    }
  });
