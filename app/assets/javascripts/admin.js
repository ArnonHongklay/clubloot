//= require jquery-ujs

$(document).on('ready', function() {

  var bodyId = $('body').attr('id');
  console.log(bodyId);

  function init() {
    console.log("xxxx")
    if(bodyId == 'edit-template' || bodyId == 'new-template') {
        $('#datetimepicker1').datetimepicker({ format: 'YYYY-MM-DD HH:mm' });
        $('#datetimepicker2').datetimepicker({ format: 'YYYY-MM-DD HH:mm' });
    }

    if(bodyId == 'announcement'){
      $('#announcement_datetimepicker').datetimepicker({ format: 'YYYY-MM-DD HH:mm' });
    }
  }
  init()
});
