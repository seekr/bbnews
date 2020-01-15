$(document).on('turbolinks:load', function() {
  $('#menuToggle, .closed').click(function(e) {
    $('nav').toggleClass('closed');
  });
});
