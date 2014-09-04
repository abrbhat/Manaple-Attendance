$(document).ready(function () {    
    $('#add-one-row-button').click(function(){
        rowHtml = "<tr>" + $("#store-add-row").html() + "</tr>" ;
        $('#add-store-table-body').append(rowHtml);
    })
    $('#add-25-rows-button').click(function(){
        rowHtml = "<tr>" + $("#store-add-row").html() + "</tr>" ;
        for(i=1;i<=25;i++){
            $('#add-store-table-body').append(rowHtml);
        }        
    })
});