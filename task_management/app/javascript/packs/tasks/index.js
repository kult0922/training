document.addEventListener("turbolinks:load", function() {
    $(function() {
        $('#all-select').on('click', function() {
            $("input[name='label_ids[]']").prop('checked', this.checked);
        });
        $("input[name='label_ids[]']").on('click', function() {
            if ($('#boxes :checked').length == $('#boxes :input').length) {
                $('#all-select').prop('checked', true);
            } else {
                $('#all-select').prop('checked', false);
            }
        });
    });
})
