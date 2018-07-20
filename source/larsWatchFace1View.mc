using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Time as Time;
using Toybox.ActivityMonitor as ActMon;
using Toybox.UserProfile as Profile;

class larsWatchFace1View extends Ui.WatchFace {

	/* 
		battery
		phone connected
		alarm set
		date
		min HR
		time two colors
	*/

	var batteryPct;
	var phoneConnected;
	var alarmSet;	
	var lastRHR = 0;
	var countRHR = 0;
		
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
        dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_BLACK);
        dc.clear();

        // Get and show the current time and date
        var clockTime = Sys.getClockTime();
        var hour = clockTime.hour;
        if (hour > 12) {
                hour -= 12;
        } else if (hour == 0) {
                hour += 12;
        }
        var hourString = hour + "";
        var minString = clockTime.min.format("%02d");
      	var currentMoment = Time.now();
        var currentInfo = Time.Gregorian.info(currentMoment, Time.FORMAT_MEDIUM); 
     
		//hour
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        //dc.drawText(dc.getWidth()/2, 80, Gfx.FONT_NUMBER_THAI_HOT, hourString, Gfx.TEXT_JUSTIFY_RIGHT);
        dc.drawText(dc.getWidth()/2, 80, Gfx.FONT_SYSTEM_NUMBER_THAI_HOT, hourString, Gfx.TEXT_JUSTIFY_RIGHT);
		
		//min        
        dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_BLACK);
        //dc.drawText(dc.getWidth()/2, 80, Gfx.FONT_NUMBER_THAI_HOT, minString, Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawText(dc.getWidth()/2, 80, Gfx.FONT_SYSTEM_NUMBER_THAI_HOT, minString, Gfx.TEXT_JUSTIFY_LEFT);
	
		//month	
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        dc.drawText(dc.getWidth()/2, 150, Gfx.FONT_TINY, currentInfo.month, Gfx.TEXT_JUSTIFY_RIGHT);
        
		//day	
        dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_BLACK);
        dc.drawText(dc.getWidth()/2 + 5, 150, Gfx.FONT_TINY, currentInfo.day, Gfx.TEXT_JUSTIFY_LEFT);

		drawBattery(dc);
	
		var ds = Sys.getDeviceSettings();	
		var phoneIcon = "";
		if ( ! ds.phoneConnected ) {
			phoneIcon = "<>";
		}

		//alarm set
		var almIcon = "";
		if ( ds.alarmCount > 0 ) {
			almIcon = "alm";
		}

        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        dc.drawText(dc.getWidth()/2, 30, Gfx.FONT_TINY, phoneIcon + " " + almIcon, Gfx.TEXT_JUSTIFY_CENTER);
		
		//min HR        
        //dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        //dc.drawText(120, 210, Gfx.FONT_SMALL, getMinHR(), Gfx.TEXT_JUSTIFY_RIGHT);
		
		//RHR
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        dc.drawText(120, 210, Gfx.FONT_SMALL, getMinHR(), Gfx.TEXT_JUSTIFY_RIGHT);
        //TODO - change color based on increasing or decreasing?
		
        return true;
    }
   
   /* only displays static variable 
    function getRHR() {
    //	System.println("getRHR: enter");
   		var rhr = Profile.getProfile().restingHeartRate;
    	//System.println("getRHR: rhr");
    	if ( lastRHR == 0 || rhr == lastRHR ) {
    		lastRHR = rhr;
   			return rhr;
   		} else {
   			var diff = lastRHR - rhr;
   			//story RHR as last after an hour or so
   			if (countRHR > 60 ) {
   				lastRHR = rhr;
   				countRHR = 0;
   			} else {
   				countRHR++;
   			}
   			return rhr + ":" + diff;
   		}	
    }
    */

	function getMinHR() {
		var dur = new Time.Duration(86400/3);  //8 hours
		var hrIterator = ActMon.getHeartRateHistory(dur, false);
		var min = hrIterator.getMin();
	//	System.println("min: " + min);
		return min;
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

	function drawBattery(dc) {
        batteryPct = Sys.getSystemStats().battery;
        dc.drawRectangle(130, 222, 18, 11);
        dc.fillRectangle(148, 225, 2, 5);

        var color = Graphics.COLOR_GREEN;
        if (batteryPct < 25) {
            color = Graphics.COLOR_RED;
        } else if (batteryPct < 40) {
            color = Graphics.COLOR_YELLOW;
        }
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);

        var width = (batteryPct * 16.0 / 100 + 0.5).toLong();
        if (width > 0) {
            //Sys.println("" + pct + "=" + width);
            if (width > 16) {
                width = 16;
            }
            dc.fillRectangle(131, 223, width, 9);
        }
    }
  
}
