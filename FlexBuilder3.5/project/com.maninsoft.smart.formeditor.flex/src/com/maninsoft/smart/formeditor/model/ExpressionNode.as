package com.maninsoft.smart.formeditor.model
{
	import com.maninsoft.smart.common.util.SmartUtil;
	
	import mx.resources.ResourceManager;
	
	public class ExpressionNode
	{
		public static const OPERATOR_PLUS:String = "+";
		public static const OPERATOR_MINUS:String = "-";
		public static const OPERATOR_MULTI:String = "*";
		public static const OPERATOR_DIV:String = "div";
		public static const OPERATORS:Array = [
			OPERATOR_PLUS, 
			OPERATOR_MINUS, 
			OPERATOR_MULTI, 
			OPERATOR_DIV
		];
		public static const OPERATORNAMES:Array = [
			"+",
			"-",
			"x",
			"/"
		];
		
		public static const MAPPINGTYPE_SELFFORM:String = Mapping.MAPPINGTYPE_SELFFORM;
		public static const MAPPINGTYPE_OTHERFORM:String = Mapping.MAPPINGTYPE_OTHERFORM;
		public static const MAPPINGTYPE_PROCESSFORM:String = Mapping.MAPPINGTYPE_PROCESSFORM;
		public static const MAPPINGTYPE_SYSTEM:String = Mapping.MAPPINGTYPE_SYSTEM;
		public static const MAPPINGTYPE_SYSTEMSERVICE:String = Mapping.MAPPINGTYPE_SYSTEMSERVICE;
		public static const MAPPINGTYPE_EXPRESSION:String = "expression";
		public static const MAPPINGTYPE_BRACKET:String = "bracket";
		public static const MAPPINGTYPES:Array = [
			MAPPINGTYPE_SELFFORM, 
			MAPPINGTYPE_OTHERFORM, 
			MAPPINGTYPE_PROCESSFORM, 
			MAPPINGTYPE_EXPRESSION, 
			MAPPINGTYPE_SYSTEM, 
			MAPPINGTYPE_SYSTEMSERVICE, 
			MAPPINGTYPE_BRACKET
		];

		internal static var mappingTypeNames:Array = [
			ResourceManager.getInstance().getString("FormEditorETC", "selfFormText"),
			ResourceManager.getInstance().getString("FormEditorETC", "otherFormText"),
			ResourceManager.getInstance().getString("FormEditorETC", "processFormText"),
			ResourceManager.getInstance().getString("FormEditorETC", "expressionText"),
			ResourceManager.getInstance().getString("FormEditorETC", "systemText"),
			ResourceManager.getInstance().getString("FormEditorETC", "systemServiceText"),
			ResourceManager.getInstance().getString("FormEditorETC", "bracketText")
		];
					
		public static const MAPPINGTYPENAMES:Array = mappingTypeNames;
		
		public static const SYSTEMFUNCTIONTYPE_CURRENTUSER:String = "system_currentUser";
		public static const SYSTEMFUNCTIONTYPE_CURRENTTIME:String = "system_currentTime";
		public static const SYSTEMFUNCTIONTYPE_CURRENTPROCESS:String = "system_currentProcess";
		public static const SYSTEMFUNCTIONTYPE_MAILMESSAGE:String = "system_mailMessage";
		public static const SYSTEMFUNCTIONTYPE_MISC:String = "system_misc";
		public static const SYSTEMFUNCTIONTYPES:Array = [
			SYSTEMFUNCTIONTYPE_CURRENTUSER, 
			SYSTEMFUNCTIONTYPE_CURRENTTIME, 
			SYSTEMFUNCTIONTYPE_CURRENTPROCESS, 
//			SYSTEMFUNCTIONTYPE_MAILMESSAGE, 
			SYSTEMFUNCTIONTYPE_MISC
		];

		internal static var systemFunctionTypeNames:Array = [
			ResourceManager.getInstance().getString("FormEditorETC", "currentUserTypeText"),
			ResourceManager.getInstance().getString("FormEditorETC", "currentTimeTypeText"),
			ResourceManager.getInstance().getString("FormEditorETC", "currentProcessTypeText"),
//			ResourceManager.getInstance().getString("FormEditorETC", "mailMessageTypeText"),
			ResourceManager.getInstance().getString("FormEditorETC", "miscTypeText")
		];
		public static const SYSTEMFUNCTIONTYPENAMES:Array = systemFunctionTypeNames;
		
		public static const SYSTEMFUNCTION_GETCURRENTUSER:String 	= "mis:getCurrentUser";
		public static const SYSTEMFUNCTION_GETDEPTID:String 		= "mis:getDeptId";
		public static const SYSTEMFUNCTION_GETTEAMLEADERID:String 	= "mis:getTeamLeaderId";
		public static const SYSTEMFUNCTION_GETDIRECTORID:String 	= "mis:getDirectorId";
		public static const SYSTEMFUNCTION_GETEXECUTIVEID:String 	= "mis:getExecutiveId";
		public static const SYSTEMFUNCTION_GETPRESIDENTID:String 	= "mis:getPresidentId";
		public static const SYSTEMFUNCTION_GETCHAIRMANID:String 	= "mis:getChairmanId";
		public static const SYSTEMFUNCTION_GETMOBILENO:String 		= "mis:getMobileNo";
		public static const SYSTEMFUNCTION_GETINTERNALNO:String 	= "mis:getInternalNo";
		public static const SYSTEMFUNCTION_GETEMPNO:String 			= "mis:getEmpNo";
		public static const SYSTEMFUNCTION_GETPOSITION:String 		= "mis:getPosition";
		
		public static const SYSTEMFUNCTION_GETCURRENTDATETIME:String= "mis:getCurrentDateTime";
		public static const SYSTEMFUNCTION_GETCURRENTDATE:String 	= "mis:getCurrentDate";
		public static const SYSTEMFUNCTION_GETCURRENTTIME:String 	= "mis:getCurrentTime";

		public static const SYSTEMFUNCTION_GETCURRENTPROCINITIATOR:String 	= "mis:getCurrentProcInitiator";
		public static const SYSTEMFUNCTION_GETCURRENTPROCPERFORMERS:String 	= "mis:getCurrentProcPerformers";
		public static const SYSTEMFUNCTION_GETCURRENTPROCFULLNAME:String 	= "mis:getCurrentProcFullName";
		public static const SYSTEMFUNCTION_GETCURRENTPROCFULLNAMEWITHLINK:String 	= "mis:getCurrentProcFullNameWithLink";

		public static const SYSTEMFUNCTION_GETMAILSUBJECTPROCFINISHED:String = "mis:getMailSubjectProcFinished";
		public static const SYSTEMFUNCTION_GETMAILCONTENTPROCFINISHED:String = "mis:getMailContentProcFinished";

		public static const SYSTEMFUNCTION_GENERATEID:String = "mis:generateId";
		public static const SYSTEMFUNCTIONS_CURRENTUSER:Array = [
			SYSTEMFUNCTION_GETCURRENTUSER,
			SYSTEMFUNCTION_GETDEPTID,
			SYSTEMFUNCTION_GETTEAMLEADERID,
			SYSTEMFUNCTION_GETDIRECTORID,
			SYSTEMFUNCTION_GETEXECUTIVEID,
			SYSTEMFUNCTION_GETPRESIDENTID,
			SYSTEMFUNCTION_GETCHAIRMANID,
			SYSTEMFUNCTION_GETMOBILENO,
			SYSTEMFUNCTION_GETINTERNALNO,
			SYSTEMFUNCTION_GETEMPNO,
			SYSTEMFUNCTION_GETPOSITION
		];

		public static const SYSTEMFUNCTIONS_CURRENTTIME:Array = [
			SYSTEMFUNCTION_GETCURRENTDATETIME,
			SYSTEMFUNCTION_GETCURRENTDATE,
			SYSTEMFUNCTION_GETCURRENTTIME
		];
		
		public static const SYSTEMFUNCTIONS_CURRENTPROCESS:Array = [
			SYSTEMFUNCTION_GETCURRENTPROCINITIATOR,
			SYSTEMFUNCTION_GETCURRENTPROCPERFORMERS
//			SYSTEMFUNCTION_GETCURRENTPROCFULLNAME,
//			SYSTEMFUNCTION_GETCURRENTPROCFULLNAMEWITHLINK
		];
		
		public static const SYSTEMFUNCTIONS_MAILMESSAGE:Array = [
			SYSTEMFUNCTION_GETMAILSUBJECTPROCFINISHED,
			SYSTEMFUNCTION_GETMAILCONTENTPROCFINISHED
		];

		public static const SYSTEMFUNCTIONS_MISC:Array = [
			SYSTEMFUNCTION_GENERATEID
		];


		internal static var systemFunctionNamesCurrentUser:Array = [
			ResourceManager.getInstance().getString("FormEditorETC", "currentUserText"),
			ResourceManager.getInstance().getString("FormEditorETC", "deptIdText"),
			ResourceManager.getInstance().getString("FormEditorETC", "teamLeaderIdText"),
			ResourceManager.getInstance().getString("FormEditorETC", "directorIdText"),
			ResourceManager.getInstance().getString("FormEditorETC", "executiveIdText"),
			ResourceManager.getInstance().getString("FormEditorETC", "presidentIdText"),
			ResourceManager.getInstance().getString("FormEditorETC", "chairmanIdText"),
			ResourceManager.getInstance().getString("FormEditorETC", "mobileNoText"),
			ResourceManager.getInstance().getString("FormEditorETC", "internalNoText"),
			ResourceManager.getInstance().getString("FormEditorETC", "empNoText"),
			ResourceManager.getInstance().getString("FormEditorETC", "positionText")
		];
		public static const SYSTEMFUNCTIONNAMES_CURRENTUSER:Array = systemFunctionNamesCurrentUser;
					
		internal static var systemFunctionNamesCurrentTime:Array = [
			ResourceManager.getInstance().getString("FormEditorETC", "currentDateTimeText"),
			ResourceManager.getInstance().getString("FormEditorETC", "currentDateText"),
			ResourceManager.getInstance().getString("FormEditorETC", "currentTimeText")
		];
		public static const SYSTEMFUNCTIONNAMES_CURRENTTIME:Array = systemFunctionNamesCurrentTime;
					
		internal static var systemFunctionNamesCurrentProcess:Array = [
			ResourceManager.getInstance().getString("FormEditorETC", "currentProcInitiatorText"),
			ResourceManager.getInstance().getString("FormEditorETC", "currentProcPerformersText")
//			ResourceManager.getInstance().getString("FormEditorETC", "currentProcFullNameText"),
//			ResourceManager.getInstance().getString("FormEditorETC", "currentProcFullNameWithLinkText")
		];
		public static const SYSTEMFUNCTIONNAMES_CURRENTPROCESS:Array = systemFunctionNamesCurrentProcess;
					
		internal static var systemFunctionNamesMailMessage:Array = [
			ResourceManager.getInstance().getString("FormEditorETC", "mailSubjectProcFinishedText"),
			ResourceManager.getInstance().getString("FormEditorETC", "mailContentProcFinishedText")
		];
		public static const SYSTEMFUNCTIONNAMES_MAILMESSAGE:Array = systemFunctionNamesMailMessage;

		internal static var systemFunctionNamesMisc:Array = [
			ResourceManager.getInstance().getString("FormEditorETC", "generateIDText")
		];
		public static const SYSTEMFUNCTIONNAMES_MISC:Array = systemFunctionNamesMisc;

		public static const MAPPINGTARGET_PROCESSPARAM:String = "processParam";
		public static const MAPPINGTARGET_SUBPARAMETER:String = "subParameter";
		public static const MAPPINGTARGET_SERVICEPARAM:String = "serviceParam";
		
		public static const VALUEFUNCTION_VALUE:String = "value";
		public static const VALUEFUNCTION_SUM:String = "sum";
		public static const VALUEFUNCTION_MIN:String = "min";
		public static const VALUEFUNCTION_MAX:String = "max";
		public static const VALUEFUNCTION_AVERAGE:String = "avg";
		public static const VALUEFUNCTION_COUNT:String = "count";
		public static const VALUEFUNCTION_LIST:String = "list";
		public static const VALUEFUNCTIONS:Array = [
			VALUEFUNCTION_VALUE, 
			VALUEFUNCTION_SUM, 
			VALUEFUNCTION_MIN, 
			VALUEFUNCTION_MAX, 
			VALUEFUNCTION_AVERAGE, 
			VALUEFUNCTION_COUNT,
			VALUEFUNCTION_LIST
		];

		internal static var valueFunctionNames:Array = [
			ResourceManager.getInstance().getString("FormEditorETC", "valueText"),
			ResourceManager.getInstance().getString("FormEditorETC", "sumText"),
			ResourceManager.getInstance().getString("FormEditorETC", "minText"),
			ResourceManager.getInstance().getString("FormEditorETC", "maxText"),
			ResourceManager.getInstance().getString("FormEditorETC", "avgText"),
			ResourceManager.getInstance().getString("FormEditorETC", "countText"),
			ResourceManager.getInstance().getString("FormEditorETC", "listText")
		];

		public static const VALUEFUNCTIONNAMES:Array = valueFunctionNames;
		
		public var label:String;
		public var operator:String;
		public var operatorName:String;
		public var mappingType:String;
		public var mappingTypeName:String;
		public var formLinkId:String;
		public var formLinkName:String;
		public var serviceLinkId:String;
		public var serviceLinkName:String;
		public var activityId:String;
		public var fieldId:String;
		public var fieldName:String;
		public var valueFunction:String;
		public var valueFunctionName:String;
		public function toXML():XML {
			var xml:XML = <node/>
			
			if (!SmartUtil.isEmpty(label))
				xml.@label = label;
			if (!SmartUtil.isEmpty(operator))
				xml.@operator = operator;
			if (!SmartUtil.isEmpty(operatorName))
				xml.@operatorName = operatorName;
			if (!SmartUtil.isEmpty(mappingType))
				xml.@mappingType = mappingType;
			if (!SmartUtil.isEmpty(mappingTypeName))
				xml.@mappingTypeName = mappingTypeName;
			if (!SmartUtil.isEmpty(formLinkId))
				xml.@formLinkId = formLinkId;
			if (!SmartUtil.isEmpty(formLinkName))
				xml.@formLinkName = formLinkName;
			if (!SmartUtil.isEmpty(serviceLinkId))
				xml.@serviceLinkId = serviceLinkId;
			if (!SmartUtil.isEmpty(serviceLinkName))
				xml.@serviceLinkName = serviceLinkName;
			if (!SmartUtil.isEmpty(activityId))
				xml.@activityId = activityId;
			if (!SmartUtil.isEmpty(fieldId))
				xml.@fieldId = fieldId;
			if (!SmartUtil.isEmpty(fieldName))
				xml.@fieldName = fieldName;
			if (!SmartUtil.isEmpty(valueFunction))
				xml.@valueFunction = valueFunction;
			if (!SmartUtil.isEmpty(valueFunctionName))
				xml.@valueFunctionName = valueFunctionName;
			
			return xml;
		}
		public static function parseXML(xml:XML):ExpressionNode {
			var obj:ExpressionNode = new ExpressionNode();
			
			obj.label = xml.@label;
			obj.operator = xml.@operator;
			obj.operatorName = xml.@operatorName;
			obj.mappingType = xml.@mappingType;
			obj.mappingTypeName = xml.@mappingTypeName;
			obj.formLinkId = xml.@formLinkId;
			obj.formLinkName = xml.@formLinkName;
			obj.serviceLinkId = xml.@serviceLinkId;
			obj.serviceLinkName = xml.@serviceLinkName;
			obj.activityId = xml.@activityId;
			obj.fieldId = xml.@fieldId;
			obj.fieldName = xml.@fieldName;
			obj.valueFunction = xml.@valueFunction;
			obj.valueFunctionName = xml.@valueFunctionName;
			
			return obj;
		}
		
		public static function toOperatorName(operator:String):String {
			if (SmartUtil.isEmpty(operator))
				return null;
			var index:int = OPERATORS.indexOf(operator);
			if (index < 0)
				return null;
			return OPERATORNAMES[index] as String;
		}
		public static function toMappingTypeName(mappingType:String):String {
			if (SmartUtil.isEmpty(mappingType))
				return null;
			var index:int = MAPPINGTYPES.indexOf(mappingType);
			if (index < 0)
				return null;
			return MAPPINGTYPENAMES[index] as String;
		}
		public static function toValueFunctionName(valueFunction:String):String {
			if (SmartUtil.isEmpty(valueFunction))
				return null;
			var index:int = VALUEFUNCTIONS.indexOf(valueFunction);
			if (index < 0)
				return null;
			return VALUEFUNCTIONNAMES[index] as String;
		}
		
		public static function toLabel(xml:XML):String {
			var label:String = "";
			var operatorName:String = xml.@operatorName;
			var mappingType:String = xml.@mappingType;
			var formLinkName:String = xml.@formLinkName;
			var serviceLinkName:String = xml.@serviceLinkName;
			var fieldName:String = xml.@fieldName;
			var valueFunction:String = xml.@valueFunction;
			var valueFunctionName:String = xml.@valueFunctionName;
			
			if (!SmartUtil.isEmpty(operatorName))
				label += operatorName + " ";
			if (mappingType == MAPPINGTYPE_SYSTEMSERVICE && mappingType != MAPPINGTYPE_EXPRESSION && !SmartUtil.isEmpty(serviceLinkName))
				label += serviceLinkName;
			else if (mappingType != MAPPINGTYPE_SELFFORM && mappingType != MAPPINGTYPE_EXPRESSION && !SmartUtil.isEmpty(formLinkName))
				label += formLinkName;
			if (!SmartUtil.isEmpty(fieldName)) {
				if (mappingType != MAPPINGTYPE_SELFFORM && mappingType != MAPPINGTYPE_EXPRESSION)
					label += ".";
				label += fieldName;
			}
			if (!SmartUtil.isEmpty(valueFunctionName) && valueFunction != VALUEFUNCTION_VALUE)
				label += "." + valueFunctionName;
			
			if (SmartUtil.isEmpty(label))
				label = ResourceManager.getInstance().getString("FormEditorETC", "emptyDataText");
			return label;
		}
	}
}