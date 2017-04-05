//= require cable

$(document).on('ready', function() {
  var Clubloot = function(){};
  var bodyId = $('body').attr('id');

  Clubloot.load = function() {
    // console.log("xxxx")
    if(bodyId == 'edit-template' || bodyId == 'new-template') {
        $('#datetimepicker1').datetimepicker({ format: 'YYYY-MM-DD HH:mm' });
        $('#datetimepicker2').datetimepicker({ format: 'YYYY-MM-DD HH:mm' });
    }

    if(bodyId == 'announcement'){
      $('#announcement_datetimepicker').datetimepicker({ format: 'YYYY-MM-DD HH:mm' });
    }

    if(bodyId == 'promo'){
      $('#expires_datetimepicker').datetimepicker({ format: 'YYYY-MM-DD HH:mm' });
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

  Clubloot.prizes = function() {
    if(bodyId == 'prizes'){
      $('#exampleModalLong').on('shown.bs.modal', function (event) {
        var button = $(event.relatedTarget)
        var userPrizeId = button.data('id')

        var modal = $(this)

        $('#userPrizeId').val(userPrizeId)
        $('#tracking_code').focus()
      });

      $('#submitPrize').on('click', function(){
        userPrizeId = $('#userPrizeId').val();
        userPrizePath = $('#userPrizePath').val();
        tracking_code = $('#tracking_code').val();
        carrier = $('#carrier').val();

        console.log(userPrizeId);
        console.log(userPrizePath);
        $.ajax({
          url: "" + userPrizePath,
          data: {
            'id': userPrizeId,
            'tracking_code': tracking_code,
            'carrier': carrier
          },
          type: 'PUT',
          success: function(result) {
            console.log(result)
            $('#exampleModalLong').modal('hide');
            location.reload();
          }
        });
      });
    }
  }

  Clubloot.load();
  Clubloot.prizes();
});
