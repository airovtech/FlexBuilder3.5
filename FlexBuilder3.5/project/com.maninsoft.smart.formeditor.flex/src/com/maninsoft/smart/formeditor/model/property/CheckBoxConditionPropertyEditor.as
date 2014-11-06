package com.maninsoft.smart.formeditor.model.property
{
	import com.maninsoft.smart.workbench.common.assets.PropertyIconLibrary;
	import com.maninsoft.smart.workbench.common.property.CheckBoxPropertyEditor;
	
	import mx.controls.Button;
	
	/**
	 * 버튼을 클릭한 후 표시되는 다이얼로그 등을 통해 속성을 편집하는 에디터
	 */
	public class CheckBoxConditionPropertyEditor extends CheckBoxPropertyEditor {

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _conditionEditButton:Button = new Button();

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function CheckBoxConditionPropertyEditor() {
			super();
		}
		
		public function get conditionEditButton():Button{
			return _conditionEditButton;			
		}
		
		public function set conditionEditButton(value:Button):void{
			_conditionEditButton = value;
		}

		override protected function childrenCreated():void{
			
			super.childrenCreated();
			
			_conditionEditButton.width = 12;
			_conditionEditButton.height = 16;
			addChild(_conditionEditButton);
		}

		//----------------------------------------------------------------------
		// Event handlers
		//----------------------------------------------------------------------
		
	}
}