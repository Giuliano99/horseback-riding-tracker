using Toybox.Activity;
using Toybox.ActivityRecording;
using Toybox.Lang;

// Keep the same session when resuming. Release it only after save/discard succeeds.
class RecordingService {
    var _session = null;
    var error = null;

    function initialize() {}

    function start(mode) {
        error = null;
        try {
            if (_session == null) {
                _session = ActivityRecording.createSession({
                    // The recorded sport profile name is limited on the target device.
                    :name => "Western " + mode,
                    :sport => Activity.SPORT_HORSEBACK_RIDING,
                    :subSport => Activity.SUB_SPORT_GENERIC
                });
            }
            if (_session.start()) {
                return true;
            }
        } catch (e instanceof Lang.Exception) {
            // Present a short message and retain the session for retry.
        }
        error = "Start fehlgeschlagen";
        return false;
    }

    function pause() {
        error = null;
        try {
            if (_session != null && _session.stop()) {
                return true;
            }
        } catch (e instanceof Lang.Exception) {}
        error = "Pause fehlgeschlagen";
        return false;
    }

    function finish(save) {
        error = null;
        try {
            if (_session != null) {
                var success = save ? _session.save() : _session.discard();
                if (success) {
                    _session = null;
                    return true;
                }
            }
        } catch (e instanceof Lang.Exception) {}
        error = save ? "Speichern fehlgeschlagen" : "Verwerfen fehlgeschlagen";
        return false;
    }
}
