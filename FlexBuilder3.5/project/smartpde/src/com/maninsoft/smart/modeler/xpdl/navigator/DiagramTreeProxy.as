////////////////////////////////////////////////////////////////////////////////
//  DiagramTreeProxy.as
//  2008.04.03, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.navigator
{
	/**
	 * 추가 생성을 위한 임시 노드
	 */
	public class DiagramTreeProxy extends DiagramTreeNode	{
		
		//----------------------------------------------------------------------
		// Class consts
		//----------------------------------------------------------------------

		public static const PROXY_LANE		: String = "lane";
		public static const PROXY_ACTIVITY	: String = "activity";


		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function DiagramTreeProxy(proxyType: String) {
			super();
			
			_proxyType = proxyType;
		}

		
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		/**
		 * proxyType
		 */
		private var _proxyType: String = PROXY_LANE; 
		 
		public function get proxyType(): String {
			return _proxyType;
		}


		/**
		 * isLaneProxy
		 */
		public function get isLaneProxy(): Boolean {
			return _proxyType == PROXY_LANE;
		}
		
		//----------------------------------------------------------------------
		// Overriden properties
		//----------------------------------------------------------------------
		
		override public function get label(): String {
			if (_proxyType == PROXY_LANE)
				return "새 부서";
			else
				return "새 액티비티";
		}
		
		override public function get icon(): Class {
			/*
			if (PROXY_LANE == proxyType)
				return DiagramNavigatorAsset.laneIcon;
			else
				return DiagramNavigatorAsset.taskIcon;
			*/
			return null;
		}
		
		override public function get removable(): Boolean {
			return false;
		}
	}
}