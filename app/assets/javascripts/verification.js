$(document).ready(function () {
count = $('ul > li').size();
count = count-1;
$('ul > li').hide();
$('ul > li:hidden:first').show();   // Show Sign Out Button
i = 0;

$('ul > li:hidden:first').show();
i += 1;

$('#status').html('Marking ' + i + ' of ' + count);

$(document).keypress(function(e) {

  if(e.which == 84 || e.which == 116) {   // 't'
    if (i<=count){
      current_visible = $('ul > li:eq('+i+')');
      current_value = $('ul > li:eq('+i+') > table > tbody > tr:first > td:last > input:last');
      current_visible.hide();
      current_value.prop('checked', true);
      i = i+1;
      $('ul > li:eq('+i+')').show();
    }else{
      $('ul > li').show();
    }
  }
  if(e.which == 70 || e.which == 102) {   // 'f'
    if (i<=count){
      current_visible = $('ul > li:eq('+i+')');
      current_value = $('ul > li:eq('+i+') > table > tbody > tr:first > td:last > input:last');
      current_visible.hide();
      current_value.prop('checked', false);
      i = i+1;
      $('ul > li:eq('+i+')').show();
    }else{
      $('ul > li').show();
    }
  }
  $('#status').html('Marking ' + i + ' of ' + count);
  if (i == count+1){
    $('#status').html("You can submit now!");
    $('ul > li').show();
    $('.form-submit-button').removeAttr('disabled');
  }
});
});
