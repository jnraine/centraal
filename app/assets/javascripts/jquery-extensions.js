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