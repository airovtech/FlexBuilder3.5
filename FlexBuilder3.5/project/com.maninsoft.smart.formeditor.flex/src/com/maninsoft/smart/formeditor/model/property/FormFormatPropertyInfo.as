////////////////////////////////////////////////////////////////////////////////
//  ActivityTypePropertyInfo.as
//  2008.02.25, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.formeditor.model.property
{
	import com.maninsoft.smart.workbench.common.property.DomainPropertyInfo;
	import com.maninsoft.smart.formeditor.model.type.FormatType;
	import com.maninsoft.smart.formeditor.model.type.FormatTypes;
	
	/**
	 * Activity의 activityType 속성
	 */
	public class FormFormatPropertyInfo extends DomainPropertyInfo	{
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function FormFormatPropertyInfo(id: String, displayName: String, 
		                                      description: String = null,
		                                      category: String = null,
		                                      editable: Boolean = true,
		                                      helpId: String = null,
		                                      domain:Array =  null) {
			super(id, displayName, description, category, editable, helpId);
			if(domain)
				super.domain = domain;
			else
				super.domain = FormatTypes.formatTypeArray;
		}

		override public function getText(value: Object): String {
			return value.label;
		}				
	}
}