
package com.maninsoft.smart.workbench.common.property.page
{
	import com.maninsoft.smart.common.dialog.AbstractDialog;
	import com.maninsoft.smart.workbench.common.property.CheckBoxPropertyInfo;
	import com.maninsoft.smart.workbench.common.property.IPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.IPropertyInfo;
	import com.maninsoft.smart.workbench.common.property.IPropertySource;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.managers.CursorManager;
	import mx.managers.PopUpManager;
	
	
	[Event(name="sourceChanged", type="flash.events.Event")]
	[Event(name="selectionChanged", type="flash.events.Event")]
	[Event(name="propertyChanged", type="flash.events.Event")]
	
	/**
	 * 선택된 IPropertySource의 속성들을 표시하고,
	 * 개별 속성들의 IPropertyEditor를 이용 속성값을 편집할 수 있도록 하는 컴포넌트
	 */  
	public class PropertyPage_old extends AbstractDialog implements IPropertyPage {

		//----------------------------------------------------------------------
		// Event consts
		//----------------------------------------------------------------------

		public static const SOURCE_CHANGED	: String = "sourceChanged";
		public static const SELECTION_CHANGED	: String = "selectionChanged";
		public static const PROPERTY_CHANGED	: String = "propertyChanged";
		

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _cursor: Class;
		public var viewName:String; //보여줄 속성 카테고리정보   general(일반속성 ), graphic(그래픽속성)
		public var isPopUped:Boolean = false;
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function PropertyPage_old() {
			super();
			
			setStyle("selectedColor", 0xeeeeee);
			
			this.viewName="general";
			
			// mouse
			addEventListener(MouseEvent.MOUSE_DOWN, doMouseDown);
			addEventListener(MouseEvent.MOUSE_OUT, doMouseOut);
			
			// keyboard
			addEventListener(KeyboardEvent.KEY_DOWN, doKeyDown);
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/**
		 * propSource
		 */
		private var _propSource: IPropertySource;

		public function get propSource(): IPropertySource {
			return _propSource;
		}
		
		public function set propSource(value: IPropertySource): void {
			if (_propSource) {
				clearItems();
			}			
			_propSource = value;
			
			if (_propSource) {
				createItems(_propSource);
			}	
			dispatchEvent(new Event(SOURCE_CHANGED));
		}
		
		/**
		 * PropertyPageItem array
		 */
		private var _items: Array;
		
		public function get items(): Array {
			return _items;
		}
		
		public function set items(value: Array): void{
			_items = value;
		}
		
		/**
		 * item count
		 */
		public function get count(): uint {
			return _items ? _items.length : 0;
		}
		
		/**
		 * labelWidth
		 */
		private var _labelWidth: int = 80;

		public function get labelWidth(): int {
			return _labelWidth;
		}
		
		public function set labelWidth(value: int): void {
			if (value != _labelWidth) {
				_labelWidth = value;
				invalidateProperties();
				invalidateDisplayList();
			}	
		}
		
		/**
		 * valueWidth
		 */
		private var _valueWidth: int = 150;

		public function get valueWidth(): int {
			return _valueWidth;
		}
		
		public function set valueWidth(value: int): void {
			if (value != _valueWidth) {
				_valueWidth = value;
				invalidateProperties();
				invalidateDisplayList();
			}	
		}
		
		/**
		 * lineHeight
		 */
		private var _lineHeight: int = 21;

		public function get lineHeight(): int {
			return _lineHeight;
		}
		
		public function set lineHeight(value: int): void {
			_lineHeight = value;
		}
		
		/**
		 * currentItem
		 */
		private var _currentItem: PropertyPageItem;

		public function get currentItem(): PropertyPageItem {
			return _currentItem;
		}
		
		public function set currentItem(value: PropertyPageItem): void {
			if (value != _currentItem) {
				if (_currentItem) {
					_currentItem.selected = false;
					_currentItem.hideEditor(true);
				}
				
				_currentItem = value;
				
				if (_currentItem) {
					_currentItem.selected = true;
					_currentItem.page = this;
				}

				dispatchEvent(new Event(SELECTION_CHANGED));
			}
		}
		
		/**
		 * currentIndex
		 */
		public function get currentIndex(): int {
			return _currentItem ? _currentItem.index : -1;
		}
		
		public function set currentIndex(value: int): void {
			currentItem = (value >= 0 && value < count) ? _items[value] : null;	
		}
		

		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------

		public function show(parent:DisplayObject, modal:Boolean):void{
			if(isPopUped) return;
			PopUpManager.addPopUp(this, parent, modal);
			isPopUped = true;
		}

		public function hide():void{
			if(!isPopUped) return;
			PopUpManager.removePopUp(this);
			isPopUped = false;
		}

		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override protected function close(event:Event=null):void{
			this.hide();
		}
		
		override protected function measure():void {
			super.measure();
		}

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number): void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}		


		//----------------------------------------------------------------------
		// Internal properties
		//----------------------------------------------------------------------
		
		protected function get cursor(): Class {
			return _cursor;
		}		
		
		protected function set cursor(value: Class): void {
			if (value != _cursor) {
				if (_cursor) {
					CursorManager.removeCursor(CursorManager.currentCursorID);
				}
				
				_cursor = value;
				
				if (_cursor) {
					CursorManager.setCursor(_cursor);
					CursorManager.currentCursorXOffset = -8;
					CursorManager.currentCursorYOffset = -8;
				}
			}	
		}
		

		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
		
		internal function setPropertyValue(propId: String, value: Object): void {
			propSource.setPropertyValue(propId, value);
		}
		
		/**
		 * pageItem들을 제거한다.
		 */
		protected function clearItems(): void {
			removeAllChildren();
			
			_items = null;
			_currentItem = null;
		}
		
		/**
		 * 설정된 propSoruce에 따라 pageItem들을 생성 추가한다.
		 */
		protected function createItems(source: IPropertySource): void {
			if (!source)
				return;
			
			var infos: Array = source.getPropertyInfos();
			
			if (!infos) return;
			
			_items = [];
			var idx: int = 0;			
			var item: PropertyPageItem;
			var checkBoxCnt:int = 0;
			var hBox:HBox;
			for each (var info: IPropertyInfo in infos) {
				var clazz: Class = info.pageItemClass;
				
				if (clazz)
					item = new clazz(this);
				else				
				 	item = new PropertyPageItem(this);
				
				if(viewName == "graphic"){
					if(info.displayName!="BorderColor" && info.displayName!="FillColor" && info.displayName!="TextColor" 
						&& info.displayName!="Shadow" && info.displayName!="Gradient"){
						continue;	
					}
				}else if(viewName == "general"){
					if(info.displayName=="BorderColor" || info.displayName=="FillColor" || info.displayName=="TextColor" || info.displayName=="startActivity"
						|| info.displayName=="Shadow" || info.displayName=="Gradient" || info.displayName=="Id" || info.displayName=="source"
						|| info.displayName=="target" || info.displayName=="path" || info.displayName=="laneId" || info.displayName=="HeadColor"){
						continue;
					}
				}
				
				if(info is CheckBoxPropertyInfo){
					checkBoxCnt++;
					if(checkBoxCnt==1){
						hBox = new HBox();
						hBox.height = lineHeight;
						hBox.percentWidth = 100;
						hBox.addChild(item);						
						contentBox.addChild(hBox);
					}else if(hBox && checkBoxCnt==2){
						hBox.addChild(item);									
					}else if(hBox && checkBoxCnt==3){
						hBox.addChild(item);									
						hBox=null;
						checkBoxCnt = 0;
					}
				}else{
					if(checkBoxCnt>0) checkBoxCnt = 0;
					hBox = new HBox();
					hBox.height = lineHeight;
					hBox.percentWidth = 100;
					hBox.addChild(item);
					contentBox.addChild(hBox);
					hBox=null;
				}

				_items.push(item);
				item.propInfo = info;
				item.index = idx++;
				item.height = lineHeight;
				item.percentWidth = 100;
				item.editValue = source.getPropertyValue(info.id);
				item.activate();
			}
		}
		
		protected function findItem(propId: String): PropertyPageItem {
			for each (var item: PropertyPageItem in _items) {
				if (item.propInfo.id == propId)
					return item;
			}
			
			return null;
		}

		//----------------------------------------------------------------------
		// Event handlers
		//----------------------------------------------------------------------
		
		protected function doMouseDown(event: MouseEvent): void {
			function isPropertyEditor(): Boolean {
				var d: DisplayObject = event.target as DisplayObject;
				
				while (d) {
					if (d is IPropertyEditor)
						return true;
						
					d = d.parent;
				}
				
				return false;
			}
			
			if (!isPropertyEditor())
				this.setFocus();

			event.updateAfterEvent();
		}
			
		protected function doMouseOut(event: MouseEvent): void {
			cursor = null;
		}
			
		protected function doKeyDown(event: KeyboardEvent): void {
			switch (event.keyCode) {
				case Keyboard.DOWN:
					currentIndex = Math.min(count - 1, currentIndex + 1);
					break;
				
				case Keyboard.UP:
					currentIndex = Math.max(0, currentIndex - 1);
					break;

				case Keyboard.ENTER:
					if (currentItem) {
						if (currentItem.isEditorVisible())
							currentItem.hideEditor(true);
						else
							currentItem.showEditor();
					}
						
					break;
			}
		}
	}
}