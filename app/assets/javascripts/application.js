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



var nextVal = 0;
document.addEventListener("DOMContentLoaded", function(event) {
    var el = document.querySelector(".gallery")
    if(el){
        setTimeout(swapWindow, 2000Oe)
    }
});

function swapWindow() {
    var el = document.querySelector(".gallery")
    nextVal = (nextVal + 200) % el.scrollWidth
    el.scrollLeft = nextVal;
    setTimeout(swapWindow, 2000)
}