/**
 * 
 *  Package: 		com.maninsoft.smart.formeditor.view.format
 *  Class: 			ImageBoxView
 * 					extends AbstractFormatView 
 * 					implements None
 *  Author:			Y.S. Jung
 *  Description:	Form Editor에서 이미지  항목 형식을 표현하기 위한 view 클래스
 * 				
 *  History:		2010.2.26 Created by Y.S. Jung for SWV20003: 폼에디터에 이미지를 보여주는 항목 추가
 * 
 *  Copyright (C) 2007-2010 Maninsoft, Inc. All Rights Reserved.
 *  
 */

package com.maninsoft.smart.formeditor.view.format
{
	import com.maninsoft.smart.formeditor.model.type.FormatType;
	import com.maninsoft.smart.formeditor.model.type.FormatTypes;
	import com.maninsoft.smart.formeditor.view.AbstractFormatView;
	
	import mx.containers.Box;
	import mx.controls.Label;
	

	public class ImageBoxView extends AbstractFormatView
	{
		private var imageBox: Box;
		public function ImageBoxView()
		{
			super();
			
			imageBox = new Box();
			imageBox.percentWidth = 100;
			imageBox.percentHeight = 100;
			imageBox.setStyle("horizontalAlign", "center");
			imageBox.setStyle("verticalAlign", "middle");
			addChild(imageBox);
			
			var label:Label = new Label();
			label.text = resourceManager.getString("FormEditorETC", "imageBoxText");
			label.height = 23;
			label.percentWidth = 100;
			label.setStyle("textAlign", "center");
			label.setStyle("fontSize", 11);
			label.setStyle("fontFamily", "Tahoma");
			label.setStyle("cornerRadius", 0);
			imageBox.addChild(label);
			
		}
		
		override public function get formatType():FormatType {
			return FormatTypes.imageBox;
		}
	}
}