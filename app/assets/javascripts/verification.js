$(document).ready(function () {
$('.photo-verification-form').hide();
$('.photo-container > .photo-container-element').hide();
//$('.final-verification-check').bootstrapSwitch();
count = $('.photo-container > .photo-container-element').size();

i = 0;
$('.photo-container > .photo-container-element:eq(0)').show();

$('#status').html('Marking ' + (i+1) + ' of ' + count);

$(document).keypress(function(e) {

  if(e.which == 80 || e.which == 112) {   // 'p/P'
    if (i<count){
      current_visible = $('.photo-container > .photo-container-element:eq('+i+')');
      id = $('.photo-container > .photo-container-element:eq('+i+')').prop('id').split(/\s*\-\s*/g)[0]
      form_id = id+'-form'
      $('#'+form_id).prop('checked', true);
      $('#'+form_id).bootstrapSwitch('setState', true);
      current_visible.hide();
      i = i+1;
      $('.photo-container > .photo-container-element:eq('+i+')').show();
    }else{
      $('.photo-verification-form').show();
    }
  }
  if(e.which == 70 || e.which == 102) {   // 'f/F'
    if (i<count){
      current_visible = $('.photo-container > .photo-container-element:eq('+i+')');
      id = $('.photo-container > .photo-container-element:eq('+i+')').prop('id').split(/\s*\-\s*/g)[0]
      form_id = id+'-form'
      $('#'+form_id).prop('checked', false);
      $('#'+form_id).bootstrapSwitch('setState', false);
      current_visible.hide();
      i = i+1;
      $('.photo-container > .photo-container-element:eq('+i+')').show();
    }else{
      $('.photo-verification-form').show();
    }
  }
  $('#status').html('Marking ' + (i + 1) + ' of ' + count);
  if (i == count){
    $('#status').html("You can submit now!");
    $('.photo-verification-form').show();
    $('.form-submit-button').removeAttr('disabled');
  }
});
});

// $(document).keypress(function(e) {

//   if(e.which == 84 || e.which == 116) {   // 't'
//     if (i<=count){
//       current_visible = $('ul > li:eq('+i+')');
//       current_value = $('ul > li:eq('+i+') > table > tbody > tr:first > td:last > input:last');
//       current_visible.hide();
//       current_value.prop('checked', true);
//       i = i+1;
//       $('ul > li:eq('+i+')').show();
//     }else{
//       $('ul > li').show();
//     }
//   }
//   if(e.which == 70 || e.which == 102) {   // 'f'
//     if (i<=count){
//       current_visible = $('ul > li:eq('+i+')');
//       current_value = $('ul > li:eq('+i+') > table > tbody > tr:first > td:last > input:last');
//       current_visible.hide();
//       current_value.prop('checked', false);
//       i = i+1;
//       $('ul > li:eq('+i+')').show();
//     }else{
//       $('ul > li').show();
//     }
//   }
//   $('#status').html('Marking ' + i + ' of ' + count);
//   if (i == count+1){
//     $('#status').html("You can submit now!");
//     $('ul > li').show();
//     $('.form-submit-button').removeAttr('disabled');
//   }
// });