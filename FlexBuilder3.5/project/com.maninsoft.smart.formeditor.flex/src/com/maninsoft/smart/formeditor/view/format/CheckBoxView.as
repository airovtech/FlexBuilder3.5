package com.maninsoft.smart.formeditor.view.format
{
	import com.maninsoft.smart.formeditor.model.type.FormatType;
	import com.maninsoft.smart.formeditor.model.type.FormatTypes;
	import com.maninsoft.smart.formeditor.view.AbstractFormatView;
	
	import mx.controls.CheckBox;

	public class CheckBoxView extends AbstractFormatView
	{
		private var checkbox:CheckBox;
		public function CheckBoxView()
		{
			super();
			
			checkbox = new CheckBox();
			addChild(checkbox);
		}
		
		override public function get formatType():FormatType {
			return FormatTypes.checkBox;
		}
	}
}