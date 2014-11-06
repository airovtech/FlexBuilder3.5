////////////////////////////////////////////////////////////////////////////////
//  TaskUserController.as
//  2007.12.13, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.controller
{
	import com.maninsoft.smart.modeler.model.events.NodeChangeEvent;
	import com.maninsoft.smart.modeler.view.IView;
	import com.maninsoft.smart.modeler.view.NodeView;
	import com.maninsoft.smart.modeler.xpdl.controller.tool.NextTaskCreationTool;
	import com.maninsoft.smart.modeler.xpdl.model.TaskUser;
	import com.maninsoft.smart.modeler.xpdl.model.base.XPDLNode;
	import com.maninsoft.smart.modeler.xpdl.view.TaskUserView;
	
	import flash.geom.Rectangle;
	
	/**
	 * Controller for TaskUser
	 */	
	public class TaskUserController extends TaskController {
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function TaskUserController(model: TaskUser) {
			super(model);
		}


		//----------------------------------------------------------------------
		// Overriden Methods
		//----------------------------------------------------------------------
		
		override protected function createNodeView(): NodeView {
			return new TaskUserView();
		}
		
		override protected function initNodeView(nodeView:NodeView): void {
			super.initNodeView(nodeView);
		}

		override protected function createTools(): Array {
			var tools: Array = [];
			
			tools.push(new NextTaskCreationTool(this));
			
			return tools.concat(createCommonTools());
		}
		
		override protected function nodeChanged(event: NodeChangeEvent): void {
			var v: TaskUserView = view as TaskUserView;
			var m: TaskUser = model as TaskUser;
			
			switch (event.prop) {
				case XPDLNode.PROP_NAME:
					v.text = m.name;
					v.draw();
					break;
					
				default:
					super.nodeChanged(event);
			}
		}
		
		//------------------------------
		// ITextEditable
		//------------------------------
		override public function canModifyText(): Boolean {
			return true;
		}

		override public function getEditText(): String {
			return TaskUser(model).name;
		}
		
		override public function setEditText(value: String): void {
			TaskUser(model).name = value;
		}
		
		override public function getTextEditBounds(): Rectangle {
			var r: Rectangle = controllerToEditorRect(nodeModel.bounds);
			
			r.y += (r.height - 21) / 2;
			r.height = 21;
			
			return r;
		}
	}
}