////////////////////////////////////////////////////////////////////////////////
//  Annotation.as
//  2007.12.20, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.model
{
	import com.maninsoft.smart.modeler.xpdl.model.base.Artifact;
	
	/**
	 * XPDL Annotation artifact
	 */
	public class Annotation extends Artifact {
		
		//----------------------------------------------------------------------
		// Property names
		//----------------------------------------------------------------------
		
		public static const PROP_TEXT_ANNOTATION: String = "prop.textAnnotation";
		
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		//------------------------------
		// XPDL
		//------------------------------
		private var _textAnnotation: String;


		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/**
		 * Construtor 
		 */
		public function Annotation() {
			super();
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		/**
		 * XPDL TextAnnotation
		 */
		public function get textAnnotation(): String {
			return _textAnnotation;
		}
		
		public function set textAnnotation(value: String): void {
			var oldVal: String = textAnnotation;
			
			if (value != oldVal) {
				_textAnnotation = value;
				fireChangeEvent(PROP_TEXT_ANNOTATION, oldVal);
			}
		}


		//----------------------------------------------------------------------
		// Overriend methods
		//----------------------------------------------------------------------

		override protected function doWrite(dst: XML): void {
			super.doWrite(dst);
			
			dst.@ArtifactType = "Annotation";
			dst.@TextAnnotation = textAnnotation;
		}

		override protected function doRead(src: XML): void {
			super.doRead(src);
			
			_textAnnotation = src.@TextAnnotation;
		}
		
		override public function setPropertyValue(id: String, value: Object): void {
			textAnnotation = value.toString();
		}

		override public function getPropertyValue(id:String):Object{
			return textAnnotation;
		}
	}
}