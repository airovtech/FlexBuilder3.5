package com.maninsoft.smart.formeditor.view.format
{
	import com.maninsoft.smart.formeditor.model.type.FormatType;
	import com.maninsoft.smart.formeditor.model.type.FormatTypes;
	
	import mx.controls.Label;
	
	public class CurrencyInputView extends NumberInputView
	{
		private var currencyLabel: Label;
		public function CurrencyInputView()
		{
			super();
			
			currencyLabel = new Label();
			currencyLabel.setStyle("fontFamily", "Tahoma");
			addChildAt(currencyLabel, 0);
		}
		
		override public function refreshVisual():void {
			currencyLabel.text = this.fieldModel.format.currencyCode;
		}
		
		override public function get formatType():FormatType {
			return FormatTypes.currencyInput;
		}
	}
}