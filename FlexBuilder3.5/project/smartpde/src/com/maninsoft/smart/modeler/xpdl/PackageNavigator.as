////////////////////////////////////////////////////////////////////////////////
//  PackageNavigator.as
//  2008.04.25, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl
{
	import com.maninsoft.smart.modeler.xpdl.navigator.DiagramNavigatorContextMenu;
	import com.maninsoft.smart.modeler.xpdl.navigator.DiagramTreeActivity;
	import com.maninsoft.smart.modeler.xpdl.navigator.DiagramTreeForm;
	import com.maninsoft.smart.modeler.xpdl.navigator.DiagramTreeLane;
	import com.maninsoft.smart.modeler.xpdl.navigator.DiagramTreeProxy;
	import com.maninsoft.smart.modeler.xpdl.navigator.DiagramTreeRoot;
	import com.maninsoft.smart.modeler.xpdl.packages.PackageNavigatorContextMenu;
	import com.maninsoft.smart.modeler.xpdl.packages.PackageTreeForm;
	import com.maninsoft.smart.modeler.xpdl.packages.PackageTreeProcess;
	import com.maninsoft.smart.modeler.xpdl.packages.PackageTreeRoot;
	import com.maninsoft.smart.modeler.xpdl.server.Server;
	
	import mx.controls.TextInput;
	import mx.events.ListEvent;
	import mx.events.ListEventReason;
	
	/**
	 * Package 구성요소를 표시하고 관리하는 툴.
	 * 일단, DiagramNavigator를 이용 간단히 처리한다.
	 * 정밀한 구현히 필요함!!!
	 */
	public class PackageNavigator extends DiagramNavigator {
		
		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function PackageNavigator() {
			super();
		}

		
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		/**
		 * server
		 */
		private var _server: Server;
		
		public function get server(): Server {
			return _server;
		}
		
		public function set server(value: Server): void {
			_server = value;
			refresh();
		}
		
		/**
		 * currentForm
		 */
		public function get currentFormId(): String {
			if (selectedItem is DiagramTreeForm)
				return DiagramTreeForm(selectedItem).formId;

			if (selectedItem is PackageTreeForm)
				return PackageTreeForm(selectedItem).formId;
				
			return null;
		}

		/**
		 * packageName
		 */
		public var packageName: String = "Package";
		
		/**
		 * WorkBench쪽 함수 호출용.
		 */
		public var callBack:Function;

		
		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------

		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override protected function createTreeRoot(): DiagramTreeRoot {
			return new PackageTreeRoot(packageName, diagram, server);
		}

		override protected function createContextMenu(): DiagramNavigatorContextMenu {
			return new PackageNavigatorContextMenu(this);
		}
		
		override protected function doItemEditEnd(event: ListEvent): void {
			if (event.reason == ListEventReason.NEW_ROW) {
				event.preventDefault();
				
				var node: Object = event.currentTarget.itemEditorInstance.data;
				var val: String = TextInput(event.currentTarget.itemEditorInstance).text;
				
				if (node is DiagramTreeLane) {
					processLane(node as DiagramTreeLane, val);
				}				
				else if (node is DiagramTreeActivity) {
					processActivity(node as DiagramTreeActivity, val);
				}
				else if (node is DiagramTreeProxy) {
					var p: DiagramTreeProxy = node as DiagramTreeProxy;
					
					if (p.proxyType == DiagramTreeProxy.PROXY_LANE)
						processLaneProxy(p, val);
					else if (p.proxyType == DiagramTreeProxy.PROXY_ACTIVITY)
						processActivityProxy(p.parent as DiagramTreeLane, val);
				}else if(node is PackageTreeForm){
					PackageTreeForm(node).formName = val;
					this.callBack(event, "type.form");
				}else if(node is PackageTreeProcess){
					this.callBack(event, "type.process");
				}else if(node is DiagramTreeForm){
				    DiagramTreeForm(node).label = val;
					this.callBack(event, "type.form");
				}
				
				destroyItemEditor();
				setFocus();	
			}
		}
		
		public function editableTrue():void{
			editable = false;
	    	editable = true;
		}
	}
}