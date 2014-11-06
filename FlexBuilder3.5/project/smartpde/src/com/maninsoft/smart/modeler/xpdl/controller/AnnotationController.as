////////////////////////////////////////////////////////////////////////////////
//  AnnotationController.as
//  2007.12.21, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.controller
{
	import com.maninsoft.smart.modeler.model.events.NodeChangeEvent;
	import com.maninsoft.smart.modeler.view.IView;
	import com.maninsoft.smart.modeler.view.NodeView;
	import com.maninsoft.smart.modeler.xpdl.model.Annotation;
	import com.maninsoft.smart.modeler.xpdl.view.AnnotationView;
	
	import flash.geom.Rectangle;
	
	/**
	 * Controller for Annotation
	 */	
	public class AnnotationController extends ArtifactController {
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function AnnotationController(model: Annotation) {
			super(model);
		}


		//------------------------------
		// ITextEditable
		//------------------------------
		override public function canModifyText(): Boolean {
			return true;
		}

		override public function getEditText(): String {
			return Annotation(model).textAnnotation;
		}
		
		override public function setEditText(value: String): void {
			Annotation(model).textAnnotation = value;
		}
		
		override public function getTextEditBounds(): Rectangle {
			var r: Rectangle = controllerToEditorRect(nodeModel.bounds);
			r.inflate(-2, -2);

			return r;
		}


		//----------------------------------------------------------------------
		// Overriden Methods
		//----------------------------------------------------------------------
		
		override protected function createNodeView(): NodeView {
			return new AnnotationView();
		}
		
		override protected function initNodeView(nodeView:NodeView): void {
			super.initNodeView(nodeView);

			var view: AnnotationView = nodeView as AnnotationView;
			view.borderColor = 	Annotation(nodeModel).borderColor = 0xa0c4ce; 
			view.text = Annotation(nodeModel).textAnnotation;
		}
		
		override protected function nodeChanged(event: NodeChangeEvent): void {
			var v: AnnotationView = view as AnnotationView;
			var m: Annotation = model as Annotation;
			
			switch (event.prop) {
				case Annotation.PROP_TEXT_ANNOTATION:	
					if (m.textAnnotation.length == 0) {
						v.text = " ";
					} else {
						v.text = m.textAnnotation;
					}
					break;

				default:
					super.nodeChanged(event);
			}
		}
	}
}