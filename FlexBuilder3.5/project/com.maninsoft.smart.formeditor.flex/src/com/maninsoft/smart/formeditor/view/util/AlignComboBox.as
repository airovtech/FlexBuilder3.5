package com.maninsoft.smart.formeditor.view.util
{
	import com.maninsoft.smart.common.controls.SimpleComboBox;
	
	public class AlignComboBox extends SimpleComboBox
	{
		public function AlignComboBox()
		{
			super();
			this.dataProvider = [
				{label: resourceManager.getString("FormEditorETC", "Left"), value: "left"}, 
				{label: resourceManager.getString("FormEditorETC", "Center"), value: "center"}, 
				{label: resourceManager.getString("FormEditorETC", "Right"), value: "right"}
			]
		}
	}
}