package com.maninsoft.smart.modeler.xpdl.model.process
{
	import com.maninsoft.smart.formeditor.model.type.FormatType;
	import com.maninsoft.smart.formeditor.model.type.FormatTypes;
	import com.maninsoft.smart.modeler.mapper.IMappingItem;
	import mx.resources.ResourceManager;
	
	
	/**
	 * XPDL DataField
	 */
	public class FormalParameter extends XPDLElement implements IMappingItem {
/*
		public static const MODE_IN: String = "IN";
		public static const MODE_OUT: String = "OUT";
		public static const MODE_INOUT: String = "INOUT";
		public static const MODE_TYPES: Array = [MODE_IN, MODE_OUT, MODE_INOUT];
		public static var MODE_TYPES_NAME: Array = [	ResourceManager.getInstance().getString("ProcessEditorETC", "modeINText"),
														ResourceManager.getInstance().getString("ProcessEditorETC", "modeOUTText"),
														ResourceManager.getInstance().getString("ProcessEditorETC", "modeINOUTText")]
*/
		public static const MODE_IN: String = "IN";
		public static const MODE_OUT: String = "OUT";
		public static const MODE_INOUT: String = "INOUT";
		public static const MODE_TYPES: Array = [MODE_INOUT];
		public static const MODE_TYPES_FULL: Array = [MODE_INOUT, MODE_IN, MODE_OUT];
		public static var MODE_TYPES_NAME: Array = [ResourceManager.getInstance().getString("ProcessEditorETC", "modeINOUTText")];
		public static var MODE_TYPES_NAME_FULL: Array = [ResourceManager.getInstance().getString("ProcessEditorETC", "modeINOUTText"),
														ResourceManager.getInstance().getString("ProcessEditorETC", "modeINText"),
														ResourceManager.getInstance().getString("ProcessEditorETC", "modeOUTText")];
		public static function getModeIndex(mode: String): int{
			for(var i:int=0; i<MODE_TYPES_FULL.length; i++)
				if(MODE_TYPES_FULL[i] == mode)
					return i;
			for(i=0; i<MODE_TYPES_NAME_FULL.length; i++)
				if(MODE_TYPES_NAME_FULL[i] == mode)
					return i;
			return -1;
		}
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		public var _owner: Object;
		private var _parentId:String = null;		
		

		//----------------------------------------------------------------------
		// XPDL Properties
		//----------------------------------------------------------------------
		
		public var id: String;
		public var name: String;
		public var initialValue: String;
		public var required: Boolean;
		public var mode: String;
		public var dataType: String;


		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function FormalParameter(owner: Object) {
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
		
		public function get parentId(): String{
			if(owner && owner is WorkflowProcess){
				return XPDLPackage(WorkflowProcess(owner).owner).process.parentId
			}
			return _parentId;
		}
		
		public function set parentId(value: String):void{
			_parentId = value;
		}

		public function get formatType(): FormatType{
			return FormatTypes.getFormatType(dataType, false);
		}

		//----------------------------------------------------------------------
		// IMappingItem
		//----------------------------------------------------------------------
		
		public function get key(): Object {
			return this;
		}
		
		public function get label(): String {
			return (name)?name:id;
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override protected function doRead(src: XML): void {
			id			= src.@Id;
			name		= src.@Name;
			initialValue= src.@InitialValue;
			required 	= src.@Required == "true" || src.@Required == "TRUE";
			mode		= src.@Mode;
			
			if (src._ns::DataType._ns::BasicType) {
				dataType = src._ns::DataType._ns::BasicType.@Type;
			} else if (src._ns::DataType._ns::DeclaredType) {
				dataType = src._ns::DataType._ns::DeclaredType.@Type;
			}
		}
		
		override protected function doWrite(dst: XML): void {
			dst.@Id				= id;
			dst.@Name			= name;
			dst.@InitialValue	= initialValue;
			dst.@Required		= required;
			dst.@Mode			= mode;
			
			// 우선 BasicType이라고 가정한다.
			dst._ns::DataType._ns::BasicType.@Type = dataType;
		}
	}
}