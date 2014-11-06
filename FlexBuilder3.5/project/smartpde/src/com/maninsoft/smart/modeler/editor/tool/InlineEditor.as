////////////////////////////////////////////////////////////////////////////////
//  InlineEditor.as
//  2008.01.07, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.editor.tool
{
	import com.maninsoft.smart.modeler.controller.ITextEditable;
	import com.maninsoft.smart.modeler.editor.DiagramEditor;
	
	import flash.geom.Rectangle;
	
	import mx.controls.TextArea;
	
	/**
	 * 선택된 개체의 텍스트를 편집하는 에디터
	 */
	public class InlineEditor extends TextArea {

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
	
		private var _target: ITextEditable;
		private var _editor: DiagramEditor;
		

		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
	
		public function InlineEditor(editor: DiagramEditor) {
			super();

			_editor = editor;
		
			this.border = null;	
		}
		
		override protected function createChildren(): void {
			super.createChildren();
			// 한글 입력 빠르게
			textField.alwaysShowSelection = true;
		}

		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		public function get target(): ITextEditable {
			return _target;
		}
		

		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------
		
		public function show(editTarget: ITextEditable): Boolean {
			_target = editTarget;
			
			if (_target && _target.canModifyText()) {
				var r: Rectangle = _target.getTextEditBounds();
				
				this.x = r.x;
				this.y = r.y;
				this.width = r.width;
				this.height = r.height;
				
				this.text = _target.getEditText();
								
				this.setStyle("textAlign", "center");
				this.setStyle("fontSize", _editor.getStyle("fontSize"));
				
				
				this.visible = true;
				this.setFocus();
				this.textField.setSelection(0, 1000000);
				
				
				return true;
			}
			
			return false;
		}
		
		public function hide(accept: Boolean): Boolean {
			if (visible) {
				if (accept)
					target.setEditText(this.text);
				
				visible = false;
				_editor.setFocus();
				
				return true;
			} else {
				return false;
			}
		}
	}
}