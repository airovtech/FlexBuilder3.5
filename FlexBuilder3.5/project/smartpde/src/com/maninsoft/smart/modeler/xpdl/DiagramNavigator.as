////////////////////////////////////////////////////////////////////////////////
//  DiagramNavigator.as
//  2008.03.14, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl
{
	import com.maninsoft.smart.modeler.command.LinkCreateCommand;
	import com.maninsoft.smart.modeler.command.NodeCreateCommand;
	import com.maninsoft.smart.modeler.editor.events.DiagramChangeEvent;
	import com.maninsoft.smart.modeler.xpdl.model.EndEvent;
	import com.maninsoft.smart.modeler.xpdl.model.IntermediateEvent;
	import com.maninsoft.smart.modeler.xpdl.model.Pool;
	import com.maninsoft.smart.modeler.xpdl.model.StartEvent;
	import com.maninsoft.smart.modeler.xpdl.model.TaskApplication;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
	import com.maninsoft.smart.modeler.xpdl.model.base.XPDLLink;
	import com.maninsoft.smart.modeler.xpdl.model.base.XPDLNode;
	import com.maninsoft.smart.modeler.xpdl.model.pool.Lane;
	import com.maninsoft.smart.modeler.xpdl.navigator.DiagramNavigatorContextMenu;
	import com.maninsoft.smart.modeler.xpdl.navigator.DiagramTree;
	import com.maninsoft.smart.modeler.xpdl.navigator.DiagramTreeActivity;
	import com.maninsoft.smart.modeler.xpdl.navigator.DiagramTreeLane;
	import com.maninsoft.smart.modeler.xpdl.navigator.DiagramTreeProxy;
	
	import flash.geom.Point;
	
	[Event(name="menuItemSelect", type="mx.events.DynamicEvent")]

	/**
	 * 다이어그램 구성요소를 표시하고 관리하는 툴
	 * 현재, 트리 컴포넌트를 이용 간략히 구성한다.
	 * 요구사항에 맞는 적합한 컴포넌트 구현이 필요하다!!!
	 */
	public class DiagramNavigator extends DiagramTree {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function DiagramNavigator() {
			super();

			var menu: DiagramNavigatorContextMenu = createContextMenu();
			menu.createMenu();	
		}
		
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/**
		 * editor
		 */
		private var _editor: XPDLEditor;

		public function get editor(): XPDLEditor {
			return _editor;
		}
		
		public function set editor(value: XPDLEditor): void {
			_editor = value;
			
			var dgm: XPDLDiagram = _editor ? _editor.xpdlDiagram : null;
			
			if (dgm) {
				dgm.removeEventListener(DiagramChangeEvent.NODE_ADDED, doNodeAdded);
				dgm.removeEventListener(DiagramChangeEvent.NODE_REMOVED, doNodeRemoved);
				dgm.removeEventListener(DiagramChangeEvent.NODE_REPLACED, doNodeReplaced);
				dgm.removeEventListener(DiagramChangeEvent.PROP_CHANGED, doPropChanged);
				dgm.removeEventListener("lanePropChanged", doLanePropChanged);
			}
		
			diagram = dgm;
		
			if (diagram) {
				diagram.addEventListener(DiagramChangeEvent.NODE_ADDED, doNodeAdded);
				diagram.addEventListener(DiagramChangeEvent.NODE_REMOVED, doNodeRemoved);
				diagram.addEventListener(DiagramChangeEvent.NODE_REPLACED, doNodeReplaced);
				diagram.addEventListener(DiagramChangeEvent.PROP_CHANGED, doPropChanged);
				diagram.addEventListener("lanePropChanged", doLanePropChanged);
			}
		}
		

		//----------------------------------------------------------------------
		// Overriden Methods
		//----------------------------------------------------------------------
		
		override protected function processLane(node: DiagramTreeLane, value: String): void {
			node.lane.name = value;
		}
		
		override protected function processActivity(node: DiagramTreeActivity, value: String): void {
			node.activity.name = value;
		}
		
		override protected function processLaneProxy(node: DiagramTreeProxy, value: String): void {
			var lane: Lane = new Lane(diagram.pool);
			lane.name = value;
			diagram.pool.addLane(lane);
			currentLane = lane;
		}
		
		override protected function processActivityProxy(node: DiagramTreeLane, value: String): void {
			var lane: Lane = node.lane;
			var pool: Pool = diagram.pool;
			
			if (lane) {
				var act: Activity = null;

				if ((value == resourceManager.getString("ProcessEditorETC", "startText")) && !pool.hasActivityOf(StartEvent))  {
					act = new StartEvent();		
					act.name = value;				
				} 
				else if ((value == resourceManager.getString("ProcessEditorETC", "endText")) && !pool.hasActivityOf(EndEvent)) {
					act = new EndEvent();
					act.name = value;
				}
				else if ((value == resourceManager.getString("ProcessEditorETC", "intermediateText")) && !pool.hasActivityOf(IntermediateEvent)) {
					act = new IntermediateEvent();
					act.name = value;
				}
				else {
					act = new TaskApplication();
					act.name = value;
				}

				var last: Activity = null;
				var l: int = lane.id;
				
				while (l >= 0) {
					last = pool.getLastActivity(pool.lane(l));
					if (last) break;
					l--;
				}
				
				var p: Point = pool.getNextActivityPos(lane, act);
				act.center = p;

				// 액티비티를 추가한다.		
				editor.execute(new NodeCreateCommand(pool, act));
				
				if (last) {
					var path: String; 
					
					if (l == lane.id)
						path = pool.isVertical ? "180,0" : "90,270";
					else
						path = pool.isVertical ? "90,270" : "180,0";

					
					// 레인의 마지막 노드와 링크로 연결한다.
					var link: XPDLLink = new XPDLLink(last, act, path);
					editor.execute(new LinkCreateCommand(link));
				}
				
				// 트리의 선택 위치를 방금 생성한 액티비티로 지정한다.
				currentActivity = act;
			}
		}

		//----------------------------------------------------------------------
		// Internal Methods
		//----------------------------------------------------------------------

		protected function createContextMenu(): DiagramNavigatorContextMenu {
			return new DiagramNavigatorContextMenu(this);
		}
		
		private function refreshTree(): void {
			var selItem: Activity = currentActivity;
			
			this.refresh();	
			
			if (selItem)
				currentActivity = selItem;
		}

		private function doNodeAdded(event: DiagramChangeEvent): void {
		    refreshTree();
		}
		
		private function doNodeRemoved(event: DiagramChangeEvent): void {
		    refreshTree();
		}
		
		private function doNodeReplaced(event: DiagramChangeEvent): void {
		    refreshTree();
		}
		
		private function doPropChanged(event: DiagramChangeEvent): void {
			if (event.prop == XPDLNode.PROP_NAME ||
			    event.prop == Activity.PROP_ACTIVITYTYPE ||
			    event.prop == Activity.PROP_LANEID ||
			    event.prop == Activity.PROP_PROBLEM ||
			    event.prop == Pool.PROP_ADD_LANE ||
			    event.prop == Pool.PROP_REMOVE_LANE ||
			    event.prop == Pool.PROP_MOVE_LANE ||
			    event.prop == TaskApplication.PROP_FORMID
			    ) 
			    refreshTree();
		}
		
		private function doLanePropChanged(event: DiagramChangeEvent): void {
			refreshTree();
		}
	}
}