package com.maninsoft.smart.formeditor.model.condition
{
	import com.maninsoft.smart.formeditor.model.mapping.FormMapping;
	
	public class FormCondition
	{
		public var mapping:FormMapping;
		
		public var connectOperator:String;
		
		public var firstOperand:String;
		public var firstOperandName:String;
		public var operator:String;
		public var secondOperand:String;
		public var secondOperandName:String;
		
		/**
		 * XML로 바꾸기
		 */
		public function toXML():XML{
			var conditionXML:XML = 
				<cond connect="" operator="">
					<first id="">
					</first>
					<second id="">
					</second>
				</cond>;
			
			if(connectOperator != null)
				conditionXML.@connect = connectOperator;
			conditionXML.@operator = operator;
			conditionXML.first[0].@id = firstOperand;
			conditionXML.first[0] = firstOperandName;
			conditionXML.second[0].@id = secondOperand;
			conditionXML.second[0] = secondOperandName;
			
			return conditionXML;
		}	
		/**
		 * XML을 객체로 파싱
		 */ 
		public static function parseXML(conditionXML:XML):FormCondition{
			var cond:FormCondition = new FormCondition();

			if(conditionXML.@connect.toString() != ""){
				cond.connectOperator = conditionXML.@connect.toString();
			}
			cond.operator = conditionXML.@operator;
			cond.firstOperand = conditionXML.first[0].@id;
			cond.firstOperandName = conditionXML.first[0].toString();
			cond.secondOperand = conditionXML.second[0].@id;
			cond.secondOperandName = conditionXML.second[0].toString();
			
			return cond;
		}	
		
		public function getLabel():String{
			return firstOperand + firstOperandName + operator + secondOperand + secondOperandName;
		}
	}
}