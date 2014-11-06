package com.maninsoft.smart.workbench.common.property
{
	import com.maninsoft.smart.workbench.common.assets.PropertyIconLibrary;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.Button;
	
	/**
	 * 버튼을 클릭한 후 표시되는 다이얼로그 등을 통해 속성을 편집하는 에디터
	 */
	public class FieldIdPropertyEditor extends ButtonPropertyEditor {

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function FieldIdPropertyEditor() {
			super();
		}
		
		override protected function childrenCreated():void{
			
			super.childrenCreated();
			
			this.buttonIcon = PropertyIconLibrary.formIdIcon;
			
		}

		override public function setBounds(x: Number, y: Number, width: Number, height: Number): void {
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
			
			valueLabel.y  = y;
			valueLabel.width = width-BUTTON_WIDTH-3;
			valueLabel.height = height;
			
			dialogButton.y = y;
			dialogButton.width = BUTTON_WIDTH;
			dialogButton.height = BUTTON_HEIGHT;
		}		
	}
}