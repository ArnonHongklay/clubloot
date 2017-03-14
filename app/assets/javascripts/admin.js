//= require jquery-ujs
//= require cable

$(document).on('ready', function() {

  var bodyId = $('body').attr('id');
  // console.log(bodyId);

  function init() {
    console.log("xxxx")
    if(bodyId == 'edit-template' || bodyId == 'new-template') {
        $('#datetimepicker1').datetimepicker({ format: 'YYYY-MM-DD HH:mm' });
        $('#datetimepicker2').datetimepicker({ format: 'YYYY-MM-DD HH:mm' });
    }

    if(bodyId == 'announcement'){
      $('#announcement_datetimepicker').datetimepicker({ format: 'YYYY-MM-DD HH:mm' });
    }

    $('#datetimepicker6').datetimepicker({
      format: 'YYYY-MM-DD'
    });
    $('#datetimepicker7').datetimepicker({
      useCurrent: false,
      format: 'YYYY-MM-DD'
    });
    $("#datetimepicker6").on("dp.change", function (e) {
      $('#datetimepicker7').data("DateTimePicker").minDate(e.date);
    });
    $("#datetimepicker7").on("dp.change", function (e) {
      $('#datetimepicker6').data("DateTimePicker").maxDate(e.date);
    });
  }

  init()
});
