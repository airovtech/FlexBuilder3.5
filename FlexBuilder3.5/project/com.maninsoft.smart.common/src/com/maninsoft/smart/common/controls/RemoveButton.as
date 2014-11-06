package com.maninsoft.smart.common.controls
{
	import com.maninsoft.smart.common.assets.DialogAssets;

	import mx.controls.Image;

	public class RemoveButton extends Image
	{
		public function RemoveButton()
		{
			super();

			source = DialogAssets.removeButton;
			buttonMode = true;
		}
	}
}