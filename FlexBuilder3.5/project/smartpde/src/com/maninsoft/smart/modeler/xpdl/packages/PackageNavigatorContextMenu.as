////////////////////////////////////////////////////////////////////////////////
//  PackageNavigatorContextMenu.as
//  2008.04.28, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.packages
{
	import com.maninsoft.smart.modeler.xpdl.PackageNavigator;
	import com.maninsoft.smart.modeler.xpdl.model.TaskApplication;
	import com.maninsoft.smart.modeler.xpdl.navigator.DiagramNavigatorContextMenu;
	import com.maninsoft.smart.modeler.xpdl.navigator.DiagramTreeActivity;
	import com.maninsoft.smart.modeler.xpdl.navigator.DiagramTreeForm;
	import com.maninsoft.smart.modeler.xpdl.navigator.DiagramTreeNode;
	
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenuItem;
	
	/**
	 * PackageNavigator 를 위한 컨텍스트 메뉴
	 */
	public class PackageNavigatorContextMenu extends DiagramNavigatorContextMenu {
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function PackageNavigatorContextMenu(navigator: PackageNavigator) {
			super(navigator);
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override protected function createMenuItems(): Array {
			var items: Array = [
					{ caption: "프로세스 생성", handler: doCreateProcess },
					{ caption: "단위업무 추가", handler: doCreateForm },
					{ caption: "열기", handler: doOpen },
					{ caption: "단위업무로 변경", handler: doChangeFormType },
					{ caption: "이름 바꾸기", handler: doChangeName }
				];
				
			return items.concat(super.createMenuItems());
		}

		override protected function checkMenuItem(item: ContextMenuItem): void {
			var node: DiagramTreeNode = navigator.selectedItem as DiagramTreeNode;
			if (item.caption == "열기") {
				item.visible = node is PackageTreeProcess || node is PackageTreeForm || node is DiagramTreeForm;	
			}else if (item.caption == "이름 바꾸기") {
				item.visible = node is PackageTreeProcess || node is PackageTreeForm || node is DiagramTreeForm;
			}
			else if (node is PackageTreeRoot) {
				switch (item.caption) {
					case "프로세스 생성":
						item.visible = !PackageTreeRoot(node).hasProcess;
						break;
						
					default:
						item.visible = false;
						break;
				}
			}
			else if (node is PackageTreeFormRoot) {
				item.visible = item.caption == "단위업무 추가";
			}
			else if (node is DiagramTreeForm) {
				item.visible = item.caption == "단위업무로 변경";
			}
			else {
				super.checkMenuItem(item);
			}
			if (item.caption == "프로세스 생성"){
				item.visible = true;
			}
		}


		//----------------------------------------------------------------------
		// Context menu handlers
		//----------------------------------------------------------------------
		
		/**
		 * 프로세스 추가
		 */
		private function doCreateProcess(event: ContextMenuEvent): void {
			fireMenuEvent(event);
		}
		
		/**
		 * 단위업무 추가
		 */
		private function doCreateForm(event: ContextMenuEvent): void {
			fireMenuEvent(event);
		}
		
		/**
		 * 열기
		 */
		private function doOpen(event: ContextMenuEvent): void {
			fireMenuEvent(event);
		}
		
		/**
		 * 단위업무로 변경
		 */
		private function doChangeFormType(event: ContextMenuEvent): void {
			var node: DiagramTreeForm = navigator.selectedItem as DiagramTreeForm;
			// assert(node != null);
			var pnode: DiagramTreeActivity = node.parent as DiagramTreeActivity;
			// assert(pnode != null);

			if (pnode.activity is TaskApplication) {
				TaskApplication(pnode.activity).formId = null;
			}	
			fireMenuEvent(event);		
		}
		
		/**
		 * 이름 바꾸기
		 */
		private function doChangeName(event: ContextMenuEvent): void {
			fireMenuEvent(event);
		}
	}
}