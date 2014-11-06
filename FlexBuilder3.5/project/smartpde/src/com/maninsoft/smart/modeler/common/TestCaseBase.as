////////////////////////////////////////////////////////////////////////////////
//  TestCaseBase.as
//  2008.02.01, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved.
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.common
{
	import flexunit.framework.TestCase;
	
	import mx.controls.TextArea;
	import mx.core.Application;
	
	/**
	 * TestRunner의 메시지 상자에 정보를 표시할 수 있도록 확장
	 */
	public class TestCaseBase extends TestCase {
		
		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		public function TestCaseBase(name: String) {
			super(name);
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		private function get message(): String {
			return (Application.application.txtConsole as TextArea).htmlText;
		}

		private function set message(value: String): void {
			(Application.application.txtConsole as TextArea).htmlText = message + value;
		}


		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------

		public function traceText(text: String): void {
			(Application.application.txtConsole as TextArea).text = text;
		}

		public function traceNormal(obj: Object, highlight: Boolean = false): void {
			var msg: String = "<p>";
			
			if (highlight) {
				msg += "<b>";
			} 
			
			msg += obj.toString();
			
			if (highlight) {
				msg += "</b>";
			} 
			
			msg += "</p>";

			message = msg;
		}
		
		public function traceError(obj: Object, highlight: Boolean = false): void {
			var msg: String = "<p><font color='#ff0000'>";

			if (highlight) {
				msg += "<b>";
			} 
			
			msg += obj.toString();
			
			if (highlight) {
				msg += "</b>";
			} 

			msg += "</font></p>";
			
			message = msg;
		}
		
 		public function traceXml(xml: Object): void {
			if (xml is XML) 
				(Application.application.txtConsole as TextArea).text = (xml as XML).toXMLString();
		}
	}
}