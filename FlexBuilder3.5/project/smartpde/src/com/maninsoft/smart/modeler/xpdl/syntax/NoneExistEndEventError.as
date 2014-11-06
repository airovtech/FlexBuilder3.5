////////////////////////////////////////////////////////////////////////////////
//  NoneExistEndEventError.as
//  2008.03.19, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.syntax
{
	import com.maninsoft.smart.modeler.command.NodeCreateCommand;
	import com.maninsoft.smart.modeler.xpdl.XPDLEditor;
	import com.maninsoft.smart.modeler.xpdl.model.EndEvent;
	import com.maninsoft.smart.modeler.xpdl.model.Pool;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
	import com.maninsoft.smart.modeler.xpdl.model.pool.Lane;
	import com.maninsoft.smart.modeler.xpdl.syntax.base.DiagramProblem;
	
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * Diagram에 endEvent가 존재하지 않는다.
	 */
	public class NoneExistEndEventError extends DiagramProblem {
		
		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function NoneExistEndEventError(diagram: XPDLDiagram) {
			super(diagram);

			level = LEVEL_ERROR;
			label = resourceManager.getString("ProcessEditorMessages", "PEP004L");
			message = resourceManager.getString("ProcessEditorMessages", "PEP004M");
			description = resourceManager.getString("ProcessEditorMessages", "PEP004LD"); 
		}
		
		public static  function checkIt(buff: ArrayCollection, diagram: XPDLDiagram): void {
			addCount(NoneExistEndEventError);
			
			// 종료 이벤트가 있는 지 확인한다.
			if (!diagram.pool.hasActivityOf(EndEvent)){
				buff.addItem(new NoneExistEndEventError(diagram));
			}
		}

		//----------------------------------------------------------------------
		// Overriden properties
		//----------------------------------------------------------------------
		
		override public function get canFixUp(): Boolean {
			return true;
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override public function fixUp(editor: XPDLEditor): void {
			var pool: Pool = (source as XPDLDiagram).pool;
			
			if (pool == null) {
				showMessage("다이어그램에 Pool이 존재하지 않습니다.");
				return;
			}
			
			if (pool.laneCount < 1) {
				showMessage("다이어그램에 부서가 존재하지 않습니다.");
				return;
			}
				
			var lane: Lane = pool.lane(pool.laneCount - 1);
			var act: Activity = new EndEvent();		
		
			var p: Point = pool.getNextActivityPos(lane, act);
			act.center = p;
			
			//editor.resetTool();
			editor.execute(new NodeCreateCommand(pool, act));
		}
	}
}