//using Toybox.WatchUi;
//using Toybox.Graphics;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.AntPlus;

class battIconView extends Ui.DataField {

   
 	
 
     function isSingleFieldLayout() {
        return ( DataField.getObscurityFlags() == OBSCURE_TOP | OBSCURE_LEFT | OBSCURE_BOTTOM | OBSCURE_RIGHT);
    }
    
    function initialize() {
        DataField.initialize();
        
    }

    // Set your layout here. Anytime the size of obscurity of
    // the draw context is changed this will be called.
    function onLayout(dc) {
        var obscurityFlags = DataField.getObscurityFlags();
        // Use the generic, centered layout
		if ( DBG_MODE == true )
		{
	         View.setLayout(Rez.Layouts.MainLayout(dc));
	         var frontlView = View.findDrawableById("lampFront");
	         frontlView.locY = frontlView.locY - 20;
	         var backView = View.findDrawableById("lampBack");
	         backView.locY = backView.locY ;
	         var dbgView = View.findDrawableById("dbg");
	         dbgView.locY = dbgView.locY + 20;
         }else
         {
         	View.setLayout(Rez.Layouts.MainLayout(dc));
	         var frontlView = View.findDrawableById("lampFront");
	         frontlView.locY = frontlView.locY - 20;
	         frontlView.setFont( Gfx.FONT_MEDIUM );
	         
	         var backView = View.findDrawableById("lampBack");
	         backView.locY = backView.locY+10 ;
	         backView.setFont ( Gfx.FONT_MEDIUM) ;
	        
	         var dbgView = View.findDrawableById("dbg");
	         dbgView.locY = dbgView.locY + 50;
         
         }

        //View.findDrawableById("label").setText(Rez.Strings.label);
        
        return true;
    }

    // The given info object contains all the current workout information.
    // Calculate a value and save it locally in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    function compute(info) {
        // See Activity.Info in the documentation for available information.
         var averageSpeed = info.averageSpeed ? info.averageSpeed : 0;  // meters per second
         var distanceToEnd = info.distanceToDestination ? info.distanceToDestination :0;//meters
         var timeToFinishSec = 0;
         
         if ( averageSpeed >0 ){
         	
         	timeToFinishSec = distanceToEnd / averageSpeed ;  
         	var timeToFinishH = timeToFinishSec/ 60 / 60 ;	
         	dbgStr = timeToFinishH + " h";
         
         }else
         {
         	var distKm = distanceToEnd/1000; 
         	dbgStr = distKm + " km";	
         }
         
         
         
         
    }

    // Display the value you computed here. This will be called
    // once a second when the data field is visible.

    function onUpdate(dc) {
    
        seconds +=1;
        if ( seconds > 60 )
        {
	       	dbgStr = "timer updt";
	       	seconds = 0;
	        if (null != mLightNetworkListener.mNetworkState) {
	        	var netState = mLightNetwork.getNetworkState();
				if ( netState == AntPlus.LIGHT_NETWORK_STATE_FORMED ) {
					var ligtsArray = mLightNetwork.getBikeLights();	 
					frontStr = "No front";
					backStr  = "No back";
					
					for ( var idx =0; idx < ligtsArray.size() ;idx++) {
						var light = ligtsArray[idx];
						var bikeLightId = light.identifier;
						if  ( null != mLightNetwork)
						{ 
			            	var batteryStatus = mLightNetwork.getBatteryStatus(light.identifier);
		                	if ( light.type == AntPlus.LIGHT_TYPE_HEADLIGHT )
							{ 
								frontStr = MyLightNetworkListener.BATTERY_STATUS_NAMES[batteryStatus.batteryStatus] 
										 +" "+
										MyLightNetworkListener.LIGHT_MODE_NAMES_FRONT[light.mode];
									
								}
								else if ( light.type == AntPlus.LIGHT_TYPE_TAILLIGHT )
								{ 
									backStr = MyLightNetworkListener.BATTERY_STATUS_NAMES[batteryStatus.batteryStatus] 
											+" "+
											MyLightNetworkListener.LIGHT_MODE_NAMES_BACK[light.mode];
								}		
						}
					}//for
				   //value.setText("F "+txt);
				  // System.println("F "+txt);
				   //View.findDrawableById("label").setText(txt);
					}
					else if ( netState == AntPlus.LIGHT_NETWORK_STATE_FORMING )
					{
					   frontStr = "Net forming";
				       backStr = "Net forming";
				    }
				    else if ( netState == AntPlus.LIGHT_NETWORK_STATE_NOT_FORMED )
					{
					   frontStr = "NOT formed" ;
				       backStr = "NOT formed";
				    }else 
					{
					   frontStr = "Other state";
				       backStr = "Other state";
				    }
	        }//mLightNetwork
       	}//60 seconds
        
        var width = dc.getWidth();
        var height = dc.getHeight();
        
        //frontStr = width.toString()+" "+height.toString();
        //backStr  = width.toString()+" "+height.toString();	
        
         View.findDrawableById("Background").setColor(getBackgroundColor());

        // Set the foreground color and value
        var frontLight = View.findDrawableById("lampFront");
        var backLight =  View.findDrawableById("lampBack");
        var dbgLabel = View.findDrawableById("dbg");
        
        if (getBackgroundColor() == Gfx.COLOR_BLACK) {
            frontLight.setColor(Gfx.COLOR_WHITE);
            backLight.setColor(Gfx.COLOR_WHITE);
            dbgLabel.setColor(Gfx.COLOR_WHITE);
            
        } else {
            frontLight.setColor(Gfx.COLOR_BLACK);
            backLight.setColor(Gfx.COLOR_BLACK);
            dbgLabel.setColor(Gfx.COLOR_BLACK);
        }
                
        frontLight.setText(frontStr);
        backLight.setText(backStr);
        dbgLabel.setText(dbgStr+" "+seconds.toString());
        // Call parent's onUpdate(dc) to redraw the layout
        View.onUpdate(dc);
        
        
    }
      
    

}
