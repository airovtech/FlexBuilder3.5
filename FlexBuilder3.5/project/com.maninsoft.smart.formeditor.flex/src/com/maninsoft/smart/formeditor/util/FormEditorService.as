package com.maninsoft.smart.formeditor.util
{
	import com.maninsoft.smart.common.util.SmartUtil;
	import com.maninsoft.smart.formeditor.model.FormCond;
	import com.maninsoft.smart.formeditor.model.FormDocument;
	import com.maninsoft.smart.formeditor.model.FormEntity;
	import com.maninsoft.smart.formeditor.model.FormRef;
	import com.maninsoft.smart.formeditor.model.SystemService;
	import com.maninsoft.smart.formeditor.model.SystemServiceParameter;
	
	import mx.collections.ArrayCollection;
	
	public class FormEditorService
	{
		// getFormXml
		public static function getFormXml(id:String, callback:Function, callbackParams:Object=null):void {
			var params:Object = {
				method: "loadFormContent", 
				userId: FormEditorConfig.userId,
				compId: FormEditorConfig.compId, 
				formId: id
			}
			var cparams:Object = new Object();
			cparams["send_callback"] = callback;
			if(callbackParams != null)
				cparams["send_callbackParams"] = callbackParams;
			SmartUtil.send(FormEditorConfig.serviceUrl, params, getFormXmlCallback, cparams);
		}
		private static function getFormXmlCallback(result:XML, params:Object):void {
			if(params == null)
				return
				
			var callback:Function = params["send_callback"];
			var callbackParams:Object = params["send_callbackParams"];
			if (callback == null)
				return;
			if(callbackParams!=null)
				callback(result, callbackParams);
			else
				callback(result);
			trace("[GetFormXML Result XML]");
			trace(result.toXMLString());
		}
		
		// getForm
		public static function getForm(id:String, callback:Function, callbackParams:Object=null):void {
			var cparams:Object = new Object();
			cparams["send_callback"] = callback;
			if(callbackParams != null)
				cparams["send_callbackParams"] = callbackParams;
			getFormXml(id, getFormCallback, cparams);
		}
		private static function getFormCallback(formXml:XML, params:Object):void {
			if(params == null)
				return
				
			var callback:Function = params["send_callback"];
			var callbackParams:Object = params["send_callbackParams"];
			if (callback == null)
				return;
				
			var form:FormDocument = FormDocument.parseXML(formXml);
			if(callbackParams!=null)
				callback(form, callbackParams);
			else
				callback(form);
		}
		
		public static function getFieldsByFormId(formId:String, callback:Function, callbackParams:Object=null):void {
			var cparams:Object = new Object();
			cparams["send_callback"] = callback;
			if(callbackParams != null)
				cparams["send_callbackParams"] = callbackParams;
			getForm(formId, getFieldsByFormIdCallback, cparams);
		}
		private static function getFieldsByFormIdCallback(form:FormDocument, params:Object):void {
			if(params == null)
				return
				
			var callback:Function = params["send_callback"];
			var callbackParams:Object = params["send_callbackParams"];
			if (callback == null)
				return;
			
			if(callbackParams!=null)			
				callback(form.children, callbackParams);
			else
				callback(form.children);
		}
		
		public static function getFieldNameByFieldId(formId:String, fieldId:String, callback:Function, callbackParams:Object=null):void {
			var cparams:Object = new Object();
			cparams["send_callback"] = callback;
			cparams["send_fieldId"] = fieldId;
			if(callbackParams != null)
				cparams["send_callbackParams"] = callbackParams;
			getForm(formId, getFieldNameByFieldIdCallback, cparams);
		}
		private static function getFieldNameByFieldIdCallback(form:FormDocument, params:Object):void {
			var fieldName:String = null;
			if(params == null)
				return
				
			var callback:Function = params["send_callback"];
			var fieldId:String = params["send_fieldId"];
			var callbackParams:Object = params["send_callbackParams"];
			if (callback == null || fieldId == null)
				return;

			if(form.children){
				for each(var field:FormEntity in form.children){
					if(field.id == fieldId){
						fieldName = field.name;
						break;
					}
				}
			}

			if(callbackParams!=null)
				callback(fieldName, callbackParams);
			else
				callback(fieldName);
		}
		
		// getFromRef
		public static function getFormRef(id:String, callback:Function, callbackParams:Object=null):void {
			var params:Object = {
				method: "getPackageByFormId", 
				userId: FormEditorConfig.userId, 
				compId: FormEditorConfig.compId, 
				formId: id
			}
			var cparams:Object = new Object();
			cparams["send_callback"] = callback;
			if(callbackParams != null)
				cparams["send_callbackParams"] = callbackParams;
			SmartUtil.send(FormEditorConfig.serviceUrl, params, getFormRefCallback, cparams);
		}
		private static function getFormRefCallback(result:XML, params:Object):void {
			if(params == null)
				return
				
			var callback:Function = params["send_callback"];
			var callbackParams:Object = params["send_callbackParams"];
			if (callback == null)
				return;
			
			var formRef:FormRef = null;
			
			var formRefXml:XML = SmartUtil.toXml(result.child("package"));
			if (!SmartUtil.isEmpty(formRefXml))
				formRef = toFormRef(formRefXml);
			if(callbackParams!=null)
				callback(formRef, callbackParams);
			else
				callback(formRef);
		}
		
		// getFromRefs
		public static function getFormRefs(cond:FormCond, callback:Function, callbackParams:Object=null):void {
			var params:Object = new Object();
			params["method"] = "getPackages";
			params["userId"] = FormEditorConfig.userId;
			params["compId"] = FormEditorConfig.compId;
			if (cond != null) {
				if (cond.pageSize > -1)
					params["pageSize"] = cond.pageSize;
				if (cond.pageNo > -1)
					params["pageNo"] = cond.pageNo;
				if (!SmartUtil.isEmpty(cond.nameLike))
					params["nameLike"] = cond.nameLike;
				if (!SmartUtil.isEmpty(cond.type))
					params["type"] = cond.type;
			}			
			var cparams:Object = new Object();
			cparams["send_callback"] = callback;
			if(callbackParams != null)
				cparams["send_callbackParams"] = callbackParams;
			SmartUtil.send(FormEditorConfig.serviceUrl, params, getFormRefsCallback, cparams);
		}
		private static function getFormRefsCallback(result:XML, params:Object):void {
			if(params == null)
				return
				
			var callback:Function = params["send_callback"];
			var callbackParams:Object = params["send_callbackParams"];
			if (callback == null)
				return;
			
			var formRefs:ArrayCollection;
			var totalSize:int = SmartUtil.toNumber(result.@totalSize);
			var pkgs:XML = SmartUtil.toXml(result.child("packages"));
			if (!SmartUtil.isEmpty(pkgs)) {
				var pkgList:XMLList = pkgs.child("package");
				if (!SmartUtil.isEmpty(pkgList)) {
					formRefs = new ArrayCollection();
					for each (var pkg:XML in pkgList) {
						var formRef:FormRef = toFormRef(pkg);
						formRefs.addItem(formRef);
					}
				}
			}
			if(callbackParams!=null)
				callback(formRefs, totalSize, callbackParams);
			else
				callback(formRefs, totalSize);
		}
		
		private static function toFormRef(xml:XML):FormRef {
			if (SmartUtil.isEmpty(xml))
				return null;
			var formRef:FormRef = new FormRef();
			formRef.id = xml.@ext_formId;
			formRef.name = xml.@name;
			formRef.categoryName = xml.@ext_categoryName;
			formRef.groupName = xml.@ext_groupName;
			return formRef;
		}

		public static function getSystemServiceRef(id:String, callback:Function, callbackParams:Object=null):void {
			var params:Object = {
				method: "webServiceList", 
				userId: FormEditorConfig.userId, 
				compId: FormEditorConfig.compId, 
				objId: id
			}
			var cparams:Object = new Object();
			cparams["send_callback"] = callback;
			if(callbackParams != null)
				cparams["send_callbackParams"] = callbackParams;
			SmartUtil.send(FormEditorConfig.serviceUrl, params, getSystemServiceRefCallback, cparams);

		}
		private static function getSystemServiceRefCallback(result:XML, params:Object):void {
			if(params == null)
				return
				
			var callback:Function = params["send_callback"];
			var callbackParams:Object = params["send_callbackParams"];
			if (callback == null)
				return;
			
			var systemServiceRef:SystemService = null;
			
			var systemServiceRefListXml:XML = SmartUtil.toXml(result.child("webServiceList"));
			if (!SmartUtil.isEmpty(systemServiceRefListXml))
				var systemServiceRefXml:XMLList = systemServiceRefListXml.child("webService");
				if (!SmartUtil.isEmpty(systemServiceRefXml[0]))
					systemServiceRef = toSystemServiceRef(systemServiceRefXml[0]);

			if(callbackParams!=null)
				callback(systemServiceRef, callbackParams);
			else
				callback(systemServiceRef);
		}
		
		// getFromRefs
		public static function getSystemServiceRefs(callback:Function, callbackParams:Object=null):void {
			var params:Object = new Object();
			params["method"] = "webServiceList";
			params["userId"] = FormEditorConfig.userId;
			params["compId"] = FormEditorConfig.compId;

			var cparams:Object = new Object();
			cparams["send_callback"] = callback;
			if(callbackParams != null)
				cparams["send_callbackParams"] = callbackParams;
			SmartUtil.send(FormEditorConfig.serviceUrl, params, getSystemServiceRefsCallback, cparams);
		}
		private static function getSystemServiceRefsCallback(result:XML, params:Object):void {
			if(params == null)
				return
				
			var callback:Function = params["send_callback"];
			var callbackParams:Object = params["send_callbackParams"];
			if (callback == null)
				return;
			
			var systemServiceRefs:Array;
			var pkgs:XML = SmartUtil.toXml(result.child("webServiceList"));
			if (!SmartUtil.isEmpty(pkgs)) {
				var pkgList:XMLList = pkgs.child("webService");
				if (!SmartUtil.isEmpty(pkgList)) {
					systemServiceRefs = new Array();
					for each (var pkg:XML in pkgList) {
						var systemServiceRef:SystemService = toSystemServiceRef(pkg);
						systemServiceRefs.push(systemServiceRef);
					}
				}
			}

			if(callbackParams!=null)
				callback(systemServiceRefs, callbackParams);
			else
				callback(systemServiceRefs);
		}
		
		private static function toSystemServiceRef(xml:XML):SystemService {
			if (SmartUtil.isEmpty(xml))
				return null;
			var systemServiceRef:SystemService = new SystemService();
			systemServiceRef.id			= xml.@objId;
			systemServiceRef.name		= xml.@webServiceName;
			systemServiceRef.wsdlUli	= xml.@wsdlAddress;
			systemServiceRef.port		= xml.@portName;
			systemServiceRef.operation	= xml.@operationName;
			systemServiceRef.messageIn 	= [];
			for each(var i:XML in xml.webServiceInputParameters.webServiceInputParameter){
				var systemServiceParameter:SystemServiceParameter = new SystemServiceParameter();
				systemServiceParameter.id 			= i.@inputName;
				systemServiceParameter.name 		= i.@inputVariableName;
				systemServiceParameter.serviceId 	= systemServiceRef.id;
				systemServiceParameter.elementName 	= i.@inputName;
				systemServiceParameter.elementType 	= i.@inputType;
				systemServiceRef.messageIn.push(systemServiceParameter);
			}
			systemServiceRef.messageOut	= [];
			for each(var o:XML in xml.webServiceOutputParameters.webServiceOutputParameter){
				systemServiceParameter = new SystemServiceParameter();
				systemServiceParameter.id 			= o.@outputName;
				systemServiceParameter.name 		= o.@outputVariableName;
				systemServiceParameter.serviceId 	= systemServiceRef.id;
				systemServiceParameter.elementName 	= o.@outputName;
				systemServiceParameter.elementType 	= o.@outputType;
				systemServiceRef.messageOut.push(systemServiceParameter);
			}
			systemServiceRef.description 	= xml.description;
			return systemServiceRef;
		}
		
		public static function getProcessFormRefsByFormId(formId:String, callback:Function, callbackParams:Object=null):void {
			var params:Object = new Object();
			params["method"] = "getProcessFormListByForm";
			params["userId"] = FormEditorConfig.userId;
			params["formId"] = formId;

			var cparams:Object = new Object();
			cparams["send_callback"] = callback;
			if(callbackParams != null)
				cparams["send_callbackParams"] = callbackParams;			
			SmartUtil.send(FormEditorConfig.serviceUrl, params, getProcessFormRefsByFormIdCallback, cparams);
		}
		private static function getProcessFormRefsByFormIdCallback(result:XML, params:Object):void {
			if(params == null)
				return
				
			var callback:Function = params["send_callback"];
			var callbackParams:Object = params["send_callbackParams"];
			if (callback == null)
				return;
			
			var formRefs:ArrayCollection;
			var totalSize:int = SmartUtil.toNumber(result.@totalSize);
			var formList:XMLList = result.child("Form");
			if (!SmartUtil.isEmpty(formList)) {
				formRefs = new ArrayCollection();
				for each (var form:XML in formList) {
					var formRef:FormRef = new FormRef();
					formRef.id = form.formId;
					formRef.name = form.name;
					formRefs.addItem(formRef);
				}
			}

			if(callbackParams!=null)			
				callback(formRefs, totalSize, callbackParams);
			else
				callback(formRefs, totalSize);
		}
	}
}