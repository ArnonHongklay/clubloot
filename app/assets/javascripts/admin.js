$(document).on('turbolinks:load', function() {
  $('#datetimepicker1').datetimepicker({ format: 'YYYY-MM-DD HH:mm:ss' });
  $('#datetimepicker2').datetimepicker({ format: 'YYYY-MM-DD HH:mm:ss' });
  $('#announcement_datetimepicker').datetimepicker({ format: 'YYYY-MM-DD HH:mm:ss' });
});
