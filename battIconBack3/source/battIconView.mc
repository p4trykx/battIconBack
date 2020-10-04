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

         View.setLayout(Rez.Layouts.MainLayout(dc));
         var labelView = View.findDrawableById("lampFront");
         labelView.locY = labelView.locY - 16;
         var valueView = View.findDrawableById("lampBack");
         valueView.locY = valueView.locY + 7;

        //View.findDrawableById("label").setText(Rez.Strings.label);
        
        return true;
    }

    // The given info object contains all the current workout information.
    // Calculate a value and save it locally in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    function compute(info) {
        // See Activity.Info in the documentation for available information.
        
    }

    // Display the value you computed here. This will be called
    // once a second when the data field is visible.

    function onUpdate(dc) {
    
        seconds +=1;
        
        if ( seconds > 60 )
        {
        
        	seconds = 0;
        	
        if (null != mLightNetworkListener.mNetworkState) {
        	var netState = mLightNetwork.getNetworkState();
			if ( netState == AntPlus.LIGHT_NETWORK_STATE_FORMED ) {
				 
				var ligtsArray = mLightNetwork.getBikeLights();	 
				
				frontStr = "No front";
				backStr  = "No back";
				
				for ( var idx =0; idx < ligtsArray.size() ;idx++) {
					var light = ligtsArray[idx];
					if (light ){
						var bikeLightId = light.identifier;
						if  ( null != mLightNetwork)
						{ 
		                	var batteryStatus = mLightNetwork.getBatteryStatus(bikeLightId);
		                	
		                	var modeStr = MyLightNetworkListener.LIGHT_MODE_NAMES[light.mode]; 
		                	
		                	if ( light.type == AntPlus.LIGHT_TYPE_HEADLIGHT )
							{ 
								frontStr =  "sH "+
									MyLightNetworkListener.BATTERY_STATUS_NAMES[batteryStatus.batteryStatus] 
									+" "+modeStr;
							}
							else if ( light.type == AntPlus.LIGHT_TYPE_TAILLIGHT )
							{ 
								backStr = "sT "+
									MyLightNetworkListener.BATTERY_STATUS_NAMES[batteryStatus.batteryStatus] 
									+" "+modeStr;
							}		
							
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
			   
			   
			   //frontStr =    Gregorian.info(Time.now(), Time.FORMAT_SHORT).hour +":"
			    //            +Gregorian.info(Time.now(), Time.FORMAT_SHORT).minute+":"
			    //            +Gregorian.info(Time.now(), Time.FORMAT_SHORT).sec;
			                
			                
			   frontStr = "NOT formed" ;
		       backStr = "NOT formed";
		    }else 
			{
			   frontStr = "Other state";
		       backStr = "Other state";
		    }
        	}
        
        }
        
        var width = dc.getWidth();
        var height = dc.getHeight();
        
        //frontStr = width.toString()+" "+height.toString();
        //backStr  = width.toString()+" "+height.toString();	
        
         View.findDrawableById("Background").setColor(getBackgroundColor());

        // Set the foreground color and value
        var frontLight = View.findDrawableById("lampFront");
        var backLight =  View.findDrawableById("lampBack");
        
        if (getBackgroundColor() == Gfx.COLOR_BLACK) {
            frontLight.setColor(Gfx.COLOR_WHITE);
            backLight.setColor(Gfx.COLOR_WHITE);
            
        } else {
            frontLight.setColor(Gfx.COLOR_BLACK);
            backLight.setColor(Gfx.COLOR_BLACK);
        }
        
        
        //frontLight.setText(mValue.format("%.2f"));
        
        frontLight.setText(frontStr + " "+seconds.toString());
        backLight.setText(backStr);
        //backLight.setText(back1Str);
        
                
        // Call parent's onUpdate(dc) to redraw the layout
        View.onUpdate(dc);
        
        
    }
      
    

}
