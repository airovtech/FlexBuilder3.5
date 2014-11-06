package com.maninsoft.smart.workbench.common.property
{
	import com.maninsoft.smart.workbench.common.property.page.PropertyPageItem;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.Box;
	import mx.containers.BoxDirection;
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.controls.TextArea;
	import mx.core.ScrollPolicy;
	
	/**
	 * 버튼을 클릭한 후 표시되는 다이얼로그 등을 통해 속성을 편집하는 에디터
	 */
	public class ButtonPropertyEditor extends Box implements IPropertyEditor {

		//----------------------------------------------------------------------
		// Class consts
		//----------------------------------------------------------------------

		public static const BUTTON_WIDTH: Number = 24;
		public static const BUTTON_HEIGHT: Number = 21;

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _pageItem: PropertyPageItem;
		public var _editValue: Object;
		private var _clickHandler: Function;
		private var _valueLabel:TextArea = new TextArea();
		private var _dialogButton:Button = new Button();
		private var _buttonIcon:Class;

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function ButtonPropertyEditor(direction:String=BoxDirection.HORIZONTAL) {
			super();
			this.styleName="buttonPropertyEditor";
			this.horizontalScrollPolicy = ScrollPolicy.OFF;
			this.direction=direction;
		}

		override protected function childrenCreated():void{
			
			_valueLabel.styleName="buttonValueLabel";
			addChild(_valueLabel);
			
			_dialogButton.styleName="buttonDialogButton";
			_dialogButton.setStyle("icon", _buttonIcon);
			addChild(_dialogButton);
			_dialogButton.addEventListener(MouseEvent.CLICK, doDialogClick);			
		}

		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		public function get pageItem():PropertyPageItem{
			return _pageItem;
		}
		public function set pageItem(value:PropertyPageItem):void{
			_pageItem = value;
		}

		public function set clickHandler(value: Function): void {
			_clickHandler = value;
		}

		public function get valueLabel():TextArea{
			return _valueLabel;
		}
		public function set valueLabel(value:TextArea):void{
			_valueLabel = value;
		}

		public function get dialogButton():Button{
			return _dialogButton;
		}
		public function set dialogButton(value:Button):void{
			_dialogButton = value;
		}
		
		public function set buttonIcon(value:Class):void{
			_buttonIcon = value;
			_dialogButton.setStyle("icon", _buttonIcon);
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
			return _editValue;
		}
		
		public function set editValue(val: Object): void {
			if(_editValue == val) return;
			_editValue = val;
			_valueLabel.text = val as String;
		}
		
		public function setBounds(x: Number, y: Number, width: Number, height: Number): void {
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
			
			_valueLabel.y  = y;
			_valueLabel.width = width-BUTTON_WIDTH-3;
			_valueLabel.height = height;
			
			_dialogButton.y = y;
			_dialogButton.width = BUTTON_WIDTH;
			_dialogButton.height = BUTTON_HEIGHT;

		}
		
		public function setEditable(val: Boolean): void {
			this.valueLabel.editable = val;
		}

		public function get isDialog(): Boolean {
			return true;
		}

 		//----------------------------------------------------------------------
		// IDataRenderer
		//----------------------------------------------------------------------

 		override public function get data():Object {
        	return editValue;
    	}
    
    	override public function set data(value:Object):void {
        	editValue = value;
    	}
   	
    	public function get text(): String{
    		return valueLabel.text;
    	}
    	
    	public function set text(value: String):void{
    		valueLabel.text = value;
    	}
 
		//----------------------------------------------------------------------
		// Event handlers
		//----------------------------------------------------------------------
		
		protected function doDialogClick(event: Event): void {
			if (_clickHandler != null) {
				_clickHandler(this);
			}		
		}
	}
}