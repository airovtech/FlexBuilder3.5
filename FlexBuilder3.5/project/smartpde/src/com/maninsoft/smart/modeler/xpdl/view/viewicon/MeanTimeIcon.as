////////////////////////////////////////////////////////////////////////////////
//  TaskFormIcon.as
//  2008.01.30, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.view.viewicon
{
	import com.maninsoft.smart.modeler.view.IView;
	import com.maninsoft.smart.modeler.view.ViewIcon;
	
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import mx.formatters.NumberFormatter;
	
	/**
	 * TaskApplication에 taskFormdl 설정됐을 때 표시
	 */
	public class MeanTimeIcon extends ViewIcon {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		public var textField: TextField = new TextField();;
	

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function MeanTimeIcon(view: IView) {
			super(view);
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		private var _meanTimeInHours: Number=0.5;
		
		public function get meanTimeInHours(): Number {
			return _meanTimeInHours;
		}
		
		public function set meanTimeInHours(value: Number): void {
			_meanTimeInHours = value;
			this.drawText();
		}

		private var _passedTimeInHours: Number=-1;
		
		public function get passedTimeInHours(): Number {
			return _passedTimeInHours;
		}
		
		public function set passedTimeInHours(value: Number): void {
			_passedTimeInHours = value;
			this.drawText();
		}

		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------


		override public function get toolTip(): String {
			return null;
		}
		
		protected function getText():String{
			var textString:String = "";
			var formatter:NumberFormatter = new NumberFormatter();
			formatter.precision = 1;
			formatter.useThousandsSeparator = false;
			if(passedTimeInHours>=0){
				textString += formatter.format(this.passedTimeInHours) + "h/";	
			}
			if(meanTimeInHours>=0){
				textString += formatter.format(this.meanTimeInHours) + "h";
			}
			return textString;
		}

		protected function drawText(): void {

			if(contains(textField))
				removeChild(textField);
				
			textField = new TextField();
			
			var fmt: TextFormat = new TextFormat();
			fmt.font = "윤고딕340";
			fmt.color = 0x9a9a9a;
			fmt.size = 10;
			fmt.bold = false;
			fmt.italic = false;
			fmt.underline = false;
			fmt.align = "left";
						
			textField.defaultTextFormat = fmt;
			textField.text = getText();
			textField.height = 12;
			textField.x=0;
			textField.y=0;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.mouseEnabled = false;
			textField.embedFonts = true;
			addChild(textField);
		}

		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override protected function draw(g: Graphics): void {
			this.drawText();
		}

		override protected function doMouseOver(event: MouseEvent): void {
		}

		override protected function doMouseOut(event: MouseEvent): void {
		}
	}
}