package com.maninsoft.smart.formeditor.view.dialog.util
{
	import com.maninsoft.smart.common.controls.SimpleComboBox;
	import com.maninsoft.smart.formeditor.model.ExpressionNode;
	import com.maninsoft.smart.formeditor.assets.FormEditorAssets;

	public class MappingTypeComboBox extends SimpleComboBox
	{
		private static const mappingTypes:Array = [
					{label: "", value: null}, 
					{icon: FormEditorAssets.formIcon, label: ExpressionNode.toMappingTypeName(ExpressionNode.MAPPINGTYPE_SELFFORM), value: ExpressionNode.MAPPINGTYPE_SELFFORM}, 
					{icon: FormEditorAssets.formLinkIcon, label: ExpressionNode.toMappingTypeName(ExpressionNode.MAPPINGTYPE_OTHERFORM), value: ExpressionNode.MAPPINGTYPE_OTHERFORM}, 
					{icon: FormEditorAssets.processIcon, label: ExpressionNode.toMappingTypeName(ExpressionNode.MAPPINGTYPE_PROCESSFORM), value: ExpressionNode.MAPPINGTYPE_PROCESSFORM}, 
					{icon: FormEditorAssets.serviceLinkIcon, label: ExpressionNode.toMappingTypeName(ExpressionNode.MAPPINGTYPE_SYSTEMSERVICE), value: ExpressionNode.MAPPINGTYPE_SYSTEMSERVICE}, 
					{icon: FormEditorAssets.expressionIcon, label: ExpressionNode.toMappingTypeName(ExpressionNode.MAPPINGTYPE_EXPRESSION), value: ExpressionNode.MAPPINGTYPE_EXPRESSION}, 
					{icon: FormEditorAssets.systemIcon, label: ExpressionNode.toMappingTypeName(ExpressionNode.MAPPINGTYPE_SYSTEM), value: ExpressionNode.MAPPINGTYPE_SYSTEM}, 
					{icon: FormEditorAssets.bracketIcon, label: ExpressionNode.toMappingTypeName(ExpressionNode.MAPPINGTYPE_BRACKET), value: ExpressionNode.MAPPINGTYPE_BRACKET}
				];
		public function MappingTypeComboBox()
		{
			super();
			dataProvider = mappingTypes;
		}
	}
}