////////////////////////////////////////////////////////////////////////////////
//  ActivityTypePropertyInfo.as
//  2008.02.25, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.ganttchart.editor.property
{
	import com.maninsoft.smart.workbench.common.property.DomainPropertyInfo;
	import com.maninsoft.smart.ganttchart.model.GanttActivityTypes;
	
	/**
	 * Activity의 activityType 속성
	 */
	public class GanttActivityTypePropertyInfo extends DomainPropertyInfo	{
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function GanttActivityTypePropertyInfo(id: String, displayName: String, 
		                                      description: String = null,
		                                      category: String = null,
		                                      editable: Boolean = true,
		                                      helpId: String = null) {
			super(id, displayName, description, category, editable, helpId);
			super.domain = GanttActivityTypes.getTypes();
		}

	}
}