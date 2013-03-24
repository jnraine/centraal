$.fn.swapIcon = function(firstIconName, secondIconName) {
    this.each(function() {
        var $el = $(this);
        var firstIconClass = "icon-" + firstIconName;
        var secondIconClass = "icon-" + secondIconName;
        if($el.hasClass(firstIconClass)) {
            $el.removeClass(firstIconClass).addClass(secondIconClass);
        } else {
            $el.removeClass(secondIconClass).addClass(firstIconClass);
        }
    });
};

$.fn.play = function() {
    $(this).playback(true);
};

$.fn.pause = function() {
    $(this).playback(false);
};

$.fn.togglePlayback = function() {
    var paused = $(this).parent().find("audio")[0].paused;
    $(this).playback(paused);
};

$.fn.playback = function(shouldPlay) {
    this.each(function() {
        if(!$(this).hasClass("audio-control")) {
            return;
        }

        var $audioControl = $(this);
        var audio = $audioControl.parent().find("audio")[0];

        if (shouldPlay && audio.paused) {
            $audioControl.swapIcon("play", "pause");
            audio.play();
        } else if(!audio.paused) {
            $audioControl.swapIcon("play", "pause");
            audio.pause();
        } else {
            // no op -- what was asked for is already happening
        }
    });
};

$.fn.caretPosition = function() {
    var input = this.get(0);
    if (!input) return;
    if ('selectionStart' in input) {
        // Standard-compliant browsers
        return input.selectionStart;
    } else if (document.selection) {
        // IE
        input.focus();
        var sel = document.selection.createRange();
        var selLen = document.selection.createRange().text.length;
        sel.moveStart('character', -input.value.length);
        return sel.text.length - selLen;
    }
}