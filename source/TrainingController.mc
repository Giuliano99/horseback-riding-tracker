using Toybox.System;

class TrainingController {
    var mode;
    var state = :ready;
    var recording;
    var _elapsedMs = 0;
    var _startedAt = 0;

    function initialize(selectedMode) {
        mode = selectedMode;
        recording = new RecordingService();
    }

    function toggle() {
        if (state == :recording) {
            return pause();
        }
        if ((state == :ready || state == :paused) && recording.start(mode)) {
            _startedAt = System.getTimer();
            state = :recording;
            return true;
        }
        return false;
    }

    function pause() {
        if (state != :recording) {
            return true;
        }
        if (!recording.pause()) {
            return false;
        }
        _elapsedMs += System.getTimer() - _startedAt;
        state = :paused;
        return true;
    }

    function finish(save) {
        if (state != :paused || !recording.finish(save)) {
            return false;
        }
        state = save ? :saved : :discarded;
        return true;
    }

    function duration() {
        var ms = _elapsedMs;
        if (state == :recording) {
            ms += System.getTimer() - _startedAt;
        }
        var seconds = (ms / 1000).toNumber();
        return (seconds / 3600).toNumber().format("%02d") + ":" +
            ((seconds / 60).toNumber() % 60).format("%02d") + ":" +
            (seconds % 60).format("%02d");
    }
}
