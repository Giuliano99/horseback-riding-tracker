using Toybox.Activity;
using Toybox.ActivityRecording;
using Toybox.Lang;
using Toybox.FitContributor;

// Keep the same session when resuming. Release it only after save/discard succeeds.
class RecordingService {
    var _session = null;
    var error = null;
    var _gaitField = null;
    var _timeFields = null;

    function initialize() {}

    function start(mode, gait) {
        error = null;
        try {
            if (_session == null) {
                _session = ActivityRecording.createSession({
                    // The recorded sport profile name is limited on the target device.
                    :name => "Western " + mode,
                    :sport => Activity.SPORT_HORSEBACK_RIDING,
                    :subSport => Activity.SUB_SPORT_GENERIC
                });
                _gaitField = _session.createField("Gangart", 0, FitContributor.DATA_TYPE_UINT8,
                    { :mesgType => FitContributor.MESG_TYPE_RECORD });
                _timeFields = [];
                var names = ["Unbekannt", "Stillstand", "Schritt", "Jog", "Lope"];
                for (var i = 0; i < names.size(); i += 1) {
                    var field = _session.createField(names[i] + " Zeit", i + 1,
                        FitContributor.DATA_TYPE_FLOAT,
                        { :mesgType => FitContributor.MESG_TYPE_SESSION, :units => "s" });
                    field.setData(0.0);
                    _timeFields.add(field);
                }
            }
            setGait(gait);
            if (_session.start()) {
                return true;
            }
        } catch (e instanceof Lang.Exception) {
            // Present a short message and retain the session for retry.
        }
        error = "Start fehlgeschlagen";
        return false;
    }

    function setGait(gait) {
        if (_gaitField != null) { _gaitField.setData(gait); }
    }

    function updateTimes(times) {
        if (_timeFields == null) { return; }
        for (var i = 0; i < times.size(); i += 1) {
            _timeFields[i].setData(times[i] / 1000.0);
        }
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
