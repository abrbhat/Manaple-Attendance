$(document).ready(function () {
$('.photo-verification-form').hide();
count = $('.photo-container > .photo-container-element').size();
$('.photo-container > .photo-container-element').hide();

i = 0;
$('.photo-container > .photo-container-element:eq(0)').show();
i += 1;

$('#status').html('Marking ' + i + ' of ' + count);

$(document).keypress(function(e) {

  if(e.which == 80 || e.which == 112) {   // 'p/P'
    if (i<=count){
      current_visible = $('.photo-container > .photo-container-element:eq('+i+')');
      id = $('.photo-container > .photo-container-element:eq(0)').prop('id').split(/\s*\-\s*/g)[0]
      form_id = id+'-form'
      $('#'+form_id).prop('checked', true);
      current_visible.hide();
      i = i+1;
      $('.photo-container > .photo-container-element:eq('+i+')').show();
    }else{
      $('ul > li').show();
    }
  }
  if(e.which == 70 || e.which == 102) {   // 'f/F'
    if (i<=count){
      current_visible = $('.photo-container > .photo-container-element:eq('+i+')');
      id = $('.photo-container > .photo-container-element:eq(0)').prop('id').split(/\s*\-\s*/g)[0]
      form_id = id+'-form'
      $('#'+form_id).prop('checked', false);
      current_visible.hide();
      i = i+1;
      $('.photo-container > .photo-container-element:eq('+i+')').show();
    }else{
      $('ul > li').show();
    }
  }
  $('#status').html('Marking ' + i + ' of ' + count);
  if (i == count+1){
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