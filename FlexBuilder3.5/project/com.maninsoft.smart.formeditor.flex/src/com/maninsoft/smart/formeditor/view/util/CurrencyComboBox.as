package com.maninsoft.smart.formeditor.view.util
{
	import com.maninsoft.smart.common.controls.SimpleComboBox;
	
	public class CurrencyComboBox extends SimpleComboBox
	{
		public function CurrencyComboBox()
		{
			super();
			this.dataProvider = ["￦", "$", "¥"]
		}
	}
}