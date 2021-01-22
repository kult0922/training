$(function() {
    init();
});

function init() {
    setStatus();
    setLabel();
    setClickEventAllSelect();
}

function setStatus() {
    $('input[name=status]').val([$('#status_btn_val').val()]);
}

function setLabel() {
    let labelIdsJson = $('.label_ids_json').val();
    let label = JSON.parse(labelIdsJson);
    let label_ids_elm = $("input[name='label_ids[]']");

    label_ids_elm.each(function(i, elem) {
        $(elem).prop('checked', false);
    });
    for (let key in label) {
        label_ids_elm.each(function(i, elem) {
            if (elem.defaultValue === label[key]) {
                $(elem).prop('checked', true);
            }
        });
    }
    if ($('#boxes :checked').length === $('#boxes :input').length) {
        $('#all-select').prop('checked', true);
    } else {
        $('#all-select').prop('checked', false);
    }
}

function setClickEventAllSelect() {
    $('#all-select').on('click', function() {
        $("input[name='label_ids[]']").prop('checked', this.checked);
    });
    $("input[name='label_ids[]']").on('click', function() {
        if ($('#boxes :checked').length === $('#boxes :input').length) {
            $('#all-select').prop('checked', true);
        } else {
            $('#all-select').prop('checked', false);
        }
    });
}
