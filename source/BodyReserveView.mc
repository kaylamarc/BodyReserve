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
            // var bbInt = bodyBattery.toNumber();
            var bbInt = 100;
            var battHeight = 0;
            var battWidth = 0;

            var battBitMapRes;

            // Set color based on value
            var fillColor;
            if (bbInt >= 80) {
                fillColor = Graphics.COLOR_GREEN;
                battBitMapRes = WatchUi.loadResource(Rez.Drawables.happy);
            } else if (bbInt < 80 && bbInt >= 60) {
                fillColor = Graphics.createColor(0, 255, 255, 0);
                battBitMapRes = WatchUi.loadResource(Rez.Drawables.okay);
            } else if (bbInt < 60 && bbInt >= 30) {
                fillColor = Graphics.COLOR_ORANGE;
                battBitMapRes = WatchUi.loadResource(Rez.Drawables.tired);
            } else {
                fillColor = Graphics.COLOR_RED;
                battBitMapRes = WatchUi.loadResource(Rez.Drawables.sleep);
            }

            // Center positions
            var posX = dc.getWidth() / 2 - (battBitMapRes.getWidth() / 2);
            var posY = dc.getHeight() / 2;

            // full height of the battery bitmap
            var battMaxHeight = battBitMapRes.getHeight();
            battWidth = battBitMapRes.getWidth() - 2;

            // 7px for the top of the battery outline
            battHeight = (((battMaxHeight - 4) * bbInt)/ 100);

            // Adjust posX to the top left edge of the battery outline
            var rectY = posY + (battMaxHeight - battHeight);
            
            // Draw battery fill rectangle
            dc.setColor(fillColor, Graphics.COLOR_TRANSPARENT);
            dc.fillRectangle(posX+1, rectY, battWidth, battHeight);

            // Draw battery outline bitmap on top of the fill rectangle
            dc.drawBitmap(posX, posY, battBitMapRes);

            // Draw Body Battery value as text
            dc.setColor(fillColor, Graphics.COLOR_TRANSPARENT);
            dc.drawText(dc.getWidth() / 2, posY - 70, Graphics.FONT_LARGE, bbInt.toString() + "%", Graphics.TEXT_JUSTIFY_CENTER);
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

}
