package com.maninsoft.smart.workbench.common.property
{
	import com.maninsoft.smart.workbench.common.property.page.PropertyPageItem;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import mx.containers.HBox;
	import mx.controls.CheckBox;
	
	/**
	 * 콤보박스를 이용한 프로퍼티 에디터의 기반 클래스
	 */
	public class CheckBoxPropertyEditor extends HBox implements IPropertyEditor	{
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _pageItem: PropertyPageItem;
		private var checkBox:CheckBox = new CheckBox();
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		public function CheckBoxPropertyEditor() {
			super();
			
			checkBox.setStyle("fillAlphas", [1, 1]);
			checkBox.setStyle("fillColors", [0xffffff, 0xffffff]);
			checkBox.setStyle("fontWeight", "normal");
			checkBox.setStyle("paddingLeft", 1);
//			checkBox.setStyle("paddingTop", );
			checkBox.setStyle("paddingBottom", 7);
			checkBox.setStyle("cornerRadius", 0);

			// css로 처리할 것.
			checkBox.setStyle("fontFamily", "Tahoma");
			checkBox.setStyle("fontSize", 11);
			this.addChild(checkBox);
		}

		//----------------------------------------------------------------------
		// IPropertyEditor
		//----------------------------------------------------------------------
		
		/**
		 * 편집기를 표시하고 입력 가능한 상태로 만든다.
		 */
		public function activate(pageItem: PropertyPageItem): void {
			_pageItem = pageItem;
			
			checkBox.label = pageItem.propInfo.displayName;
			this.visible = true;
			this.setFocus();

			checkBox.addEventListener(MouseEvent.CLICK, doClick);
			checkBox.addEventListener(KeyboardEvent.KEY_DOWN, doKeyDown);
		}
		
		/**
		 * 편집기를 숨긴다.
		 */
		public function deactivate(): void {
			this.visible = false;

			checkBox.removeEventListener(MouseEvent.CLICK, doClick);
			checkBox.removeEventListener(KeyboardEvent.KEY_DOWN, doKeyDown);
		}
		
		/**
		 * 편집기에 값을 가져오거나 설정한다.
		 */
		public function get editValue(): Object {
			return checkBox.selected;
		}
		
		public function set editValue(value: Object): void {
			checkBox.selected = value;	
		}
		
		public function setBounds(x: Number, y: Number, width: Number, height: Number): void {
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
		}
		
		public function setEditable(val: Boolean): void {
			this.checkBox.enabled = val;
		}

		public function get isDialog(): Boolean {
			return false;
		}

		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/**
		 * pageItem
		 */
		protected function get pageItem(): PropertyPageItem {
			return _pageItem;
		}
		

		//----------------------------------------------------------------------
		// Event handlers
		//----------------------------------------------------------------------
		
		protected function doClick(event:MouseEvent): void {
			pageItem.acceptEditValue();
		}
		
		protected function doKeyDown(event: KeyboardEvent): void {
			if (event.keyCode == Keyboard.DOWN) {
				this.setFocus();
				event.stopImmediatePropagation();
			}
		}
	}
}