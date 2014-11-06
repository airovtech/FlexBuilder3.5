package com.maninsoft.smart.modeler.xpdl.utils
{
	import com.maninsoft.smart.common.util.SmartUtil;
	import com.maninsoft.smart.modeler.xpdl.dialogs.SelectActivityFieldDialog;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.model.base.XPDLLink;
	
	import flash.display.DisplayObject;
	
	import mx.managers.PopUpManager;
	
	public class XPDLEditorPopup
	{
/*
		public static function popupConditionDialog(parent:DisplayObject, link:XPDLLink, callback:Function = null, options:Object = null):void {
			var dialog:ConditionDialog = PopUpManager.createPopUp(parent, ConditionDialog, true) as ConditionDialog;
//			var dialog:LinkConditionDialog = PopUpManager.createPopUp(parent, LinkConditionDialog, true) as LinkConditionDialog;
			if (callback != null)
				dialog.addEventListener(XPDLEditorEvent.OK, callback);
			
			dialog.link = link;
			
			if (options != null) {
				dialog.title = SmartUtil.toDefault(options["title"], dialog.title);
			}
			
			PopUpManager.centerPopUp(dialog);
		}
*/		
		public static function popupSelectActivityFieldDialog(parent:DisplayObject, value:String, diagram:XPDLDiagram, callback:Function = null):void {
			var dialog:SelectActivityFieldDialog = PopUpManager.createPopUp(parent, SelectActivityFieldDialog, true) as SelectActivityFieldDialog;
			dialog.diagram = diagram;
			dialog.value = value;
			
			if (callback != null)
				dialog.addEventListener(XPDLEditorEvent.OK, callback);
			
			PopUpManager.centerPopUp(dialog);
		}
	}
}