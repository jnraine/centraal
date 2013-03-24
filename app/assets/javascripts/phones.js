function connectPhone(token, pingPath) {
    Twilio.Device.setup(token);
    var connection = null;
    var connectedWith = null;
    var callStatusUpdaterInterval = null;

    // UI Fanciness
    $(document).on("click", "#start-call", function() {
        var outgoingNumber = $("#outgoing-number").first().val().replace(/[^0-9]/g, "");
        params = {"OutgoingNumber" : outgoingNumber};
        connectedWith = outgoingNumber;
        updateStatus("Calling " + connectedWith + "...");
        connection = Twilio.Device.connect(params);
    });

    $(document).on("click", "#hangup", function() {
        Twilio.Device.disconnectAll();
    });

    $("#call-form").submit(function() {
      $("#start-call").click();
      return false;
    });

    function updateStatus(message) {
        $('#status').text(message);
    }

    function setStatusReady() {
        showButton("start-call");
        updateStatus("Ready to start call");
    }

    // Twilio.Device callbacks
    Twilio.Device.ready(function (device) {
        var pingClient = function() {
            $.post(pingPath);
        };

        setInterval(pingClient, 120000); // ping server every 2 minutes
        pingClient();
        setStatusReady();
    });

    Twilio.Device.incoming(function (incomingConnection) {
        connectedWith = incomingConnection.parameters.From;
        updateStatus("Incoming call from " + connectedWith + "...");
        showButton("answer");
        $("#answer").click(function() {
            connection = incomingConnection;
            connection.accept();
        });
    });

    Twilio.Device.offline(function (device) {
        updateStatus("Offline");
        hideButtons();
    });

    Twilio.Device.cancel(function (cancelledConnection) {
        setStatusReady();
    });

    Twilio.Device.error(function (error) {
        console.log("A Twilio error occurred");
        console.log(error);
        updateStatus(error);
    });

    Twilio.Device.connect(function (conn) {
        console.log("let's set the call status to time the call");
        startCallStatus();
        showButton("hangup");
    });

    Twilio.Device.disconnect(function (conn) {
        stopCallStatus();
    });

    $(".keypad .key").click(function() {
        var $key = $(this);
        var digit = $key.find(".digit").text();
        var $digitDisplay = $("#outgoing-number");
        $digitDisplay.val($digitDisplay.val() + digit);
        $digitDisplay.keyup();
        if(connection) {
            connection.sendDigits(digit);
        }
    });

    function startCallStatus() {
        var callStartTime = new Date().getTime();
        callStatusUpdaterInterval = setInterval(function() {
            var message = "Connected — " + connectedWith + " — " + timerDisplay(callStartTime);
            updateStatus(message);
        }, 500);
    }

    function stopCallStatus() {
        clearInterval(callStatusUpdaterInterval);
        updateStatus("Call ended");
        setTimeout(setStatusReady, 2000);
        showButton("start-call");
    }

    function hideButtons() {
        showButton("none-that-actually-exist");
    }

    function showButton(name){
        $('#start-call').hide();
        $('#hangup').hide();
        $('#answer').hide();
        $('#' + name).show();
    }

    function timerDisplay(startTime) {
        var duration = secondsSinceTime(startTime);
        var minutes = Math.floor(duration / 60);
        var seconds = duration % 60;
        if(seconds.toString().length == 1) {
            seconds = "0" + seconds;
        }
        return minutes + ":" + seconds;
    }

    function secondsSinceTime(time) {
        var seconds = (new Date().getTime() - time) / 1000;
        return Math.floor(seconds);
    }
}

$(document).ready(function() {
    $("#outgoing-number")
        .keydown(function(event) {
            // if you want to be fancy, don't let them press non-digits
        })
        .keyup(function() {
            var $digitDisplay = $(this);
            if($digitDisplay.caretPosition() == $digitDisplay.val().length) {
                var formattedNumber = formatNumber($digitDisplay.val());
                $digitDisplay.val(formattedNumber);
            }
        });
});

function formatNumber(number) {
    var formatted = number.replace(/[^0-9\*#]/g,"");

    if(formatted.match(/^\d+$/)) {
        if(formatted.length > 10) {
            // leave it as is
        } else if(formatted.length > 6) { // format whole number
            match = formatted.match(/^(\d{3})(\d{3})(\d+)$/);
            formatted = "(" + match[1] + ") " + match[2] + "-" + match[3];
        } else if(formatted.length > 3) { // format whole number
            match = formatted.match(/^(\d{3})(\d+)$/);
            formatted = "(" + match[1] + ") " + match[2];
        } else if(formatted.length > 1) {
            formatted = "(" + formatted;
        }
    }

    return formatted;
}