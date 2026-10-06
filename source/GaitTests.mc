using Toybox.Test;

(:test)
function gaitIntervals(logger) {
    var gaits = new GaitTracker();
    gaits.select(2, 5000);
    gaits.select(3, 15000);
    gaits.select(4, 22000);
    var times = gaits.times(25000);
    Test.assertEqual(times[0], 5000);
    Test.assertEqual(times[1], 0);
    Test.assertEqual(times[2], 10000);
    Test.assertEqual(times[3], 7000);
    Test.assertEqual(times[4], 3000);
    // Reading the summary must not mutate accumulated time.
    Test.assertEqual(gaits.times(25000)[4], 3000);
    return true;
}

(:test)
function gaitPauseAndResume(logger) {
    var gaits = new GaitTracker();
    gaits.select(2, 0);
    Test.assertEqual(gaits.times(10000)[2], 10000);
    // Controller holds the active clock at 10s during a pause.
    Test.assertEqual(gaits.times(10000)[2], 10000);
    gaits.select(1, 15000);
    var times = gaits.times(18000);
    Test.assertEqual(times[2], 15000);
    Test.assertEqual(times[1], 3000);
    Test.assertEqual(times[0] + times[1] + times[2] + times[3] + times[4], 18000);
    return true;
}
