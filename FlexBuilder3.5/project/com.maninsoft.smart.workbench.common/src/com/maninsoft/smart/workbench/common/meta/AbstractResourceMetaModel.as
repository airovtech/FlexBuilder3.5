package com.maninsoft.smart.workbench.common.meta
{
	import com.maninsoft.smart.workbench.common.assets.WorkbenchIconLibrary;
	import com.maninsoft.smart.workbench.common.util.DateUtil;
	
	import flash.events.EventDispatcher;
	
	
	public class AbstractResourceMetaModel extends EventDispatcher implements IResourceMetaModel
	{
		/**
		 * 아이디
		 */
		private var _id:String;
		/**
		 * 버전
		 */		
		private var _version:int = 0;		
		/**
		 * 이름
		 */		
		private var _name:String;
		/**
		 * 타입
		 */		
		private var _type:String;
		/**
		 * 생성된 시간
		 */
		private var _createdTime:Date;
		/**
		 * 생성된 시간
		 */
		private var _createdTimeString:String;
		/**
		 * 생성자
		 */
		private var _creator:String;
		/**
		 * 생성자이름
		 */
		private var _creatorName:String;
		/**
		 * 설명
		 */
		private var _description:String;
		/**
		 * 수정된 시간
		 */
		private var _modifiedTime:Date;
		/**
		 * 수정된 시간
		 */
		private var _modifiedTimeString:String;
		/**
		 * 수정자
		 */
		private var _modifier:String;
		/**
		 * 수정자
		 */
		private var _modifierName:String;
		/**
		 * 상태
		 */
		private var _pkgStatus:String;

		public function get id():String{
			return _id;
		}
		[Bindable]
		public function set id(id:String):void{
			this._id = id;
		}
		public function get version():int{
			return _version;
		}
		[Bindable]
		public function set version(version:int):void{
			this._version = version;
		}	
		public function get name():String{
			return _name;
		}		
		[Bindable]
		public function set name(name:String):void{
			this._name = name;
		}
		
		public function get type():String{
			return _type;
		}
		[Bindable]
		public function set type(type:String):void{
			this._type = type;
		}

		public function get modifiedTime():Date{
			return _modifiedTime;
		}		
		[Bindable]
		public function set modifiedTime(modifiedTime:Date):void{
			this._modifiedTime = modifiedTime;
		}
		
		public function get modifiedTimeString():String{
			return _modifiedTimeString;
		}		
		[Bindable]
		public function set modifiedTimeString(modifiedTimeString:String):void{
			this._modifiedTimeString = modifiedTimeString;
		}
				
		public function get modifier():String{
			return _modifier;
		}		
		[Bindable]
		public function set modifier(modifier:String):void{
			this._modifier = modifier;
		}
		
		public function get modifierName():String{
			return _modifierName;
		}		
		[Bindable]
		public function set modifierName(modifierName:String):void{
			this._modifierName = modifierName;
		}
		
		public function get createdTime():Date{
			return _createdTime;
		}		
		[Bindable]
		public function set createdTime(createdTime:Date):void{
			this._createdTime = createdTime;
		}
		
		public function get createdTimeString():String{
			return _createdTimeString;
		}		
		[Bindable]
		public function set createdTimeString(createdTimeString:String):void{
			this._createdTimeString = createdTimeString;
		}
		
		public function get creator():String{
			return _creator;
		}		
		[Bindable]
		public function set creator(creator:String):void{
			this._creator = creator;
		}
		
		public function get creatorName():String{
			return _creatorName;
		}		
		[Bindable]
		public function set creatorName(creatorName:String):void{
			this._creatorName = creatorName;
		}
		
		public function get description():String{
			return _description;
		}		
		[Bindable]
		public function set description(description:String):void{
			this._description = description;
		}
		
		public function get icon():Class{
			//return WorkbenchIconLibrary.PACKAGE_ICON;	
			return null;
		}
		
		public function get pkgStatus():String{
			return _pkgStatus;
		}		
		[Bindable]
		public function set pkgStatus(pkgStatus:String):void{
			this._pkgStatus = pkgStatus;
		}
		
		public function get label():String{
			return name;
		}
		
		public function toXML():XML{
			var resourceXML:XML = 
			<resource id="" type="">
				<name/>
			</resource>;
			
			resourceXML.@id = this.id;
			resourceXML.name = this.name;
			resourceXML.@type = this.type;
			resourceXML.@createdTime = this.createdTime;
			resourceXML.@creator = this.creator;
			resourceXML.@creatorName = this.creatorName;
			resourceXML.@description = this.description;
			resourceXML.@pkgStatus = this.pkgStatus;
			
			return resourceXML;
		}
		
		protected static function parseResource(resource:AbstractResourceMetaModel, resourceXML:XML):void{
			resource.id = resourceXML.id;			
			resource.version = resourceXML.version;			
			resource.name = resourceXML.name;
			if(resourceXML.createdTime.@["class"] == "sql-timestamp"){
				resource.createdTime = DateUtil.parseDateString(resourceXML.createdTime.toString());
				resource.createdTimeString = resourceXML.createdTime.toString();				
			}else{
				resource.createdTime = new Date(resourceXML.createdTime);
				resource.createdTimeString = resourceXML.createdTime;
			}
			
			if(resourceXML.modifiedTime.@["class"] == "sql-timestamp"){
				resource.modifiedTime = DateUtil.parseDateString(resourceXML.modifiedTime.toString());	
				resource.modifiedTimeString = resourceXML.modifiedTime.toString();				
			}else{
				resource.modifiedTime = new Date(resourceXML.modifiedTime);
				resource.modifiedTimeString = resourceXML.modifiedTime;
			}
			resource.creator = resourceXML.creator;
			resource.creatorName = resourceXML.creatorName;
			resource.pkgStatus = resourceXML.status;
			resource.modifier = resourceXML.modifier;
			resource.modifierName = resourceXML.modifierName;
			resource.description = resourceXML.description;;
		}
	}
}