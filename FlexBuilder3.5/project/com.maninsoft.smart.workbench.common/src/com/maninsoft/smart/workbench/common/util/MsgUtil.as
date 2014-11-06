package com.maninsoft.smart.workbench.common.util
{
	import com.maninsoft.smart.workbench.common.assets.UtilAssets;
	
	import flash.display.DisplayObject;
	
	import mx.controls.Alert;
	import mx.controls.Text;
	import mx.events.CloseEvent;
	import mx.resources.ResourceManager;
	
	public class MsgUtil
	{

		public static var resultTxt:Text;
		public static var resultFunc:Function;
		public static var resultVal:Boolean;
		
		public static function clearMsg():void {   
			resultVal=false;
		}

        private static function alertClickHandler(event:CloseEvent):void {
            if (event.detail==Alert.YES)
                resultVal = true;
            else
                resultVal = false;
                
            if(resultFunc!=null)
            	resultFunc(resultVal);
        }
		
		public static function showMsg(msg:String):void {   
			var message:String = "\n" + msg + "\n\n";
			Alert.yesLabel = ResourceManager.getInstance().getString("WorkbenchETC", "confirmText");
			Alert.show(message, null, Alert.YES, null, null,  UtilAssets.informMsgIcon, Alert.YES);
		}
		
		public static function showError(msg:String):void {   
			var message:String = "\n" + msg + "\n\n";
			Alert.yesLabel = ResourceManager.getInstance().getString("WorkbenchETC", "confirmText");
			Alert.show(message, null, Alert.YES, null, null,  UtilAssets.warningMsgIcon, Alert.YES);
		}
		
		public static function confirmMsg(msg:String, resultHandler:Function):void {
			resultFunc = resultHandler;
			var message:String = "\n" + msg + "\n\n";
			Alert.yesLabel = ResourceManager.getInstance().getString("WorkbenchETC", "yesText");
			Alert.noLabel = ResourceManager.getInstance().getString("WorkbenchETC", "noText");
			Alert.show(message, null, Alert.YES|Alert.NO, null, alertClickHandler,  UtilAssets.confirmMsgIcon, Alert.NO);
		}

		public static function showPopupMsg(parent:DisplayObject, msg:String, title:String = null):void { 
			Alert.show(msg);
		}
	}
}