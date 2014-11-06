package com.maninsoft.smart.workbench.common.meta
{
	import com.maninsoft.smart.workbench.common.assets.WorkbenchIconLibrary;
	
	public class AbstractPackageChildResourceMeta extends AbstractResourceMetaModel implements IPackageChildResourceMeta
	{
		/**
		 * 체크아웃 상태
		 */
		public static const STATUS_CHECKED_OUT:String = "CHECKED-OUT";
		/**
		 * 체크인 상태
		 */
		public static const STATUS_CHECKED_IN:String = "CHECKED-IN";
		/**
		 * 배치
		 */
		public static const STATUS_DEPLOYED:String = "DEPLOYED";
		
		private var pack:IPackageMetaModel;
		private var _uid:String;
		private var _status:String;
		private var _keyword:String;
		private var _ownerDept:String;
		private var _owner:String;
			
		public function AbstractPackageChildResourceMeta()
		{
		}
		
		public function getPackage():IPackageMetaModel{
			return this.pack;
		}
		public function setPackage(packageModel:IPackageMetaModel):void{
			this.pack = packageModel;
		}
		
		public function get status():String{
			return this._status;
		}
		[Bindable]
		public function set status(status:String):void{
			this._status = status;
		}
		
		public function get uid():String{
			return this._uid;
		}
		[Bindable]
		public function set uid(uid:String):void{
			this._uid = uid;
		}

		public function get keyword():String{
			return this._keyword;
		}
		[Bindable]
		public function set keyword(keyword:String):void{
			this._keyword = keyword;
		}
		
		public function get ownerDept():String{
			return this._ownerDept;
		}
		[Bindable]
		public function set ownerDept(ownerDept:String):void{
			this._ownerDept = ownerDept;
		}
		
		public function get owner():String{
			return this._owner;
		}
		[Bindable]
		public function set owner(owner:String):void{
			this._owner = owner;
		}
						
		protected static function parseChildResource(resource:AbstractPackageChildResourceMeta, resourceXML:XML):void{
			parseResource(resource, resourceXML);

			resource.status = resourceXML.status;
			resource.keyword = resourceXML.keyword;			
			resource.ownerDept = resourceXML.ownerDept;
			resource.owner = resourceXML.owner;			
		}
	}
}