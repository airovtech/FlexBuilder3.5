////////////////////////////////////////////////////////////////////////////////
//  XPDLNodeController.as
//  2007.12.20, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.controller
{
	import com.maninsoft.smart.modeler.controller.Controller;
	import com.maninsoft.smart.modeler.controller.NodeController;
	import com.maninsoft.smart.modeler.editor.SelectionManager;
	import com.maninsoft.smart.modeler.model.events.NodeChangeEvent;
	import com.maninsoft.smart.modeler.view.NodeView;
	import com.maninsoft.smart.modeler.xpdl.XPDLEditor;
	import com.maninsoft.smart.modeler.xpdl.controller.tool.LinkByTargetTool;
	import com.maninsoft.smart.modeler.xpdl.model.base.XPDLNode;
	import com.maninsoft.smart.modeler.xpdl.view.base.XPDLNodeView;
	
	import flash.geom.Rectangle;
	
	/**
	 * XPDLNode 모델의 컨트롤러 base
	 */
	public class XPDLNodeController extends NodeController {
		
		//----------------------------------------------------------------------
		// Internal variables
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Property variables
		//----------------------------------------------------------------------

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function XPDLNodeController(model: XPDLNode) {
			super(model);
		}
		

		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/** 
		 * Property model
		 */
		public function get xpdlNode(): XPDLNode {
			return super.model as XPDLNode;
		}


		//----------------------------------------------------------------------
		// Virtual methods
		//----------------------------------------------------------------------
		
		/**
		 * XPDL 노드라면 공통적으로 갖게 되는 컨트롤러 툴들을 생성한다.
		 */
		protected function createCommonTools(): Array {
			return [new LinkByTargetTool(this)];
			
			/*
			var tools: Array = [];
			
			tools.push(new LinkByTargetTool(this));
			
			return tools;
			*/
		}

		
		//------------------------------
		// ITextEditable
		//------------------------------
		
		override public function canModifyText(): Boolean {
			return true;
		}

		override public function getEditText(): String {
			return XPDLNode(model).name;
		}
		
		override public function setEditText(value: String): void {
			XPDLNode(model).name = value;
		}
		
		override public function getTextEditBounds(): Rectangle {
			var r: Rectangle = controllerToEditorRect(nodeModel.bounds);
			
			r.y += (r.height - 21) / 2;
			r.height = 21;
			r.inflate(-2, 0);
			
			return r;
		}

		//----------------------------------------------------------------------
		// Overriden Methods
		//----------------------------------------------------------------------
		
		override protected function initNodeView(nodeView: NodeView): void {
			super.initNodeView(nodeView);
			
			var view: XPDLNodeView = nodeView as XPDLNodeView;
			var node: XPDLNode = nodeModel as XPDLNode;

			view.borderColor = node.borderColor;
			view.fillColor = node.fillColor; 
			view.textColor = node.textColor;
			view.showShadowed = node.shadow;
			view.showGradient = node.gradient;
		}

		override public function canConnect(): Boolean {
			return true;
		}
		
		override public function canConnectWith(source: Controller): Boolean {
			return true;
		}
		
		override protected function nodeChanged(event: NodeChangeEvent): void {
			var v: XPDLNodeView = view as XPDLNodeView;
			var m: XPDLNode = model as XPDLNode;

			switch (event.prop) {
				case XPDLNode.PROP_BORDERCOLOR:
					v.borderColor = m.borderColor;
					refreshView();
					break;
					
				case XPDLNode.PROP_FILLCOLOR:
					v.fillColor = m.fillColor;
					refreshView();
					break;
					
				case XPDLNode.PROP_TEXTCOLOR:
					v.textColor = m.textColor;
					refreshView();
					break;
					
				case XPDLNode.PROP_SHADOW:
					v.showShadowed = m.shadow;
					refreshView();
					break;
					
				case XPDLNode.PROP_GRADIENT:
					v.showGradient = m.gradient;
					refreshView();
					break;
				
				default:
					super.nodeChanged(event);
			}
		}

		override public function showTools(): Boolean {
			return super.showTools();
		}

		//----------------------------------------------------------------------
		// Internal properties
		//----------------------------------------------------------------------
		
		protected function get xpdlEditor(): XPDLEditor {
			return editor as XPDLEditor;
		}
		
		protected function get selManager(): SelectionManager {
			return editor.selectionManager;
		} 
	}
}