////////////////////////////////////////////////////////////////////////////////
//  AlignmentHelper.as
//  2008.03.11, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.editor.helper
{
	import com.maninsoft.smart.modeler.command.Command;
	import com.maninsoft.smart.modeler.command.GroupCommand;
	import com.maninsoft.smart.modeler.command.NodeMoveCommand;
	import com.maninsoft.smart.modeler.editor.DiagramEditor;
	import com.maninsoft.smart.modeler.model.Node;
	
	/**
	 * 정렬 도우미
	 */
	public class AlignmentHelper {
		
		//----------------------------------------------------------------------
		// Class constans
		//----------------------------------------------------------------------

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		private var _editor: DiagramEditor;
		

		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function AlignmentHelper(editor: DiagramEditor) {
			super();
			
			_editor = editor;
		}
		

		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------
		
		public function getCommand(alignType: String, value: Number): Command {
			var nodes: Array  = _editor.selectionManager.nodes;
			
			if (nodes.length < 2)
				return null;

			var grcmd: GroupCommand = new GroupCommand();
			var base: Node = nodes[0] as Node;
			
			for (var i: int = 1; i < nodes.length; i++) {
				var node: Node = nodes[i] as Node;
				var dx: Number = 0;
				var dy: Number = 0;
				
				switch (alignType) {
					case AlignmentTypes.ALIGN_LEFT:
						dx = base.x - node.x;
						break;

					case AlignmentTypes.ALIGN_RIGHT:
						dx = base.right - node.right;
						break;

					case AlignmentTypes.ALIGN_HCENTER:
						dx = base.center.x - node.center.x;
						break;

					case AlignmentTypes.ALIGN_TOP:
						dy = base.y - node.y;
						break;

					case AlignmentTypes.ALIGN_BOTTOM:
						dy = base.bottom - node.bottom;
						break;

					case AlignmentTypes.ALIGN_VCENTER:
						dy = base.center.y - node.center.y;
						break;

					case AlignmentTypes.ALIGN_XCENTER:
						dx = value - node.center.x;
						break;

					case AlignmentTypes.ALIGN_YCENTER:
						dy = value - node.center.y;
						break;
				}

				if (dx || dy)				
					grcmd.add(new NodeMoveCommand(node, dx, dy));
			}
			
			return grcmd;
		}

	}
}