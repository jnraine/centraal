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
    console.log($otherAudioControls.length);
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
});