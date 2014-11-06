package com.maninsoft.smart.formeditor.view.format
{
	import com.maninsoft.smart.formeditor.model.type.FormatType;
	import com.maninsoft.smart.formeditor.model.type.FormatTypes;
	import com.maninsoft.smart.formeditor.view.AbstractFormatView;
	
	import mx.controls.TextArea;

	public class RichTextEditorView extends AbstractFormatView
	{
		private var textarea:TextArea;
		public function RichTextEditorView()
		{
			super();
			
			textarea = new TextArea();
			textarea.percentWidth = 100;
			textarea.percentHeight = 100;
			textarea.minHeight = 22;
			addChild(textarea);
		}
		
		override public function get formatType():FormatType {
			return FormatTypes.richEditor;
		}
	}
}