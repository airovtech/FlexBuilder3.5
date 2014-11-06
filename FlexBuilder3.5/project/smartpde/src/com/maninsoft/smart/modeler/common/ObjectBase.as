////////////////////////////////////////////////////////////////////////////////
//  ObjectBase.as
//  2007.12.13, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.common
{
	import flash.events.EventDispatcher;
	import flash.utils.describeType;
	
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	/**
	 * Base object
	 */
	public class ObjectBase extends EventDispatcher {
		
		private var _resourceManager:IResourceManager;

		public function ObjectBase() {
			this._resourceManager = ResourceManager.getInstance();
		}

		public function get resourceManager():IResourceManager{
			if(_resourceManager==null)
				_resourceManager = ResourceManager.getInstance();
			return _resourceManager;
		}

		public function getFullClassName(): String {
			return describeType(this).@name;			
		}

		public function getClassName(): String {
			var str: String = describeType(this).@name;
			var idx: int = str.indexOf("::");
			
			return str.substr(idx + 2);			
		}

		override public function toString(): String {	
			var classInfo: XML = describeType(this);
			var a: XML;	
			var s: String = "\n[" + classInfo.@name.toString() + "] ==\n";			
		
			
			for each (a in classInfo..variable) {
            	s += "    " + a.@name + "=" + this[a.@name] + "\n";
            } 

			for each (a in classInfo..accessor) {
				try {
	                if (a.@access != 'writeonly' && !isHiddenProperty(a.@name)) {
	                    s += "    " + a.@name + "=" + this[a.@name] + "\n";
	                }
			  	} catch (e: Error) {
                    s += "    " + a.@name + "=<<Error!!!>>" + "\n";
			  	}
            } 

			return s + "======================================================\n";
			
			/*
			var obj: Object = ObjectUtil.getClassInfo(this);
			return ObjectUtil.toString(obj);
			*/
		}
		
		protected function isHiddenProperty(property: String): Boolean {
			return false;
		}
	}
}