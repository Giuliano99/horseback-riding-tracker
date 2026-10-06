using Toybox.System;

class TrainingController {
    var mode;
    var state = :ready;
    var recording;
    var _elapsedMs = 0;
    var _startedAt = 0;
    var gaits;
    var metrics;

    function initialize(selectedMode, useGps) {
        mode = selectedMode;
        gaits = new GaitTracker();
        metrics = new MetricsProvider(useGps && mode != "Halle");
        recording = new RecordingService();
    }

    function toggle() {
        if (state == :recording) {
            return pause();
        }
        if ((state == :ready || state == :paused) && recording.start(mode, gaits.current)) {
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
        recording.updateTimes(gaits.times(activeMs()));
        if (!recording.pause()) {
            return false;
        }
        _elapsedMs += System.getTimer() - _startedAt;
        state = :paused;
        return true;
    }

    function finish(save) {
        recording.updateTimes(gaits.times(activeMs()));
        if (state != :paused || !recording.finish(save)) {
            return false;
        }
        state = save ? :saved : :discarded;
        close();
        return true;
    }

    function activeMs() {
        var ms = _elapsedMs;
        if (state == :recording) {
            ms += System.getTimer() - _startedAt;
        }
        return ms;
    }

    function selectGait(id) {
        if (state != :recording) { return; }
        gaits.select(id, activeMs());
        recording.setGait(id);
    }

    function close() { metrics.close(); }

    function duration() { return formatDuration(activeMs()); }

    function formatDuration(ms) {
        var seconds = (ms / 1000).toNumber();
        return (seconds / 3600).toNumber().format("%02d") + ":" +
            ((seconds / 60).toNumber() % 60).format("%02d") + ":" +
            (seconds % 60).format("%02d");
    }
}
