using Toybox.Activity;
using Toybox.Position;
using Toybox.Sensor;
using Toybox.System;
using Toybox.Lang;

class MetricsProvider {
    var gps;
    var pulse = null;
    var speed = null;
    var quality = Position.QUALITY_NOT_AVAILABLE;
    var error = null;
    var _closed = false;
    var _pulseAt = null;
    var _positionAt = null;

    function initialize(useGps) {
        gps = useGps;
        try {
            Sensor.setEnabledSensors([Sensor.SENSOR_HEARTRATE]);
            Sensor.enableSensorEvents(method(:onSensor));
        } catch (e instanceof Lang.Exception) { error = "Pulssensor nicht verfuegbar"; }
        try {
            Position.enableLocationEvents(gps ? Position.LOCATION_CONTINUOUS : Position.LOCATION_DISABLE, method(:onPosition));
        } catch (e instanceof Lang.Exception) {
            error = gps ? "GPS nicht verfuegbar" : "GPS-Abschaltung fehlgeschlagen";
        }
    }

    function onSensor(info as Sensor.Info) as Void {
        pulse = info.heartRate;
        _pulseAt = System.getTimer();
    }

    function onPosition(info as Position.Info) as Void {
        quality = info.accuracy;
        speed = info.speed;
        _positionAt = System.getTimer();
    }

    function fresh(timestamp) {
        return timestamp != null && System.getTimer() - timestamp <= 5000;
    }

    function pulseText() {
        return fresh(_pulseAt) && pulse != null && pulse > 0 ? pulse.format("%d") : "--";
    }

    function hasFix() {
        return gps && fresh(_positionAt) && quality >= Position.QUALITY_USABLE;
    }

    function gpsText() {
        if (!gps) { return "GPS aus"; }
        return hasFix() ? "GPS bereit" : "GPS sucht Signal";
    }

    function speedText(active) {
        if (!active || !hasFix() || speed == null || speed < 0) { return "--"; }
        return (speed * 3.6).format("%.1f");
    }

    function distanceText(started) {
        if (!gps || !started) { return "--"; }
        var distance = Activity.getActivityInfo().elapsedDistance;
        return distance == null ? "--" : (distance / 1000.0).format("%.2f");
    }

    function close() {
        if (_closed) { return; }
        _closed = true;
        try { Sensor.enableSensorEvents(null); Sensor.setEnabledSensors([]); }
        catch (e instanceof Lang.Exception) {}
        if (gps) {
            try { Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition)); }
            catch (e instanceof Lang.Exception) {}
        }
    }
}
