package com.maninsoft.smart.formeditor.view.format
{
	import com.maninsoft.smart.formeditor.model.type.FormatType;
	import com.maninsoft.smart.formeditor.model.type.FormatTypes;
	
	import mx.controls.Button;
	
	public class FileListView extends TextInputView
	{
		private var button:Button;
		public function FileListView()
		{
			super();
			
			button = new Button();
			button.styleName = "browseButton";
			addChild(button);
		}
		
		override public function get formatType():FormatType {
			return FormatTypes.fileField;
		}
	}
}