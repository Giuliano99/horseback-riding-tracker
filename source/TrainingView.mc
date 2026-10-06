using Toybox.Graphics;
using Toybox.Timer;
using Toybox.WatchUi;

class TrainingView extends WatchUi.View {
    var _controller;
    var _timer;

    function initialize(controller) {
        View.initialize();
        _controller = controller;
        _timer = new Timer.Timer();
    }

    function onShow() {
        _timer.start(method(:refresh), 1000, true);
    }

    function onHide() {
        _timer.stop();
    }

    function refresh() {
        WatchUi.requestUpdate();
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        var x = dc.getWidth() / 2;
        var h = dc.getHeight();
        var status = "Bereit";
        var action = "Auswahl: Start";
        if (_controller.state == :recording) {
            status = "Training";
            action = "Auswahl: Pause";
        } else if (_controller.state == :paused) {
            status = "Pausiert";
            action = "Auswahl: Weiter";
        }
        dc.drawText(x, h * 0.14, Graphics.FONT_SMALL, _controller.mode,
            Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(x, h * 0.29, Graphics.FONT_MEDIUM, status,
            Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(x, h * 0.43, Graphics.FONT_LARGE, _controller.duration(),
            Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_BLACK);
        if (_controller.recording.error != null) {
            dc.drawText(x, h * 0.62, Graphics.FONT_XTINY, _controller.recording.error,
                Graphics.TEXT_JUSTIFY_CENTER);
        }
        dc.drawText(x, h * 0.73, Graphics.FONT_XTINY, action,
            Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(x, h * 0.81, Graphics.FONT_XTINY, "Zurueck: Optionen",
            Graphics.TEXT_JUSTIFY_CENTER);
    }
}

class TrainingDelegate extends WatchUi.BehaviorDelegate {
    var _controller;

    function initialize(controller) {
        BehaviorDelegate.initialize();
        _controller = controller;
    }

    function onSelect() {
        _controller.toggle();
        WatchUi.requestUpdate();
        return true;
    }

    function onBack() {
        if (_controller.state == :ready) {
            WatchUi.popView(WatchUi.SLIDE_RIGHT);
        } else if (_controller.pause()) {
            WatchUi.pushView(new FinishMenu(_controller),
                new FinishDelegate(_controller), WatchUi.SLIDE_UP);
        } else {
            WatchUi.requestUpdate();
        }
        return true;
    }

    function onMenu() {
        return onBack();
    }
}
