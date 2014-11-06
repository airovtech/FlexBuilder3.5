package com.maninsoft.smart.formeditor.model.property
{
	import com.maninsoft.smart.formeditor.model.ArrayObject;
	import com.maninsoft.smart.formeditor.model.AutoIndexRule;
	import com.maninsoft.smart.formeditor.model.AutoIndexRules;
	import com.maninsoft.smart.workbench.common.assets.PropertyIconLibrary;
	import com.maninsoft.smart.workbench.common.property.ButtonPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.page.PropertyPageItem;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.containers.BoxDirection;
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.Button;
	import mx.controls.ComboBox;
	import mx.controls.Label;
	import mx.controls.List;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.core.ScrollPolicy;
	import mx.events.ListEvent;
	
	/**
	 * 버튼을 클릭한 후 표시되는 다이얼로그 등을 통해 속성을 편집하는 에디터
	 */
	public class AutoIndexPropertyEditor extends ButtonPropertyEditor{

		[Bindable]
		public var list:ArrayCollection;
		
		public var valueButtonHBox:HBox = new HBox();
		public var ruleList:ComboBox = new ComboBox();
		public var listItem:List = new List;
		public var moveUpItemButton:Button = new Button();
		public var moveDownItemButton:Button = new Button();
		public var deleteItemButton:Button = new Button();
		public var codeInput:TextInput = new TextInput
		
		private var listHBox:HBox = new HBox();

		private var codeVBox:VBox = new VBox();
		private var codeTextHBox:HBox = new HBox();
		private var codeTextInput:TextInput = new TextInput();
		private var codeSepHBox:HBox = new HBox();			
		private var codeSepList:ComboBox = new ComboBox();
		private var formatListHBox:HBox = new HBox();			
		private var formatList:ComboBox = new ComboBox();
		private var incrementHBox:HBox = new HBox();			
		private var incrementInput:TextInput = new TextInput();
		private var incrementByListHBox:HBox = new HBox();			
		private var incrementByList:ComboBox = new ComboBox();
		private var digitsHBox:HBox = new HBox();			
		private var digitsInput:TextInput = new TextInput();
		private var userListHBox:HBox = new HBox();
		private var userListInput:TextArea = new TextArea();

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function AutoIndexPropertyEditor() {
			super(BoxDirection.VERTICAL);
		}

		override protected function childrenCreated():void{
			super.childrenCreated();			
			this.buttonIcon =  PropertyIconLibrary.addListIcon;
			this.dialogButton.toolTip = resourceManager.getString("WorkbenchETC", "addAutoIndexTTip");
			this.ruleList.dataProvider = AutoIndexRules.autoIndexRules;
			
			this.setStyle("verticalGap", 2);
			
			removeChild(valueLabel);
			removeChild(dialogButton);
			ruleList.percentWidth= 100;
			ruleList.height= 20;
			valueButtonHBox.addChild(ruleList);
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
			listItem.verticalScrollPolicy=ScrollPolicy.OFF;
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
			
			codeVBox.setStyle("borderStyle", "none");
			codeVBox.setStyle("paddingTop", 13);
			codeVBox.setStyle("paddingBotton", 13);
			codeVBox.setStyle("paddingLeft", 3);
			codeVBox.setStyle("paddingRight", 3);
			codeVBox.percentWidth=100;
			codeVBox.percentHeight=100;						
			addChild(codeVBox);
			this.verticalScrollPolicy = ScrollPolicy.OFF;

			var codeTextLabel:Label = new Label();
			codeTextLabel.text = resourceManager.getString("FormEditorETC", "codeTextLabelText");
			codeTextLabel.width = 60;			
			codeTextInput.width = 130;
			codeTextInput.height = 20;
			codeTextHBox.height = 20;
			codeTextHBox.setStyle("paddingTop", 0);
			codeTextHBox.setStyle("paddingBottom", 0);
			codeTextHBox.setStyle("paddingLeft", 0);
			codeTextHBox.setStyle("paddingRight", 0);
			codeTextHBox.addChild(codeTextLabel);
			codeTextHBox.addChild(codeTextInput);

			var codeSepLabel:Label = new Label();
			codeSepLabel.text = resourceManager.getString("FormEditorETC", "codeSepLabelText");
			codeSepLabel.width = 60;
			codeSepList.dataProvider = AutoIndexRule.POSTFIX_CHARACTERS;
			codeSepList.width = 130;
			codeSepList.height = 20;
			codeSepHBox.height = 20;
			codeSepHBox.setStyle("paddingTop", 0);
			codeSepHBox.setStyle("paddingBottom", 0);
			codeSepHBox.setStyle("paddingLeft", 0);
			codeSepHBox.setStyle("paddingRight", 0);
			codeSepHBox.addChild(codeSepLabel);
			codeSepHBox.addChild(codeSepList);			

			var formatListLabel:Label = new Label();
			formatListLabel.text = resourceManager.getString("FormEditorETC", "formatListLabelText");
			formatListLabel.width = 60;			
			formatList.dataProvider = AutoIndexRule.dateFormats;
			formatList.width = 130;
			formatList.height = 20;
			formatListHBox.height = 20;
			formatListHBox.setStyle("paddingTop", 0);
			formatListHBox.setStyle("paddingBottom", 0);
			formatListHBox.setStyle("paddingLeft", 0);
			formatListHBox.setStyle("paddingRight", 0);
			formatListHBox.addChild(formatListLabel);
			formatListHBox.addChild(formatList);

			var incrementLabel:Label = new Label();
			incrementLabel.text = resourceManager.getString("FormEditorETC", "incrementLabelText");
			incrementLabel.width = 60;
			incrementInput.width = 130;
			incrementInput.height = 20;
			incrementInput.setStyle("textAlign", "right");
			incrementHBox.height = 20;
			incrementHBox.setStyle("paddingTop", 0);
			incrementHBox.setStyle("paddingBottom", 0);
			incrementHBox.setStyle("paddingLeft", 0);
			incrementHBox.setStyle("paddingRight", 0);
			incrementHBox.addChild(incrementLabel);
			incrementHBox.addChild(incrementInput);

			var incrementByListLabel:Label = new Label();
			incrementByListLabel.text = resourceManager.getString("FormEditorETC", "incrementByListLabelText");
			incrementByListLabel.width = 60;
			incrementByList.dataProvider = AutoIndexRule.incrementBys;
			incrementByList.width = 130;				
			incrementByList.height = 20;				
			incrementByListHBox.height = 20;
			incrementByListHBox.setStyle("paddingTop", 0);
			incrementByListHBox.setStyle("paddingBottom", 0);
			incrementByListHBox.setStyle("paddingLeft", 0);
			incrementByListHBox.setStyle("paddingRight", 0);
			incrementByListHBox.addChild(incrementByListLabel);
			incrementByListHBox.addChild(incrementByList);

			var digitsLabel:Label = new Label();
			digitsLabel.text = resourceManager.getString("FormEditorETC", "digitsLabelText");
			digitsLabel.width = 60;
			digitsInput.width = 130;
			digitsInput.height = 20;
			digitsInput.setStyle("textAlign", "right");
			digitsHBox.height = 20;
			digitsHBox.setStyle("paddingTop", 0);
			digitsHBox.setStyle("paddingBottom", 0);
			digitsHBox.setStyle("paddingLeft", 0);
			digitsHBox.setStyle("paddingRight", 0);
			digitsHBox.addChild(digitsLabel);
			digitsHBox.addChild(digitsInput);

			var userListLabel:Label = new Label();
			userListLabel.text = resourceManager.getString("FormEditorETC", "userListLabelText");
			userListLabel.width = 60;
			userListInput.width = 130;
			userListInput.height = 80;
			userListHBox.height = 80;
			userListHBox.setStyle("paddingTop", 0);
			userListHBox.setStyle("paddingBottom", 0);
			userListHBox.setStyle("paddingLeft", 0);
			userListHBox.setStyle("paddingRight", 0);
			userListHBox.addChild(userListLabel);
			userListHBox.addChild(userListInput);

		}
		/**
		 * 편집기를 표시하고 입력 가능한 상태로 만든다.
		 */
		override public function activate(pageItem: PropertyPageItem): void {
			super.activate(pageItem);
			listItem.addEventListener(MouseEvent.CLICK, listItemClick);
			moveUpItemButton.addEventListener(MouseEvent.CLICK, moveUpItemClick);
			deleteItemButton.addEventListener(MouseEvent.CLICK, deleteItemClick);
			moveDownItemButton.addEventListener(MouseEvent.CLICK, moveDownItemClick);
			
			codeTextInput.addEventListener(Event.CHANGE, codeTextInputChange);
			codeSepList.addEventListener(ListEvent.CHANGE, codeSepListChange);
			formatList.addEventListener(ListEvent.CHANGE, formatListChange);
			incrementInput.addEventListener(Event.CHANGE, incrementInputChange);
			incrementByList.addEventListener(ListEvent.CHANGE, incrementByListChange);
			digitsInput.addEventListener(Event.CHANGE, digitsInputChange);
			userListInput.addEventListener(Event.CHANGE, userListInputChange);
		}
		
		/**
		 * 편집기를 숨긴다.
		 */
		override public function deactivate(): void {
			super.deactivate();
			listItem.removeEventListener(MouseEvent.CLICK, listItemClick);
			moveUpItemButton.removeEventListener(MouseEvent.CLICK, moveUpItemClick);
			deleteItemButton.removeEventListener(MouseEvent.CLICK, deleteItemClick);
			moveDownItemButton.removeEventListener(MouseEvent.CLICK, moveDownItemClick);

			codeTextInput.removeEventListener(Event.CHANGE, codeTextInputChange);
			codeSepList.removeEventListener(ListEvent.CHANGE, codeSepListChange);
			formatList.removeEventListener(ListEvent.CHANGE, formatListChange);
			incrementInput.removeEventListener(Event.CHANGE, incrementInputChange);
			incrementByList.removeEventListener(ListEvent.CHANGE, incrementByListChange);
			digitsInput.removeEventListener(Event.CHANGE, digitsInputChange);
			userListInput.removeEventListener(Event.CHANGE, userListInputChange);
		}
		

		override public function setBounds(x: Number, y: Number, width: Number, height: Number): void {
			super.setBounds(x, y, width, height);
			this.height = height*11+3;
			valueButtonHBox.height = height;
			valueLabel.height = height;
			listHBox.height = height*4+3;
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
			if(listItem && listItem.selectedItem){
				var rule:AutoIndexRule = listItem.selectedItem as AutoIndexRule;
				if(rule.ruleId == AutoIndexRule.RULE_ID_CODE){
					this.showCodeItems(rule);
				}else if(rule.ruleId == AutoIndexRule.RULE_ID_DATE){
					this.showDateItems(rule);
				}else if(rule.ruleId == AutoIndexRule.RULE_ID_LIST){
					this.showListItems(rule);	
				}else if(rule.ruleId == AutoIndexRule.RULE_ID_SEQUENCE){
					this.showSequenceItems(rule);
				}else{
					codeVBox.removeAllChildren();
				}
			}
		}
		
		public function addItemClick(event:MouseEvent=null):void{
			if(!list) list = new ArrayCollection();
			if(list.length==4) return;
			
			var rule:AutoIndexRule = new AutoIndexRule((ruleList.selectedItem as AutoIndexRule).ruleId);

			if(rule.ruleId == AutoIndexRule.RULE_ID_DATE){
				rule.dateFormat = AutoIndexRule.dateFormats[0];
			}else if(rule.ruleId == AutoIndexRule.RULE_ID_SEQUENCE){
				rule.incrementBy = (AutoIndexRule.incrementBys[0] as ArrayObject).id;
			}
			list.addItem(rule);
			listItem.selectedItem=rule;
			listItem.invalidateList();
			setPropertyValue(list);
		}
		
		public function listItemClick(event:MouseEvent=null):void{			
			if(listItem && listItem.selectedItem){
				var rule:AutoIndexRule = listItem.selectedItem as AutoIndexRule;
				if(rule.ruleId == AutoIndexRule.RULE_ID_CODE){
					this.showCodeItems(rule);
				}else if(rule.ruleId == AutoIndexRule.RULE_ID_DATE){
					this.showDateItems(rule);
				}else if(rule.ruleId == AutoIndexRule.RULE_ID_LIST){
					this.showListItems(rule);		
				}else if(rule.ruleId == AutoIndexRule.RULE_ID_SEQUENCE){
					this.showSequenceItems(rule);
				}else{
					codeVBox.removeAllChildren();
				}
			}
		}
		
		private function showCodeItems(rule:AutoIndexRule):void{
			codeVBox.removeAllChildren();

			codeTextInput.text = rule.codeValue;
			codeVBox.addChild(codeTextHBox);

			if(rule.seperator){
				for(var i:int=0; i<AutoIndexRule.POSTFIX_CHARACTERS.length; i++){
					if((AutoIndexRule.POSTFIX_CHARACTERS[i] as ArrayObject).id == rule.seperator){
						codeSepList.selectedIndex = i;
						break;
					}
				}
			}
			if(!rule.seperator || i==AutoIndexRule.POSTFIX_CHARACTERS.length)
				codeSepList.selectedIndex = 0;
				
			codeVBox.addChild(codeSepHBox);
		}

		private function showDateItems(rule:AutoIndexRule):void{
			codeVBox.removeAllChildren();			

			if(rule.dateFormat){
				for(var i:int=0; i<AutoIndexRule.dateFormats.length; i++){
					if(AutoIndexRule.dateFormats[i] == rule.dateFormat){
						formatList.selectedIndex = i;
						break;
					}
				}
				
			}
			if(i==AutoIndexRule.dateFormats.length)
				formatList.selectedIndex = 0;
				
			codeVBox.addChild(formatListHBox);
			
			if(rule.seperator){
				for(i=0; i<AutoIndexRule.POSTFIX_CHARACTERS.length; i++){
					if((AutoIndexRule.POSTFIX_CHARACTERS[i] as ArrayObject).id == rule.seperator){
						codeSepList.selectedIndex = i;
						break;
					}
				}
			}
			if(!rule.seperator || i==AutoIndexRule.POSTFIX_CHARACTERS.length)
				codeSepList.selectedIndex = 0;
				
			codeVBox.addChild(codeSepHBox);
		}

		private function showSequenceItems(rule:AutoIndexRule):void{
			codeVBox.removeAllChildren();			

			if(rule.increment)
				incrementInput.text = rule.increment.toString();
			else
				incrementInput.text = "";
			codeVBox.addChild(incrementHBox);

			if(rule.incrementBy){
				for(var i:int=0; i<AutoIndexRule.incrementBys.length; i++){
					if((AutoIndexRule.incrementBys[i] as ArrayObject).id == rule.incrementBy){
						incrementByList.selectedIndex = i;
						break;
					}
				}
			}
			if(!rule.incrementBy || i==AutoIndexRule.incrementBys.length)
				incrementByList.selectedIndex = 0;
				
			codeVBox.addChild(incrementByListHBox);
			
			if(rule.digits)
				digitsInput.text = rule.digits.toString();
			else
				digitsInput.text = "";
			codeVBox.addChild(digitsHBox);
			
			if(rule.seperator){
				for(i=0; i<AutoIndexRule.POSTFIX_CHARACTERS.length; i++){
					if((AutoIndexRule.POSTFIX_CHARACTERS[i] as ArrayObject).id == rule.seperator){
						codeSepList.selectedIndex = i;
						break;
					}
				}
			}
			if(!rule.seperator || i==AutoIndexRule.POSTFIX_CHARACTERS.length)
				codeSepList.selectedIndex = 0;
				
			codeVBox.addChild(codeSepHBox);
		}

		private function showListItems(rule:AutoIndexRule):void{
			codeVBox.removeAllChildren();			

			if(rule.list){
				userListInput.text = "";
				for(var i:int=0; i<rule.list.length; i++){
					if(rule.list[i]) userListInput.text = userListInput.text + rule.list[i] + "\r";					
				}
			}else{
				userListInput.text = "";
			}
			codeVBox.addChild(userListHBox);
			
			if(rule.seperator){
				for(i=0; i<AutoIndexRule.POSTFIX_CHARACTERS.length; i++){
					if((AutoIndexRule.POSTFIX_CHARACTERS[i] as ArrayObject).id == rule.seperator){
						codeSepList.selectedIndex = i;
						break;
					}
				}
			}
			if(!rule.seperator || i==AutoIndexRule.POSTFIX_CHARACTERS.length)
				codeSepList.selectedIndex = 0;
				
			codeVBox.addChild(codeSepHBox);
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

		private function codeTextInputChange(event:Event):void{
			if(listItem && listItem.selectedItem){
				var rule:AutoIndexRule = listItem.selectedItem as AutoIndexRule;
				rule.codeValue = codeTextInput.text;
			}			
		}
		private function codeSepListChange(event:ListEvent):void{
			if(listItem && listItem.selectedItem){
				var rule:AutoIndexRule = listItem.selectedItem as AutoIndexRule;
				rule.seperator = (codeSepList.selectedItem as ArrayObject).id;
			}
			
		}
		private function formatListChange(event:ListEvent):void{
			if(listItem && listItem.selectedItem){
				var rule:AutoIndexRule = listItem.selectedItem as AutoIndexRule;
				rule.dateFormat = formatList.selectedItem as String;
			}
			
		}
		private function incrementInputChange(event:Event):void{
			if(listItem && listItem.selectedItem){
				var rule:AutoIndexRule = listItem.selectedItem as AutoIndexRule;
				rule.increment = (incrementInput.text) ? int(incrementInput.text) : 0;
			}
			
		}
		private function incrementByListChange(event:ListEvent):void{
			if(listItem && listItem.selectedItem){
				var rule:AutoIndexRule = listItem.selectedItem as AutoIndexRule;
				rule.incrementBy = (incrementByList.selectedItem as ArrayObject).id;
			}
			
		}
		private function digitsInputChange(event:Event):void{
			if(listItem && listItem.selectedItem){
				var rule:AutoIndexRule = listItem.selectedItem as AutoIndexRule;
				rule.digits = (digitsInput.text) ? int(digitsInput.text) : 0;				
			}
			
		}
		private function userListInputChange(event:Event):void{
			if(listItem && listItem.selectedItem){
				var rule:AutoIndexRule = listItem.selectedItem as AutoIndexRule;
				rule.list = userListInput.text.split("\r");		
			}
			
		}
	}
}