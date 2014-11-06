package com.maninsoft.smart.formeditor.view.dialog.util
{
	import com.maninsoft.smart.common.controls.SimpleComboBox;
	import com.maninsoft.smart.formeditor.model.Cond;
	
	public class CondOperatorComboBox extends SimpleComboBox
	{
		private static var instance:CondOperatorComboBox = null;
		public static function getInstance():CondOperatorComboBox {
			if (instance == null)
				instance = new CondOperatorComboBox();
			return instance;
		}
		public function CondOperatorComboBox()
		{
			super();
			dataProvider = Cond.OPERATORS;
		}
	}
}