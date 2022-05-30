
#define canyonRun_id_flightData 950
#define canyonRun_id_flightDataStream 951

class RscTitles {
 class Default {
       idd = -1;
       fadein = 0;
       fadeout = 0;
       duration = 0;
    };

	class FLIGHTDATA_MESSAGE {
        idd = canyonRun_id_flightData;
        movingEnable =  0;
        enableSimulation = 1;
        enableDisplay = 1;
        duration     =  8;
        fadein       =  0;
        fadeout      =  0;
        name = "FLIGHTDATA_MESSAGE";
		onLoad = "with uiNameSpace do { FLIGHTDATA_MESSAGE = _this select 0 }";
	
		class controls {
		    class structuredText {
                access = 0;
                type = 13;
                idc = canyonRun_id_flightDataStream;
                style = 0x00;
                lineSpacing = 1;
				x = 0.80 * safezoneW + safezoneX;
				y = 0.50 * safezoneH + safezoneY;
				w = 0.20 * safezoneW;
				h = 0.10 * safezoneH;
                size = 0.030;
                colorBackground[] = {1,1,1,0.1};
                colorText[] = {0,0,0,1};
                text = "";
                font = "PuristaSemiBold";
				
				class Attributes {
					font = "PuristaSemiBold";
					color = "#FFFFFF";
					align = "LEFT";
					valign = "CENTER";
					shadow = false;
					shadowColor = "#000000";
					underline = false;
					size = "1";
				}; 
            };
		};
	};


};


