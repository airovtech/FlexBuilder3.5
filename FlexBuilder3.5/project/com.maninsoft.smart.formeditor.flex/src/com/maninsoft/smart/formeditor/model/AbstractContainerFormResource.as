package com.maninsoft.smart.formeditor.model
{
	import com.maninsoft.smart.formeditor.FormEditorBase;
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridLayout;
	import com.maninsoft.smart.formeditor.layout.model.FormLayout;
	import com.maninsoft.smart.formeditor.refactor.event.FormPropertyEvent;
	import com.maninsoft.smart.formeditor.refactor.simple.navigator.FormItemProxy;
	
	import mx.collections.ArrayCollection;
	
	public class AbstractContainerFormResource extends AbstractFormResource implements IFormContainer
	{
		public static const PROP_STRUCTURE_ADD:String = "prop.structure.add";
		public static const PROP_STRUCTURE_REMOVE:String = "prop.structure.add";
		
		private var _layout:FormLayout;

		public function set layout(layout:FormLayout):void{
		    this._layout = layout;
		}
		public function get layout():FormLayout{
			if(this._layout == null){
				this._layout = new FormGridLayout();
				this._layout.container = this;
			}
		    return this._layout;
		}
		
		private var _layoutType:String = FormLayout.GRID;

		public function set layoutType(layoutType:String):void{
		    this._layoutType = layoutType;
		}
		public function get layoutType():String{
		    return this._layoutType;
		}
		
		[Bindable]
		public var children:ArrayCollection = new ArrayCollection();
		
		public function AbstractContainerFormResource():void{
			refreshChildren();
		}
		
		private function getChildern():ArrayCollection{
			if(this.children == null)
				this.children = new ArrayCollection();
			return this.children;
		}
		
		public function addField(child:FormEntity, index:int = -1):void{
			if(this.children == null || !(this.children.contains(child))){
				
				if(this is FormEntity){
					child.parent = FormEntity(this);
					child.depth = this.depth + 1;
				}else{
					child.parent = null;
					child.depth = 0;
				}
					
				if(index == -1)
					getChildern().addItem(child);
				else
					getChildern().addItemAt(child, index);
					
				refreshChildren();
				
				dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_STRUCTURE));
				trace("[Event]AbstractContainerFormResource addField dispatch event : " + FormPropertyEvent.UPDATE_FORM_STRUCTURE);
			}	
		}

		public function removeField(child:FormEntity):void{
			if(getChildern() != null && getChildern().contains(child)){
				getChildern().removeItemAt(getChildern().getItemIndex(child));
				dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_STRUCTURE));
				trace("[Event]AbstractContainerFormResource removeField dispatch event : " + FormPropertyEvent.UPDATE_FORM_STRUCTURE);
			}			
		}
		
		public function refreshChildren():void{
			
			var proxyExist:Boolean = false;
			var proxy:FormEntity;
			
			for each (var item:FormEntity in getChildern()) {
				if(item is FormItemProxy){
					proxyExist = true;
					proxy = item;
				}
			}
			
			if (!proxyExist) {
//				var formItemProxy:FormItemProxy = new FormItemProxy(this.root);
//				
//				if(this is FormDocument){
//					formItemProxy.parent = null;
//					formItemProxy.depth = 0;
//				}else{
//					formItemProxy.parent = FormEntity(this);
//					formItemProxy.depth = this.depth + 1;
//				}				
//				
//				getChildern().addItem(formItemProxy);
			} else {
				var proxyIdx:int = getChildern().getItemIndex(proxy);
				if(proxyIdx != -1 && proxyIdx != (getChildern().length - 1)){
					getChildern().removeItemAt(proxyIdx);
					getChildern().addItem(proxy);
				} 
			}
		}
		
		public function getFieldAt(index:int):FormEntity{
			return getChildern().getItemAt(index) as FormEntity;
		}
		
		public function get length():int{
			return getChildern().length;
		}
		
		public function contain(child:FormEntity):Boolean{
			return getChildern().contains(child);
		}
	}
}