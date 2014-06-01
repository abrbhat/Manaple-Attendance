$(document).ready(function(){	
	$('#attendance-data-date-chooser').datepicker({
					format: 'dd-mm-yyyy'
				});
	$('#attendance-data-time-period-start-chooser').datepicker({
					format: 'dd-mm-yyyy'
				});
	$('#attendance-data-time-period-end-chooser').datepicker({
					format: 'dd-mm-yyyy'
				});
	$('.attendance-status-popover').tooltip();
	$( "#take-picture-button" ).click(function() {
		var data_uri = Webcam.snap();
    	var raw_image_data = data_uri.replace(/^data\:image\/\w+\;base64\,/, '');
    	var employee_id = $("#photo_user_id").val();
    	$.ajax({
	      type: "POST",
	      url: "/photos/upload",
	      async:"true",      
	      data: {"photo_data":raw_image_data,
	  			 "photo_employee_id":employee_id},
	      error: function(){
	        $("#spinner").hide()
	        alert('There was an error during file upload. Please contact at 8953342253.'); 
	        $('#take-picture-button').show();
	      },
	      success: function(data){	
	      	$("#spinner").hide();        
        	$('#photo-form').show();
        	$('#webcam').html('<img src="'+data_uri+'"/>');
	      },
	      beforeSend: function(){
	      	$('#take-picture-button').hide();
	      	$("#spinner").text("");
	        var target = document.getElementById("spinner");
            var spinner = new Spinner().spin(target); 
	      }
	    });
	});	
});