package com.maninsoft.smart.formeditor.view.format
{
	import com.maninsoft.smart.formeditor.model.type.FormatType;
	import com.maninsoft.smart.formeditor.model.type.FormatTypes;
	
	public class NumberInputView extends TextInputView
	{
		public function NumberInputView()
		{
			super();
		}
		
		override public function get formatType():FormatType {
			return FormatTypes.numberInput;
		}
	}
}