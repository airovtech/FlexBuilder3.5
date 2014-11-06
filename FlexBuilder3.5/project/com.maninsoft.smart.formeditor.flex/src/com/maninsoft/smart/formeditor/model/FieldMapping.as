package com.maninsoft.smart.formeditor.model
{
	import com.maninsoft.smart.common.util.SmartUtil;
	
	import mx.collections.ArrayCollection;
	import mx.resources.ResourceManager;
	
	public class FieldMapping
	{
		public var leftOperand:String;
		public var leftOperandName:String;
		public var rightOperand:String;
		public var rightOperandName:String;
		
		public function toXML():XML {
			var xml:XML = <fieldMapping/>;
			if (!SmartUtil.isEmpty(leftOperand))
				xml.@leftOperand = leftOperand;
			if (!SmartUtil.isEmpty(leftOperandName))
				xml.@leftOperandName = leftOperandName;
			if (!SmartUtil.isEmpty(rightOperand))
				xml.@rightOperand = rightOperand;
			if (!SmartUtil.isEmpty(rightOperandName))
				xml.@rightOperandName = rightOperandName;
			return xml;
		}
		public static function parseXML(xml:XML):FieldMapping {
			var obj:FieldMapping = new FieldMapping;
			
			obj.leftOperand = xml.@leftOperand;
			obj.leftOperandName = xml.@leftOperandName;
			obj.rightOperand = xml.@rightOperand;
			obj.rightOperandName = xml.@rightOperandName;
			
			return obj;
		}
		public static function toLabel(formLinkName:String, fieldMappings:ArrayCollection):String {
			if(SmartUtil.isEmpty(formLinkName)) formLinkName = ResourceManager.getInstance().getString("FormEditorETC", "emptyDataText");
			var label:String = "";
			if(!SmartUtil.isEmpty(fieldMappings)){
				var isNotEmpty:Boolean = false;
				for(var i:int=0; i<fieldMappings.length; i++){
					var fieldMapping:FieldMapping = fieldMappings[i] as FieldMapping;
					if(!SmartUtil.isEmpty(fieldMapping.rightOperandName)) isNotEmpty = true;
					label = label + formLinkName + "." + (SmartUtil.isEmpty(fieldMapping.rightOperandName) ? ResourceManager.getInstance().getString("FormEditorETC", "emptyDataText") : fieldMapping.rightOperandName) + ((i<fieldMappings.length-1) ? ", " : "");
				}
			}
			if (SmartUtil.isEmpty(label) || !isNotEmpty)
				label = ResourceManager.getInstance().getString("FormEditorETC", "emptyDataText");
			return label;
		}

	}
}