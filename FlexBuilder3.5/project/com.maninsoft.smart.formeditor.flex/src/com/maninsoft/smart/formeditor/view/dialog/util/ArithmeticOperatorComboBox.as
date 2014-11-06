package com.maninsoft.smart.formeditor.view.dialog.util
{
	import com.maninsoft.smart.common.controls.SimpleComboBox;
	import com.maninsoft.smart.formeditor.model.ExpressionNode;

	public class ArithmeticOperatorComboBox extends SimpleComboBox
	{
		private static const operators:Array = [
				{label: "", value: null}, 
				{label: ExpressionNode.toOperatorName(ExpressionNode.OPERATOR_PLUS), value: ExpressionNode.OPERATOR_PLUS}, 
				{label: ExpressionNode.toOperatorName(ExpressionNode.OPERATOR_MINUS), value: ExpressionNode.OPERATOR_MINUS}, 
				{label: ExpressionNode.toOperatorName(ExpressionNode.OPERATOR_MULTI), value: ExpressionNode.OPERATOR_MULTI}, 
				{label: ExpressionNode.toOperatorName(ExpressionNode.OPERATOR_DIV), value: ExpressionNode.OPERATOR_DIV}
			];
		public function ArithmeticOperatorComboBox()
		{
			super();
			dataProvider = operators;
		}
	}
}