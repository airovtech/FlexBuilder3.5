package com.maninsoft.smart.formeditor.view.dialog.util
{
	import com.maninsoft.smart.common.controls.SimpleComboBox;
	import com.maninsoft.smart.formeditor.model.Cond;
	import com.maninsoft.smart.formeditor.assets.FormEditorAssets;

	public class OperandTypeComboBox extends SimpleComboBox
	{
		private static var instance:OperandTypeComboBox = null;
		public static function getInstance():OperandTypeComboBox {
			if (instance == null)
				instance = new OperandTypeComboBox();
			return instance;
		}
		public function OperandTypeComboBox()
		{
			super();
			dataProvider = [
				{label: "", value: null}, 
				{icon: FormEditorAssets.formIcon, label: resourceManager.getString("FormEditorETC", "selfFormText"), value: Cond.OPERANDTYPE_SELF}, 
				{icon: FormEditorAssets.expressionIcon, label: resourceManager.getString("FormEditorETC", "expressionText"), value: Cond.OPERANDTYPE_EXPRESSION}
			];
		}
	}
}