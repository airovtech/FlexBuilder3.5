
package com.maninsoft.smart.workbench.common.property.page
{
	import com.maninsoft.smart.workbench.common.property.CheckBoxPropertyInfo;
	import com.maninsoft.smart.workbench.common.property.IPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.IPropertyInfo;
	
	import flash.display.DisplayObject;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import mx.core.UIComponent;
	
	/**
	 * PropertyPage에서 개별 속성을 담당한다.
	 */
	public class PropertyPageItem extends UIComponent {
		
		//--------------------------------------------------------------------
		// Class variables
		//----------------------------------------------------------------------

		private var _textFormat: TextFormat = new TextFormat("Tahoma", 11, 0x4c4c4c);
		private var _labelTextFormat: TextFormat = new TextFormat("Tahoma", 11, 0x4c4c4c, true);

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		public var _labelField: TextField;
		public var _valueField: DisplayObject;
		public var _editor: IPropertyEditor;
		
		private var _hideItemField:Boolean = false;
		private var _hideValueField:Boolean = false;
		private var _propertyPage:PropertyPage = null;

		public function get hideItemField():Boolean{
			return _hideItemField;
		}
		
		public function set hideItemField(value:Boolean):void{
			if(_hideItemField == value) return;

			_hideItemField = value;

			if(_hideItemField){
				this.showEditor();
				_labelField.visible = false;
				_valueField.visible = false;
			}
			else{
				_labelField.visible = true;
				_valueField.visible = true;
				this.hideEditor(true);
			}
		}

		public function get hideValueField():Boolean{
			return _hideValueField;
		}
		
		public function set hideValueField(value:Boolean):void{
			if(_hideValueField == value) return;

			_hideValueField = value;

			if(_hideValueField){
				this.showEditor();
				_labelField.visible = true;
				_valueField.visible = false;
			}
			else{
				_labelField.visible = true;
				_valueField.visible = true;
				this.hideEditor(true);
			}
		}

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function PropertyPageItem(page:PropertyPage) {
			super();
			_propertyPage = page;
		}

		override protected function createChildren(): void {
			super.createChildren();
			
			_labelField = new TextField();
			_labelField.mouseEnabled = false;
			_labelField.defaultTextFormat = _labelTextFormat;
			_labelField.wordWrap = true;
			_labelField.x = 0;
			_labelField.y = 2;
			addChild(_labelField);
						
			_valueField = createValueField();
			addChild(_valueField);
		}
		
		public function activate(): void {
			addEventListener(MouseEvent.MOUSE_DOWN, doMouseDown);
			addEventListener(KeyboardEvent.KEY_DOWN, doKeyDown);
		}
		
		public function deactivate(): void {
			removeEventListener(MouseEvent.MOUSE_DOWN, doMouseDown);
			removeEventListener(KeyboardEvent.KEY_DOWN, doKeyDown);
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/**
		 * ower
		 */
		public function get page(): PropertyPage {
			if(_propertyPage)
				return _propertyPage;
			return (parent.parent.parent) as PropertyPage;
		}

		public function set page(value:PropertyPage):void{
			_propertyPage = value;
		}

		/**
		 * index
		 */
		private var _index: int = -1;
		
		public function get index(): int{
			return _index;
		}
		
		public function set index(value: int): void{
			_index = value;
		}
		
		/**
		 * propInfo
		 */
		private var _propInfo: IPropertyInfo;

		public function get propInfo(): IPropertyInfo {
			return _propInfo;
		}
		
		public function set propInfo(value: IPropertyInfo): void {
			if (value != _propInfo) {
				if (_propInfo && !this.hideItemField) {
					removeChild(_propInfo.getEditor(page.propSource) as DisplayObject);
				}				
				
				_propInfo = value;

				if (_propInfo) {
					_labelField.text = _propInfo.displayName;
					if(_propInfo is CheckBoxPropertyInfo 
						|| _propInfo.displayName == resourceManager.getString("FormEditorETC", "hiddenItemText")
						|| _propInfo.displayName == resourceManager.getString("FormEditorETC", "readOnlyItemText")
						|| _propInfo.displayName == resourceManager.getString("FormEditorETC", "requiredItemText")){
						this.hideItemField = true;
					}else{
						this.hideValueField = true;
					}
				}
			}
			
		}
		
		/**
		 * editValue
		 */
		private var _editValue: Object;

		public function get editValue(): Object {
			return _editValue;
		}
		 
		public function set editValue(value: Object): void {
			if(editValue==value) return;
			_editValue = value;
			setValueField(value);
			if((hideItemField || hideValueField) && _editor){
				_editor.editValue = value;
			}
		}
		
		/**
		 * selected
		 */
		private var _selected: Boolean;

		public function get selected(): Boolean {
			return _selected;
		}
		
		public function set selected(value: Boolean): void {
			if (value != _selected) {
				_selected = value;
				invalidateDisplayList();
			}
		}
		

		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------
		
		public function isEditor(editor: Object): Boolean {
			return editor && (editor == _editor);
		}
		
		public function showEditor(): void {
			if (page && !isEditorVisible()) {
				if (!_editor) {
					_editor = propInfo.getEditor(page.propSource);	
				}
	
				resetEditorBounds();
				_editor.editValue = this.editValue;
				_editor.setEditable(propInfo.editable);
	
				addChild(_editor as DisplayObject);
				_editor.activate(this);
			}
		}
		
		public function acceptValue(value: Object):void{
			editValue = value;
			page.setPropertyValue(propInfo.id, editValue);
		}
		
		public function acceptEditValue(): void {
			editValue = _editor.editValue;
			page.setPropertyValue(propInfo.id, editValue);
		}

		public function hideEditor(accept: Boolean): void {
			if(this.hideItemField || this.hideValueField) return;
			
			if (isEditorVisible()) {
				if (page)
					page.setFocus();

				// 다이얼로그를 통한 설정일 경우 이미 accept되었다.
				if (!_editor.isDialog && accept) {
					acceptEditValue();
				}
				
				_editor.deactivate();
				removeChild(_editor as DisplayObject);
				invalidateDisplayList();
			}
		}

		protected function resetEditorBounds(): void {
			if(!this.hideItemField)
				_editor.setBounds(page.labelWidth+5, 0, page.valueWidth, page.lineHeight);
			else
				_editor.setBounds( 5, 0, page.labelWidth+page.valueWidth-5 , page.lineHeight);
		}

		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number): void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if (!page)
				return;
			
			_labelField.width = page.labelWidth;
			_labelField.height = this.height;
	
			updateValueField(page.labelWidth+5, 0, page.valueWidth, page.lineHeight, 0);
			
		}
		
		public function callUpdateDisplayList(unscaledWidth:Number, unscaledHeight:Number): void {
			updateDisplayList(unscaledWidth, unscaledHeight);
		}


		//----------------------------------------------------------------------
		// Internal properties
		//----------------------------------------------------------------------
		
		protected function get editor(): IPropertyEditor {
			return _editor;
		}
		
		protected function get valueField(): DisplayObject {
			return _valueField;
		}

		protected function get defaultTextFormat(): TextFormat {
			return _textFormat;
		}

		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------

		public function refreshEditor(): void {
			if (isEditorVisible()) {
				resetEditorBounds();
			}			
		}

		public function isEditorVisible(): Boolean {
			return _editor && contains(_editor as DisplayObject);
		}
		
		protected function createValueField(): DisplayObject {
			var fld: TextField = new TextField();
			fld.defaultTextFormat = _textFormat;			
			
			return fld;
		}

		protected function setValueField(value: Object): void {
			_valueField["text"] = propInfo.getText(value); 
		}
		
		protected function updateValueField(x: Number, y: Number, width: Number, height: Number, bgCol: uint): void {
			_valueField.x = x
			_valueField.y = y;
			_valueField.width = width;
			_valueField.height = height;
		}

		//----------------------------------------------------------------------
		// Event handlers
		//----------------------------------------------------------------------
		
		protected function doMouseDown(event: MouseEvent): void {
			page.currentItem = this;
			
			if (event.target == _valueField) {
				showEditor();
				event.stopImmediatePropagation();
			}
		}
		
		protected function doKeyDown(event: KeyboardEvent): void {
			switch (event.keyCode) {
				case Keyboard.ESCAPE:
					hideEditor(false);
					break;
			}		
		}
	}
}