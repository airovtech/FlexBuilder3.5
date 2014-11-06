package com.maninsoft.smart.formeditor.view.format
{
	import com.maninsoft.smart.formeditor.model.type.FormatType;
	import com.maninsoft.smart.formeditor.model.type.FormatTypes;
	import com.maninsoft.smart.formeditor.assets.FormEditorAssets;
	
	import mx.controls.Image;
	
	public class DateTimeChooserView extends TextInputView
	{
		private var button:Image;
		public function DateTimeChooserView()
		{
			super();
			
			this.button = new Image();
			this.button.source = FormEditorAssets.dateTimeChooserIcon;
			this.addChild(this.button);
		}
		
		override public function get formatType():FormatType {
			return FormatTypes.dateTimeChooser;
		}
	}
}