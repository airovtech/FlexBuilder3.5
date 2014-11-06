package com.maninsoft.smart.formeditor.view.dialog.util
{
	import com.maninsoft.smart.common.controls.SimpleComboBox;
	import com.maninsoft.smart.formeditor.model.ExpressionNode;
	import com.maninsoft.smart.formeditor.assets.FormEditorAssets;

	public class OutMappingTypeComboBox extends SimpleComboBox
	{
		private static const mappingTypes:Array = [
					{label: "", value: null}, 
					{icon: FormEditorAssets.formLinkIcon, label: ExpressionNode.toMappingTypeName(ExpressionNode.MAPPINGTYPE_OTHERFORM), value: ExpressionNode.MAPPINGTYPE_OTHERFORM}, 
					{icon: FormEditorAssets.processIcon, label: ExpressionNode.toMappingTypeName(ExpressionNode.MAPPINGTYPE_PROCESSFORM), value: ExpressionNode.MAPPINGTYPE_PROCESSFORM}, 
					{icon: FormEditorAssets.serviceLinkIcon, label: ExpressionNode.toMappingTypeName(ExpressionNode.MAPPINGTYPE_SYSTEMSERVICE), value: ExpressionNode.MAPPINGTYPE_SYSTEMSERVICE} 
				];
		public function OutMappingTypeComboBox()
		{
			super();
			dataProvider = mappingTypes;
		}
	}
}