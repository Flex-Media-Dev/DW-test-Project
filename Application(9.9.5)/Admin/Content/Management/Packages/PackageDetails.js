(function ($) {
    $(function () {
        $("#PackageVersion").on("change", function () {
            var queryStringParams = {};
            $.each(window.location.search.split("?")[1].split("&"), function (i, val) {
                var arr = val.split("=");
                queryStringParams[arr[0]] = arr[1];
            });
            queryStringParams["PackageVersion"] = $(this).val();
            $("form")
                .prop("action", "?" + $.param(queryStringParams))
                .submit();
        });
    });
})(jQuery);

function showOverlay(message, hide) {
    if (!window.actionOverlay) {
        window.actionOverlay = new overlay("ActionOverlay");
    }
    if (message) {
        window.actionOverlay.message(message);
    }
    if (hide) {
        window.actionOverlay.hide();
    }
    else {
        window.actionOverlay.show();
    }
}