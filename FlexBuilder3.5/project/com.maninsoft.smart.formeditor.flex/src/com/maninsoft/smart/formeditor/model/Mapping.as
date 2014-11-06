package com.maninsoft.smart.formeditor.model
{
	import com.maninsoft.smart.common.util.SmartUtil;
	
	import mx.collections.ArrayCollection;
	
	public class Mapping
	{
		public static const TYPE_SIMPLE:String = "mapping_form";
		public static const TYPE_EXPRESSION:String = "expression";
		public static const TYPE_TABLE_RECORDS:String = "table_records";
		
		public static const MAPPINGTYPE_SELFFORM:String = "self_form";
		public static const MAPPINGTYPE_OTHERFORM:String = "info_form";
		public static const MAPPINGTYPE_PROCESSFORM:String = "process_form";
		public static const MAPPINGTYPE_SYSTEM:String = "system_form";
		public static const MAPPINGTYPE_SYSTEMSERVICE:String = "service_form";
		
		public var parent:Mappings;
		
		public var name:String;
		public var type:String = TYPE_EXPRESSION;
		public var eachTime:Boolean = false;
		
		public var expression:String;
		
		public var mappingType:String;
		public var formLinkId:String;
		public var formLinkName:String;
		public var serviceLinkId:String;
		public var serviceLinkName:String;
		public var activityId:String;
		public var fieldId:String;	
		public var fieldName:String;
		public var valueFunction:String;
		
		public var expressionTree:XML;
		
		public var fieldMappings:ArrayCollection;
		
		public var propertyId:String;
		
		public function Mapping(parent:Mappings) {
			this.parent = parent;
		}
		
		public function clone():Mapping {
			return parseXML(parent, toXML());
		}
		public function toXML(xml:XML=null):XML {
			if(xml==null)
				xml = <mapping/>;
				
			if (!SmartUtil.isEmpty(name))
				xml.@name = name;
			if (!SmartUtil.isEmpty(type))
				xml.@type = type;
			xml.@eachTime = eachTime;
			if (!SmartUtil.isEmpty(mappingType))
				xml.@mappingFormType = mappingType;
			if (!SmartUtil.isEmpty(formLinkId))
				xml.@mappingFormId = formLinkId;
			if (!SmartUtil.isEmpty(formLinkName))
				xml.@formName = formLinkName;
			if (!SmartUtil.isEmpty(serviceLinkId))
				xml.@mappingServiceId = serviceLinkId;
			if (!SmartUtil.isEmpty(serviceLinkName))
				xml.@serviceName = serviceLinkName;
			if (!SmartUtil.isEmpty(activityId))
				xml.@activityId = activityId;
			if (!SmartUtil.isEmpty(fieldId))
				xml.@fieldId = fieldId;
			if (!SmartUtil.isEmpty(fieldName))
				xml.@fieldName = fieldName;
			if (!SmartUtil.isEmpty(valueFunction))
				xml.@valueFunc = valueFunction;
			if (expression != null)
				xml.appendChild(expression);
			if (expressionTree != null)
				xml.appendChild(expressionTree);
			if (!SmartUtil.isEmpty(fieldMappings)) {
				var fieldMappingsXML:XML = <fieldMappings/>;
				for each (var fieldMapping:FieldMapping in fieldMappings)
					fieldMappingsXML.appendChild(fieldMapping.toXML());
				xml.appendChild(fieldMappingsXML);
			}
			if (!SmartUtil.isEmpty(propertyId))
				xml.@propertyId = propertyId;
				
			return xml;
		}
		public static function parseXML(parent:Mappings, xml:XML):Mapping {
			var mapping:Mapping = new Mapping(parent);
			mapping.name = xml.@name;
			mapping.type = xml.@type;
			mapping.eachTime = SmartUtil.toBoolean(xml.@eachTime);
			mapping.mappingType = xml.@mappingFormType;
			mapping.formLinkId = xml.@mappingFormId;
			mapping.formLinkName = xml.@formName;
			mapping.serviceLinkId = xml.@mappingServiceId;
			mapping.serviceLinkName = xml.@serviceName;
			mapping.activityId = xml.@activityId;
			mapping.fieldId = xml.@fieldId;
			mapping.fieldName = xml.@fieldName;
			mapping.valueFunction = xml.@valueFunc;
			mapping.expression = xml.text().toString();
			mapping.expressionTree = xml.expressionTree[0];
			var fieldMappingsXML:XML = SmartUtil.toXml(xml.fieldMappings[0]);
			if (fieldMappingsXML != null) {
				var fieldMappingList:XMLList = fieldMappingsXML.elements("fieldMapping");
				if (!SmartUtil.isEmpty(fieldMappingList)) {
					mapping.fieldMappings = new ArrayCollection();
					for each (var fieldMappingXML:XML in fieldMappingList)
						mapping.fieldMappings.addItem(FieldMapping.parseXML(fieldMappingXML));
				}
			}
			mapping.propertyId = xml.@propertyId;
			return mapping;
		}
	}
}