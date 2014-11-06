package com.maninsoft.smart.modeler.xpdl.dialogs
{
	import com.maninsoft.smart.common.assets.DialogAssets;
	import com.maninsoft.smart.common.dialog.AbstractDialog;
	import com.maninsoft.smart.modeler.xpdl.XPDLEditor;
	import com.maninsoft.smart.modeler.xpdl.syntax.Problem;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import mx.controls.TextArea;
	import mx.managers.PopUpManager;
	import mx.resources.ResourceManager;

	public class ProblemDialog extends AbstractDialog
	{

		//----------------------------------------------------------------------
		// Class Variables
		//----------------------------------------------------------------------

		private static var _dialog: ProblemDialog;

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		[Bindable]
		private var _editor: XPDLEditor;
		private var _problem: Problem;
		private var _textBox:TextArea;

		//----------------------------------------------------------------------
		// Class methods
		//----------------------------------------------------------------------

		public function ProblemDialog()
		{
			super();
			this.showCancelButton=true;
			this.showCloseButton=true;
		}
			
		override protected function childrenCreated():void{
			_textBox = new TextArea();
			_textBox.percentHeight = 100;
			_textBox.percentWidth = 100;
			_textBox.editable = false;
			_textBox.styleName="problemDialogTextBox";
			contentBox.addChild(_textBox);
		}

		public static function execute(problem: Problem, editor: XPDLEditor, position: Point=null, width:Number=0, height:Number=0): void {
			_dialog = PopUpManager.createPopUp(editor, ProblemDialog, true) as ProblemDialog;
			PopUpManager.centerPopUp(_dialog);

			_dialog._problem = problem;
			_dialog._editor = editor;
			_dialog.title = ResourceManager.getInstance().getString("ProcessEditorETC", "problemText");
			if(position){
				_dialog.x = position.x;
				_dialog.y = position.y;
			}else{
				PopUpManager.centerPopUp(_dialog);	
			}

			if(width) _dialog.width = width;
			if(height) _dialog.height = height;
	
			_dialog.load();
		}

		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------

		private function load(): void {
			this.title = _problem.message;
			this._textBox.text = _problem.description;
			if(_problem.canFixUp){
				this.showOkButton=true;
				this.okButton.source = DialogAssets.fixUpButton;
			}else{
				this.showOkButton=false;				
			}
		}

		private function closeDialog(accept: Boolean = false): void {
			if (accept)
				_problem.fixUp(_editor);
		
			PopUpManager.removePopUp(this);
		}


		private function dlg_keyDown(event: KeyboardEvent): void {
			if (event.keyCode == Keyboard.ESCAPE)
				closeDialog(false);
		}	

		override protected function ok(event:Event = null):void {
			closeDialog(true);
		}
	}
}