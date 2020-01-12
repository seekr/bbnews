$(document).on('turbolinks:load', function() {
  $('#menuToggle').click(function(e) {
    $('nav').toggleClass('closed');
  });
});
