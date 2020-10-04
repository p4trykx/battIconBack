using Toybox.WatchUi;
using Toybox.Application;
using Toybox.Graphics;
using Toybox.AntPlus;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Attention;




class Background extends WatchUi.Drawable {

    hidden var mColor;

    function initialize() {
        var dictionary = {
            :identifier => "Background"
        };

        Drawable.initialize(dictionary);
        
        back1Str = "init app";
        
        mLightNetworkListener = new MyLightNetworkListener();
        mLightNetwork = new AntPlus.LightNetwork(mLightNetworkListener);
        
        
		frontStr = "Front init back";
		backStr  = "Back init back";
		
    }

    function setColor(color) {
        mColor = color;
    }

    function draw(dc) {
        dc.setColor(Graphics.COLOR_TRANSPARENT, mColor);
        dc.clear();
    }

}
