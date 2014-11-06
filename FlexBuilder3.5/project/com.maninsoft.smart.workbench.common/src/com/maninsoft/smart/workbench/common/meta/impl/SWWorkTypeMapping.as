package com.maninsoft.smart.workbench.common.meta.impl
{
	import flash.events.EventDispatcher;
	
	public class SWWorkTypeMapping extends EventDispatcher 
	{
		/**
		 * 아이디
		 */
		private var _id:String;
		/**
		 * 이름
		 */		
		private var _condition:String = "true";
		/**
		 * 워크타입 유니크 아이디
 		 */		
		private var _workTypeId:String;
		/**
		 * 필드 아이디
		 */		
		private var _fieldId:String;
		/**
		 * 가져올 워크타입 유니크 아이디
 		 */		
		private var _fromWorkTypeId:String;
		/**
		 * 가져올 필드 아이디
		 */		
		private var _fromWorkTypeFieldId:String;

		public function get id():String{
			return _id;
		}
		[Bindable]
		public function set id(id:String):void{
			this._id = id;
		}
		public function get condition():String{
			return _condition;
		}
		[Bindable]
		public function set condition(condition:String):void{
			this._condition = condition;
		}
		public function get workTypeId():String{
			return _workTypeId;
		}
		[Bindable]
		public function set workTypeId(workTypeId:String):void{
			this._workTypeId = workTypeId;
		}
		public function get fieldId():String{
			return _fieldId;
		}
		[Bindable]
		public function set fieldId(fieldId:String):void{
			this._fieldId = fieldId;
		}
		public function get fromWorkTypeId():String{
			return _fromWorkTypeId;
		}
		[Bindable]
		public function set fromWorkTypeId(fromWorkTypeId:String):void{
			this._fromWorkTypeId = fromWorkTypeId;
		}
		public function get fromWorkTypeFieldId():String{
			return _fromWorkTypeFieldId;
		}
		[Bindable]
		public function set fromWorkTypeFieldId(fromWorkTypeFieldId:String):void{
			this._fromWorkTypeFieldId = fromWorkTypeFieldId;
		}
		public static function parseXML(workTypeXML:XML):SWWorkTypeMapping{
			if(workTypeXML != null && workTypeXML.id.toString() != ""){
				var swWorkTypeMapping:SWWorkTypeMapping = new SWWorkTypeMapping();
				swWorkTypeMapping.id = workTypeXML.id.toString();		
				swWorkTypeMapping.workTypeId = workTypeXML.workTypeId.toString();
				swWorkTypeMapping.fieldId  = workTypeXML.workTypeFieldId.toString();
				swWorkTypeMapping.condition  = workTypeXML.condition.toString();
				swWorkTypeMapping.fromWorkTypeId  = workTypeXML.fromWorkTypeId.toString();
				swWorkTypeMapping.fromWorkTypeFieldId  = workTypeXML.fromWorkTypeFieldId.toString();
				
				return swWorkTypeMapping;	
			}
			return null;			
		}
		public function toXML():XML{
			var workTypeMappingXML:XML = 
				<WorkTypeMapping>
					<id/>
					<workTypeId/>
					<workTypeFieldId/>
					<condition/>
					<fromWorkTypeId/>
					<fromWorkTypeFieldId/>
				</WorkTypeMapping>;
			if(this.id != null) workTypeMappingXML.id = id;
			workTypeMappingXML.workTypeId = workTypeId;
			workTypeMappingXML.workTypeFieldId = fieldId;
			workTypeMappingXML.condition = condition;
			workTypeMappingXML.fromWorkTypeId = fromWorkTypeId;
			workTypeMappingXML.fromWorkTypeFieldId = fromWorkTypeFieldId;

			return workTypeMappingXML;			
		}
	}
}