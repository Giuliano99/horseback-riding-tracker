using Toybox.Application;

class WesternRideApp extends Application.AppBase {
    var controller = null;
    function initialize() {
        AppBase.initialize();
    }

    function getInitialView() {
        return [new ModeMenu(), new ModeDelegate()];
    }

    function onStop(state) {
        if (controller != null) { controller.close(); }
    }
}
