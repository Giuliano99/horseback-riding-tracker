using Toybox.Graphics;
using Toybox.WatchUi;

// Keep all five choices visible, so changing gait requires one tap and no scrolling.
class GaitSelectionView extends WatchUi.View {
    var controller;
    var height = 390;
    function initialize(selectedController) { View.initialize(); controller = selectedController; }
    function onUpdate(dc) {
        height = dc.getHeight();
        var x = dc.getWidth() / 2;
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        dc.drawText(x, height * 0.12, Graphics.FONT_SMALL, "Gangart", Graphics.TEXT_JUSTIFY_CENTER);
        for (var i = 0; i < controller.gaits.labels.size(); i += 1) {
            dc.setColor(i == controller.gaits.current ? Graphics.COLOR_YELLOW : Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
            dc.drawText(x, height * (0.24 + i * 0.13), Graphics.FONT_SMALL, controller.gaits.labels[i], Graphics.TEXT_JUSTIFY_CENTER);
        }
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_BLACK);
        dc.drawText(x, height * 0.88, Graphics.FONT_XTINY, "Zurueck", Graphics.TEXT_JUSTIFY_CENTER);
    }
}

class GaitSelectionDelegate extends WatchUi.BehaviorDelegate {
    var _controller;
    var _view;
    function initialize(controller, view) { BehaviorDelegate.initialize(); _controller = controller; _view = view; }
    function onSelect() { return false; }
    function onTap(event) {
        // Venu 3S display is 390px; use the active view height for layout consistency.
        var relative = event.getCoordinates()[1] / _view.height.toFloat();
        if (relative >= 0.23 && relative < 0.88) {
            var id = ((relative - 0.23) / 0.13).toNumber();
            _controller.selectGait(id);
            WatchUi.popView(WatchUi.SLIDE_DOWN);
        }
        return true;
    }
    function onBack() { WatchUi.popView(WatchUi.SLIDE_DOWN); return true; }
}
