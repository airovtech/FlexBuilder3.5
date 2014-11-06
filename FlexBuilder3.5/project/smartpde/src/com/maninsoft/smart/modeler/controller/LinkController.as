////////////////////////////////////////////////////////////////////////////////
//  LinkController.as
//  2007.12.27, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.controller
{
	import com.maninsoft.smart.modeler.editor.handle.LinkEndHandle;
	import com.maninsoft.smart.modeler.editor.handle.LinkHandle;
	import com.maninsoft.smart.modeler.model.Link;
	import com.maninsoft.smart.modeler.model.Node;
	import com.maninsoft.smart.modeler.model.events.LinkChangeEvent;
	import com.maninsoft.smart.modeler.model.events.LinkEvent;
	import com.maninsoft.smart.modeler.view.IView;
	import com.maninsoft.smart.modeler.view.LinkView;
	import com.maninsoft.smart.modeler.view.connection.IConnectionRouter;
	import com.maninsoft.smart.modeler.view.connection.ManhattanConnectionRouter;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	/**
	 * Link 컨트로러
	 */
	public class LinkController extends Controller {

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		/** Storage for selection handlers */
		private var _selectHandles: Array;

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function LinkController(model: Link) {
			super(model);
		}

		

		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/** 
		 * Property model
		 */
		public function get linkModel(): Link {
			return super.model as Link;
		}
		
		public function get sourceNode(): Node {
			return linkModel.source;
		}
		
		public function get targetNode(): Node {
			return linkModel.target;
		}
		
		public function get sourceController(): NodeController {
			return editor.findControllerByModel(sourceNode) as NodeController;
		}
		
		public function get targetController(): NodeController {
			return editor.findControllerByModel(targetNode) as NodeController;
		}

		public function get selectHandles(): Array{
			return _selectHandles;
		}
		
		public function set selectHandles(value: Array): void{
			_selectHandles = value;
		}

		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------
		
		public function sourceConstraintChanged(): void {
			refreshView();
		}
		
		public function targetConstraintChanged(): void {
			refreshView();
		}
		
		/**
		 * path로 부터 양끝점과 각 선분의 중점을 배열로 리턴한다.
		 */
		public function getSelectSegmentPoints(): Array {
			var pts: Array = calcConnectPoints();
			var len: int = pts.length;
			var points: Array = new Array();		
			
			points.push(new Point(pts[0].x, pts[0].y));
			
			for (var i: int = 1; i < len; i++) {
				
			}

			points.push(new Point(pts[len - 1].x, pts[len - 1].y));
			
			return points;
		}

		//----------------------------------------------------------------------
		// Virtual methods
		//----------------------------------------------------------------------

		protected function createConnectionRouter(): IConnectionRouter {
			return new ManhattanConnectionRouter();
		}

		//----------------------------------------------------------------------
		// Overriden Methods
		//----------------------------------------------------------------------
		
		/**
		 * 컨트롤러를 활성 시킨다.
		 */
		override public function activate(): void {
			super.activate();

			if (linkModel) {
				linkModel.addEventListener(LinkEvent.CHANGE, linkChanged);
			}
		}
		
		/**
		 * 컨트롤러를 비활성 시킨다.
		 */
		override public function deactivate(): void {
			if (linkModel) {
				linkModel.removeEventListener(LinkEvent.CHANGE, linkChanged);
			}
			
			super.deactivate();
		}

		override protected function activateView(): void {
			if (view) {
				editor.addView(view);
			}
		}
		
		override protected function deactivateView(): void {
			if (view) {
				editor.removeView(view);
			}
		}

		override protected function createView(): IView {
			if (linkModel) {
				var view: LinkView = new LinkView(calcConnectPoints());			
				var m: Link = linkModel;
				
				view.lineColor = m.lineColor; 
				view.lineWidth = m.lineWidth;
				view.isBackward = m.isBackward;
					
				return view;

			} else {
				return null;
			}
		}
		
		override public function refreshView(): void {
			var view: LinkView = view as LinkView;
			var m: Link = linkModel;
			
			view.points = calcConnectPoints();
			view.lineColor = m.lineColor;
			view.lineWidth = m.lineWidth;
			view.isBackward = m.isBackward;
			view.refresh();
		}
		
		override protected function showSelection(): Boolean {
			if (!_selectHandles) {
				_selectHandles = new Array();
				
				var segs: Array = getSelectSegmentPoints();
				var handle1: LinkEndHandle;
				var handle2: LinkEndHandle;
				
				// 시작점
				handle1 = new LinkEndHandle(this, LinkEndHandle.SOURCE_EDGE);
	
				handle1.x = Point(segs[0]).x;
				handle1.y = Point(segs[0]).y;
				
				_selectHandles.push(handle1);
				editor.getSelectionLayer().addChild(handle1);
				
				
				// 도착점
				handle2 = new LinkEndHandle(this, LinkEndHandle.TARGET_EDGE);
	
				handle2.x = Point(segs[segs.length - 1]).x;
				handle2.y = Point(segs[segs.length - 1]).y;
				
				_selectHandles.push(handle2);
				editor.getSelectionLayer().addChild(handle2);
				
				handle1.opposite = handle2;
				handle2.opposite = handle1;
				
				return true;
			} else {
				return false;
			}
		}
		
		override protected function hideSelection(): Boolean {
			showPropertyView = false;
			if (_selectHandles) {
				for each (var handle: LinkHandle in _selectHandles) {
					if (editor.getSelectionLayer().contains(handle)) {
						editor.getSelectionLayer().removeChild(handle);	
					}
				}
				
				_selectHandles = null;		
				return true;
			} else {
				return false;
			}
		}
		
		override protected function showToolsInternal(): void {
			var pts: Array = LinkView(view).points;
			var x: int;
			var y: int;
			var tool: DisplayObject;
			
			if (pts[0].y == pts[1].y) {
				y = pts[0].y - 20;
				x = Math.min(pts[0].x, pts[1].x) + 30;
				
				for each (tool in tools) {
					if (IControllerTool(tool).enabled) {
						tool.x = x;
						tool.y = y;
						editor.getFeedbackLayer().addChild(tool);
						
						x += tool.width + 4;
					}
				}
				
			} else {
				x = pts[0].x + 20;
				y = Math.min(pts[0].y, pts[1].y) + 30;
				
				for each (tool in tools) {
					if (IControllerTool(tool).enabled) {
						tool.x = x;
						tool.y = y;
						editor.getFeedbackLayer().addChild(tool);
						
						y += tool.height + 4;
					}
				}
			}
		}

		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
		
		protected function calcConnectPoints(): Array {
			var paths: Array = linkModel.path.split(",");
			var cr: IConnectionRouter = createConnectionRouter();
			
			var sourceCtrl: NodeController = editor.findControllerByModel(linkModel.source) as NodeController;
			var targetCtrl: NodeController = editor.findControllerByModel(linkModel.target) as NodeController;
			
			var pts: Array = cr.route(sourceCtrl.controllerToEditorRect(linkModel.source.bounds),
									  sourceCtrl.controllerToEditor(linkModel.source.connectAnchorToPoint(paths[0])), 
									  linkModel.sourceAnchor,
									  targetCtrl.controllerToEditorRect(linkModel.target.bounds),
									  targetCtrl.controllerToEditor(linkModel.target.connectAnchorToPoint(paths[paths.length - 1])),
									  linkModel.targetAnchor);
									  
			return pts;
		}

		//----------------------------------------------------------------------
		// Event handlers
		//----------------------------------------------------------------------
		
		protected function linkChanged(event: LinkChangeEvent): void {
			refreshView();
		}
	}
}