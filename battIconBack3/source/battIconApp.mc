using Toybox.Application;
using Toybox.AntPlus;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Attention;

var isNetworkNewlyFormed;
var networkState;

var mLightNetworkListener; 
var mLightNetwork ;

var frontStr = "Front";
var backStr  = "Back";
var dbgStr ="dgb";

var seconds = 0;


var back1Str = "init";


var beepOn = false;

class MyLightNetworkListener extends AntPlus.LightNetworkListener {


	

	public static var BATTERY_STATUS_NAMES = { 0 => "Zer",
    						   	 1 => "NEW",
                                 2 => "GOOD", 
                  				 3 => "OKAY",
                   				 4 => "LOW",
                    			 5 => "CRIT",
                     			 6 => "CNT",
                      			 7 => "INV"
                 };
                 
                 
    public  static var LIGHT_MODE_NAMES_FRONT ={
                0 => "OFF",	
				1 => "ST100",  //Steady beam 81-100% intensity
				2 => "ST80",  //Steady beam 61-80% intensity
				3 => "ST60", //Steady beam 41-60% intensity
				4 => "ST40", //Steady beam 21-40% intensity
				5 => "ST20", //Steady beam 0-20% intensity
				6 => "SL_FLH",//Slow flash mode
				7 => "FST_FLH",	//Fast flash mode
				8 => "RAN_FLH", //Randomly timed flash mode	
				9 => "AUTO",	//auto?	
				10 => "SIGNAL_LEFT_SC", //	Turn signal left self-cancelling
				11 => "SIGNAL_LEFT", //Turn signal left
				12 => "SIGNAL_RIGHT_SC", //Turn signal right self-cancelling
				13 => "SIGNAL_RIGHT",	//Turn signal right
				14 => "HAZARD", //Hazard - right and left signals flash
				59 => "CUS5", //Custom mode (manufacturer-defined)
				60 => "CUS4",	//Custom mode (manufacturer-defined)
				61 => "CUS3",	//Custom mode (manufacturer-defined)	
				62 => "CUS2",	//Custom mode (manufacturer-defined)
				63 => "CUS1"	//Custom mode (manufacturer-defined)
		};
		
		public  static var LIGHT_MODE_NAMES_BACK ={
                0 => "OFF",	
				1 => "ST100",  //Steady beam 81-100% intensity
				2 => "ST80",  //Steady beam 61-80% intensity
				3 => "ST60", //Steady beam 41-60% intensity
				4 => "ST40", //Steady beam 21-40% intensity
				5 => "ST20", //Steady beam 0-20% intensity
				6 => "SL_FLH",//Slow flash mode
				7 => "FST_FLH",	//Fast flash mode
				8 => "RAN_FLH", //Randomly timed flash mode	
				9 => "AUTO",	//auto?	
				10 => "SIGNAL_LEFT_SC", //	Turn signal left self-cancelling
				11 => "SIGNAL_LEFT", //Turn signal left
				12 => "SIGNAL_RIGHT_SC", //Turn signal right self-cancelling
				13 => "SIGNAL_RIGHT",	//Turn signal right
				14 => "HAZARD", //Hazard - right and left signals flash
				59 => "CUS5", //Custom mode (manufacturer-defined)
				60 => "CUS4",	//Custom mode (manufacturer-defined)
				61 => "CUS3",	//Custom mode (manufacturer-defined)	
				62 => "CUS2",	//Custom mode (manufacturer-defined)
				63 => "CUS1"	//Custom mode (manufacturer-defined)
		};
                 
                 
    var mNetworkState = 0;


    
	function getTimeStr()
	{
	
		var str1 =       Gregorian.info(Time.now(), Time.FORMAT_SHORT).hour +":"
			             +Gregorian.info(Time.now(), Time.FORMAT_SHORT).min+":"
			             +Gregorian.info(Time.now(), Time.FORMAT_SHORT).sec;
		return str1;  
	}
    
    
    function onBatteryStatusUpdate(data)
    {
    	var batStatus = data; //it has bat status and identifier
		System.println(getTimeStr()+" Bat Status "+  BATTERY_STATUS_NAMES[batStatus.batteryStatus]+" ID="+batStatus.identifier );
    
    	if (  null != mLightNetwork )
    	{
    		var ligtsArray = mLightNetwork.getBikeLights();	 
			frontStr = "No front";
			backStr  = "No back";
			for ( var idx =0; idx < ligtsArray.size() ;idx++) {
				var light = ligtsArray[idx];
				var batteryStatus = mLightNetwork.getBatteryStatus( light.identifier );
               	if ( light.type == AntPlus.LIGHT_TYPE_HEADLIGHT )
				{ 
					frontStr =  BATTERY_STATUS_NAMES[batteryStatus.batteryStatus] 
									+" "+
								LIGHT_MODE_NAMES_FRONT[light.mode];
					if ( light.identifier == batStatus.identifier )	{
						dbgStr = "frnt bat updt";
					}
				}
				else if ( light.type == AntPlus.LIGHT_TYPE_TAILLIGHT )
				{ 
					backStr = BATTERY_STATUS_NAMES[batteryStatus.batteryStatus] 
							   +" "+
							  LIGHT_MODE_NAMES_BACK[light.mode];
					if ( light.identifier == batStatus.identifier )	{
						dbgStr = "back bat updt";
					}
				}		
			}//for
		}//mLightNetwork
    }
    
    function onBikeLightUpdate(data) {
		//mode changed by button or beacuse of light change
		if ( (Attention has :playTone) && beepOn ) {
   			Attention.playTone(Attention.TONE_LOUD_BEEP);
		}	
    	var light = data;
		if  ( null != mLightNetwork)
		{ 
			var batteryStatus = mLightNetwork.getBatteryStatus( light.identifier );
	       	if ( light.type == AntPlus.LIGHT_TYPE_HEADLIGHT ){ 
				frontStr = BATTERY_STATUS_NAMES[batteryStatus.batteryStatus] 
							+" "+
						  LIGHT_MODE_NAMES_FRONT[light.mode];
				dbgStr = "frnt state updt";	  
				System.println(getTimeStr()+" Bike Light update "+light.type + " mode="+  LIGHT_MODE_NAMES_FRONT[light.mode]+" ID="+light.identifier);
			}
			else if ( light.type == AntPlus.LIGHT_TYPE_TAILLIGHT )	{ 
				backStr = BATTERY_STATUS_NAMES[batteryStatus.batteryStatus] 
						  +" "+
						  LIGHT_MODE_NAMES_BACK[light.mode];
				dbgStr = "back state updt";
				System.println(getTimeStr()+" Bike Light update "+light.type + " mode="+  LIGHT_MODE_NAMES_BACK[light.mode]+" ID="+light.identifier);
			}		
		}//mLightNetwork
    }
    
    

    function onLightNetworkStateUpdate(data) {
        mNetworkState = data;
        frontStr = "Front listner";
		backStr  = "Back listner";
		dbgStr = "net state updt";

    	System.println(getTimeStr()+" Light NetUpdate "+ mNetworkState.toString());
    	
		if (null != mLightNetworkListener.mNetworkState) {
			var netState = mLightNetwork.getNetworkState();
			if ( netState == AntPlus.LIGHT_NETWORK_STATE_FORMED ) {
				 
				var ligtsArray = mLightNetwork.getBikeLights();	 
				frontStr = "No front";
				backStr  = "No back";
				
				for ( var idx =0; idx < ligtsArray.size() ;idx++) {
					var light = ligtsArray[idx];
					if  ( null != mLightNetwork)
					{ 
	                	var batteryStatus = mLightNetwork.getBatteryStatus( light.identifier );
	                	if ( light.type == AntPlus.LIGHT_TYPE_HEADLIGHT )
						{ 
							frontStr = BATTERY_STATUS_NAMES[batteryStatus.batteryStatus] 
										+" "+
										LIGHT_MODE_NAMES_FRONT[light.mode];
						}
						else if ( light.type == AntPlus.LIGHT_TYPE_TAILLIGHT )
						{ 
							backStr = BATTERY_STATUS_NAMES[batteryStatus.batteryStatus] 
									   +" "+
								 	LIGHT_MODE_NAMES_BACK[light.mode];
						}
					}//mLightNetwork		
				}//for
			}
			else if ( netState == AntPlus. LIGHT_NETWORK_STATE_FORMING )
			{
			   frontStr = "Net forming";
		       backStr = "Net forming";
		    }
		    else if ( netState == AntPlus. LIGHT_NETWORK_STATE_NOT_FORMED )
			{
			   frontStr = "NOT formed ";
		       backStr = "NOT formed";
		       
		    }else 
			{
			   frontStr = "Other state";
		       backStr = "Other state";
		    }
        }else
        {
        	frontStr = "Null";
		    backStr  = "Null";
        }
    }
}


class battIconApp extends Application.AppBase {

                 
    function initialize() {
     	//mLightNetworkListener = new MyLightNetworkListener();
        //mLightNetwork = new AntPlus.LightNetwork(mLightNetworkListener);
		//frontStr = "Front init";
		//backStr  = "Back init";
	    var app = Application.getApp();
	    beepOn = app.getProperty("beep_prop");
     	System.println("Beep Init "+beepOn.toString() );
     	        
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    //! Return the initial view of your application here
    function getInitialView() {
        return [ new battIconView() ];
    }
    
     function onSettingsChanged() {
    	var app = Application.getApp();
	    beepOn = app.getProperty("beep_prop");
    	System.println("Beep Init "+beepOn.toString() ); 
    
    }
    

}