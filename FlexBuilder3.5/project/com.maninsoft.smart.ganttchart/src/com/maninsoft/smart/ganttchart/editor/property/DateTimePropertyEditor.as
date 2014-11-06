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
	import com.maninsoft.smart.ganttchart.editor.property.dialog.SelectDateDialog;
	import com.maninsoft.smart.ganttchart.model.GanttChartGrid;
	import com.maninsoft.smart.ganttchart.model.process.GanttPackage;
	import com.maninsoft.smart.ganttchart.server.CalendarInfo;
	import com.maninsoft.smart.workbench.common.property.IPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.page.PropertyPageItem;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.containers.HBox;
	import mx.controls.ComboBox;
	import mx.controls.DateChooser;
	import mx.controls.TextInput;
	import mx.events.ListEvent;
	import mx.formatters.DateFormatter;
	
	/**
	 * 버튼을 클릭한 후 표시되는 다이얼로그 등을 통해 속성을 편집하는 에디터
	 */
	public class DateTimePropertyEditor extends HBox implements IPropertyEditor {

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

		private var _dateChooser: DateChooser;

		public static const DATE_WIDTH: Number = 118;
		public static const HOUR_WIDTH: Number = 89;
		

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function DateTimePropertyEditor() {
			super();

			this.setStyle("horizontalGap", 3);				
			_dateText = createTextInput();			
			_hourText = createHourComboBox();
		}

		override protected function createChildren():void {
			super.createChildren();

			_dateText.width = DATE_WIDTH;
			_dateText.height = this.height
			_dateText.editable = false;
			_dateText.doubleClickEnabled = false;
			this.addChild(_dateText);
			_dateText.addEventListener(MouseEvent.CLICK, doDateTextClick);

			_hourText.width = HOUR_WIDTH;
			_hourText.height = this.height
			this.addChild(_hourText);
			_hourText.addEventListener(ListEvent.CHANGE, doHourTextChange);
			
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
			return _date;
		}
		
		public function set editValue(val: Object): void {
			var dateFormatter: DateFormatter = new DateFormatter();
			if(val==null)
				_date = new Date();
			else
				_date = new Date((val as Date).time);

			_dateText.text = CalendarInfo.fullDayToStringShort(_date, GanttChartGrid.DEPLOY_MODE);				
			_hourText.selectedIndex = _date.getHours();
		}
		
		public function setBounds(x: Number, y: Number, width: Number, height: Number): void {
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
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
			var current:Date = _date? _date:new Date(GanttPackage.GANTTCHART_DUEDATE.time);
			SelectDateDialog.execute(_date, doAccept, this.localToGlobal(new Point(_dateText.x, _dateText.y+_dateText.height+1)), GanttPackage.GANTTCHART_DUEDATE); 			
		}

		private function doHourTextChange(event: ListEvent): void {
			_date.setHours(_hourText.selectedIndex);
			_pageItem.acceptEditValue();
		}

		public function doAccept(value:Date):void{
			if(value){
				value.setHours(_hourText.selectedIndex);
				editValue=value;
				_pageItem.acceptEditValue();
			}
		}
		private function createTextInput(): TextInput{
			var textInput: TextInput = new TextInput();
			textInput.setStyle("fillAlphas", [1, 1]);
			textInput.setStyle("fillColors", [0xffffff, 0xffffff]);
			textInput.setStyle("highlightAlphas", [1, 1]);
			textInput.setStyle("fontWeight", "normal");
			textInput.setStyle("focusThickness", 0);
			textInput.setStyle("fontName", "Tahoma");
			textInput.setStyle("fontSize", 11);
			textInput.setStyle("textIndent", 0);
			textInput.restrict="- 0-9";
			return textInput;
		}

		private function createHourComboBox(): ComboBox{
			var comboBox: ComboBox = new ComboBox();
			var hourList: Array = CalendarInfo.getHoursArrayLong();
			comboBox.dataProvider = hourList;
			comboBox.editable = false;
			comboBox.setStyle("fillAlphas", [1, 1]);
			comboBox.setStyle("fillColors", [0xffffff, 0xffffff]);
			comboBox.setStyle("focusThickness", 0);
			comboBox.setStyle("highlightAlphas", [1, 1]);
			comboBox.setStyle("fontWeight", "normal");
			comboBox.setStyle("paddingLeft", 0);
			comboBox.setStyle("cornerRadius", 0);
			comboBox.setStyle("fontName", "Tahoma");
			comboBox.setStyle("fontSize", 11);
			comboBox.setStyle("textIndent", 0);
			return comboBox;
		}
	}
}