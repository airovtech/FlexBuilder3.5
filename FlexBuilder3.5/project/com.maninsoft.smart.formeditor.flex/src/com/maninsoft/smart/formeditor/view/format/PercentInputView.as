package com.maninsoft.smart.formeditor.view.format
{
	import com.maninsoft.smart.formeditor.model.type.FormatType;
	import com.maninsoft.smart.formeditor.model.type.FormatTypes;
	
	import mx.controls.Label;
	
	public class PercentInputView extends NumberInputView
	{
		private static var percentLabel: Label;
		public function PercentInputView()
		{
			super();
			
			if (percentLabel == null) {
				percentLabel = new Label();
				percentLabel.text = "%";
			}
			this.addChild(percentLabel);
		}
		
		override public function get formatType():FormatType {
			return FormatTypes.percentInput;
		}
	}
}