package com.maninsoft.smart.formeditor.model
{
	public class AbstractActualParameter
	{
		public function AbstractActualParameter()
		{
			super();
		}

		public var execution:String;
		public var executionName:String;
		
		public var _parent:ActualParameters;
		public var serviceLink:ServiceLink;
		
		public function get parent():ActualParameters {
			return _parent;
		}
		public function set parent(parent:ActualParameters):void {
			this._parent = parent;
		}
		
		public function toXML(dst:XML=null):XML {
			return null;
		}
		public function clone():AbstractActualParameter{
			return null;
		}
	}
}