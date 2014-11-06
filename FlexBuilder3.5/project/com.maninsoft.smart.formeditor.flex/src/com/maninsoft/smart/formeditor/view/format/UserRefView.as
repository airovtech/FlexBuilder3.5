package com.maninsoft.smart.formeditor.view.format
{
	import com.maninsoft.smart.formeditor.model.type.FormatType;
	import com.maninsoft.smart.formeditor.model.type.FormatTypes;
	import com.maninsoft.smart.formeditor.assets.FormEditorAssets;
	
	import mx.controls.Image;
	
	public class UserRefView extends TextInputView
	{
		private var button:Image;
		public function UserRefView()
		{
			super();
			
			button = new Image();
			button.source = FormEditorAssets.userRefIcon;
			addChild(this.button);
		}
		
		override public function get formatType():FormatType {
			return FormatTypes.userField;
		}
	}
}