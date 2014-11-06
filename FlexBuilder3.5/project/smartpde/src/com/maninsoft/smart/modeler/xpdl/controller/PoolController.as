////////////////////////////////////////////////////////////////////////////////
//  PoolController.as
//  2007.12.31, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved.
//
//  Addio 2007 !! 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.controller
{
	import com.maninsoft.smart.modeler.command.Command;
	import com.maninsoft.smart.modeler.command.GroupCommand;
	import com.maninsoft.smart.modeler.controller.Controller;
	import com.maninsoft.smart.modeler.controller.IControllerTool;
	import com.maninsoft.smart.modeler.controller.NodeController;
	import com.maninsoft.smart.modeler.editor.handle.SelectHandle;
	import com.maninsoft.smart.modeler.model.events.NodeChangeEvent;
	import com.maninsoft.smart.modeler.view.NodeView;
	import com.maninsoft.smart.modeler.xpdl.controller.tool.LaneCreationTool;
	import com.maninsoft.smart.modeler.xpdl.controller.tool.StartEventCreationTool;
	import com.maninsoft.smart.modeler.xpdl.model.Pool;
	import com.maninsoft.smart.modeler.xpdl.model.command.LaneResizeCommand;
	import com.maninsoft.smart.modeler.xpdl.model.command.PoolResizeCommand;
	import com.maninsoft.smart.modeler.xpdl.model.pool.Lane;
	import com.maninsoft.smart.modeler.xpdl.model.pool.LaneChangeEvent;
	import com.maninsoft.smart.modeler.xpdl.view.PoolView;
	import com.maninsoft.smart.workbench.common.event.LoadCallbackEvent;
	
	import flash.geom.Rectangle;
	
	/**
	 * Controller for pool
	 */
	public class PoolController extends XPDLNodeController {

		private var selectLineColor:uint = 0xda0000;
		private var currentLineColor:uint;

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function PoolController(model: Pool) {
			super(model);
		}

		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		/**
		 * pool
		 */
		public function get pool(): Pool {
			return model as Pool;
		}


		//----------------------------------------------------------------------
		// Overriden Properties
		//----------------------------------------------------------------------

		override protected function get toolsDir(): int {
			return TOOLS_TOP;
		}
		
		override public function get leftMargin(): Number {
			return Pool(model).isVertical ? 0 : PoolView(view).headSize;
		}
		
		override public function get topMargin(): Number {
			return Pool(model).isVertical ? PoolView(view).headSize : 0;
		}


		//----------------------------------------------------------------------
		// Overriden Methods
		//----------------------------------------------------------------------
		
		override public function activate(): void {
			super.activate();
			
			for each (var lane: Lane in pool.lanes)
				lane.addEventListener(LaneChangeEvent.CHANGE, laneChanged);
		}
		
		override public function deactivate(): void {
			super.deactivate();
			
			for each (var lane: Lane in pool.lanes)
				lane.removeEventListener(LaneChangeEvent.CHANGE, laneChanged);
		}
		
		override protected function createNodeView(): NodeView {
			return new PoolView();
		}

		override protected function initNodeView(nodeView:NodeView): void {
			super.initNodeView(nodeView);

			var view: PoolView 	= nodeView as PoolView;
			
			with (view) {
				x				= this.pool.x = 4;
				y				= this.pool.y = 0;			
				isVertical 		= this.pool.orientation == Pool.VERT_LANES;
				lanes 			= this.pool.lanes;
				poolHeadSize 	= this.pool.headSize;
				laneHeadSize 	= this.pool.laneHeadSize;
				headColor 		= this.pool.headColor;
				title           = this.pool.processName;
			}
			
			var editorHeight:Number, contentHeight:Number;
			if(editor.readOnly && smartWorkbench.id == "diagramViewer"){
				editorHeight = -pool.y + pool.height*(xpdlEditor.zoom)/100 + xpdlEditor.scrollMargin;
				editorHeight = (editorHeight>xpdlEditor.minimumContentHeight)? editorHeight:xpdlEditor.minimumContentHeight;
				contentHeight = smartWorkbench.diagramViewerHeaderToolBar.height+editorHeight;
			}else{
				editorHeight = -pool.y + pool.height*xpdlEditor.zoom/100 + xpdlEditor.scrollMargin;
				editorHeight = (editorHeight>xpdlEditor.minimumContentHeight)? editorHeight:xpdlEditor.minimumContentHeight;
				contentHeight = smartWorkbench.processEditor.processEditorHeaderToolBar.height+editorHeight+8;
			}
			smartWorkbench.dispatchEvent(new LoadCallbackEvent(LoadCallbackEvent.LOAD_CALLBACK, LoadCallbackEvent.STAGENAME_PROCESS, contentHeight));
			this.xpdlEditor.height = editorHeight;
		}
	
		override public function refreshView(): void {
			var v: PoolView = view as PoolView;
			
			v.isVertical = pool.orientation == Pool.VERT_LANES;
			v.lanes = pool.lanes;
			// xpdl 패키지 하나에 풀과 프로세스가 하나라고 가정하고 있기 때문에
			v.title = pool.processName;
			v.headColor = pool.headColor;
			
			super.refreshView();  

			var editorHeight:Number, contentHeight:Number;
			if(editor.readOnly)
				editorHeight = -pool.y + pool.height*(xpdlEditor.zoom+10)/100 + xpdlEditor.scrollMargin;
			else
				editorHeight = -pool.y + pool.height*xpdlEditor.zoom/100 + xpdlEditor.scrollMargin;			
			editorHeight = (editorHeight>xpdlEditor.minimumContentHeight)? editorHeight:xpdlEditor.minimumContentHeight;
			if( this.xpdlEditor.height != editorHeight){
				if(editor.readOnly && smartWorkbench.id == "diagramViewer")
					contentHeight = smartWorkbench.diagramViewerHeaderToolBar.height+editorHeight+6+50;
				else
				    contentHeight = smartWorkbench.processEditor.processEditorHeaderToolBar.height+editorHeight+8;
				smartWorkbench.dispatchEvent(new LoadCallbackEvent(LoadCallbackEvent.LOAD_CALLBACK, LoadCallbackEvent.STAGENAME_PROCESS, contentHeight));
				this.xpdlEditor.height = editorHeight;
			}
		}

		override public function getSelectAnchorDirs(): Array {
			var dirs: Array = new Array();
			
			dirs.push(SelectHandle.DIR_RIGHT);
			dirs.push(SelectHandle.DIR_BOTTOMRIGHT);
			dirs.push(SelectHandle.DIR_BOTTOM);
			dirs.push(SelectHandle.DIR_BOTTOMLEFT);

			return dirs;			
		}
		
		override protected function showSelection(): Boolean {

			PoolView(view).selected = true;
			currentLineColor = PoolView(view).lineColor;
			PoolView(view).lineColor = selectLineColor;
			return super.showSelection();			
		}
		
		override protected function hideSelection(): Boolean {
			PoolView(view).selected = false;
			PoolView(view).lineColor = currentLineColor;
			return super.hideSelection();
		}
		
		override public function canSelect(x: Number, y: Number): Boolean {
			/**
			 * 헤더 영역을 클릭했을 때만 선택되도록 한다.
			 * 나머지 영역은 자식 개체들을 선택하는 툴링이 되도록 해야 한다.
			 */			
			var r: Rectangle = PoolView(view).poolHeadRect;
			return r.contains(x, y);
		}

		override public function canConnect(): Boolean {
			return false;
		}
		
		override public function canConnectWith(source: Controller): Boolean {
			return false;
		}
		
		override public function canMoveBy(dx: Number, dy: Number): Boolean {
			return false;
		}
		
		override public function canResizeBy(anchorDir: int, dx: Number, dy: Number): Boolean {

			return valueIsIn(anchorDir, SelectHandle.DIR_RIGHT, SelectHandle.DIR_BOTTOMRIGHT, SelectHandle.DIR_BOTTOM); 
		}

		override protected function createTools(): Array {
			if (editor.readOnly)
				return EMPTY_TOOLS;
			
			var tools: Array = [];
			var tool: IControllerTool;
			
			tool = new LaneCreationTool(this);
			tools.push(tool);
			
			tool = new StartEventCreationTool(this);
			tools.push(tool);
			
			return tools;
		}
		
		override public function canModifyText(): Boolean {
			return false;
		}

		/**
		 * 노드의 속성이 변경되었다.
		 */
		override protected function nodeChanged(event: NodeChangeEvent): void {
			/**
			 * lane이 추가되면 추가된 만큼 pool의 크기를 변경시킨다.
			 */
			switch (event.prop) {
				case Pool.PROP_ADD_LANE:
					Lane(event.value).addEventListener(LaneChangeEvent.CHANGE, laneChanged);
					refreshView();
					break;
				
				case Pool.PROP_MOVE_LANE:
					Lane(event.value).removeEventListener(LaneChangeEvent.CHANGE, laneChanged);
					refreshView();
					break;
				
				case Pool.PROP_RESIZE_LANE:
					refreshView();
					break;
					
				case Pool.PROP_ORIENTATION:
					refreshView();
					
					for each (var ctrl: NodeController in children) {
						ctrl.refreshBounds();
						ctrl.refreshView();
					}
						
					break;
					
				case Pool.PROP_HEADCOLOR:
					refreshView();
					break;
					
				default:
					super.nodeChanged(event);
			}
		}
		
		override public function getResizeCommand(anchorDir: int, deltaX: Number, deltaY: Number): Command {
			var gcmd: GroupCommand = new GroupCommand();
			gcmd.add(new PoolResizeCommand(pool, deltaX, deltaY));
			
			if (pool.isVertical && deltaX != 0) {
			
			}
			else if (!pool.isVertical && deltaY != 0) {
				gcmd.add(new LaneResizeCommand(pool.lastLane, deltaY));
			}
			
			return gcmd;
		}


		//----------------------------------------------------------------------
		// Internal Methods
		//----------------------------------------------------------------------
		
		private function laneChanged(event: LaneChangeEvent): void {
			if (event.prop == Lane.PROP_FILLCOLOR)
				refreshView();		
		}
		
		private function get smartWorkbench():Object{
			
			var processEditor:Object = this.editor.parentDocument as Object;
			if(editor.readOnly && processEditor.id == "diagramViewer")
				return processEditor;
			else
				return processEditor.parentDocument as Object;
		}
	}
}