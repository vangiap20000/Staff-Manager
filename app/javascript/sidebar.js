$(document).ready(function () {
    $(document).on("click", function () {
        closeAllPopups();
    });

    $('#sidebarToggle').on('click', function () {
        $(this).toggleClass("is-toggled");
        let titleSidebar = $("#title-sidebar");
        let fullTitle = titleSidebar.data("title");
        let shortTitle = getInitials(fullTitle);

        if (titleSidebar.text().length > 2) {
            titleSidebar.text(shortTitle);
        } else {
            titleSidebar.fadeOut(500, function () {
                titleSidebar.text(fullTitle);
                titleSidebar.fadeIn(500);
            });
        }
        toggleSidebar();
    });
});

function toggleSidebar() {
    let animation = {
        duration: 500,
        easing: 'swing',
    };
    $("#accordionSidebar").toggleClass("w-[104px]", animation);
    $(".sidebar-heading").toggleClass("text-center", animation);
    $(".collapse-group:not(button)").toggleClass("flex-col w-full", animation);
    $("button.collapse-group").toggleClass("flex-col", animation);
    $(".collapse-group span").toggleClass("text-[10px]", animation)
    $(".collapse-icon").toggle();
    $(".popup-menu").addClass("hidden").hide();
    $(".collapse-icon").removeClass("rotate-180");
}

function toggleCollapse(evt, id) {
    const content = $('#' + id);
    closeAllPopups(content);
    evt.stopPropagation();
    if ($('#sidebarToggle').hasClass("is-toggled")) {
        content.toggle();
        content.toggleClass(`absolute w-[144px] left-[${content.parent().width()}px] top-0 z-10`);
    } else {
        content.slideToggle("slow");
        $('#' + id + 'Icon').toggleClass("rotate-180");
    }
}

function closeAllPopups(thisElement = null) {
    let popup = $(".popup-menu");
    if (thisElement) {
        popup.not(thisElement).removeClass(`absolute w-[144px] left-[${$(".popup-menu").parent().width()}px] top-0 z-10`).hide();
    } else {
        popup.removeClass(`absolute w-[144px] left-[${$(".popup-menu").parent().width()}px] top-0 z-10`).hide();
    }
}

function getInitials(name) {
    if (!name || typeof name !== "string") return "";

    return name
        .trim()
        .split(/\s+/)
        .map(word => word[0].toUpperCase())
        .join("");
}
