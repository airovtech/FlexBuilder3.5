////////////////////////////////////////////////////////////////////////////////
//  DiagramTree.as
//  2008.02.27, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.navigator
{
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
	import com.maninsoft.smart.modeler.xpdl.model.pool.Lane;
	
	import flash.display.DisplayObject;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import mx.controls.TextInput;
	import mx.controls.Tree;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.ClassFactory;
	import mx.events.ListEvent;
	import mx.events.ListEventReason;
	
	/**
	 * 다이어그램 요소들을 트리형태로 표시하고, 추가/삭제도 가능하게 한다.
	 */
	public class DiagramTree extends Tree {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		private var _root: DiagramTreeRoot;
		
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function DiagramTree() {
			super();
			
			// context menu를 해킹하기 위해... DiagramTreeItemRenderer 참조.
			itemRenderer = new ClassFactory(DiagramTreeItemRenderer);
			itemEditor = new ClassFactory(DiagramTreeItemEditor);
			
			//this.labelField = "label";
			this.labelFunction = getNodeLabel;
			this.iconFunction = getNodeIcon;
			this.editable = false;
			
			setStyle("paddingRight", 2);
			setStyle("selectionColor", 0xdddddd);
			setStyle("useRollOver", false);
			setStyle("selectionDuration", 0);
			setStyle("paddingTop", 1);
			setStyle("paddingBottom", 1);
			
			//variableRowHeight = true; 
			//wordWrap = false;
			
			addEventListener(ListEvent.ITEM_EDIT_END, doItemEditEnd);
			addEventListener(ListEvent.CHANGE, doChange);
		}

		
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		protected function get rootNode(): DiagramTreeRoot {
			return _root;
		}
		
		/**
		 * diagram
		 */
		private var _diagram: XPDLDiagram;

		public function get diagram(): XPDLDiagram {
			return _diagram;
		}
		
		public function set diagram(value: XPDLDiagram): void {
			if (value == _diagram)
				return;
				
			_diagram = value;
			refresh();
		}

		/**
		 * currentLane
		 */
		public function get currentLane(): Lane {
			if (selectedItem is DiagramTreeLane)
				return DiagramTreeLane(selectedItem).lane;
				
			return null;
		}
		
		public function set currentLane(value: Lane): void {
			if (currentLane != value)
				selectedItem = _root.getLaneItem(value);
		}

		/**
		 * currentItem
		 * diagram에서 선택된 diagram object와 트리의 선택을 동기화 한다.
		 */
		public function get currentActivity(): Activity {
			if (selectedItem is DiagramTreeActivity)
				return DiagramTreeActivity(selectedItem).activity;
				
			return null;
		}
		 
		public function set currentActivity(value: Activity): void {
			if (currentActivity != value) {
				selectedItem = _root.getActivityItem(value);
			}
		}
		
		/**
		 * true로 설정하면 선택된 셀을 마우스 클릭하면 편집 상태가 된다.
		 */
		public var clickEditing: Boolean = true;

		
		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------
		
		public function refresh(): void {
			_root = createTreeRoot();
			
			if (_root) {
				dataProvider = _root;
				// validateNow 하지 않으면 아래 펼치기가 동작하지 않는다. 도움말 참조.
				validateNow();
				
				this.expandChildrenOf(_root, true);
				//this.expandItem(root, true);
				this.selectedIndex = 0;
			}
		}
		

		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override public function isItemEditable(data:Object):Boolean {
			if (data is DiagramTreeNode)
				return DiagramTreeNode(data).editable;
			else				
				return super.isItemEditable(data);
		}
		
		/**
		 * 현재 선택된 row를 클릭하면 편집 상태로 만든다. (마우스 다운 되었을때 에디터 하지 못하게 주석처리함 -안성호-)
		 */
	    override protected function mouseDownHandler(event: MouseEvent): void {
	    	if (clickEditing) {
		    	var r: IListItemRenderer = mouseEventToItemRenderer(event);
		    	
		    	if (r &&  r != itemEditorInstance && 
		    		itemRendererToIndex(r) == selectedIndex && isItemEditable(r.data)) {
					editedItemPosition = { rowIndex: this.selectedIndex };
					return;	
		    	}
		    }
	    
	    	super.mouseDownHandler(event);	
	    }


		/**
		 * 한번 클릭으로 편집 상태가 되는 것을 막는다.
		 * sdk List.as 참조.
		 */
	    override protected function mouseUpHandler(event: MouseEvent): void {
	    	//var r: IListItemRenderer = mouseEventToItemRenderer(event);
	    	//editable = r && itemRendererToIndex(r) == selectedIndex;
	    	editable = false;
	    	super.mouseUpHandler(event);
	    	//editable = true;
	    }
		
		/**
		 * F2 키를 누르면 선택된 아이템을 편집 상태로 만든다.
		 * 루트 노드는 편집할 수 없다.
		 */
	    override protected function keyDownHandler(event: KeyboardEvent):void {
	        if (itemEditorInstance)
	            return;
	
			if (event.keyCode == Keyboard.F2) {
				editedItemPosition = { rowIndex: this.selectedIndex };	
				return;
			}
	
	        super.keyDownHandler(event);
	    }

		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
		
		public function getNodeLabel(node: Object): String {
			return DiagramTreeNode(node).label;
		}
		
		public function getNodeIcon(node: Object): Class {
			return DiagramTreeNode(node).icon;
		}

		protected function createTreeRoot(): DiagramTreeRoot {
			return new DiagramTreeRoot(diagram);
		}

		//----------------------------------------------------------------------
		// Event handlers
		//----------------------------------------------------------------------
		
		protected function doChange(event: ListEvent): void {
			if (selectedItem is DiagramTreeProxy) {
				editedItemPosition = { rowIndex: this.selectedIndex };	
			}
		}
		
		protected function doItemEditEnd(event: ListEvent): void {
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
				}
				
				destroyItemEditor();
				setFocus();	
			}
		}
		
		protected function processLane(node: DiagramTreeLane, value: String): void {
		}
		
		protected function processActivity(node: DiagramTreeActivity, value: String): void {
		}
		
		protected function processLaneProxy(node: DiagramTreeProxy, value: String): void {
		}
		
		protected function processActivityProxy(node: DiagramTreeLane, value: String): void {
		}

	    override public function createItemEditor(colIndex:int, rowIndex:int):void {
	    	super.createItemEditor(colIndex, rowIndex);
	    	
	    	//TextInput(itemEditorInstance).textField.alwaysShowSelection = false;
	    	DisplayObject(itemEditorInstance).addEventListener(KeyboardEvent.KEY_DOWN, editorKeyDownHandler);
	    }

	    private function editorKeyDownHandler(event:KeyboardEvent):void {
	        switch (event.keyCode)
	        {
	            case Keyboard.UP:
	            case Keyboard.DOWN:
	            case Keyboard.PAGE_UP:
	            case Keyboard.PAGE_DOWN:
		    		endEdit(ListEventReason.CANCELLED);
		    		event.stopImmediatePropagation();
	    			this.keyDownHandler(event);
	    			break;
	    			
	    		default:
	    			break;
	        }
	    }
	}
}