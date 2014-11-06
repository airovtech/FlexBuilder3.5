package com.maninsoft.smart.formeditor.model
{
	import com.maninsoft.smart.common.util.SmartUtil;
	import com.maninsoft.smart.formeditor.assets.FormEditorAssets;
	
	import mx.resources.ResourceManager;
	
	public class Cond extends AbstractCond
	{
		public static const OPERATOR_EQUAL:String = "=";
		public static const OPERATOR_NOTEQUAL:String = "!=";
		public static const OPERATOR_LIKE:String = "like";
		public static const OPERATOR_TO:String = "<=";
		public static const OPERATOR_FROM:String = ">=";
		public static const OPERATOR_UNDER:String = "<";
		public static const OPERATOR_OVER:String = ">";
		public static const OPERANDTYPE_SELF:String = "self";
		public static const OPERANDTYPE_OTHER:String = "other";
		public static const OPERANDTYPE_EXPRESSION:String = "expression";
		
		public function Cond()
		{
			super();
			operator = OPERATOR_EQUAL;
		}
		
		public var firstOperand:String;
		public var firstOperandType:String = OPERANDTYPE_OTHER;
		public var firstOperandName:String;
		public var firstExpr:String;

		public var secondOperand:String;
		public var secondOperandType:String = OPERANDTYPE_SELF;
		public var secondOperandTypeName:String;
		public var secondOperandName:String;
		public var secondExpr:String;

		public static const EQUAL_INDEX:int = 4;
		public static const OPERATORS:Array = [ 
									{label: ResourceManager.getInstance().getString("FormEditorETC", "notEqualOperatorText"), value: Cond.OPERATOR_NOTEQUAL}, 
									{label: ResourceManager.getInstance().getString("FormEditorETC", "likeOperatorText"), value: Cond.OPERATOR_LIKE}, 
									{label: ResourceManager.getInstance().getString("FormEditorETC", "fromOperatorText"), value: Cond.OPERATOR_FROM}, 
									{label: ResourceManager.getInstance().getString("FormEditorETC", "toOperatorText"), value: Cond.OPERATOR_TO}, 
									{label: ResourceManager.getInstance().getString("FormEditorETC", "equalOperatorText"), value: Cond.OPERATOR_EQUAL}, 
									{label: ResourceManager.getInstance().getString("FormEditorETC", "overOperatorText"), value: Cond.OPERATOR_OVER}, 
									{label: ResourceManager.getInstance().getString("FormEditorETC", "underOperatorText"), value: Cond.OPERATOR_UNDER}];

		public static const OPERAND_TYPES:Array = [
									{icon: FormEditorAssets.formIcon, label: ResourceManager.getInstance().getString("FormEditorETC", "selfFormText"), value: OPERANDTYPE_SELF}, 
									{icon: FormEditorAssets.expressionIcon, label: ResourceManager.getInstance().getString("FormEditorETC", "expressionText"), value: OPERANDTYPE_EXPRESSION}];
		
		public function toString():String {
			return firstOperandName + " " + operator + " " + secondOperandName;
		}
		
		/**
		 * XML로 바꾸기
		 */
		override public function toXML():XML{
			var condXML:XML = 
				<cond>
					<first/>
					<second/>
				</cond>;
			
			condXML.@operator = operator;
			if (!SmartUtil.isEmpty(firstOperand))
				condXML.first[0].@fieldId = firstOperand;
			if (!SmartUtil.isEmpty(firstOperandName))
				condXML.first[0].@fieldName = firstOperandName;
			if (!SmartUtil.isEmpty(firstOperandType))
				condXML.first[0].@type = firstOperandType;
			if (!SmartUtil.isEmpty(firstExpr))
				condXML.first[0] = firstExpr;
			if (!SmartUtil.isEmpty(secondOperand))
				condXML.second[0].@fieldId = secondOperand;
			if (!SmartUtil.isEmpty(secondOperandName))
				condXML.second[0].@fieldName = secondOperandName;
			if (!SmartUtil.isEmpty(secondOperandType))
				condXML.second[0].@type = secondOperandType;
			if (!SmartUtil.isEmpty(secondExpr))
				condXML.second[0] = secondExpr;
			
			return condXML;
		}	
		/**
		 * XML을 객체로 파싱
		 */ 
		public static function parseXML(condXML:XML):AbstractCond{
			var cond:Cond = new Cond();
			
			cond.operator = condXML.@operator;
			cond.firstOperand = condXML.first[0].@fieldId;
			cond.firstOperandType = condXML.first[0].@type;
			cond.firstOperandName = condXML.first[0].@fieldName;
			cond.firstExpr = condXML.first[0].toString();
			cond.secondOperand = condXML.second[0].@fieldId;
			cond.secondOperandType = condXML.second[0].@type;
			cond.secondOperandName = condXML.second[0].@fieldName;
			cond.secondExpr = condXML.second[0].toString();
			
			return cond;
		}	
		
		override public function clone():AbstractCond{
			var cond:Cond = new Cond();
			
			cond.operator = operator;
			cond.firstOperand = firstOperand;
			cond.firstOperandType = firstOperandType;
			cond.firstOperandName = firstOperandName;
			cond.firstExpr = firstExpr;
			cond.secondOperand = secondOperand;
			cond.secondOperandType = secondOperandType;
			cond.secondOperandName = secondOperandName;
			cond.secondExpr = secondExpr;
			
			return cond;
		}
	}
}