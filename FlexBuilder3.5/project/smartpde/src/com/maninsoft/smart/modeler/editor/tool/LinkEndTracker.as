////////////////////////////////////////////////////////////////////////////////
//  LinkEndTracker.as
//  2007.12.29, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.editor.tool
{
	import com.maninsoft.smart.modeler.command.Command;
	import com.maninsoft.smart.modeler.command.LinkPathChangeCommand;
	import com.maninsoft.smart.modeler.common.LinkPathUtils;
	import com.maninsoft.smart.modeler.controller.NodeController;
	import com.maninsoft.smart.modeler.editor.handle.ConnectHandle;
	import com.maninsoft.smart.modeler.editor.handle.LinkEndHandle;
	import com.maninsoft.smart.modeler.model.Link;
	import com.maninsoft.smart.modeler.view.NodeView;
	import com.maninsoft.smart.modeler.view.connection.IConnectionRouter;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * 링크의 양 끝점을 이동시키는 tracker
	 */
	public class LinkEndTracker extends ControllerDragTracker {
		
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		/** Storage for handle */
		private var _handle: LinkEndHandle;
		/** feedback view */
		private var _view: Sprite;
		private var _router: IConnectionRouter;

		private var _current: NodeController;
		private var _source: NodeController;
		private var _target: NodeController;
		private var _sourceAnchor: Number;
		private var _targetAnchor: Number;
		private var _sourcePoint: Point;

		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function LinkEndTracker(handle: LinkEndHandle) {
			super(handle.controller);
			
			_handle = handle;
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function activate(): void {
			super.activate();
			
			_current = null;
			_source = null;
			_target = null;
			_router = editor.getCurrentConnectionRouter();
		}
		
		override public function deactivate(): void {
			if (_current)
				_current.hideConnectFeedback();
			
			_current = null;
			_source = null;
			_target = null;
			_router = null;

			super.deactivate();
		}

		override protected function startDrag(target: Object): Boolean {
			_source = handle.opposite.nodeController;
			_sourceAnchor = handle.opposite.linkAnchor;
			_target = null;
			
			_sourcePoint = new Point(handle.opposite.x, handle.opposite.y);

			_view = new Sprite();
			renderView(handle.x, handle.y, null);
			editor.getFeedbackLayer().addChild(_view);
			
			return true;
		}
		
		override protected function drag(target: Object): Boolean {
			if (target is NodeView) {
				current = editor.findControllerByView(target as NodeView) as NodeController;
			} 

			if (target is ConnectHandle)			
				renderView(currentX, currentY, target as ConnectHandle);
			else
				renderView(currentX, currentY, null);
				
			return true;
		}
		
		
		override protected function endDrag(target: Object): Boolean {
			if (_view) {
				editor.getFeedbackLayer().removeChild(_view);
				_view = null;
			}

			_source.hideConnectFeedback();

			var handle: ConnectHandle = target as ConnectHandle;
			
			if (!handle)
				return false;

			handle.controller.hideConnectFeedback();

			_current = null;
			_target = handle.controller;
			_targetAnchor = handle.anchor;
			
			return true;
		}

		override protected function performCompleted(): void {
			handle.controller.refreshSelection();
		}
		
		override protected function performCanceled(): void {
		}
		
		override protected function getCommand(): Command {
			var path: String = LinkPathUtils.makePath(handle.isSourceEdge ? _targetAnchor : _sourceAnchor, 
			                                          handle.isSourceEdge ? _sourceAnchor : _targetAnchor);
			
			return new LinkPathChangeCommand(_handle.controller.model as Link, path);
		}
		
		private function renderView(x: int, y: int, connHandle: ConnectHandle): void {
			var g: Graphics = _view.graphics;
			
			g.clear();
			
			var pts: Array;
			
			if (connHandle != null) {
				if (handle.isSourceEdge) {
					pts = _router.route(connHandle.controller.bounds, new Point(connHandle.x, connHandle.y), connHandle.anchor,
							            _source.bounds, _sourcePoint, _sourceAnchor);
				} else {
					pts = _router.route(_source.bounds, _sourcePoint, _sourceAnchor,
										connHandle.controller.bounds, new Point(connHandle.x, connHandle.y), connHandle.anchor);
				}
			} else {
				pts = _router.route(null, _sourcePoint, 0, null, new Point(x, y), 0);
			}
			
			for (var i: int = 1; i < pts.length; i++) {
				g.lineStyle(2, 0x000000);
				g.moveTo(pts[i - 1].x, pts[i - 1].y);
				g.lineTo(pts[i].x, pts[i].y);
			}
		}

		//----------------------------------------------------------------------
		// Internal properties
		//----------------------------------------------------------------------
		
		protected function get handle(): LinkEndHandle {
			return _handle;
		}

		/**
		 * Current controller
		 */
		public function get current(): NodeController {
			return _current;
		}
		
		public function set current(value: NodeController): void {
			if (value) {
				if (!value.canConnect() || !value.canConnectWith(_source))
					value = null;
			}			
			
			if (value != _current) {
				if (_current && (_current != _source))
					_current.hideConnectFeedback();
					
				_current = value;
				
				if (_current && (_current != _source))
					_current.showConnectFeedback();
			}
		}
	}
}