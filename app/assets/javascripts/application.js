// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require_tree .

$(document).ready(function() {
    $("[data-spin-on-click]").click(function() {
        $(this).find("i[class|='icon']").addClass("icon-spin");
    });

    $("[data-click-text]").click(function() {
        var $link = $(this);
        var spinText = $link.attr("data-click-text");
        var $children = $link.children();
        $link
            .text(" " + spinText)
            .prepend($children);
    });

    $(".field_with_errors").closest(".control-group").addClass("error");

    // Edit on click magic...a bit ugly
    $(".edit-on-click")
        .find(".field").hide().end()
        .find(".display")
            .css({cursor: "pointer"})
            .click(function() {
                $(this).closest(".edit-on-click")
                    .find(".field")
                        .show()
                        .find("input").first()
                            .focus().end()
                            .blur(function() {
                            $(this).closest(".field").hide().closest(".edit-on-click")
                                .find(".display").show();
                            })
                        .end()
                    .end()
                    .find(".display").hide();
            });

    // Phone number expander
    $(".phone-number")
        .find(".details").hide().end()
        .find(".incoming-number")
            .css({cursor: "pointer"})
            .click(function() {
                $(this).closest(".phone-number")
                    .find(".details").slideToggle().end()
                    .find(".expand-icon").swapIcon("caret-down", "caret-right");
            });
    $(".incoming-number").click(); // show all numbers for now

    setTimeout(function() { $(".alert").slideUp(); }, 5000);

    $("[data-toggle='popover']").popover({html: true});

    $(".voicemail").click(function() {
        var $voicemail = $(this);
        var $audioControl = $voicemail.find(".audio-control");

        var $otherAudioControls = $voicemail.parent().find(".voicemail").not($voicemail).find(".audio-control");
        $otherAudioControls.pause();
        $audioControl.togglePlayback();
    });

    // Handle audio finished playing event
    $(".voicemails audio").bind('ended', function() {
        var $audio = $(this);
        var $audioControl = $audio.parent().find(".audio-control");
        $audioControl.swapIcon("pause", "play");
        $.post($audio.attr("data-mark-as-read-path"));
        $audio.parent().find(".unread-label").hide();
    });

    // Voicemail greeting play
    $(".voicemail-greeting").click(function() {
        var $voicemailGreeting = $(this);
        var $audioControl = $voicemailGreeting.find(".audio-control");
        $audioControl.togglePlayback();
        return false;
    });

    $(".voicemail-greeting audio").bind('ended', function() {
        var $audio = $(this);
        var $audioControl = $audio.parent().find(".audio-control");
        $audioControl.swapIcon("pause", "play");
    });

    function flashSaveNotice() {
        $notice = $(".save-notice");
        $notice.fadeIn();
        setTimeout(function() { $notice.fadeOut(); }, 1000);
    }

    function flashErrorNotice() {
        $notice = $(".error-notice");
        $notice.fadeIn();
        setTimeout(function() { $notice.fadeOut(); }, 1000);
    }

    function highlightFieldsWithErrors($form, errors) {
        for(var fieldName in errors) {
            var $field = $form.find("#phone_" + fieldName);
            $field
                .parents(".control-group")
                    .first().addClass("error")
                .end()
                .parent()
                    .find(".help-inline").text(errors[fieldName]);
        }
    }

    function clearErrorsFromFields($form) {
        $form
            .find(".control-group").removeClass("error").end()
            .find(".help-inline").text("");
    }

    $(".edit_phone")
        .change(function() {
            $(this).submit();
        })
        .bind('ajax:success', function(event, data, status) {
            var $form = $(this);
            $.each(data.flash, function(index, element) {
                if(element[0] == "error") {
                    flashErrorNotice();
                    highlightFieldsWithErrors($form, data.errors);
                } else {
                    flashSaveNotice();
                    clearErrorsFromFields($form)
                }
            });
        })
        .bind('ajax:error', function(xhr, status, error) {
            var $notice = $(".error-notice");
            $notice.fadeIn();
            setTimeout(function() { $notice.fadeOut(); }, 1000);
        });

    $(".switch").on("switch-change", function (e, data) {
        $(data.el).parents("form").change();
    });

    if(navigator.userAgent.match(/iPhone/)) {
        $(".phone-controls")
            .find("#call-form")
                .slideUp()
            .end()
            .append("<div><em>The browser-based phone is not supported by your device</em></div>");
    }
});

function flashSuccess(message) {
    flash(message, "success");
}

function flashInfo(message) {
    flash(message, "info");
}

function flashWarning(message) {
    flash(message, "warning");
}

function flashError(message) {
    flash(message, "error");
}

function flash(message, type) {
    var $alert = $(".content .alert");
    var typeClass = "alert-" + type;
    if($alert.length === 0) {
        $alert = $("<div class='alert'></div>").hide();
        $(".content").prepend($alert);
    }

    $alert
        .attr('class', '')
        .addClass("alert")
        .addClass(typeClass)
        .html(message)
        .slideDown();

    setTimeout(function() { $alert.slideUp(); }, 5000);
}