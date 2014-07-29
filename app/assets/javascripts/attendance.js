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


function goToNextAttendancePage(currentPage){	
	var nextPage = getNextAttendancePage(currentPage);
	if (nextPage == '3'){
		setWebcam();		
	    showTakePictureButtonContainer();
	}
	$(".attendance-page").hide();
	$("#attendance-page-"+nextPage).show();
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
function showSavePhotoAndTakeAnotherButtonContainer(){
	$(".photo-form-container").hide();
	$("#save-photo-and-take-another-button-container").show();
}
function showSpinner(){
	$(".photo-form-container").hide();
	$("#spinner-container").show();
}
function showTakePictureButtonContainer(){
	$(".photo-form-container").hide();
	$("#take-picture-button-container").show();
}
function initializeSpinner(){
	$("#spinner").text("");
	var target = document.getElementById("spinner");
    var spinner = new Spinner().spin(target); 
    $("#spinner-container").hide();
}
$(document).ready(function() {
	var selectedEmployeeId, selectedAttendanceMarker, storeId;
	storeId = $("#store-id").val();
  goToAttendancePage('1');
	initializeSpinner();
	
	$(".next-attendance-page-button").click(function(){
		var currentPageId = $(this).closest('.attendance-page').attr('id');
		var currentPage = currentPageId.slice(-1);
		goToNextAttendancePage(currentPage);
	})
	$("#take-another-picture-button").click(function(){
		showTakePictureButtonContainer();
		setWebcam();
	})
	$( "#take-picture-button" ).click(function() {
		 var data_uri = Webcam.snap();
     var raw_image_data = data_uri.replace(/^data\:image\/\w+\;base64\,/, '');
     showSpinner();
    	$.ajax({
	      type: "POST",
	      url: "/photos/upload",
	      async:"true",      
	      data: {"photo_data":raw_image_data,
	  			 "photo_employee_id":selectedEmployeeId},
	      error: function(){
	        $("#spinner").hide()
	        alert('There was an error during file upload. Please contact at 8953342253.'); 
	        showTakePictureButtonContainer();
	      },
	      success: function(data){	
	      	showSavePhotoAndTakeAnotherButtonContainer();     
        	$('#webcam').html('<img src="'+data_uri+'"/>');
	      },
	      beforeSend: function(){
	      	
	      }
	    });
	});	
	$("#save-photo-button").click(function() {
		showSpinner();
		$.ajax({
	      type: "POST",
	      url: "/photos",
	      async:"true",      
	      data: {"photo[store_id]":storeId,
	      		 "photo[user_id]":selectedEmployeeId,
	  			 "photo[description]":selectedAttendanceMarker},
	      error: function(){
	        alert('There was an error during file upload. Please contact at 8953342253.'); 
	        goToAttendancePage('1');
	      },
	      success: function(data){	
	      	goToAttendancePage('4');
	      	$("#employee-name-attendance-marked").html(data["employee_name"]);
	      	$("#description-attendance-marked").html(data["description"]);
	      	$("#time-attendance-marked").html(data["time"]);   
	      },
	      beforeSend: function(){
	      	
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

