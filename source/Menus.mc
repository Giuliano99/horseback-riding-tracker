using Toybox.Application;
using Toybox.WatchUi;

function openTraining(mode, gps) {
    var controller = new TrainingController(mode, gps);
    Application.getApp().controller = controller;
    WatchUi.pushView(new TrainingView(controller), new TrainingDelegate(controller), WatchUi.SLIDE_LEFT);
}

class ModeMenu extends WatchUi.Menu2 {
    function initialize() {
        Menu2.initialize({ :title => "Western Ride" });
        addItem(new WatchUi.MenuItem("Halle", "Ohne GPS", :indoor, {}));
        addItem(new WatchUi.MenuItem("Platz", "GPS optional", :arena, {}));
        addItem(new WatchUi.MenuItem("Ausritt", "GPS optional", :trail, {}));
    }
}

class ModeDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() { Menu2InputDelegate.initialize(); }
    function onSelect(item) {
        if (item.getId() == :indoor) { openTraining("Halle", false); return; }
        var mode = item.getId() == :arena ? "Platz" : "Ausritt";
        var menu = new WatchUi.Menu2({ :title => mode });
        menu.addItem(new WatchUi.MenuItem("GPS nutzen", "Strecke aufzeichnen", :gps, {}));
        menu.addItem(new WatchUi.MenuItem("Ohne GPS", "Nur Zeit und Puls", :noGps, {}));
        WatchUi.pushView(menu, new GpsDelegate(mode), WatchUi.SLIDE_LEFT);
    }
}

class GpsDelegate extends WatchUi.Menu2InputDelegate {
    var _mode;
    function initialize(mode) { Menu2InputDelegate.initialize(); _mode = mode; }
    function onSelect(item) {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        openTraining(_mode, item.getId() == :gps);
    }
}

class GaitMenu extends WatchUi.Menu2 {
    function initialize(controller, summary) {
        Menu2.initialize({ :title => summary ? "Gangartenzeiten" : "Gangart waehlen" });
        var times = controller.gaits.times(controller.activeMs());
        for (var i = 0; i < times.size(); i += 1) {
            var caption = controller.gaits.labels[i];
            if (!summary && i == controller.gaits.current) { caption += " *"; }
            addItem(new WatchUi.MenuItem(caption, summary ? controller.formatDuration(times[i]) : null, i, {}));
        }
    }
}

class GaitDelegate extends WatchUi.Menu2InputDelegate {
    var _controller;
    var _summary;
    function initialize(controller, summary) {
        Menu2InputDelegate.initialize(); _controller = controller; _summary = summary;
    }
    function onSelect(item) {
        if (!_summary) { _controller.selectGait(item.getId()); }
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}

class FinishMenu extends WatchUi.Menu2 {
    function initialize(controller) {
        Menu2.initialize({ :title => controller.duration() });
        addItem(new WatchUi.MenuItem("Weiter", null, :resume, {}));
        addItem(new WatchUi.MenuItem("Speichern", "FIT-Aktivitaet", :save, {}));
        addItem(new WatchUi.MenuItem("Gangartenzeiten", "Ohne Pausen", :summary, {}));
        addItem(new WatchUi.MenuItem("Verwerfen", "Mit Bestaetigung", :discard, {}));
    }
}

class FinishDelegate extends WatchUi.Menu2InputDelegate {
    var _controller;
    function initialize(controller) { Menu2InputDelegate.initialize(); _controller = controller; }
    function onSelect(item) {
        var id = item.getId();
        if (id == :summary) {
            WatchUi.pushView(new GaitMenu(_controller, true), new GaitDelegate(_controller, true), WatchUi.SLIDE_UP);
        } else if (id == :discard) {
            var menu = new WatchUi.Menu2({ :title => "Ritt verwerfen?" });
            menu.addItem(new WatchUi.MenuItem("Abbrechen", null, :cancel, {}));
            menu.addItem(new WatchUi.MenuItem("Ja, verwerfen", null, :confirm, {}));
            WatchUi.pushView(menu, new DiscardDelegate(_controller), WatchUi.SLIDE_UP);
        } else if (id == :resume) {
            _controller.toggle();
            WatchUi.popView(WatchUi.SLIDE_DOWN);
        } else if (id == :save) {
            var success = _controller.finish(true);
            WatchUi.popView(WatchUi.SLIDE_DOWN);
            if (success) { WatchUi.popView(WatchUi.SLIDE_RIGHT); }
        }
    }
}

class DiscardDelegate extends WatchUi.Menu2InputDelegate {
    var _controller;
    function initialize(controller) { Menu2InputDelegate.initialize(); _controller = controller; }
    function onSelect(item) {
        if (item.getId() != :confirm) { WatchUi.popView(WatchUi.SLIDE_DOWN); return; }
        var success = _controller.finish(false);
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        if (success) { WatchUi.popView(WatchUi.SLIDE_RIGHT); }
    }
}
