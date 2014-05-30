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
		webcam.snap();
	});
	
});