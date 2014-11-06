////////////////////////////////////////////////////////////////////////////////
//  ArtifactController.as
//  2008.01.15, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.controller
{
	import com.maninsoft.smart.modeler.mapper.IMappingItem;
	import com.maninsoft.smart.modeler.mapper.IMappingLink;
	import com.maninsoft.smart.modeler.mapper.IMappingSource;
	import com.maninsoft.smart.modeler.xpdl.model.action.CheckStartActivityAction;
	import com.maninsoft.smart.modeler.xpdl.model.action.SetActivityPerformerAction;
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
	import com.maninsoft.smart.modeler.xpdl.model.base.Artifact;
	
	import flash.geom.Rectangle;
	
	/**
	 * Artifact 모델의 컨트롤러 base
	 */
	public class ArtifactController extends XPDLNodeController {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------


		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function ArtifactController(model: Artifact) {
			super(model);
		}
		

		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/** 
		 * Property model
		 */
		public function get artifact(): Artifact {
			return super.model as Artifact;
		}

		//----------------------------------------------------------------------
		// Virtual methods
		//----------------------------------------------------------------------
		
		/**
		 * XPDL 노드라면 공통적으로 갖게 되는 컨트롤러 툴들을 생성한다.
		 */
		override protected function createCommonTools(): Array {
			return super.createCommonTools();
		}


		//----------------------------------------------------------------------
		// Overriden properties
		//----------------------------------------------------------------------

		//------------------------------
		// ITextEditable
		//------------------------------
		override public function canModifyText(): Boolean {
			return true;
		}
	}
}