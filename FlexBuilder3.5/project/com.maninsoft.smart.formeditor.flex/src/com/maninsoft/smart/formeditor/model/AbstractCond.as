package com.maninsoft.smart.formeditor.model
{
	public class AbstractCond
	{
		public function AbstractCond()
		{
			super();
		}

		public var operator:String;
		public var operatorName:String;
		
		public var _parent:Conds;
		public var formLink:FormLink;
		
		public function get parent():Conds {
			return _parent;
		}
		public function set parent(parent:Conds):void {
			this._parent = parent;
		}
		
		public function toXML():XML {
			return null;
		}
		public function clone():AbstractCond{
			return null;
		}
	}
}