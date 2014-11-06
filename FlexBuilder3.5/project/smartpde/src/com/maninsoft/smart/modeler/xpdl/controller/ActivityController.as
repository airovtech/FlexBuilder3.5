////////////////////////////////////////////////////////////////////////////////
//  ActivityController.as
//  2008.01.12, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.controller
{
	import com.maninsoft.smart.modeler.editor.handle.SelectHandle;
	import com.maninsoft.smart.modeler.mapper.IMappingItem;
	import com.maninsoft.smart.modeler.mapper.IMappingLink;
	import com.maninsoft.smart.modeler.mapper.IMappingSource;
	import com.maninsoft.smart.modeler.model.events.NodeChangeEvent;
	import com.maninsoft.smart.modeler.view.NodeView;
	import com.maninsoft.smart.modeler.xpdl.XPDLEditor;
	import com.maninsoft.smart.modeler.xpdl.model.StartEvent;
	import com.maninsoft.smart.modeler.xpdl.model.action.CheckStartActivityAction;
	import com.maninsoft.smart.modeler.xpdl.model.action.SetActivityPerformerAction;
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
	import com.maninsoft.smart.modeler.xpdl.model.base.XPDLLink;
	import com.maninsoft.smart.modeler.xpdl.view.base.ActivityView;
	
	import flash.geom.Rectangle;
	
	/**
	 * Activity 모델의 컨트롤러 base
	 */
	public class ActivityController extends XPDLNodeController implements IMappingSource {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------


		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function ActivityController(model: Activity) {
			super(model);
		}
		

		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/** 
		 * Property model
		 */
		public function get activity(): Activity {
			return super.model as Activity;
		}

		//----------------------------------------------------------------------
		// Virtual methods
		//----------------------------------------------------------------------
		
		/**
		 * XPDL 노드라면 공통적으로 갖게 되는 컨트롤러 툴들을 생성한다.
		 */
		override protected function createCommonTools(): Array {
			return super.createCommonTools();
		}


		//----------------------------------------------------------------------
		// IMappingSource
		//----------------------------------------------------------------------
	
		public function get mappingBounds(): Rectangle {
			return controllerToEditorRect(bounds);
		}
	
		public function get mappingTitle(): String {
			return activity.name;
		}
		
		public function get mappingItems(): Array {
			return activity.mappingItems;
		}
		
		/**
		 * 이 소스로 부터 target 으로 연결된 링크들의 컬렉션
		 */
		public function getMappingLinks(target: IMappingSource): Array {
			return activity.getMappingLinks(target);	
		}
		
		public function addMappingLink(source: IMappingItem, target: IMappingItem): IMappingLink {
			return activity.addMappingLink(source, target);
		}
		
		public function removeMappingLink(link: IMappingLink): void {
			activity.removeMappingLink(link);
		}


		//----------------------------------------------------------------------
		// Overriden properties
		//----------------------------------------------------------------------

		override public function get canPopUp(): Boolean {
			return true;
		}
		
		override public function get actions(): Array {
			return [ new CheckStartActivityAction(this.activity),
			          new SetActivityPerformerAction(this.activity)
			        ];
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override protected function initNodeView(nodeView: NodeView): void {
			super.initNodeView(nodeView);
			
			var activity: Activity = nodeModel as Activity;
			var view: ActivityView = nodeView as ActivityView;
			
			view.problem = activity.problem;
			view.isMultiInstance = activity.isMultiInstance;
			view.multiInstanceBehavior = activity.multiInstanceBehavior;
			view.orderIndex = activity.orderIndex;
			
			checkStatus(activity.status, view);
			checkInterestStatus(activity.interestStatus, view);
		}

		override protected function nodeChanged(event: NodeChangeEvent): void {
			var v: ActivityView = view as ActivityView;
			var m: Activity = model as Activity;
			
			switch (event.prop) {
				case Activity.PROP_STATUS:
					checkStatus(m.status, v);
					checkInterestStatus(m.interestStatus, v);
					refreshView();
					break;
					
				case Activity.PROP_PROBLEM:
					v.problem = m.problem;
					refreshView();
					break;
					
				case Activity.PROP_ORDER_INDEX:
					v.orderIndex = m.orderIndex;
					break;
					
				case Activity.PROP_STARTACTIVITY:
					var myStartEvent: StartEvent = getStartEvent();
					if(myStartEvent){
 						StartEventController(editor.findControllerByModel(myStartEvent)).nodeChanged(event);
						if(m.startActivity){
							var arr:Array = XPDLEditor(this.editor).xpdlDiagram.activities;
							for each (var activity:Activity in arr) {
								if(activity.startActivity && activity != this.model)	activity.startActivity = false;
							}
						}
					}
					refreshPropertyPage();
					break;
					
				case Activity.PROP_MULTI_INSTANCE:
					v.isMultiInstance = m.isMultiInstance;
					v.multiInstanceBehavior = m.multiInstanceBehavior;
					refreshPropertyPage();
					refreshView();
					break;
					
				case Activity.PROP_MULTI_INSTANCE_BEHAVIOR:
					v.multiInstanceBehavior = m.multiInstanceBehavior;
					refreshView();
					break;
					
				default:
					super.nodeChanged(event);
			}
		}

		/**
		 * anchorDir 쪽 선택 핸들을 이용 마우스가 dx, dy 만큼 이동한 대로 크기 변경 가능한가?
		 */
		override public function canResizeBy(anchorDir: int, dx: Number, dy: Number): Boolean {
			var rslt: Boolean = super.canResizeBy(anchorDir, dx, dy);
			
			if (rslt) {
				var r: Rectangle = nodeModel.bounds;

				switch (anchorDir) {
					case SelectHandle.DIR_TOPLEFT:
						break;
						
					case SelectHandle.DIR_TOP:
						break;
						
					case SelectHandle.DIR_TOPRIGHT:
						break;
						
					case SelectHandle.DIR_RIGHT:
						break;
						
					case SelectHandle.DIR_BOTTOMRIGHT:
						break;
						
					case SelectHandle.DIR_BOTTOM:
						break;
						
					case SelectHandle.DIR_BOTTOMLEFT:
						break;
						
					case SelectHandle.DIR_LEFT:		
						// dx가 0보다 적으면면 좌변이 좌로 이동하면서 크기가 커진다.
						if (dx < 0) {
							r.offset(dx, 0);
							r.width -= dx;	
						}	
						else {
							r.width += dx;
						}
						
						break;
						
					default:
						throw new Error("Invalid canResizeBy(" + anchorDir + ")");
				}
				
				var rLane: Rectangle = activity.pool.getLaneBodyRect(activity.laneId);
				rslt = rLane.containsRect(r);
			} 
			
			return rslt;
		}


		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------

		/**행
		 * TODO: ActivityController로 옮겨야 함.
		 * TODO: GatewayController를 ActivityController 밑으로 바꿀 것
		 */
		protected function checkStatus(status: String, view: ActivityView): void {
			//if (xpdlEditor.isRunning) {

			view.showShadowed = false;
			view.showGrayed = false;
			view.showGradient = false;
			view.showGlowed = false;

			switch (status) {
				case Activity.STATUS_READY:// Assigned to the performer, but not start yet
					view.fillColor = 0xd4e9ac;
					view.borderColor = 0xa9cb60;
					break;
	
				case Activity.STATUS_PROCESSING: // Assigned to the performer and started, but finished yet
					view.fillColor = 0xd4e9ac;
					view.borderColor = 0xa9cb60;
					break;
	
				case Activity.STATUS_COMPLETED: // finished task 
					view.fillColor = 0xd3d3d3;
					view.borderColor = 0xa6a6a6;
					break;
	
				case Activity.STATUS_SUSPENDED: // Process is stopped at the task
					view.fillColor = 0xefa10b;
					view.borderColor = 0xd9aa2c;
					break;
	
				case Activity.STATUS_RETURNED: // Assigned to the performer, but returned to the previous task before started
					view.fillColor = 0xbfe9e8;
					view.borderColor = 0x9bcad0;
					break;
	
				case Activity.STATUS_DELAYED: // Assigned to the performer, but not started yet even the planed start time is over
					view.fillColor = 0xff6d6d;
					view.borderColor = 0xd84a2e;
					break;

				case Activity.STATUS_NONE:
				default:
					view.fillColor = 0xe6f1f3;
					view.borderColor = 0xafc6cb;
					break;
	
			}
		}
		
		/**
		 * 프로세스 다이어그램 뷰어에서 관심있는(예:자신관련된업무)에 해당하는 지정되어 있으면 Glow(발광효과)를 낸다.
		 */
		protected function checkInterestStatus(status: Boolean, view: ActivityView): void {
			if (xpdlEditor.isRunning) {
				if(status){
					view.showGlowed = true;
				}
			}
		}
		
		private function getStartEvent(): StartEvent{
			if(!activity.incomingLinks)
				return null;
			for(var i:int=0; i<activity.incomingLinks.length; i++){
				if(XPDLLink(activity.incomingLinks[i]).source is StartEvent){
					return XPDLLink(activity.incomingLinks[i]).source as StartEvent;
				}
			}
			return null;
		}		

		private function refreshPropertyPage():void{
			if(editor.selectionManager.contains(this) && editor.selectionManager.items.length==1)
				editor.select(model);
		}
	}
}