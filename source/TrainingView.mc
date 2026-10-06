using Toybox.Graphics;
using Toybox.Timer;
using Toybox.WatchUi;

class TrainingView extends WatchUi.View {
    var _controller;
    var _timer;
    function initialize(controller) {
        View.initialize(); _controller = controller; _timer = new Timer.Timer();
    }
    function onShow() { _timer.start(method(:refresh), 1000, true); }
    function onHide() { _timer.stop(); }
    function refresh() { WatchUi.requestUpdate(); }
    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        var x = dc.getWidth() / 2;
        var h = dc.getHeight();
        var status = "Bereit";
        if (_controller.state == :recording) { status = "Training"; }
        else if (_controller.state == :paused) { status = "Pause"; }
        dc.drawText(x, h * 0.08, Graphics.FONT_XTINY, _controller.mode + " / " + status, Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(x, h * 0.18, Graphics.FONT_LARGE, _controller.duration(), Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_BLACK);
        dc.drawText(x, h * 0.34, Graphics.FONT_MEDIUM, _controller.gaits.label(), Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(x, h * 0.47, Graphics.FONT_SMALL, "Puls " + _controller.metrics.pulseText() + " bpm", Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_BLACK);
        dc.drawText(x, h * 0.59, Graphics.FONT_XTINY, _controller.metrics.gpsText(), Graphics.TEXT_JUSTIFY_CENTER);
        if (_controller.metrics.gps) {
            var distance = _controller.metrics.distanceText(_controller.state != :ready);
            var speed = _controller.metrics.speedText(_controller.state == :recording);
            dc.drawText(x, h * 0.67, Graphics.FONT_XTINY, distance + " km / " + speed + " km/h", Graphics.TEXT_JUSTIFY_CENTER);
        }
        var error = _controller.recording.error;
        if (error == null) { error = _controller.metrics.error; }
        dc.drawText(x, h * 0.77, Graphics.FONT_XTINY, error != null ? error : (_controller.state == :recording ? "Tippen: Gangart" : "Gangart nach Start"), Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(x, h * 0.84, Graphics.FONT_XTINY, "Taste: Start/Pause", Graphics.TEXT_JUSTIFY_CENTER);
    }
}

class TrainingDelegate extends WatchUi.BehaviorDelegate {
    var _controller;
    function initialize(controller) { BehaviorDelegate.initialize(); _controller = controller; }
    // Let raw input distinguish screen taps from the start/pause key.
    function onSelect() { return false; }
    function onBack() {
        if (_controller.state == :ready) {
            _controller.close();
            WatchUi.popView(WatchUi.SLIDE_RIGHT);
        } else if (_controller.pause()) {
            WatchUi.pushView(new FinishMenu(_controller), new FinishDelegate(_controller), WatchUi.SLIDE_UP);
        } else { WatchUi.requestUpdate(); }
        return true;
    }
    function onMenu() {
        if (_controller.state == :recording) {
            var selection = new GaitSelectionView(_controller);
            WatchUi.pushView(selection, new GaitSelectionDelegate(_controller, selection), WatchUi.SLIDE_UP);
        }
        return true;
    }
    function onTap(event) { return onMenu(); }
    function onKey(event) {
        var key = event.getKey();
        if (key == WatchUi.KEY_ENTER) {
            _controller.toggle();
            WatchUi.requestUpdate();
            return true;
        }
        return false;
    }
}
