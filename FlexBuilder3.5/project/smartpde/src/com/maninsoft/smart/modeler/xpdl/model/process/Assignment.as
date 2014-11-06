////////////////////////////////////////////////////////////////////////////////
//  Assignment.as
//  2008.01.12, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.model.process
{
	import com.maninsoft.smart.modeler.mapper.IMappingItem;
	import com.maninsoft.smart.modeler.mapper.IMappingLink;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
	import com.maninsoft.smart.modeler.xpdl.server.Server;
	
	
	
	/**
	 * XPDL Assignment
	 */
	public class Assignment extends XPDLElement implements IMappingLink {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _owner: Activity;

		//------------------------------
		// XPDL Properties
		//------------------------------
		
		public var assignTime: String;
		public var target: String;
		public var expression: String;		


		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function Assignment(owner: Activity) {
			super();
			
			_owner = owner;
		}


		//----------------------------------------------------------------------
		// IMappingLink
		//----------------------------------------------------------------------

		public function get sourceItem(): IMappingItem {
			return findExpressionDataField();
		}
		
		public function get targetItem(): IMappingItem {
			return owner.findDataField(target);
		}

		public function connect(sourceItem: IMappingItem, targetItem: IMappingItem): void {
			var fld: DataField = sourceItem as DataField;
			expression = "/task/" + fld.owner.id + "/" + fld.name;
			target = DataField(targetItem).name;
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		public function get owner(): Activity {
			return _owner;
		}


		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------
		 
		public function isValid(): Boolean {
			return targetItem && sourceItem;
		}

		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override protected function doRead(src: XML): void {
			assignTime 	= src.@AssignTime;
			target		= src._ns::Target;
			expression	= src._ns::Expression;
		}
		
		override protected function doWrite(dst: XML): void {
			dst.@AssignTime		= assignTime ? assignTime : "Start";
			dst._ns::Target		= target;
			dst._ns::Expression	= expression;
		}


		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------

		/**
		 * 현재 expression에는 이 Assignment의 소스가 되는 Activity의 DataField가 지정되어 있다. 
		 * expression을 파싱하영 expression DataField를 리턴한다.
		 * expression ==> /task/id/datafield.Name
		 */
		private function findExpressionDataField(): DataField {
			if (owner.diagram && expression) {
				var str: Array = expression.substr(1).split("/");
	
				if (str && (str.length == 3)) {
					var act: Activity = XPDLDiagram(owner.diagram).findActivity(int(str[1]));
									
					if (act) {
						return act.findDataField(str[2]);
					}
				}
			}
			
			return null;
		}
	}
}