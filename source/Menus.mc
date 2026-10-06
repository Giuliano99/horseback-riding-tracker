using Toybox.WatchUi;

class ModeMenu extends WatchUi.Menu2 {
    function initialize() {
        Menu2.initialize({ :title => "Western Ride" });
        addItem(new WatchUi.MenuItem("Halle", "Ohne GPS", :indoor, {}));
        addItem(new WatchUi.MenuItem("Platz", "Basistraining", :arena, {}));
        addItem(new WatchUi.MenuItem("Ausritt", "Basistraining", :trail, {}));
    }
}

class ModeDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {
        var mode = "Halle";
        if (item.getId() == :arena) {
            mode = "Platz";
        } else if (item.getId() == :trail) {
            mode = "Ausritt";
        }
        var controller = new TrainingController(mode);
        WatchUi.pushView(new TrainingView(controller),
            new TrainingDelegate(controller), WatchUi.SLIDE_LEFT);
    }
}

class FinishMenu extends WatchUi.Menu2 {
    function initialize(controller) {
        Menu2.initialize({ :title => controller.duration() });
        addItem(new WatchUi.MenuItem("Weiter", null, :resume, {}));
        addItem(new WatchUi.MenuItem("Speichern", "FIT-Aktivitaet", :save, {}));
        addItem(new WatchUi.MenuItem("Verwerfen", "Mit Bestaetigung", :discard, {}));
    }
}

class FinishDelegate extends WatchUi.Menu2InputDelegate {
    var _controller;

    function initialize(controller) {
        Menu2InputDelegate.initialize();
        _controller = controller;
    }

    function onSelect(item) {
        var id = item.getId();
        if (id == :discard) {
            var menu = new WatchUi.Menu2({ :title => "Ritt verwerfen?" });
            menu.addItem(new WatchUi.MenuItem("Abbrechen", null, :cancel, {}));
            menu.addItem(new WatchUi.MenuItem("Ja, verwerfen", null, :confirm, {}));
            WatchUi.pushView(menu, new DiscardDelegate(_controller), WatchUi.SLIDE_UP);
            return;
        }
        if (id == :resume) {
            _controller.toggle();
            WatchUi.popView(WatchUi.SLIDE_DOWN);
        } else if (id == :save) {
            if (_controller.finish(true)) {
                WatchUi.popView(WatchUi.SLIDE_DOWN);
                WatchUi.popView(WatchUi.SLIDE_RIGHT);
            } else {
                // Keep the paused session. The live view exposes the error and retry menu.
                WatchUi.popView(WatchUi.SLIDE_DOWN);
            }
        }
    }
}

class DiscardDelegate extends WatchUi.Menu2InputDelegate {
    var _controller;

    function initialize(controller) {
        Menu2InputDelegate.initialize();
        _controller = controller;
    }

    function onSelect(item) {
        if (item.getId() != :confirm) {
            WatchUi.popView(WatchUi.SLIDE_DOWN);
            return;
        }
        var success = _controller.finish(false);
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        if (success) {
            WatchUi.popView(WatchUi.SLIDE_RIGHT);
        }
    }
}
