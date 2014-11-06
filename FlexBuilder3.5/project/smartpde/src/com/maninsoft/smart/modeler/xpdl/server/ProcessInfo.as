////////////////////////////////////////////////////////////////////////////////
//  ProcessInfo.mxml.as
//  2008.04.26, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.server
{
	/**
	 * 프로세스 메타 정보
	 */
	public class ProcessInfo {

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function ProcessInfo()	{
			super();
		}

		
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		public var processId: String;
		public var packageId: String;
		public var version: String;
		public var name: String;
		public var status: String;
		public var creator: String;
		public var categoryPath:String;
		public function get label():String{
//			return categoryName + ">" + (groupName? groupName + ">" : "") + name; 
			if(categoryPath) return categoryPath;
			else return name; 
		}
	}
}