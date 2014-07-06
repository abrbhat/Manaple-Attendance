$(document).ready(function () {    
	console.log("test1");
    var allOptions = $('#select-employee option');
    //console.log(allOptions);
    $('#select-from-store').change(function () {
        $('#select-employee option').remove(); //remove all options
        var classN = $('#select-from-store option:selected').prop('class'); //get the 
        console.log(classN);
        var opts = allOptions.filter('.' + classN); //selected option's classname
        console.log(opts);
        $.each(opts, function (i, j) {
            $(j).appendTo('#select-employee'); //append those options back
        });
    });
});