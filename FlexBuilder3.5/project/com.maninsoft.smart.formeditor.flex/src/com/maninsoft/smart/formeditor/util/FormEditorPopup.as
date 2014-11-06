package com.maninsoft.smart.formeditor.util
{
	import com.maninsoft.smart.common.util.SmartUtil;
	import com.maninsoft.smart.formeditor.FormEditorBase;
	import com.maninsoft.smart.formeditor.model.FormDocument;
	import com.maninsoft.smart.formeditor.model.FormEntity;
	import com.maninsoft.smart.formeditor.model.FormLink;
	import com.maninsoft.smart.formeditor.model.Mapping;
	import com.maninsoft.smart.formeditor.model.ServiceLink;
	import com.maninsoft.smart.formeditor.view.dialog.FormLinkDialog;
	import com.maninsoft.smart.formeditor.view.dialog.MappingDialog;
	import com.maninsoft.smart.formeditor.view.dialog.ServiceLinkDialog;
	
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Menu;
	import mx.core.IFlexDisplayObject;
	import mx.events.MenuEvent;
	import mx.managers.PopUpManager;
	import mx.resources.ResourceManager;
	
	public class FormEditorPopup
	{
		private static var parent:DisplayObjectContainer;
		private static var position:Point;
		private static var form:FormDocument;
		private static var field:FormEntity;
		
		public static function popupFormLinkMenu(parent:DisplayObjectContainer, x:Number, y:Number, form:FormDocument):void {
			if (form == null)
				return;
			
			FormEditorPopup.parent = parent;
			FormEditorPopup.form = form;
			FormEditorPopup.position = new Point(x, y);
			
			var options:Array = null;
			if (form.formLinks != null && form.formLinks.formLinks != null && !SmartUtil.isEmpty(form.formLinks.formLinks)) {
				options = new Array();
				for each (var formLink:FormLink in form.formLinks.formLinks)
					options.push({label: formLink.name, value: formLink});
			}
			
			popupObjectMenu(parent, x, y, options, _popupFormLinkDialog, _popupFormLinkDialog, removeFormLink);
		}
		private static function _popupFormLinkDialog(event:MenuEvent):void {
			popupFormLinkDialog(parent, position, form, event.item["value"] as FormLink, setFormLink);
		}
		private static function setFormLink(event:FormEditorEvent):void {
			FormEditorInvoker.setFormLink(form, event.model as FormLink);
		}
		private static function removeFormLink(event:MenuEvent):void {
			FormEditorInvoker.removeFormLink(event.item["value"] as FormLink);
		}
		public static function popupFormLinkDialog(parent:DisplayObjectContainer, position:Point, form:FormDocument, formLink:FormLink = null, callback:Function = null):void {
			if (formLink != null)
				formLink = formLink.clone();
			
			var formLinkDialog:FormLinkDialog = PopUpManager.createPopUp(parent, FormLinkDialog, true) as FormLinkDialog;
			if (callback != null)
				formLinkDialog.addEventListener(FormEditorEvent.OK, callback);
			
			formLinkDialog.form = form;
			formLinkDialog.formLink = formLink;
			formLinkDialog.x = position.x;
			formLinkDialog.y = position.y;
		}
		
		public static function popupServiceLinkMenu(parent:DisplayObjectContainer, x:Number, y:Number, form:FormDocument):void {
			if (form == null)
				return;
			
			FormEditorPopup.parent = parent;
			FormEditorPopup.form = form;
			FormEditorPopup.position = new Point(x, y);
			
			var options:Array = null;
			if (form.serviceLinks != null && form.serviceLinks.serviceLinks != null && !SmartUtil.isEmpty(form.serviceLinks.serviceLinks)) {
				options = new Array();
				for each (var serviceLink:ServiceLink in form.serviceLinks.serviceLinks)
					options.push({label: serviceLink.name, value: serviceLink});
			}
			
			popupObjectMenu(parent, x, y, options, _popupServiceLinkDialog, _popupServiceLinkDialog, removeServiceLink);
		}
		private static function _popupServiceLinkDialog(event:MenuEvent):void {
			popupServiceLinkDialog(parent, position, form, event.item["value"] as ServiceLink, setServiceLink);
		}

		private static function setServiceLink(event:FormEditorEvent):void {
			FormEditorInvoker.setServiceLink(form, event.model as ServiceLink);
		}
		private static function removeServiceLink(event:MenuEvent):void {
			FormEditorInvoker.removeServiceLink(event.item["value"] as ServiceLink);
		}
		public static function popupServiceLinkDialog(parent:DisplayObjectContainer, position:Point, form:FormDocument, serviceLink:ServiceLink = null, callback:Function = null):void {
			if (serviceLink != null)
				serviceLink = serviceLink.clone();
			
			var serviceLinkDialog:ServiceLinkDialog = PopUpManager.createPopUp(parent, ServiceLinkDialog, true) as ServiceLinkDialog;
			if (callback != null)
				serviceLinkDialog.addEventListener(FormEditorEvent.OK, callback);
			
			serviceLinkDialog.form = form;
			serviceLinkDialog.serviceLink = serviceLink;
			serviceLinkDialog.x = position.x;
			serviceLinkDialog.y = position.y;
		}
		
		public static function popupInMappingMenu(parent:DisplayObjectContainer, x:Number, y:Number, field:FormEntity):void {
			popupMappingMenu(parent, x, y, field, true);
		}
		public static function popupOutMappingMenu(parent:DisplayObjectContainer, x:Number, y:Number, field:FormEntity):void {
			popupMappingMenu(parent, x, y, field, false);
		}
		private static function popupMappingMenu(parent:DisplayObjectContainer, x:Number, y:Number, field:FormEntity, isIn:Boolean):void {
			if (field == null)
				return;
			
			FormEditorPopup.parent = parent;
			FormEditorPopup.field = field;
			FormEditorPopup.position = new Point(x, y);;
			
			var options:Array = null;
			if (field.mappings != null) {
				var mappings:ArrayCollection = isIn? field.mappings.inMappings : field.mappings.outMappings;
				if (!SmartUtil.isEmpty(mappings)) {
					options = new Array();
					for each (var mapping:Mapping in mappings)
						options.push({label: mapping.name, value: mapping});
				}
			}
			
			if (isIn) {
				popupObjectMenu(parent, x, y, options, popupInMappingDialog, popupInMappingDialog, removeInMapping);
			} else {
				popupObjectMenu(parent, x, y, options, popupOutMappingDialog, popupOutMappingDialog, removeOutMapping);
			}
		}
		private static var oldMapping:Mapping;
		private static function popupInMappingDialog(e:MenuEvent):void {
			var mapping:Mapping = e.item["value"] as Mapping;
			oldMapping = mapping;
			FormEditorPopup.popupMappingDialog(parent, position, field, true, mapping, mapping == null? createInMapping : updateInMapping);
		}
		private static function createInMapping(event:FormEditorEvent):void {
			FormEditorInvoker.createMapping(field, event.model as Mapping, true);
		}
		private static function updateInMapping(event:FormEditorEvent):void {
			FormEditorInvoker.updateMapping(event.model as Mapping, oldMapping);
		}
		private static function removeInMapping(e:MenuEvent):void {
			FormEditorInvoker.removeMapping(e.item["value"] as Mapping, true);
		}
		private static function popupOutMappingDialog(e:MenuEvent):void {
			var mapping:Mapping = e.item["value"] as Mapping;
			oldMapping = mapping;
			FormEditorPopup.popupMappingDialog(parent, position, field, false, mapping, mapping == null? createOutMapping : updateOutMapping);
		}
		private static function createOutMapping(event:FormEditorEvent):void {
			FormEditorInvoker.createMapping(field, event.model as Mapping, false);
		}
		private static function updateOutMapping(event:FormEditorEvent):void {
			FormEditorInvoker.updateMapping(event.model as Mapping, oldMapping);
		}
		private static function removeOutMapping(e:MenuEvent):void {
			FormEditorInvoker.removeMapping(e.item["value"] as Mapping, false);
		}
		
		public static function popupMappingDialog(parent:DisplayObjectContainer, position:Point, field:FormEntity, isIn:Boolean = true, mapping:Mapping = null, callback:Function = null):void {
			if (mapping != null)
				mapping = mapping.clone();
			
			var mappingDialog:MappingDialog = PopUpManager.createPopUp(parent, MappingDialog, true) as MappingDialog;
			if (callback != null)
				mappingDialog.addEventListener(FormEditorEvent.OK, callback);
			
			mappingDialog.formEditorBase = parent as FormEditorBase;
			mappingDialog.field = field;
			mappingDialog.mapping = mapping;
			if (!isIn)
				mappingDialog.direction = MappingDialog.DIRECTION_EXPORT;

			mappingDialog.x = position.x;
			mappingDialog.y = position.y;
		}
		
		private static function popupObjectMenu(parent:DisplayObjectContainer, x:Number, y:Number , options:Array = null, createFunction:Function = null, updateFunction:Function = null, deleteFunction:Function = null):void {
			var menus:Array = new Array();
			var deleteMenus:Array = null;
			if (!SmartUtil.isEmpty(options)) {
				if (deleteFunction != null)
					deleteMenus = new Array();
				for each (var option:Object in options) {
					if (updateFunction != null)
						menus.push({icon: option["icon"],label: option["label"], value: option["value"], click: updateFunction});
					if (deleteFunction != null)
						deleteMenus.push({icon: option["icon"],label: option["label"], value: option["value"], click: deleteFunction});
				}
				if (updateFunction != null)
					menus.push({type: "separator"});
			}
			if (createFunction != null)
				menus.push({label: ResourceManager.getInstance().getString("WorkbenchETC", "addText"), click: createFunction});
			if (!SmartUtil.isEmpty(deleteMenus))
				menus.push({label: ResourceManager.getInstance().getString("WorkbenchETC", "deleteText"), children: deleteMenus});
			
			var menu:Menu = Menu.createMenu(parent, menus, false);
			menu.styleName = "contextMenu";
			SmartUtil.showMenu(menu, x, y);
		}

		public static function localCenterPopUp(popUp:IFlexDisplayObject, parent:DisplayObjectContainer):void{
			if(parent.width>popUp.width && parent.height>popUp.height){
				popUp.x = parent.width/2-popUp.width/2;
				popUp.y = parent.height/2-popUp.height/2;
			}				
		}				
	}
}