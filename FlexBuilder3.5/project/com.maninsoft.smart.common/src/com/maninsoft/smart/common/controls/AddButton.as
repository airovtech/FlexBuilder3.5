package com.maninsoft.smart.common.controls
{
	import com.maninsoft.smart.common.assets.DialogAssets;
	
	import mx.controls.Image;

	public class AddButton extends Image
	{
		public function AddButton()
		{
			super();
			source = DialogAssets.addButton;
			buttonMode = true;
		}
	}
}