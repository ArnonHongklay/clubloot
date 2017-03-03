$(document).on('turbolinks:load', function() {
  var bodyId = $('body').attr('id');
  console.log(bodyId);
  if(bodyId == 'edit-template' || bodyId == 'new-template') {
    $('#datetimepicker1').datetimepicker({ format: 'YYYY-MM-DD HH:mm:ss' });
    $('#datetimepicker2').datetimepicker({ format: 'YYYY-MM-DD HH:mm:ss' });
  }

  if(bodyId == 'announcement'){
    $('#announcement_datetimepicker').datetimepicker({ format: 'YYYY-MM-DD HH:mm:ss' });
  }
});
