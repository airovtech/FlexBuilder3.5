////////////////////////////////////////////////////////////////////////////////
//  DiagramNavigatorContextMenu.as
//  2008.02.29, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.navigator
{
	import com.maninsoft.smart.modeler.command.NodeCreateCommand;
	import com.maninsoft.smart.modeler.command.NodeDeleteCommand;
	import com.maninsoft.smart.modeler.xpdl.DiagramNavigator;
	import com.maninsoft.smart.modeler.xpdl.XPDLEditor;
	import com.maninsoft.smart.modeler.xpdl.model.AndGateway;
	import com.maninsoft.smart.modeler.xpdl.model.EndEvent;
	import com.maninsoft.smart.modeler.xpdl.model.IntermediateEvent;
	import com.maninsoft.smart.modeler.xpdl.model.Pool;
	import com.maninsoft.smart.modeler.xpdl.model.StartEvent;
	import com.maninsoft.smart.modeler.xpdl.model.TaskApplication;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.model.XorGateway;
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
	import com.maninsoft.smart.modeler.xpdl.model.base.ActivityTypes;
	import com.maninsoft.smart.modeler.xpdl.model.command.LaneMoveCommand;
	import com.maninsoft.smart.modeler.xpdl.model.pool.Lane;
	
	import flash.events.ContextMenuEvent;
	import flash.geom.Point;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import mx.controls.Alert;
	import mx.controls.Tree;
	import mx.controls.treeClasses.TreeItemRenderer;
	import mx.events.DynamicEvent;
	import mx.events.ListEvent;
	
	/**
	 * 다이어그램 네비케이터의 context menu를 관리한다.
	 */
	public class DiagramNavigatorContextMenu {

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		private var _navigator: DiagramNavigator;
		private var _ctxMenu: ContextMenu;
		

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function DiagramNavigatorContextMenu(navigator: DiagramNavigator) {
			super();
			
			_navigator = navigator;
			_navigator.addEventListener(ListEvent.CHANGE, doTreeChange);
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		public function get navigator(): DiagramNavigator  {
			return _navigator;
		}
		
		public function get editor(): XPDLEditor {
			return _navigator.editor;
		}
		
		public function get diagram(): XPDLDiagram {
			return _navigator.diagram;
		}


		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------
		
		public function createMenu(): void {
			var actions: Array = createMenuItems();
			
			_ctxMenu = new ContextMenu();

			for each (var action: Object in actions) {
				var item: ContextMenuItem;

				item = new ContextMenuItem(action.caption);
				item.separatorBefore = action.separatorBefore;
				
				_ctxMenu.customItems.push(item);
				
				item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, action.handler ? action.handler : doNotReady);
			}
			
			_ctxMenu.hideBuiltInItems();
			_ctxMenu.addEventListener(ContextMenuEvent.MENU_SELECT, doMenuSelect);
			_navigator.contextMenu = _ctxMenu;
		}
		
		protected function doNotReady(event: ContextMenuEvent): void {
			Alert.show("준비 중입니다.", "정보");
		}
		
		protected function createMenuItems(): Array {
			var items: Array = 
			[
				{ caption: "부서 추가", 		handler: ctxMenu_addLane 		},
				{ caption: "액티비티 추가", 	handler: ctxMenu_addActivity 	},
				
				{ caption: "위로 이동", 		handler: ctxMenu_laneMoveUp,	separatorBefore: true },
				{ caption: "아래로 이동", 	handler: ctxMenu_laneMoveDown	},
				
				{ caption: ActivityTypes.START_EVENT 		+ "로 변경", handler: ctxMenu_changeActivityType },
				{ caption: ActivityTypes.END_EVENT		 	+ "로 변경", handler: ctxMenu_changeActivityType },
				{ caption: ActivityTypes.INTERMEDIATE_EVENT	+ "로 변경", handler: ctxMenu_changeActivityType },
				{ caption: ActivityTypes.TASK_APPLICATION 	+ "로 변경", handler: ctxMenu_changeActivityType },
				{ caption: ActivityTypes.AND_GATEWAY		+ "로 변경", handler: ctxMenu_changeActivityType },
				{ caption: ActivityTypes.XOR_GATEWAY		+ "로 변경", handler: ctxMenu_changeActivityType },
				
				{ caption: "삭제", handler: ctxMenu_delete, separatorBefore: true }
			];
			
			return items;
		}
		
		protected function doTreeChange(event: ListEvent): void {
			trace(event);
			checkMenuItems();
		}
		
		protected function doMenuSelect(event: ContextMenuEvent): void {
			var tree: Tree = _navigator
			
			//trace(event);
			trace(event.mouseTarget);
			//trace(tree.getObjectsUnderPoint(new Point(tree.mouseX, tree.mouseY)));

			var renderer: TreeItemRenderer = null;
			
			if (event.mouseTarget.parent is TreeItemRenderer) {
				renderer = event.mouseTarget.parent as TreeItemRenderer;
			}
			else if (event.mouseTarget is TreeItemRenderer) {
				renderer = event.mouseTarget as TreeItemRenderer;
			}
			
			
			if (renderer != null) {
				tree.selectedItem = renderer.data;
			}
			
			//여기에서 event를 조사해서 tree의 selection을 변경한다...
			
			checkMenuItems();
		}

		protected function checkMenuItems(): void {
			for each (var item: ContextMenuItem in _ctxMenu.customItems) 
				checkMenuItem(item);
		}

		protected function checkMenuItem(item: ContextMenuItem): void {
			var node: DiagramTreeNode = navigator.selectedItem as DiagramTreeNode;

			switch (item.caption) {
				case "부서 추가":
					item.visible = node is DiagramTreeRoot;
					break;
					
				case "액티비티 추가":
					item.visible = node is DiagramTreeLane;
					break;	
					
				case "위로 이동":
					item.visible = node is DiagramTreeLane;
					break;
					
				case "아래로 이동":
					item.visible = node is DiagramTreeLane;
					break;
					
				case "삭제":
					item.visible = node.removable;
					break;
					
				default:
					if (node is DiagramTreeActivity) {
						item.visible = true;
						var act: Activity = DiagramTreeActivity(node).activity;
						
						if (item.caption.indexOf(ActivityTypes.START_EVENT) >= 0 && act is StartEvent)
							item.visible = false;
						else if (item.caption.indexOf(ActivityTypes.END_EVENT) >= 0 && act is EndEvent)
							item.visible = false;
						else if (item.caption.indexOf(ActivityTypes.INTERMEDIATE_EVENT) >= 0 && act is IntermediateEvent)
							item.visible = false;
						else if (item.caption.indexOf(ActivityTypes.TASK_APPLICATION) >= 0 && act is TaskApplication)
							item.visible = false;
						else if (item.caption.indexOf(ActivityTypes.AND_GATEWAY) >= 0 && act is AndGateway)
							item.visible = false;
						else if (item.caption.indexOf(ActivityTypes.XOR_GATEWAY) >= 0 && act is XorGateway)
							item.visible = false;
						
					} 
					else
						item.visible = false;
											
					break;
			}
		}
		
		protected function fireMenuEvent(event: ContextMenuEvent): void {
			if (navigator) {
				var ev: DynamicEvent = new DynamicEvent("menuItemSelect");
				
				ev.menu = event.target;
				ev.node = navigator.selectedItem;
				
				navigator.dispatchEvent(ev);
			}
		}


		//----------------------------------------------------------------------
		// Context menu handlers
		//----------------------------------------------------------------------
		
		/**
		 * add lane
		 */
		private function ctxMenu_addLane(event: ContextMenuEvent): void {
			var lane: Lane = new Lane(diagram.pool);
			lane.name = "부서";
			diagram.pool.addLane(lane);
		}

		/**
		 * add activity
		 */
		private function ctxMenu_addActivity(event: ContextMenuEvent): void {
			var node: DiagramTreeLane = navigator.selectedItem as DiagramTreeLane;
			
			if (node) {
				var lane: Lane = node.lane;
				var pool: Pool = diagram.pool;
				
				if (lane) {
					var act: Activity;

					if (!pool.hasActivityOf(StartEvent))  {
						act = new StartEvent();						
					} 
					//else if (!pool.hasActivityOf(EndEvent)) {
					//	act = new EndEvent();
					//}
					else {
						act = new TaskApplication();
					}
					
					//act.id = diagram.getNextId();
					var p: Point = diagram.pool.getNextActivityPos(lane, act);
					act.center = p;
					
					//editor.resetTool();
					editor.execute(new NodeCreateCommand(diagram.pool, act));
					
					navigator.currentActivity = act;
				}
			}
		}
		
		/**
		 * Lane 위로 이동
		 */
		private function ctxMenu_laneMoveUp(event: ContextMenuEvent): void {
			var node: DiagramTreeLane = navigator.selectedItem as DiagramTreeLane;

			if (node.lane.id > 0) {
				editor.execute(new LaneMoveCommand(node.lane, node.lane.id - 1));
			}			
		}
		
		/**
		 * Lane 아래로 이동
		 */
		private function ctxMenu_laneMoveDown(event: ContextMenuEvent): void {
			var node: DiagramTreeLane = navigator.selectedItem as DiagramTreeLane;

			if (node.lane.id < node.lane.owner.laneCount - 1) {
				editor.execute(new LaneMoveCommand(node.lane, node.lane.id + 1));
			}			
		}
		
		/**
		 * change activity type
		 */
		private function ctxMenu_changeActivityType(event: ContextMenuEvent): void {
			trace(event);

			var menu: ContextMenuItem = event.target as ContextMenuItem;
			var item: DiagramTreeActivity = navigator.selectedItem as DiagramTreeActivity;
			var act: Activity = item.activity;
			var type: String = null;
			
			if (menu.caption.indexOf(ActivityTypes.START_EVENT) >= 0)
				type = ActivityTypes.START_EVENT;
			else if (menu.caption.indexOf(ActivityTypes.END_EVENT) >= 0)
				type = ActivityTypes.END_EVENT;
			else if (menu.caption.indexOf(ActivityTypes.INTERMEDIATE_EVENT) >= 0)
				type = ActivityTypes.INTERMEDIATE_EVENT;
			else if (menu.caption.indexOf(ActivityTypes.TASK_APPLICATION) >= 0)
				type = ActivityTypes.TASK_APPLICATION
			else if (menu.caption.indexOf(ActivityTypes.AND_GATEWAY) >= 0)
				type = ActivityTypes.AND_GATEWAY
			else if (menu.caption.indexOf(ActivityTypes.XOR_GATEWAY) >= 0)
				type = ActivityTypes.XOR_GATEWAY;

			if (type)
				diagram.changeActivityType(act, type);
		}
		
		/**
		 * 삭제
		 */
		private function ctxMenu_delete(event: ContextMenuEvent): void {
			trace(event);
			
			var item: Object = navigator.selectedItem;
			
			if (item is DiagramTreeActivity) {
				deleteActivity(item as DiagramTreeActivity);
			}
			else if (item is DiagramTreeLane) {
				deleteLane(item as DiagramTreeLane);
			}
			
			fireMenuEvent(event);
		}
		
		private function deleteActivity(item: DiagramTreeActivity): void {
			if (item && item.activity) {
				editor.clearSelection();
				editor.execute(new NodeDeleteCommand(item.activity));
			}
		}
		
		private function deleteLane(item: DiagramTreeLane): void {
			if (item && item.lane) {
				//editor.clearSelection();
				//editor.execute(new LaneDeleteCommand(item.lane));
				editor.deleteLane(item.lane);
			}
		}
	}
}