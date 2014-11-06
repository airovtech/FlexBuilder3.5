package com.maninsoft.smart.formeditor.model
{
	import com.maninsoft.smart.common.util.SmartUtil;
	
	import mx.resources.ResourceManager;
	
	public class AutoIndexRule
	{
		
		public static const RULE_ID_CODE:String 		= "ruleId.code";
		public static const RULE_ID_DATE:String 		= "ruleId.date";
		public static const RULE_ID_SEQUENCE:String 	= "ruleId.sequence";
		public static const RULE_ID_LIST:String 		= "ruleId.list";

		public static const INCREMENT_BY_ITEM:String 	= "incrementBy.item";
		public static const INCREMENT_BY_DAY:String 	= "incrementBy.day";
		public static const INCREMENT_BY_MONTH:String = "incrementBy.month";
		public static const INCREMENT_BY_YEAR:String 	= "incrementBy.year";
		
		public static const DATE_FORMAT_YYYYMMDD:String = "YYYYMMDD";
		public static const DATE_FORMAT_YYYYMM:String 	= "YYYYMM";
		public static const DATE_FORMAT_YYYY:String 	= "YYYY";
		public static const DATE_FORMAT_MMDD:String 	= "MMDD";
		public static const DATE_FORMAT_MM:String 		= "MM";
		public static const DATE_FORMAT_DD:String 		= "DD";
		
		public static const POSTFIX_CHARACTERS:Array = [
			new ArrayObject("", ResourceManager.getInstance().getString("FormEditorETC", "postfixNone")),
			new ArrayObject("_", "_"),
			new ArrayObject("-", "-"),
			new ArrayObject("+", "+"),
			new ArrayObject("%", "%"),
			new ArrayObject("&", "&"),
			new ArrayObject("$", "$"),
			new ArrayObject("#", "#"),
			new ArrayObject("@", "@"),
			new ArrayObject(".", ".")
		]; 
		
		public static const incrementBys:Array = [
			new ArrayObject(INCREMENT_BY_ITEM, ResourceManager.getInstance().getString("FormEditorETC", INCREMENT_BY_ITEM + "Text")),
			new ArrayObject(INCREMENT_BY_DAY, ResourceManager.getInstance().getString("FormEditorETC", INCREMENT_BY_DAY + "Text")),
			new ArrayObject(INCREMENT_BY_MONTH, ResourceManager.getInstance().getString("FormEditorETC", INCREMENT_BY_MONTH + "Text")),
			new ArrayObject(INCREMENT_BY_YEAR, ResourceManager.getInstance().getString("FormEditorETC", INCREMENT_BY_YEAR + "Text"))
		];
		
		public static const dateFormats:Array = [
			DATE_FORMAT_YYYYMMDD, DATE_FORMAT_YYYYMM, DATE_FORMAT_YYYY, DATE_FORMAT_MMDD, DATE_FORMAT_MM, DATE_FORMAT_DD
		];

		public var ruleId:String;
		public var codeValue:String;
		public var dateFormat:String;
		public var increment:int;
		public var incrementBy:String;
		public var digits:int;
		public var list:Array;
		public var seperator:String;

		public function AutoIndexRule(ruleId:String)
		{
			this.ruleId = ruleId;
		}
				
		public function get name():String{
			if(this.ruleId)
				return ResourceManager.getInstance().getString("FormEditorETC", this.ruleId + "Text");
			return "";
		}
		
		public function get label():String{
			return this.name;
		}

		public function toXML():XML {
			var xml:XML = <autoIndexRule/>;
			if(this.ruleId == RULE_ID_CODE){
				xml.@ruleId = RULE_ID_CODE;
				if(!SmartUtil.isEmpty(this.codeValue))
					xml.@codeValue = this.codeValue;
			}else if(this.ruleId == RULE_ID_DATE){
				xml.@ruleId = RULE_ID_DATE;
				if(!SmartUtil.isEmpty(this.dateFormat))
					xml.@dateFormat = this.dateFormat;
			}else if(this.ruleId == RULE_ID_SEQUENCE){
				xml.@ruleId = RULE_ID_SEQUENCE;
				xml.@increment = this.increment.toString();
				if(!SmartUtil.isEmpty(this.incrementBy))
					xml.@incrementBy = this.incrementBy;
				xml.@digits = this.digits.toString();					
			}else if(this.ruleId == RULE_ID_LIST){
				xml.@ruleId = RULE_ID_LIST;
				if(!SmartUtil.isEmpty(this.list)){
					var listItemsXML:XML = <listItems/>;
					for(var i:int=0; i<this.list.length; i++){
						listItemsXML[0].appendChild(new XML("<listItem>" + this.list[i].toString() + "</listItem>"));
					}
					xml.appendChild(listItemsXML);
				}
			}
			xml.@seperator = this.seperator;					
			return xml;
		}
		public static function parseXML(xml:XML):AutoIndexRule{
			var rule:AutoIndexRule = new AutoIndexRule(xml.@ruleId);
			if(rule.ruleId == AutoIndexRule.RULE_ID_CODE){
				rule.codeValue = xml.@codeValue;
			}else if(rule.ruleId == AutoIndexRule.RULE_ID_DATE){
				rule.dateFormat = xml.@dateFormat;
			}else if(rule.ruleId == AutoIndexRule.RULE_ID_SEQUENCE){
				rule.increment = int(xml.@increment);
				rule.incrementBy = xml.@incrementBy;
				rule.digits = int(xml.@digits);
			}else if(rule.ruleId == AutoIndexRule.RULE_ID_LIST){
				var listItemsXML:XML = SmartUtil.toXml(xml.listItems[0]);
				if (listItemsXML != null) {
					rule.list = new Array();
					for each(var itemXML:XML in listItemsXML.listItem){
						rule.list.push(itemXML.toString());
					}
				}			
			}
			rule.seperator = xml.@seperator;
			return rule;
		}
	}
}