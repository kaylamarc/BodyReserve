import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.SensorHistory;

class BodyReserveView extends WatchUi.View {

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);

        // Get the body battery iterator object
        var bbIterator = null;
        if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getBodyBatteryHistory)) {
            bbIterator = SensorHistory.getBodyBatteryHistory({});
        }

        var bodyBattery = null;
        if (bbIterator != null) {
            var sample = bbIterator.next();
            if (sample != null) {
                bodyBattery = sample.data;
            }
        }

        // Draw Body Battery value on screen
        if (bodyBattery != null) {
            var bbInt = bodyBattery.toNumber();

            // Set color based on value
            var fillColor;
            if (bbInt > 70) {
                fillColor = Graphics.COLOR_GREEN;
            } else if (bbInt > 30) {
                fillColor = Graphics.COLOR_YELLOW;
            } else {
                fillColor = Graphics.COLOR_RED;
            }

            // Rectangle position and size
            var rectX = dc.getWidth()/2 - 40; // center horizontally
            var rectY = dc.getHeight()/2 + 40; // below the text
            var rectWidth = 80 * bbInt / 100; // width proportional to battery
            var rectHeight = 30;

            // Draw battery fill rectangle
            dc.setColor(fillColor, Graphics.COLOR_TRANSPARENT);
            dc.fillRectangle(rectX, rectY, rectWidth, rectHeight);
            
            // dc.drawBitmap(rectX, rectY, Rez.Drawables.battery_outline);
            
            // Draw Body Battery value as text
            dc.setColor(fillColor, Graphics.COLOR_TRANSPARENT);
            dc.drawText(dc.getWidth()/2, dc.getHeight()/2, Graphics.FONT_LARGE, bbInt.toString() + "%", Graphics.TEXT_JUSTIFY_CENTER);
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

}
