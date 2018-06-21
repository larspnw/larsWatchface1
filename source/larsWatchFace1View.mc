using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;

class larsWatchFace1View extends Ui.WatchFace {

	/* TODO
		battery
		phone connected
		alarm set
		date
		min HR
	*/
    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        // Get and show the current time
        var clockTime = Sys.getClockTime();
        var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]);
        //var view = View.findDrawableById("TimeLabel");
        //view.setText(timeString);
        dc.clear();
        
        dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_BLACK);
        dc.drawText(100, 100, Gfx.FONT_LARGE, timeString, Gfx.TEXT_JUSTIFY_CENTER);

        // Call the parent onUpdate function to redraw the layout
        //View.onUpdate(dc);
        
        return true;
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

}
