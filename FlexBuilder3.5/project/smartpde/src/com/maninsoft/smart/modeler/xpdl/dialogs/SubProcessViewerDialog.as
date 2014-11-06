package com.maninsoft.smart.modeler.xpdl.dialogs
{
	import com.maninsoft.smart.modeler.assets.XPDLEditorAssets;
	import com.maninsoft.smart.modeler.xpdl.dialogs.viewer.SubDiagramViewer;
	import com.maninsoft.smart.modeler.xpdl.dialogs.viewer.SubInstanceViewer;
	import com.maninsoft.smart.modeler.xpdl.model.SubFlow;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.view.SubFlowView;
	import com.maninsoft.smart.workbench.common.event.LoadCallbackEvent;
	import com.maninsoft.smart.workbench.common.event.SelectActivityCallbackEvent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	
	import mx.containers.TitleWindow;
	import mx.core.Application;
	import mx.core.ScrollPolicy;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;

	public class SubProcessViewerDialog extends TitleWindow
	{

		//----------------------------------------------------------------------
		// Class Variables
		//----------------------------------------------------------------------
		private static var _dialog: SubProcessViewerDialog;

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		private var _diagramViewer: SubDiagramViewer;
		private var _instanceViewer: SubInstanceViewer;
		private var _diagram: XPDLDiagram;
		private var _subFlow: SubFlow;
		private var _subFlowView: SubFlowView;
		
		public function SubProcessViewerDialog()
		{
			super();
			this.titleIcon = XPDLEditorAssets.subTaskIcon;
			this.showCloseButton=true;
			this.addEventListener(CloseEvent.CLOSE, close);
			this.styleName = "subProcessViewer";
		}
		
		private function closeUp(): void{
			PopUpManager.removePopUp(this);			
		}
		
		protected function close(event: Event = null):void {
			_dialog._subFlow.subFlowView = SubFlow.VIEW_COLLAPSED;
		}

		//----------------------------------------------------------------------
		// Class methods
		//----------------------------------------------------------------------

		public static function execute(title: String, diagram: XPDLDiagram, subFlow: SubFlow, subFlowView: SubFlowView, isDiagramViewer: Boolean, position: Point=null, width:Number=0, height:Number=0): void {
			_dialog = PopUpManager.createPopUp(Application.application as DisplayObject, 
	                                   SubProcessViewerDialog, false) as SubProcessViewerDialog;
	                                   
			_dialog.title = title;
			_dialog._diagram = diagram;
			_dialog._subFlow = subFlow;
			_dialog._subFlowView = subFlowView;
			
			if(position){
				_dialog.x = position.x;
				_dialog.y = position.y;
			}else{
				PopUpManager.centerPopUp(_dialog);	
			}
	
			if(width) _dialog.width = width;
			if(height) _dialog.height = height;

			if(isDiagramViewer) _dialog.loadDiagramViewer();
			else _dialog.loadInstanceViewer();
		}
		
		public static function closeViewer(): void{
			if(_dialog)
				_dialog.closeUp();
		}
		
		private function initViewer(): void{
		}
				
		private function loadDiagramViewer(): void{
			this.setStyle("backgroundColor", _subFlowView.fillColor);
			this.setStyle("borderColor", _subFlowView.borderColor);

			_diagramViewer = new SubDiagramViewer();
			_diagramViewer.id = "diagramViewer";
			_diagramViewer.percentHeight = 100;
			_diagramViewer.percentWidth = 100;
			_diagramViewer.verticalScrollPolicy = ScrollPolicy.OFF;
			_diagramViewer.horizontalScrollPolicy = ScrollPolicy.OFF;
			_diagramViewer.addEventListener(LoadCallbackEvent.LOAD_CALLBACK, loadCallbackHandler);
			_diagramViewer.addEventListener(SelectActivityCallbackEvent.SELECT_ACTIVITY_CALLBACK, selectActivityCallbackHandler);
			this.addChild(_diagramViewer);
			_diagramViewer.loadDiagram(_diagram);
		}

		private function loadInstanceViewer(): void{
			this.setStyle("backgroundColor", _subFlowView.fillColor);
			this.setStyle("borderColor", _subFlowView.borderColor);

			_instanceViewer = new SubInstanceViewer();
			_instanceViewer.id = "diagramViewer";
			_instanceViewer.percentHeight = 100;
			_instanceViewer.percentWidth = 100;
			_instanceViewer.verticalScrollPolicy = ScrollPolicy.OFF;
			_instanceViewer.horizontalScrollPolicy = ScrollPolicy.OFF;
			_instanceViewer.addEventListener(LoadCallbackEvent.LOAD_CALLBACK, loadCallbackHandler);
			_instanceViewer.addEventListener(SelectActivityCallbackEvent.SELECT_ACTIVITY_CALLBACK, selectActivityCallbackHandler);
			this.addChild(_instanceViewer);
			_instanceViewer.loadDiagram(_diagram);
		}

		public function loadCallbackHandler(event:LoadCallbackEvent):void{
			_diagramViewer.resetExtents();
		}	

		public function selectActivityCallbackHandler(event: SelectActivityCallbackEvent):void{
			ExternalInterface.call(SelectActivityCallbackEvent.SELECT_ACTIVITY_CALLBACK, event.taskId);
		}			
	}
}