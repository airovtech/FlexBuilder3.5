package com.maninsoft.smart.workbench.common.meta.impl
{
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	public class SWWorkType extends EventDispatcher
	{
		/**
		 * 아이디
		 */
		private var _id:String;
		/**
		 * 이름
		 */		
		private var _name:String;
		/**
		 * 아이디
		 */
		private var _formUid:String;
		/**
		 * 폼
		 */
		private var _form:SWForm;
		/**
		 * 타입
		 */		
		private var _type:String;
		/**
		 * 스텝 수
		 */		
		private var _stepCount:int;
		/**
		 * 처리기한 
		 */		
		private var _duration:int;
		/**
		 * 맵핑
		 */		
		public var mappings:ArrayCollection = new ArrayCollection();
		/**
		 * 폼 아이디
		 */		
		[Bindable]
		private var formId:String;
		/**
		 * 버전
		 */		
		[Bindable]
		private var version:int;
		
		public function get id():String{
			return _id;
		}
		public function set id(id:String):void{
			this._id = id;
		}
		public function get name():String{
			return _name;
		}		
		[Bindable]
		public function set name(name:String):void{
			this._name = name;
		}
		public function get formUid():String{
			return _formUid;
		}
		[Bindable]
		public function set formUid(formUid:String):void{
			this._formUid = formUid;
		}
		public function get form():SWForm{
			return _form;
		}
		[Bindable]
		public function set form(form:SWForm):void{
			this._form = form;
		}
		public function get type():String{
			return _type;
		}
		[Bindable]
		public function set type(type:String):void{
			this._type = type;
		}
		public function get stepCount():int{
			return _stepCount;
		}
		[Bindable]
		public function set stepCount(stepCount:int):void{
			this._stepCount = stepCount;
		}
		public function get duration():int{
			return _duration;
		}
		[Bindable]
		public function set duration(duration:int):void{
			this._duration = duration;
		}		
		
		public static function parseXML(workTypeXML:XML):SWWorkType{
			if(workTypeXML != null && workTypeXML.id.toString() != ""){
				var swWorkType:SWWorkType = new SWWorkType();
				swWorkType.id = workTypeXML.id.toString();			
				swWorkType.name = workTypeXML.name.toString();
				swWorkType.formUid = workTypeXML.formUid.toString();
				swWorkType.stepCount = new int(workTypeXML.stepCount.toString());
				swWorkType.type = workTypeXML.type.toString();
				swWorkType.duration = new int(workTypeXML.duration.toString());
				
				return swWorkType;	
			}
			return null;			
		}
	}
}