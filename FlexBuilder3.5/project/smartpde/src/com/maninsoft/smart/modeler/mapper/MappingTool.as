////////////////////////////////////////////////////////////////////////////////
//  ConnectionTool.as
//  2008.01.09, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.mapper
{
	import com.maninsoft.smart.modeler.common.ComponentUtils;
	import com.maninsoft.smart.modeler.editor.DiagramEditor;
	import com.maninsoft.smart.modeler.editor.tool.AbstractTool;
	import com.maninsoft.smart.modeler.editor.tool.DragTracker;
	import com.maninsoft.smart.modeler.editor.tool.IDraggable;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	/**
	 * 두 태스크 간 데이터 매핑을 하는 tool
	 */
	public class MappingTool extends AbstractTool	{

		//----------------------------------------------------------------------
		// Class constants
		//----------------------------------------------------------------------

		public static const STATE_READY    	   	: int = 0;
		public static const STATE_CONNECT_STARTED	: int = 1;
		public static const STATE_CONNECTED   	: int = 2;
		public static const STATE_CANCELED    	: int = 3;


		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _sourcePanel: SmartMappingPanel;
		private var _targetPanel: SmartMappingPanel;
		private var _linkViews: Array;
		
		private var _dragTracker: DragTracker;
		private var _state: int;
		
		private var _connectSource: SmartMappingPanelItem;
		private var _connectTarget: SmartMappingPanelItem;;
		private var _connectView: Sprite;


		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function MappingTool(editor: DiagramEditor) {
			super(editor);

			_sourcePanel = new SmartMappingPanel(editor, SmartMappingPanel.SOURCE_PANEL);
			_sourcePanel.fillColor = 0xeaeaea;
			
			_sourcePanel.addEventListener("moved", panelMoved);
			_sourcePanel.addEventListener("headClick", panelHeadClick);

			_targetPanel = new SmartMappingPanel(editor, SmartMappingPanel.TARGET_PANEL);
			_targetPanel.fillColor = 0xeaea00;
			
			_targetPanel.addEventListener("moved", panelMoved);
			_targetPanel.addEventListener("headClick", panelHeadClick);
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		/**
		 * source
		 */
		public function get source(): IMappingSource {
			return sourcePanel.mapSource;
		}

		/**
		 * target
		 */
		public function get target(): IMappingSource {
			return targetPanel.mapSource;
		}
		
		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------

		public function show(source: IMappingSource, target: IMappingSource): void {
			sourcePanel.mapSource = source;
			targetPanel.mapSource = target;
			
			// load links
			for each (var link: IMappingLink in target.getMappingLinks(source)) {
				if (link && link.sourceItem && link.targetItem)
					addLinkView(link);
			}
		}

		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override public function activate(): void {
			super.activate();

			_sourcePanel.refresh();
			feedbackLayer.addChild(_sourcePanel);

			_targetPanel.refresh();
			feedbackLayer.addChild(_targetPanel);
		}

		override public function deactivate(): void {
			feedbackLayer.removeChild(_sourcePanel);
			feedbackLayer.removeChild(_targetPanel);
			ComponentUtils.clearChildrenByType(feedbackLayer, SmartMappingLinkView);
			
			super.deactivate();
		}
		
		override protected function acceptAbort(): Boolean {
			/**
			 * 드래깅 중이 아닐 때 esc를 누르면 tool을 종료시킨다.
			 */
			if (_state == STATE_CONNECT_STARTED) {
				endConnection(null);
				_state = STATE_CANCELED;
			
				return false;
			}
			
			return !_dragTracker;
		}

		override public function mouseDown(event: MouseEvent): void {
			super.mouseDown(event);
			
			_dragTracker = null;

			if (_state == STATE_CANCELED || _state == STATE_CONNECTED)
				_state = STATE_READY;
			
			// panle link
			if (event.target is SmartMappingLinkView) {
				var link: SmartMappingLinkView = event.target as SmartMappingLinkView;
				link.selected = !link.selected;				
			}
			// panel item
			else if (event.target is SmartMappingPanelItem) {
				if (_state == STATE_READY) {
					if (startConnection(event.target as SmartMappingPanelItem)) {
						_state = STATE_CONNECT_STARTED;
					}
				} else if (_state == STATE_CONNECT_STARTED) {
					endConnection(event.target as SmartMappingPanelItem);
					_state = STATE_CONNECTED;
				}
			} 
			else if (_state == STATE_CONNECT_STARTED) {
				endConnection(null);
				_state = STATE_CANCELED;
			}
			else if (event.target is IDraggable) {
				_dragTracker = IDraggable(event.target).getDragTracker(event);		
			
				if (_dragTracker) {
					_dragTracker.activate();
					_dragTracker.mouseDown(event);
				}
			} 
		}

		override public function mouseMove(event: MouseEvent): void {
			super.mouseMove(event);

			if (_dragTracker) {
				_dragTracker.mouseMove(event);
			} else if (_state == STATE_CONNECT_STARTED) {
				doConnect();
			}
		}
		
		override public function mouseUp(event: MouseEvent): void {
			super.mouseUp(event);
			
			if (_dragTracker) {
				_dragTracker.mouseUp(event);
				_dragTracker.deactivate();
				_dragTracker = null;
			}
		}

		override public function keyDown(event: KeyboardEvent): void {
			super.keyDown(event);
			
			switch (event.keyCode) {
				case Keyboard.DELETE:
					deleteSelectedLinks();
					break;
			}
		}
		
		override public function keyUp(event: KeyboardEvent): void {
			super.keyUp(event);	
		}


		//----------------------------------------------------------------------
		// Internal properties
		//----------------------------------------------------------------------
		
		protected function get sourcePanel(): SmartMappingPanel {
			return _sourcePanel;
		}
		
		protected function get targetPanel(): SmartMappingPanel {
			return _targetPanel;
		}


		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
		
		protected function startConnection(item: SmartMappingPanelItem): Boolean {
			if (item && item.panel.panelType == SmartMappingPanel.SOURCE_PANEL) {
				_connectSource = item;
				_connectTarget = null;
				
				if (!_connectView) {
					_connectView = new Sprite();
				}
				
				feedbackLayer.addChild(_connectView);
				renderConnection(_connectSource.connectPoint, new Point(editor.zoomedX, editor.zoomedY));
				return true;
			}
			
			return false;
		}
		
		protected function doConnect(): void {
			trace("doConnect: " + editor.zoomedX + ", " + editor.zoomedY);
			renderConnection(_connectSource.connectPoint, new Point(editor.zoomedX, editor.zoomedY));
		}
		
		protected function endConnection(item: SmartMappingPanelItem): void {
			feedbackLayer.removeChild(_connectView);
			
			if (item) {
				_connectTarget = item;
				
				// 타깃 쪽에 링크를 추가한다.
				var link: IMappingLink = targetPanel.mapSource.addMappingLink(_connectSource.item, _connectTarget.item);
				
				addLinkView(link);
			}
		}
		
		protected function renderConnection(pFrom: Point, pTo: Point): void {
			if (_connectView) {
				var g: Graphics = _connectView.graphics;
				g.clear();
				
				g.lineStyle(2, 0x000000);
				g.moveTo(pFrom.x, pFrom.y);
				g.lineTo(pTo.x - 1, pTo.y - 1);
				//g.curveTo(Math.min(pFrom.x, pTo.x) + Math.abs(pFrom.x - pTo.x) / 2, 
				//          Math.min(pFrom.y, pTo.y) - 20,
				//          pTo.x, pTo.y);
			}	
		}
		
		protected function addLinkView(link: IMappingLink): void {
			var view: SmartMappingLinkView = new SmartMappingLinkView(link,
			                                                         sourcePanel.findItem(link.sourceItem),
																     targetPanel.findItem(link.targetItem));
			feedbackLayer.addChild(view);
		}

		//----------------------------------------------------------------------
		// Event handlers - panel
		//----------------------------------------------------------------------
		
		private function panelMoved(event: Event): void {
			var layer: Sprite = feedbackLayer;
			
			for (var i: int = 0; i < layer.numChildren; i++) {
				if (layer.getChildAt(i) is SmartMappingLinkView) {
					SmartMappingLinkView(layer.getChildAt(i)).refresh();
				}				
			}
		}
		
		private function panelHeadClick(event: Event): void {
			editor.resetTool();
		}
		
		private function deleteSelectedLinks(): void {
			var layer: Sprite = feedbackLayer;
			
			for (var i: int = layer.numChildren - 1; i >= 0; i--) {
				if (layer.getChildAt(i) is SmartMappingLinkView) {
					var linkView: SmartMappingLinkView = layer.getChildAt(i) as SmartMappingLinkView;
					
					if (linkView.selected) {
						layer.removeChildAt(i);
						targetPanel.mapSource.removeMappingLink(linkView.link);
					}
				}				
			}
		}
	}
}