package com.maninsoft.smart.formeditor.model
{
	import com.maninsoft.smart.common.util.SmartUtil;
	import com.maninsoft.smart.formeditor.assets.FormEditorAssets;
	
	import mx.resources.ResourceManager;
	
	public class ActualParameter extends AbstractActualParameter
	{
		public static const EDITMODE_EDIT:String = "EDIT";
		public static const EDITMODE_VIEW:String = "VIEW"; 
		public static const FORMALPARAMETERMODE_IN:String = "IN";
		public static const FORMALPARAMETERMODE_OUT:String = "OUT";
		public static const TARGETTYPE_SELF:String = "self";
		public static const TARGETTYPE_OTHER:String = "other";
		public static const TARGETTYPE_EXPRESSION:String = "expression";
		public static const TARGETTYPE_PROCESSFORM:String = "processForm";
		
		public static const TARGETVALUETYPE_VALUE:String = "value";

		public function ActualParameter()
		{
			super();
		}
		
		public var editMode:String;
		
		public var formalParameterId:String;
		public var formalParameterName:String;
		public var formalParameterType:String;
		public var formalParameterMode:String;

		public var targetType:String = TARGETTYPE_SELF;
		public var targetTypeName:String;
		
		public var targetFieldId:String;
		public var targetFieldName:String;
		public var targetValueType:String = TARGETVALUETYPE_VALUE;
		public var targetValueTypeName:String;
		
		public var expression:String;
		public var expressionName:String;

		public static const TARGET_TYPES:Array = [
									{icon: FormEditorAssets.formIcon, label: ResourceManager.getInstance().getString("FormEditorETC", "selfFormText"), value: TARGETTYPE_SELF}, 
									{icon: FormEditorAssets.expressionIcon, label: ResourceManager.getInstance().getString("FormEditorETC", "expressionText"), value: TARGETTYPE_EXPRESSION}];
		
		public static const TARGET_PROCESS_TYPES:Array = [
									{icon: FormEditorAssets.processIcon, label: ResourceManager.getInstance().getString("FormEditorETC", "processFormText"), value: TARGETTYPE_PROCESSFORM}, 
									{icon: FormEditorAssets.expressionIcon, label: ResourceManager.getInstance().getString("FormEditorETC", "expressionText"), value: TARGETTYPE_EXPRESSION}];
		
		public static const TARGETVALUE_TYPES:Array = [
									{icon:null, label: ResourceManager.getInstance().getString("FormEditorETC", "valueText"), value: TARGETVALUETYPE_VALUE}];

		public function toString():String {
			var text:String = formalParameterName + " = ";
			if(targetType == ActualParameter.TARGETTYPE_EXPRESSION) text += expression;
			else text += targetTypeName + "." +  targetFieldName + "." + targetValueTypeName;
			return text;
		}

		public static function getTargetTypeNameByValue(targetType:String):String{
			if(targetType){
				for each(var type:Object in TARGET_TYPES){
					if(targetType == type["value"]){
						return type["label"];
					}
				}
				for each(type in TARGET_PROCESS_TYPES){
					if(targetType == type["value"]){
						return type["label"];
					}
				}
			}
			return null;
		}
		
		public static function getTargetValueTypeNameByValue(targetValueType:String):String{
			if(targetValueType){
				for each(var type:Object in TARGETVALUE_TYPES){
					if(targetValueType == type["value"]){
						return type["label"];
					}
				}
			}
			return null;
		}

		/**
		 * XML로 바꾸기
		 */
		override public function toXML(dst:XML=null):XML{
			var paramXML:XML = <ActualParmeter/>;
			if(dst) paramXML = dst;				
			
			if (!SmartUtil.isEmpty(formalParameterId))
				paramXML.@Id = formalParameterId;
			if (!SmartUtil.isEmpty(formalParameterName))
				paramXML.@Name = formalParameterName;
			if (!SmartUtil.isEmpty(formalParameterType))
				paramXML.@DataType = formalParameterType;
			if (!SmartUtil.isEmpty(formalParameterMode))
				paramXML.@Mode = formalParameterMode;
			if (!SmartUtil.isEmpty(targetType))
				paramXML.@TargetType = targetType;
			if (!SmartUtil.isEmpty(editMode))
				paramXML.@EditMode = editMode;
			if (!SmartUtil.isEmpty(targetFieldId))
				paramXML.@FieldId = targetFieldId;
			if (!SmartUtil.isEmpty(targetFieldName))
				paramXML.@FieldName = targetFieldName;
			if (!SmartUtil.isEmpty(targetValueType))
				paramXML.@ValueType = targetValueType;
			if (!SmartUtil.isEmpty(expression))
				paramXML.@Expression = expression;
			return paramXML;
		}	
		/**
		 * XML을 객체로 파싱
		 */ 
		public static function parseXML(paramXML:XML):ActualParameter{
			var param:ActualParameter = new ActualParameter();
			
			param.formalParameterId 	= paramXML.@Id;
			param.formalParameterName 	= paramXML.@Name;
			param.formalParameterType 	= paramXML.@DataType;
			param.formalParameterMode 	= paramXML.@Mode;
			param.editMode 				= paramXML.@EditMode;
			param.targetType 			= paramXML.@TargetType;
			param.targetFieldId 		= paramXML.@FieldId;
			param.targetFieldName 		= paramXML.@FieldName;
			param.targetValueType 		= paramXML.@ValueType;
			param.expression 			= paramXML.@Expression;
			param.targetTypeName 		= ActualParameter.getTargetTypeNameByValue(param.targetType);
			param.targetValueTypeName 	= ActualParameter.getTargetValueTypeNameByValue(param.targetValueType);						
			return param;
		}	
		
		override public function clone():AbstractActualParameter{
			var param:ActualParameter = new ActualParameter();
			
			param.formalParameterId 	= formalParameterId;
			param.formalParameterName 	= formalParameterName;
			param.formalParameterType 	= formalParameterType;
			param.formalParameterMode 	= formalParameterMode;
			param.editMode 				= editMode;
			param.targetType 			= targetType;
			param.targetTypeName		= targetTypeName;
			param.targetFieldId 		= targetFieldId;
			param.targetFieldName 		= targetFieldName;
			param.targetValueType 		= targetValueType;
			param.targetValueTypeName	= targetValueTypeName;
			param.expression 			= expression;			
			return param;
		}
	}
}