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
	$('#select-all').change(function() {
	    var checkboxes = $(this).closest('form').find(':checkbox');
	    if($(this).is(':checked')) {
	        checkboxes.attr('checked', 'checked');
	    } else {
	        checkboxes.removeAttr('checked');
	    }
	});
	$(function () { 
    	$("[data-toggle='popover']").popover(); 
	});
	$('.store-chooser-dropdown').multiselect({
		includeSelectAllOption: true,
		numberDisplayed: 0
	});
});