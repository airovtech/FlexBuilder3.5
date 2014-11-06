////////////////////////////////////////////////////////////////////////////////
//  ProblemIcon.as
//  2008.04.18, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.view.viewicon
{
	import com.maninsoft.smart.modeler.assets.XPDLEditorAssets;
	import com.maninsoft.smart.modeler.view.IView;
	import com.maninsoft.smart.modeler.view.ViewIcon;
	import com.maninsoft.smart.modeler.xpdl.XPDLEditor;
	import com.maninsoft.smart.modeler.xpdl.dialogs.ProblemDialog;
	import com.maninsoft.smart.modeler.xpdl.syntax.Problem;
	
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.core.SpriteAsset;
	
	/**
	 * 문제가 있는 Activity에 표시
	 */
	public class ProblemIcon extends ViewIcon	{
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function ProblemIcon(view: IView) {
			super(view);
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		/**
		 * problem
		 */
		public var problem: Problem;
		
		private var warningIcon:SpriteAsset = SpriteAsset(new XPDLEditorAssets.warningIcon());

		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override public function get toolTip(): String {
			return problem.message;
		}
				

		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override protected function draw(g: Graphics): void {
			if(contains(warningIcon))
				removeChild(warningIcon);
			addChild(warningIcon);
		}

		override protected function doClick(event: MouseEvent): void {
			ProblemDialog.execute(problem, editor as XPDLEditor, new Point(event.stageX, event.stageY), 350, 150);
			
			super.doClick(event);
		}
	}
}