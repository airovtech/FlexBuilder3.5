////////////////////////////////////////////////////////////////////////////////
//  Condition.as
//  2008.01.30, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.model.process
{
	import com.maninsoft.smart.modeler.xpdl.server.Server;
	
	/**
	 * XPDL Condition
	 */
	public class Condition extends XPDLElement {
		
		//----------------------------------------------------------------------
		// Class const
		//----------------------------------------------------------------------

		public static const DEF_TYPE	 : String = "CONDITION";
		public static const DEF_GRAMMAR: String = "javascript";

		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		public var type: String = DEF_TYPE;
		private var _expression: String = EMPTY_STRING;
		public var scriptGrammar: String = DEF_GRAMMAR;


		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function Condition() {
			super();
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		/**
		 * expression
		 */
		public function get expression(): String {
			return _expression;
		}
		
		public function set expression(value: String): void {
			_expression = value ? value : EMPTY_STRING;
		}
		

		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override protected function doRead(src: XML): void {
			type = src.@Type;
			if (!type) type = DEF_TYPE

			_expression = src._ns::Expression;
			
			scriptGrammar	= src._ns::Expression.@ScriptGrammar;
			if (!scriptGrammar) scriptGrammar = DEF_GRAMMAR;
		}
		
		override protected function doWrite(dst: XML): void {
			dst.@Type			= type;	
			dst._ns::Expression	= _expression ? _expression : ""; 
			dst._ns::Expression.@ScriptGrammar	= scriptGrammar; 
		}
	}
}