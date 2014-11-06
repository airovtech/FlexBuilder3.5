package com.maninsoft.smart.formeditor.model
{
	import com.maninsoft.smart.formeditor.model.SelectableModel;
	import com.maninsoft.smart.formeditor.refactor.component.model.TextStyleModel;
	import com.maninsoft.smart.formeditor.refactor.event.FormPropertyEvent;
	import com.maninsoft.smart.formeditor.assets.IconLibrary;
	
	
	public class AbstractFormResource extends SelectableModel implements IFormResource
	{
		// id
		private var _id:String;
		// 이름
		private var _name:String = resourceManager.getString("WorkbenchETC", "nameText");
		// 제목(라벨)		
		private var _titleTextStyle:TextStyleModel = new TextStyleModel();
		// 제목(라벨)		
		private var _contentsTextStyle:TextStyleModel = new TextStyleModel();
		// 제목(라벨)		
		private var _bgColor:Number;
		/**
		 * 현재 아이템의 깊이(0부터 시작)
		 **/ 
		private var _depth:int = 0;
		/**
		 * 루트 도큐먼트
		 **/ 
		private var _root:FormDocument;
		/**
		 * 부모(도큐먼트에 붙어있는 녀석은 없음)
		 **/ 	
		private var _parent:FormEntity;
				
		[Bindable]
		public function set id(id:String):void{
			this._id = id;
			dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_INFO));
			trace("[Event]AbstractFormResource id updated : " + _id + ", event : " + FormPropertyEvent.UPDATE_FORM_STRUCTURE);
		}		
		public function get id():String{
			return this._id;
		}
		
		[Bindable]				
		public function set name(name:String):void{
			this._name = name;
			dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_INFO));
			trace("[Event]AbstractFormResource name updated : " + _name + ", event : " + FormPropertyEvent.UPDATE_FORM_INFO);
		}
		public function get name():String{
			return this._name;
		}
		
		[Bindable]
		public function set titleTextStyle(titleTextStyle:TextStyleModel):void{
			this._titleTextStyle = titleTextStyle;
			dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_INFO));
			trace("[Event]AbstractFormResource titleTextStyle updated : " + _titleTextStyle + ", event : " + FormPropertyEvent.UPDATE_FORM_INFO);
		}		
		public function get titleTextStyle():TextStyleModel{
			return this._titleTextStyle;
		}
		
		[Bindable]
		public function set contentsTextStyle(contentsTextStyle:TextStyleModel):void{
			this._contentsTextStyle = contentsTextStyle;
			dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_INFO));
			trace("[Event]AbstractFormResource contentsTextStyle updated : " + _contentsTextStyle + ", event : " + FormPropertyEvent.UPDATE_FORM_INFO);
		}		
		public function get contentsTextStyle():TextStyleModel{
			return this._contentsTextStyle;
		}
		
		[Bindable]
		public function set bgColor(bgColor:Number):void{
			this._bgColor = bgColor;
			dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_INFO));
			trace("[Event]AbstractFormResource bgColor updated : " + _bgColor + ", event : " + FormPropertyEvent.UPDATE_FORM_INFO);
		}		
		public function get bgColor():Number{
			return this._bgColor;
		}

		[Bindable]	
		public function set root(root:FormDocument):void{
			this._root = root;
			dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_INFO));
			trace("[Event]AbstractFormResource root updated : " + _root + ", event : " + FormPropertyEvent.UPDATE_FORM_INFO);
		}
		public function get root():FormDocument{
			return this._root;
		}		
		
		[Bindable]	
		public function set depth(depth:int):void{
			this._depth = depth;
			dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_INFO));
			trace("[Event]AbstractFormResource depth updated : " + _depth + ", event : " + FormPropertyEvent.UPDATE_FORM_INFO);
		}
		public function get depth():int{
			return this._depth;
		}
		
		[Bindable]	
		public function set parent(parent:FormEntity):void{
			this._parent = parent;
			dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_INFO));
			trace("[Event]AbstractFormResource parent updated : " + _parent + ", event : " + FormPropertyEvent.UPDATE_FORM_INFO);
		}
		public function get parent():FormEntity{
			return this._parent;
		}
		
		public function get icon():Class{
			return IconLibrary.baseSchemaItem;	
		}
		
		public override function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);			 
		}
		
		private var _systemName:String = "";
		
		public function set systemName(systemName:String):void{
			this._systemName = systemName;
		}
		
		public function get systemName():String{
			return this._systemName;
		}
		
		public function get label():String{
			return name;
		}
	}
}