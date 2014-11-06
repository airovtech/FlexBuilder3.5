////////////////////////////////////////////////////////////////////////////////
//  ActivityTypePropertyInfo.as
//  2008.02.25, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.property
{
	import com.maninsoft.smart.workbench.common.property.DomainPropertyInfo;
	import com.maninsoft.smart.modeler.xpdl.model.base.ActivityTypes;
	
	/**
	 * Activity의 activityType 속성
	 */
	public class ActivityTypePropertyInfo extends DomainPropertyInfo	{
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function ActivityTypePropertyInfo(id: String, displayName: String, 
		                                      description: String = null,
		                                      category: String = null,
		                                      editable: Boolean = true,
		                                      helpId: String = null) {
			super(id, displayName, description, category, editable, helpId);
			super.domain = ActivityTypes.getTypes();
		}

	}
}