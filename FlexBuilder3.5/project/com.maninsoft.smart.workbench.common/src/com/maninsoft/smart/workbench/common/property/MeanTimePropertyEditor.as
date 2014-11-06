package com.maninsoft.smart.workbench.common.property
{
	import com.maninsoft.smart.workbench.common.property.page.PropertyPageItem;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import mx.containers.HBox;
	import mx.controls.Label;
	import mx.controls.TextInput;
	
	/**
	 * 문자열 속성을 편집하는 에디터
	 */
	public class MeanTimePropertyEditor extends HBox implements IPropertyEditor	{

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		private var meanTime:Date = new Date(0);
		private var daysText:TextInput = new TextInput();
		private	var dayLabel:Label = new Label();
		private var hoursText:TextInput = new TextInput();
		private	var hourLabel:Label = new Label();
		private var minutesText:TextInput = new TextInput();
		private	var minuteLabel:Label = new Label();
		private var minimumMinutes:int = 5; // 5분
		private var maximumMinutes:int = 100*365*24*60;// 100년
		
		/** Constructor */
		public function MeanTimePropertyEditor(minimumMinutes:int=0, maximumMinutes:int=0) {
			super();
			this.styleName="meanTimePropertyEditor";
			if(minimumMinutes)
				this.minimumMinutes = minimumMinutes;
			if(maximumMinutes)
				this.maximumMinutes = maximumMinutes;
		}

		override protected function createChildren(): void {
			super.createChildren();

			daysText.width = 30;
			daysText.height = this.height-1;
			daysText.restrict = "1-90";
			daysText.maxChars = 3;
			daysText.styleName="meanTimePropertyEditorText"
			addChild(daysText);
			
			dayLabel.text = resourceManager.getString("WorkbenchETC", "meanTimeDaysText")+"  ";
			dayLabel.styleName="meanTimePropertyEditorLabel";
			addChild(dayLabel);
			 
			hoursText.width = 30;
			hoursText.height = this.height-1;
			hoursText.restrict = "1-90";
			hoursText.maxChars = 2;
			hoursText.styleName="meanTimePropertyEditorText"
			addChild(hoursText);
			
			hourLabel.text = resourceManager.getString("WorkbenchETC", "meanTimeHoursText") + "  ";
			hourLabel.styleName="meanTimePropertyEditorLabel";
			addChild(hourLabel);
			 
			minutesText.width = 30;
			minutesText.height = this.height-1;
			minutesText.restrict = "1-90";
			minutesText.maxChars = 2;
			minutesText.styleName="meanTimePropertyEditorText"
			addChild(minutesText);
			
			minuteLabel.text = resourceManager.getString("WorkbenchETC", "meanTimeMinutesText");
			minuteLabel.styleName="meanTimePropertyEditorLabel";
			addChild(minuteLabel);	 
		}


		//----------------------------------------------------------------------
		// IPropertyEditor
		//----------------------------------------------------------------------
		
		/**
		 * 편집기를 표시하고 입력 가능한 상태로 만든다.
		 */
		public function activate(pageItem: PropertyPageItem): void {
			this.visible = true;

			addEventListener(MouseEvent.MOUSE_DOWN, doMouseDown);
			addEventListener(KeyboardEvent.KEY_DOWN, doKeyDown);
			daysText.addEventListener(Event.CHANGE, doChange);
			hoursText.addEventListener(Event.CHANGE, doChange);
			minutesText.addEventListener(Event.CHANGE, doChange);
		}
		
		/**
		 * 편집기를 숨긴다.
		 */
		public function deactivate(): void {
			this.visible = false;

			removeEventListener(MouseEvent.MOUSE_DOWN, doMouseDown);
			removeEventListener(KeyboardEvent.KEY_DOWN, doKeyDown);
		}
		
		/**
		 * 편집기에 값을 가져오거나 설정한다.
		 */
		public function get editValue(): Object {
			var meanTime:int = int(daysText.text)*24*60 + int(hoursText.text)*60 + int(minutesText.text);
			if(meanTime<minimumMinutes || meanTime>maximumMinutes)
				return minimumMinutes.toString();
			else
				return meanTime.toString();
		}
		
		public function set editValue(val: Object): void {
			if(!val) val = new int(minimumMinutes);

			var minutes:int = int(val);
			var days:int = minutes/24/60;
			minutes -= days*24*60;
			var hours:int = minutes/60;
			minutes -= hours*60;
			daysText.text = days.toString();
			hoursText.text = hours.toString();
			minutesText.text = minutes.toString()
		}
		
		public function setBounds(x: Number, y: Number, width: Number, height: Number): void {
			this.x = x-1;
			this.y = y;
			this.width = width;
			this.height = height;
		}
		
		public function setEditable(val: Boolean): void {
			this.daysText.editable = val;
			this.hoursText.editable = val;
			this.minutesText.editable = val;
		}

		public function get isDialog(): Boolean {
			return false;
		}

		//----------------------------------------------------------------------
		// Event handlers
		//----------------------------------------------------------------------

		protected function doMouseDown(event: MouseEvent): void {
		}		
		
		protected function doKeyDown(event: KeyboardEvent): void {
			switch (event.keyCode) {
				case Keyboard.LEFT:
				case Keyboard.RIGHT:
					event.stopImmediatePropagation();
					break;
			}		
		}
		
		protected function doChange(event:Event): void {
			PropertyPageItem(this.parent).acceptEditValue();
		}
	}
}