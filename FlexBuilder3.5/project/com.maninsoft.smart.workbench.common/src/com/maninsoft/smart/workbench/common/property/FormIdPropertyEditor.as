package com.maninsoft.smart.workbench.common.property
{
	import com.maninsoft.smart.workbench.common.assets.PropertyIconLibrary;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.Button;
	
	/**
	 * 버튼을 클릭한 후 표시되는 다이얼로그 등을 통해 속성을 편집하는 에디터
	 */
	public class FormIdPropertyEditor extends ButtonPropertyEditor {

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _formEditButton:Button = new Button();

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function FormIdPropertyEditor() {
			super();
		}
		
		public function get formEditButton():Button{
			return _formEditButton;			
		}
		
		public function set formEditButton(value:Button):void{
			_formEditButton = value;
		}

		override protected function childrenCreated():void{
			
			super.childrenCreated();
			
			this.buttonIcon = PropertyIconLibrary.formIdIcon;
			
			_formEditButton.styleName="formEditButton";
			addChild(_formEditButton);
			_formEditButton.addEventListener(MouseEvent.CLICK, doFormEditClick);			
		}

		override public function setBounds(x: Number, y: Number, width: Number, height: Number): void {
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
			
			valueLabel.y  = y;
			valueLabel.width = width-BUTTON_WIDTH*2-3*2;
			valueLabel.height = height;
			
			dialogButton.y = y;
			dialogButton.width = BUTTON_WIDTH;
			dialogButton.height = BUTTON_HEIGHT;

			_formEditButton.y = y;
			_formEditButton.width = BUTTON_WIDTH;
			_formEditButton.height = BUTTON_HEIGHT;
		}
		
		//----------------------------------------------------------------------
		// Event handlers
		//----------------------------------------------------------------------
		
		private function doFormEditClick(event: Event): void {
			this.pageItem.page.hide();
			this.parentApplication.workbench.goForm();
		}
	}
}