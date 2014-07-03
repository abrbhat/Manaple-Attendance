//= require photos

function getNextAttendancePage(currentPage){
	var nextPage;
	switch(currentPage) {
    case '1':
        nextPage = '2';
        break;
    case '2':
        nextPage = '3';
        break;
    case '3':
        nextPage = '4';
        break;    
    default:
        nextPage = '1';
	} 
	return nextPage;
}
function initializeAttendancePageSwitching(){
	$(".next-attendance-page-button").click(function(){
		var currentPageId = $(this).closest('.attendance-page').attr('id');
		var currentPage = currentPageId.slice(-1);
		var nextPage = getNextAttendancePage(currentPage);
		if (nextPage == '3'){
			setWebcam();
		}
		$(".attendance-page").hide();
		$("#attendance-page-"+nextPage).show();
	})
}
function goToAttendancePage(page){
	$(".attendance-page").hide();
	$("#attendance-page-"+page).show();
}
function setWebcam(){
  $("#webcam").html("");
  Webcam.set({
            dest_width: 640,
            dest_height: 480,
            image_format: 'jpeg',
            jpeg_quality: 90
        });
        Webcam.attach( '#webcam' );
        Webcam.setSWFLocation("/public/webcam.swf");
}
$(document).ready(function(){	
	$(".attendance-page").hide();	
	$("#attendance-page-1").show();
	initializeAttendancePageSwitching();
	var selectedEmployeeId, selectedAttendanceMarker;
	$("#take-another-picture-button").click(function(){
		setWebcam();
	})
	$( "#take-picture-button" ).click(function() {
		var data_uri = Webcam.snap();
    	var raw_image_data = data_uri.replace(/^data\:image\/\w+\;base64\,/, '');
    	$.ajax({
	      type: "POST",
	      url: "/photos/upload",
	      async:"true",      
	      data: {"photo_data":raw_image_data,
	  			 "photo_employee_id":selectedEmployeeId},
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
	$("#save-photo-button").click(function() {
		$.ajax({
	      type: "POST",
	      url: "/photos/create",
	      async:"true",      
	      data: {"photo[user_id]":selectedEmployeeId,
	  			 "photo[description]":selectedAttendanceMarker},
	      error: function(){
	        $("#spinner").hide()
	        alert('There was an error during file upload. Please contact at 8953342253.'); 
	        goToAttendancePage('1');
	      },
	      success: function(data){	
	      	$("#spinner").hide();        
        	console.log(data) ;
	      },
	      beforeSend: function(){
	      	$('#photo-form').hide();
			$("#spinner").show(); 
	      }
	    });
	});	
	$(".employee-name-option").click(function(){
		$(".employee-name").html($(this).html());
	})
	$(".attendance-marker-option").click(function(){
		selectedAttendanceMarker = $(this).data("attendance-marker-value");
		$("#selected-attendance-marker").val(selectedAttendanceMarker);
	});
	$(".employee-name-option").click(function(){
		selectedEmployeeId = $(this).data("employee-id");
		$("#selected-employee-id").val(selectedEmployeeId);
	});
	$("#mark-another-attendance-button").click(function(){
		goToAttendancePage('1');
	})
});
