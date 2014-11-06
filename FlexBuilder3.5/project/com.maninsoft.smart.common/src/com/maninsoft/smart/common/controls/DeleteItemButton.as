package com.maninsoft.smart.common.controls
{
	import com.maninsoft.smart.common.assets.DialogAssets;

	import mx.controls.Image;

	public class DeleteItemButton extends Image
	{
		public function DeleteItemButton()
		{
			super();

			source = DialogAssets.deleteItemButton;
			buttonMode = true;
		}
	}
}