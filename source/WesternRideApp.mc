using Toybox.Application;

class WesternRideApp extends Application.AppBase {
    function initialize() {
        AppBase.initialize();
    }

    function getInitialView() {
        return [new ModeMenu(), new ModeDelegate()];
    }
}
