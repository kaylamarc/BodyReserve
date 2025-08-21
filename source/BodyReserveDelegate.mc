import Toybox.Lang;
import Toybox.WatchUi;

class BodyReserveDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new BodyReserveMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}