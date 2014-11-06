package com.maninsoft.smart.common.assets
{
	import com.maninsoft.smart.common.assets.locale.Icons;
	
	import mx.controls.Image;
	

	public class DialogAssets
	{

		[Embed(source="assets/button/dialog/btn_x.png")]
		public static const closeButtonUp:Class;
				
		[Embed(source="assets/button/dialog/btn_x_w.png")]
		public static const closeButtonOver:Class;

		[Embed(source="assets/image/logo_w.png")]
		public static const titleImage:Class;

		[Embed(source="assets/button/dialog/browse.gif")]
		public static const browseIcon:Class;

		[Embed(source="assets/button/btn_x.png")]
		public static const closeXButton:Class;

		[Embed(source="assets/button/btn_x.png")]
		public static const deleteItemButton:Class;

		public static const okButton:Class = Icons.okButton;		
		public static const closeButton:Class = Icons.closeButton;
		public static const addButton:Class = Icons.addButton;
		public static const removeButton:Class = Icons.removeButton;
		public static const deleteButton:Class = Icons.deleteButton;
		public static const cancelButton:Class = Icons.cancelButton;
		public static const saveButton:Class = Icons.saveButton;
		public static const searchButton:Class = Icons.searchButton;
		public static const fixUpButton:Class = Icons.fixUpButton;

		public static const workFormListIcon: Class = Icons.formListIcon;		
	}
}