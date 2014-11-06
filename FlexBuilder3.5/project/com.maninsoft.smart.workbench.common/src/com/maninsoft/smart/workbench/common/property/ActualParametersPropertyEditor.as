package com.maninsoft.smart.workbench.common.property
{
	import com.maninsoft.smart.workbench.common.assets.PropertyIconLibrary;
	
	/**
	 * 버튼을 클릭한 후 표시되는 다이얼로그 등을 통해 속성을 편집하는 에디터
	 */
	public class ActualParametersPropertyEditor extends ButtonPropertyEditor{


		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function ActualParametersPropertyEditor() {
			super();
		}

		override protected function childrenCreated():void{
			super.childrenCreated();			
			this.buttonIcon =  PropertyIconLibrary.gatewayConditionIcon;
		}

		override public function setBounds(x: Number, y: Number, width: Number, height: Number): void {
			super.setBounds(x, y, width, height);
			this.height = height*3;
			valueLabel.height = height*3;
		}
	}
}