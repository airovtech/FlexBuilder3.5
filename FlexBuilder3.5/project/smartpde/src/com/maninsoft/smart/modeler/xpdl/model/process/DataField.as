////////////////////////////////////////////////////////////////////////////////
//  DataField.as
//  2008.01.09, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.model.process
{
	import com.maninsoft.smart.modeler.mapper.IMappingItem;
	import com.maninsoft.smart.modeler.xpdl.server.Server;
	
	
	
	/**
	 * XPDL DataField
	 */
	public class DataField	extends XPDLElement implements IMappingItem {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		public var _owner: Object;
		

		//----------------------------------------------------------------------
		// XPDL Properties
		//----------------------------------------------------------------------
		
		public var id: String;
		public var name: String;
		public var isArray: Boolean;
		public var dataType: String;		
		public var initialValue: String;


		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function DataField(owner: Object) {
			super();
			
			_owner = owner;
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		/**
		 * Activity나 Process가 될 수 있겠다.
		 */
		public function get owner(): Object {
			return _owner;
		}


		//----------------------------------------------------------------------
		// IMappingItem
		//----------------------------------------------------------------------
		
		public function get key(): Object {
			return this;
		}
		
		public function get label(): String {
			return name;
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override protected function doRead(src: XML): void {
			id		= src.@Id;
			name	= src.@Name;
			isArray = src.@IsArray == "true" || src.@IsArray == "TRUE";
			
			if (src._ns::DataType._ns::BasicType) {
				dataType = src._ns::DataType._ns::BasicType.@Type;
			} else if (src._ns::DataType._ns::DeclaredType) {
				dataType = src._ns::DataType._ns::DeclaredType.@Type;
			}
			
			initialValue = src._ns::InitialValue;
		}
		
		override protected function doWrite(dst: XML): void {
			dst.@Id			= id;
			dst.@Name		= name;
			dst.@IsArray	= isArray;
			
			// 우선 BasicType이라고 가정한다.
			dst._ns::DataType._ns::BasicType.@Type = dataType;
		}
	}
}