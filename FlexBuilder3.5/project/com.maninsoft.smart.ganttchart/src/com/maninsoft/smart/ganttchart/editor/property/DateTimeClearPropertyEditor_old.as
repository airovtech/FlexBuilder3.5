////////////////////////////////////////////////////////////////////////////////
//  EllipsisPropertyEditor.as
//  2008.02.01, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.ganttchart.editor.property
{
	import com.maninsoft.smart.workbench.common.property.IPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.page.PropertyPageItem;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.HBox;
	import mx.controls.Button;
	import mx.controls.ComboBox;
	import mx.controls.DateChooser;
	import mx.controls.TextInput;
	import mx.formatters.DateFormatter;
	
	/**
	 * 버튼을 클릭한 후 표시되는 다이얼로그 등을 통해 속성을 편집하는 에디터
	 */
	public class DateTimeClearPropertyEditor_old extends HBox implements IPropertyEditor {

		//----------------------------------------------------------------------
		// Class consts
		//----------------------------------------------------------------------


		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _pageItem: PropertyPageItem;
		private var _editValue: Object;

		private var _date: Date;

		private var _dateText: TextInput;
		private var _hourText: ComboBox;
		private var _clearButton: Button;

		private var _dateChooser: DateChooser;

		public static const DATE_WIDTH: Number = 96;
		public static const HOUR_WIDTH: Number = 90;
		public static const CLEAR_WIDTH: Number = 50;
		

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function DateTimeClearPropertyEditor() {
			super();

			_dateText = createTextInput();			
			_hourText = createHourComboBox();
			_clearButton = createClearButton();			
		}

		override protected function createChildren():void {
			super.createChildren();

			_dateText.width = DATE_WIDTH;
			_dateText.y = this.y-1;
			_dateText.height = this.height
			this.addChild(_dateText);
//			_dateText.addEventListener(MouseEvent.CLICK, doDateTextClick);

			_hourText.x = DATE_WIDTH+2;
			_hourText.y = this.y-1;
			_hourText.width = HOUR_WIDTH;
			_hourText.height = this.height
			this.addChild(_hourText);
			
			_clearButton.y = this.y-1;
			_clearButton.width = CLEAR_WIDTH;
			_clearButton.height = this.height
			this.addChild(_clearButton);
			_clearButton.addEventListener(MouseEvent.CLICK, doClearButtonClick);
		}

		//----------------------------------------------------------------------
		// IPropertyEditor
		//----------------------------------------------------------------------
		
		/**
		 * 편집기를 표시하고 입력 가능한 상태로 만든다.
		 */
		public function activate(pageItem: PropertyPageItem): void {
			_pageItem = pageItem;
			
			this.visible = true;
//			_dateText.setFocus()
		}
		
		/**
		 * 편집기를 숨긴다.
		 */
		public function deactivate(): void {
			this.visible = false;
		}
		
		/**
		 * 편집기에 값을 가져오거나 설정한다.
		 */
		public function get editValue(): Object {
			var dateString: String = _dateText.text;
			if(_dateText.text==null || _dateText.text=="" || _hourText.text==null || _hourText.text==""){
				return null;
			}
			
			_date = new Date(dateString.substring(0,4), parseInt(dateString.substring(5,7))-1, dateString.substring(8,10));
			_date.setHours(_hourText.selectedIndex, 0, 0);

			return _date;
		}
		
		public function set editValue(val: Object): void {
			var dateFormatter: DateFormatter = new DateFormatter();
			if(val==null)
				_date = new Date();
			else
				_date = val as Date;

			dateFormatter.formatString = "YYYY-MM-DD";
			_dateText.text = dateFormatter.format(_date);
			_hourText.selectedIndex = _date.getHours();
		}
		
		public function setBounds(x: Number, y: Number, width: Number, height: Number): void {
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height+4;
		}
		
		public function setEditable(val: Boolean): void {
			this.enabled = val;
		}

		public function get isDialog(): Boolean {
			return false;
		}

		//----------------------------------------------------------------------
		// Event handlers
		//----------------------------------------------------------------------
		
		private function doDateTextClick(event: Event): void {
			if(_dateChooser)	return;
			
			_dateChooser = createDateChooser();			
			_dateChooser.y= -200;
			_dateChooser.selectedDate = _date;
			_dateText.addChild(_dateChooser);
		}

		private function doClearButtonClick(event: Event): void {
			_date=null;
			_dateText.text=null;
			_hourText.text=null;
		}

		private function createTextInput(): TextInput{
			var textInput: TextInput = new TextInput();
			textInput.setStyle("focusThickness", 1);
			textInput.setStyle("fontName", "verdana");
			textInput.setStyle("fontSize", 11);
			textInput.restrict="- 0-9";
			return textInput;
		}

		private function createHourComboBox(): ComboBox{
			var comboBox: ComboBox = new ComboBox();
			var hourList: Array = new Array();
			for(var i: int=0; i<24; i++){
				if(i==0) hourList[i] = resourceManager.getString("GanttChartETC", "midNightText");
				else if(i<12) hourList[i] = resourceManager.getString("GanttChartETC", "beforeNoonText") + get99String(i);
				else if(i==12) hourList[i] = resourceManager.getString("GanttChartETC", "noonText");
				else if(i<24) hourList[i] = resourceManager.getString("GanttChartETC", "afterNoonText") + get99String(i-12);
			}
			function get99String(value: int): String{
				var result: String;
				if(value<10)
					result = "0"+value.toString();
				else
					result = value.toString();
				return result;
			}

			comboBox.dataProvider = hourList;
			comboBox.editable = true;
			comboBox.setStyle("focusThickness", 1);
			comboBox.setStyle("fontName", "verdana");
			comboBox.setStyle("fontSize", 11);
			comboBox.restrict=	  resourceManager.getString("GanttChartETC", "midNightText")
								+ resourceManager.getString("GanttChartETC", "noonText")
								+ resourceManager.getString("GanttChartETC", "beforeNoonText")
								+ resourceManager.getString("GanttChartETC", "afterNoonText")
								+ "0-9";
			return comboBox;
		}

		private function createDateChooser(): DateChooser{
			var dateChooser: DateChooser = new DateChooser();
			dateChooser.setStyle("focusThickness", 1);
			dateChooser.setStyle("fontName", "verdana");
			dateChooser.setStyle("fontSize", 11);
			return dateChooser;
		}

		private function createClearButton(): Button{
			var button: Button = new Button();
			button.setStyle("focusThickness", 1);
			button.setStyle("fontName", "verdana");
			button.setStyle("fontSize", 11);
			button.label = resourceManager.getString("GanttChartETC", "noDateText");
			return button;
		}
	}
}