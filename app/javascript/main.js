$(document).ready(function(){
    $('.delete-action').on('click', function(){
        var path = $(this).data('path');
        $('#modal-confirm-actions form').attr('action', path);
    });
});