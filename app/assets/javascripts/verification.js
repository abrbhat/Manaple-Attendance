$(document).ready(function () {
  $('.photo-verification-form').hide();
  $('.photo-container > .photo-container-element').hide();
  $('.final-verification-check').bootstrapSwitch();
  $('.final-verification-check').bootstrapSwitch('onColor', 'success');
  $('.final-verification-check').bootstrapSwitch('offColor', 'danger');
  $('.final-verification-check').bootstrapSwitch('onText', 'Pass');
  $('.final-verification-check').bootstrapSwitch('offText', 'Fail');
  count = $('.photo-container > .photo-container-element').size();

  i = 0;
  $('.photo-container > .photo-container-element:eq(0)').show();

  $('#status').html('Marking ' + (i+1) + ' of ' + count);
  $(".pass-button").click(function(){
    if (i<count){
        current_visible = $('.photo-container > .photo-container-element:eq('+i+')');
        id = $('.photo-container > .photo-container-element:eq('+i+')').prop('id').split(/\s*\-\s*/g)[0]
        form_id = id+'-form'
        $('#'+form_id).bootstrapSwitch('toggleState');
        current_visible.css("background-color", "lightgreen");
        current_visible.fadeOut();
        i = i+1;
        $('.photo-container > .photo-container-element:eq('+i+')').show();
      }else{
        $('.photo-verification-form').show();
        $('.verification-form-submit').removeAttr('disabled');
      }
      $('#status').html('Marking ' + (i + 1) + ' of ' + count);
    if (i == count){
      $('#status').html("You can submit now!");
      $('.photo-verification-form').show();
      $('.verification-form-submit').removeAttr('disabled');
    }
  });
  $(".fail-button").click(function(){
    if (i<count){
        current_visible = $('.photo-container > .photo-container-element:eq('+i+')');
        id = $('.photo-container > .photo-container-element:eq('+i+')').prop('id').split(/\s*\-\s*/g)[0]
        form_id = id+'-form'
        current_visible.css("background-color", "lightcoral");
        current_visible.fadeOut();
        i = i+1;
        $('.photo-container > .photo-container-element:eq('+i+')').show();
      }else{
        $('.photo-verification-form').show();
        $('.verification-form-submit').removeAttr('disabled');
      }
    $('#status').html('Marking ' + (i + 1) + ' of ' + count);
    if (i == count){
      $('#status').html("You can submit now!");
      $('.photo-verification-form').show();
      $('.verification-form-submit').removeAttr('disabled');
    }
  });
  $(document).keypress(function(e) {
    if(e.which == 80 || e.which == 112) {   // 'p/P'
      if (i<count){
        current_visible = $('.photo-container > .photo-container-element:eq('+i+')');
        id = $('.photo-container > .photo-container-element:eq('+i+')').prop('id').split(/\s*\-\s*/g)[0]
        form_id = id+'-form'
  //      $('#'+form_id).prop('checked', true);
        $('#'+form_id).bootstrapSwitch('toggleState');
        current_visible.css("background-color", "lightgreen");
        current_visible.fadeOut();
        i = i+1;
        $('.photo-container > .photo-container-element:eq('+i+')').show();
      }else{
        $('.photo-verification-form').show();
        $('.verification-form-submit').removeAttr('disabled');
      }
    }
    if(e.which == 70 || e.which == 102) {   // 'f/F'
      if (i<count){
        current_visible = $('.photo-container > .photo-container-element:eq('+i+')');
        id = $('.photo-container > .photo-container-element:eq('+i+')').prop('id').split(/\s*\-\s*/g)[0]
        form_id = id+'-form'
        current_visible.css("background-color", "lightcoral");
        current_visible.fadeOut();
        i = i+1;
        $('.photo-container > .photo-container-element:eq('+i+')').show();
      }else{
        $('.photo-verification-form').show();
        $('.verification-form-submit').removeAttr('disabled');
      }
    }
    $('#status').html('Marking ' + (i + 1) + ' of ' + count);
    if (i == count){
      $('#status').html("You can submit now!");
      $('.photo-verification-form').show();
      $('.verification-form-submit').removeAttr('disabled');
    }
  });
  
});
