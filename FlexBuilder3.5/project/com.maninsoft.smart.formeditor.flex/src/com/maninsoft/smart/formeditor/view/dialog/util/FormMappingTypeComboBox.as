package com.maninsoft.smart.formeditor.view.dialog.util
{
	import com.maninsoft.smart.common.controls.SimpleComboBox;
	import com.maninsoft.smart.formeditor.model.ExpressionNode;
	import com.maninsoft.smart.formeditor.assets.FormEditorAssets;

	public class FormMappingTypeComboBox extends SimpleComboBox
	{
		private static const mappingTypes:Array = [
					{label: "", value: null}, 
					{icon: FormEditorAssets.processIcon, label: ExpressionNode.toMappingTypeName(ExpressionNode.MAPPINGTYPE_PROCESSFORM), value: ExpressionNode.MAPPINGTYPE_PROCESSFORM}, 
					{icon: FormEditorAssets.expressionIcon, label: ExpressionNode.toMappingTypeName(ExpressionNode.MAPPINGTYPE_EXPRESSION), value: ExpressionNode.MAPPINGTYPE_EXPRESSION}, 
					{icon: FormEditorAssets.systemIcon, label: ExpressionNode.toMappingTypeName(ExpressionNode.MAPPINGTYPE_SYSTEM), value: ExpressionNode.MAPPINGTYPE_SYSTEM}, 
					{icon: FormEditorAssets.bracketIcon, label: ExpressionNode.toMappingTypeName(ExpressionNode.MAPPINGTYPE_BRACKET), value: ExpressionNode.MAPPINGTYPE_BRACKET}
				];
		public function FormMappingTypeComboBox()
		{
			super();
			dataProvider = mappingTypes;
		}
	}
}