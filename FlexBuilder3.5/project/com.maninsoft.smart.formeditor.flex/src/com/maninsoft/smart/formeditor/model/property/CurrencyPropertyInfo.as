package com.maninsoft.smart.formeditor.model.property
{
	import com.maninsoft.smart.formeditor.model.type.CurrencyTypes;
	import com.maninsoft.smart.workbench.common.property.DomainPropertyInfo;
	
	/**
	 * Activity의 activityType 속성
	 */
	public class CurrencyPropertyInfo extends DomainPropertyInfo	{
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function CurrencyPropertyInfo(id: String, displayName: String, 
		                                      description: String = null,
		                                      category: String = null,
		                                      editable: Boolean = true,
		                                      helpId: String = null) {
			super(id, displayName, description, category, editable, helpId);
			super.domain = CurrencyTypes.currencyTypeArray;
		}

		override public function getText(value: Object): String {
			return value.label;
		}				
	}
}