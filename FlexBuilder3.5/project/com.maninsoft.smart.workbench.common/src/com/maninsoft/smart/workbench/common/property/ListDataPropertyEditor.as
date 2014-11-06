package com.maninsoft.smart.workbench.common.property
{
	import com.maninsoft.smart.workbench.common.assets.PropertyIconLibrary;
	import com.maninsoft.smart.workbench.common.property.page.PropertyPageItem;
	
	import flash.events.MouseEvent;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.containers.BoxDirection;
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.Button;
	import mx.controls.List;
	import mx.core.ScrollPolicy;
	
	/**
	 * 버튼을 클릭한 후 표시되는 다이얼로그 등을 통해 속성을 편집하는 에디터
	 */
	public class ListDataPropertyEditor extends ButtonPropertyEditor{

		[Bindable]
		public var list:ArrayCollection;
		
		public var valueButtonHBox:HBox = new HBox();
		public var listItem:List = new List;
		public var moveUpItemButton:Button = new Button();
		public var moveDownItemButton:Button = new Button();
		public var deleteItemButton:Button = new Button();
		
		private var listHBox:HBox = new HBox();

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function ListDataPropertyEditor() {
			super(BoxDirection.VERTICAL);
		}

		override protected function childrenCreated():void{
			super.childrenCreated();			
			this.buttonIcon =  PropertyIconLibrary.addListIcon;
			this.dialogButton.toolTip = resourceManager.getString("WorkbenchETC", "addListItemTTip");

			this.setStyle("verticalGap", 2);
			
			removeChild(valueLabel);
			removeChild(dialogButton);
			valueButtonHBox.addChild(valueLabel);
			valueButtonHBox.addChild(dialogButton);
			valueButtonHBox.percentWidth=100;
			valueButtonHBox.setStyle("paddingTop", 0);
			valueButtonHBox.setStyle("paddingBottom", 0);
			valueButtonHBox.setStyle("paddingLeft", 0);
			valueButtonHBox.setStyle("paddingRight", 0);
			valueButtonHBox.setStyle("horizontalGap", 3);
			addChild(valueButtonHBox);

//			listHBox.styleName="listDataListHBox";
			listHBox.setStyle("paddingTop", 0);
			listHBox.setStyle("paddingBottom", 0);
			listHBox.setStyle("paddingLeft", 0);
			listHBox.setStyle("paddingRight", 0);
			listHBox.setStyle("horizontalGap", 3);
			
			listItem.styleName="listDataListItemDG";
			BindingUtils.bindProperty(listItem, "dataProvider", this, "list");
			listItem.percentHeight=100;
			listItem.verticalScrollPolicy=ScrollPolicy.AUTO;
			listItem.horizontalScrollPolicy=ScrollPolicy.OFF;
			listItem.rowHeight=22;
			listItem.editable=false;
			listItem.selectable=true; 
			listItem.allowMultipleSelection=false;
			listHBox.addChild(listItem);
		
			var buttonVBox:VBox = new VBox();
//			buttonVBox.styleName="listDataButtonVBox";
			buttonVBox.setStyle("borderStyle", "none");
			buttonVBox.setStyle("paddingTop", 13);
			buttonVBox.setStyle("paddingBotton", 13);
			buttonVBox.setStyle("paddingLeft", 3);
			buttonVBox.setStyle("paddingRight", 3);
			buttonVBox.percentHeight=100;
			buttonVBox.width = 15+6;
			buttonVBox.setStyle("borderSttyle", "solid");
			buttonVBox.setStyle("borderColor", 0x000000);

//			moveUpItemButton.styleName="listDataButton"
			moveUpItemButton.setStyle("paddingTop", 0);
			moveUpItemButton.setStyle("paddingBottom", 0);
			moveUpItemButton.setStyle("paddingLeft", 0);
			moveUpItemButton.setStyle("paddingRight", 0);
			moveUpItemButton.setStyle("icon", PropertyIconLibrary.moveUpItemIcon);
			moveUpItemButton.width = 15;
			moveUpItemButton.height = 17;
			moveUpItemButton.toolTip = resourceManager.getString("WorkbenchETC", "moveUpItemTTip");
			buttonVBox.addChild(moveUpItemButton);


//			deleteItemButton.styleName="listDataButton"
			deleteItemButton.setStyle("paddingTop", 0);
			deleteItemButton.setStyle("paddingBottom", 0);
			deleteItemButton.setStyle("paddingLeft", 0);
			deleteItemButton.setStyle("paddingRight", 0);
			deleteItemButton.setStyle("icon", PropertyIconLibrary.deleteItemIcon);
			deleteItemButton.width = 15;
			deleteItemButton.height = 17;
			deleteItemButton.toolTip = resourceManager.getString("WorkbenchETC", "deleteItemTTip");
			buttonVBox.addChild(deleteItemButton);
			
//			moveDownItemButton.styleName="listDataButton"
			moveDownItemButton.setStyle("paddingTop", 0);
			moveDownItemButton.setStyle("paddingBottom", 0);
			moveDownItemButton.setStyle("paddingLeft", 0);
			moveDownItemButton.setStyle("paddingRight", 0);
			moveDownItemButton.setStyle("icon", PropertyIconLibrary.moveDownItemIcon);
			moveDownItemButton.width = 15;
			moveDownItemButton.height = 17;
			moveDownItemButton.toolTip = resourceManager.getString("WorkbenchETC", "moveDownItemTTip");
			buttonVBox.addChild(moveDownItemButton);
			
			listHBox.addChild(buttonVBox);
			listHBox.visible=true;
			addChild(listHBox);
		}
		/**
		 * 편집기를 표시하고 입력 가능한 상태로 만든다.
		 */
		override public function activate(pageItem: PropertyPageItem): void {
			super.activate(pageItem);
			moveUpItemButton.addEventListener(MouseEvent.CLICK, moveUpItemClick);
			deleteItemButton.addEventListener(MouseEvent.CLICK, deleteItemClick);
			moveDownItemButton.addEventListener(MouseEvent.CLICK, moveDownItemClick);
		}
		
		/**
		 * 편집기를 숨긴다.
		 */
		override public function deactivate(): void {
			super.deactivate();
			moveUpItemButton.removeEventListener(MouseEvent.CLICK, moveUpItemClick);
			deleteItemButton.removeEventListener(MouseEvent.CLICK, deleteItemClick);
			moveDownItemButton.removeEventListener(MouseEvent.CLICK, moveDownItemClick);
		}
		

		override public function setBounds(x: Number, y: Number, width: Number, height: Number): void {
			super.setBounds(x, y, width, height);
			this.height = height*5+3;
			valueButtonHBox.height = height;
			valueLabel.height = height;
			listHBox.height = height*4;
			listHBox.width = width;
			listItem.width = valueLabel.width;
		}

		/**
		 * 편집기에 값을 가져오거나 설정한다.
		 */
		override public function get editValue(): Object {
			return list;
		}
		
		override public function set editValue(val: Object): void {
			if(list != val)
				list = val as ArrayCollection;
		}
		
		public function setPropertyValue(value:ArrayCollection):void{
			if(pageItem)
				this.pageItem.page.propSource.setPropertyValue(this.pageItem.propInfo.id, value);
		}
		
		public function addItemClick(event:MouseEvent=null):void{
			if(valueLabel.text==null) return;
			if(!list) list = new ArrayCollection();
			for each(var item:Object in list){
				if(item as String == valueLabel.text)
					return;
			}
			list.addItem(valueLabel.text);
			listItem.selectedItem=valueLabel.text;
			listItem.invalidateList();
			setPropertyValue(list);
		}

		private function moveUpItemClick(event:MouseEvent):void{
			if(!listItem.selectedItem && (listItem.selectedIndex<0 || listItem.selectedIndex>listItem.dataProvider.length)) return;
			if(listItem.selectedIndex==0 || list.length<=1) return;
			var selectedItem:Object = listItem.selectedItem;
			var selectedIndex:int = listItem.selectedIndex;
			
			list.removeItemAt(selectedIndex);
			list.addItemAt(selectedItem, selectedIndex-1);
			listItem.selectedItem=selectedItem;
			listItem.invalidateList();
			setPropertyValue(list);
		}

		private function deleteItemClick(event:MouseEvent):void{
			if(!listItem.selectedItem && (listItem.selectedIndex<0 || listItem.selectedIndex>listItem.dataProvider.length)) return;
			var selectedIndex:int = listItem.selectedIndex;
			list.removeItemAt(selectedIndex);
			if(selectedIndex>0){
				listItem.selectedIndex = selectedIndex-1;
			}
			listItem.invalidateList();
			setPropertyValue(list);
		}

		private function moveDownItemClick(event:MouseEvent):void{
			if(!listItem.selectedItem && (listItem.selectedIndex<0 || listItem.selectedIndex>listItem.dataProvider.length)) return;
			if(listItem.selectedIndex==list.length-1 || list.length<=1) return;
			var selectedItem:Object = listItem.selectedItem;
			var selectedIndex:int = listItem.selectedIndex;
			
			list.removeItemAt(selectedIndex);
			list.addItemAt(selectedItem, selectedIndex+1);
			listItem.selectedItem=selectedItem;
			listItem.invalidateList();
			setPropertyValue(list);
		}
	}
}