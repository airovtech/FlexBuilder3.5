////////////////////////////////////////////////////////////////////////////////
//  TaskFormPanelItem.as
//  2007.01.08, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.components
{
	import com.maninsoft.smart.modeler.xpdl.server.TaskFormField;
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import mx.core.UITextField;
	
	/**
	 * SmartMapperPanel 의 항목 view
	 */
	public class TaskFormPanelItem extends Sprite {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _textField: UITextField;
		private var _textFormat: TextFormat;
		private var _formField: TaskFormField;
	

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function TaskFormPanelItem(field: TaskFormField, width: int, height: int) {
			super();		
			
			_formField = field;
			
			_textField = new UITextField();
			_textField.y = 2;
			_textField.width = width;
			_textField.height = height;
			_textField.mouseEnabled = false;
			_textField.text = field.name;

			_textFormat = new TextFormat();
			_textFormat.align = "center";

			addChild(_textField);
		}
	

		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
	
		//------------------------------
		// panel
		//------------------------------
		
		public function get panel(): TaskFormPanel {
			return parent as TaskFormPanel;
		}
	
		//------------------------------
		// formField
		//------------------------------
		
		public function get formField(): TaskFormField {
			return _formField;
		}

		//------------------------------
		// itemWidth
		//------------------------------
		
		public function get itemWidth(): int {
			return _textField.width;
		}
		
		public function set itemWidth(value: int): void {
			if (value != itemWidth) {
				_textField.width = value;
				draw();
			}
		}
	
		//------------------------------
		// itemHeight
		//------------------------------
		
		public function get itemHeight(): int {
			return _textField.height;
		}
		
		public function set itemHeight(value: int): void {
			if (value != itemHeight) {
				_textField.height = value;
				draw();
			}
		}
	
		//------------------------------
		// text
		//------------------------------
		
		public function get text(): String {
			return _textField.text;
		}
		
		public function set text(value: String): void {
			if (value != text) {
				_textField.text = value;
				draw();
			}
		}
		
		//------------------------------
		// bounds
		//------------------------------
		
		public function get bounds(): Rectangle {
			return new Rectangle(parent.x + x, parent.y + y, width, height);
		}
		
		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------
		
		public function draw(): void {
			_textField.wordWrap = false;
			_textField.textColor = 0x00000;

			_textField.setTextFormat(_textFormat);
		}
	}
}