// Time is supplied by the active training clock, so pauses never add gait time.
class GaitTracker {
    var current = 0;
    var labels = ["Unbekannt", "Stillstand", "Schritt", "Jog", "Lope"];
    var _times;
    var _changedAt = 0;

    function initialize() { _times = [0, 0, 0, 0, 0]; }

    function select(id, activeMs) {
        _times[current] += activeMs - _changedAt;
        _changedAt = activeMs;
        current = id;
    }

    function times(activeMs) {
        var result = _times.slice(0, _times.size());
        result[current] += activeMs - _changedAt;
        return result;
    }

    function label() { return labels[current]; }
}
