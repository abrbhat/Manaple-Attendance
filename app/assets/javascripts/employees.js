$(document).ready(function () {
    var allEmployeeOptions = $('#select-employee option');
    var allToStoreOptions = $('#select-to-store option');
    $('#select-from-store').change(function () {
        $('#select-employee option').remove(); //remove all options
        $('#select-to-store option').remove(); //remove all options
        var fromStoreId = $('#select-from-store option:selected').prop('class'); //get the selected option's classname
        var employeeOpts = allEmployeeOptions.filter('.' + fromStoreId); 
        var toStoreOpts = allToStoreOptions.not('.' + fromStoreId);
        $.each(employeeOpts, function (i, j) {
            $(j).appendTo('#select-employee'); //append those options back
        });
        $.each(toStoreOpts, function (i, j) {
            $(j).appendTo('#select-to-store'); //append those options back
        });
    });
});