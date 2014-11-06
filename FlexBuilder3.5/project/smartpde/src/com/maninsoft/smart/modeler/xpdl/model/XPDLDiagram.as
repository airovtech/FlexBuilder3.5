////////////////////////////////////////////////////////////////////////////////
//  XPDLReader.as
//  2008.01.09, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.model
{
	import com.maninsoft.smart.modeler.editor.events.DiagramChangeEvent;
	import com.maninsoft.smart.modeler.model.Diagram;
	import com.maninsoft.smart.modeler.model.Link;
	import com.maninsoft.smart.modeler.model.Node;
	import com.maninsoft.smart.modeler.model.utils.DiagramUtils;
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
	import com.maninsoft.smart.modeler.xpdl.model.base.ActivityTypes;
	import com.maninsoft.smart.modeler.xpdl.model.base.Artifact;
	import com.maninsoft.smart.modeler.xpdl.model.base.XPDLLink;
	import com.maninsoft.smart.modeler.xpdl.model.base.XPDLNode;
	import com.maninsoft.smart.modeler.xpdl.model.pool.Lane;
	import com.maninsoft.smart.modeler.xpdl.model.process.XPDLPackage;
	import com.maninsoft.smart.modeler.xpdl.server.Server;
	
	/**
	 * XPDL Diagram
	 */
	public class XPDLDiagram extends Diagram	{
		
		//----------------------------------------------------------------------
		// Varaibles
		//----------------------------------------------------------------------

		private var _nextId: int = 1;

		
		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function XPDLDiagram() {
			super();
		}		

		
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/**
		 * server
		 */
		private var _server: Server;
		
		public function get server(): Server {
			return _server;
		}
		
		public function set server(value: Server): void {
			_server = value;
		}
		
		/**
		 * xpdlPackage
		 */
		private var _xpdlPackage: XPDLPackage;

		public function get xpdlPackage(): XPDLPackage {
			return _xpdlPackage;
		}
		
		public function set xpdlPackage(value: XPDLPackage): void {
			var id: int;
			
			_xpdlPackage = value;
			
			id = value.pool.id;
			_pool = value.pool;
			root.addChild(_pool);
			_pool.id = id;
			
			for each (var act: Activity in value.process.activities) {
				id = act.id;
				_pool.addChild(act);
				act.id = id;
				loadId(act.id);
				
				// laneId를 재설정한다.
				var lane: Lane = _pool.getLaneAt(act.x, act.y);
				act.lane = lane;
			}
			
			for each (var art: Artifact in value.artifacts) {
				id = art.id;
				_pool.addChild(art);
				art.id = id;
				loadId(art.id);
			}

			for each (var lnk: XPDLLink in value.process.transitions) {
				id = lnk.id;
				this.addLink(lnk);
				lnk.id = id;
				loadId(lnk.id);
			}
		}
		
		/**
		 * pool
		 */
		private var _pool: Pool;

		public function get pool(): Pool {
			return _pool;
		}
		
		/**
		 * XPDL Activity들만 모아서 리턴한다.
		 * root의 첫번째 노드가 유일한 Pool이라고 가정하고,
		 * 그 pool의 자식 노드들 중 activity만을 모은다.
		 */
		public function get activities(): Array {
			var acts: Array = [];
			
			if (_pool) {
				for each (var node: Node in _pool.children) {
					if (node is Activity)
						acts.push(node);
				}
			}
			
			return acts;
		}
		
		/**
		 * XPDL Artifact들만 모아서 리턴한다.
		 * root의 첫번째 노드가 유일한 Pool이라고 가정하고,
		 * 그 pool의 자식 노드들 중 activity만을 모은다.
		 */
		public function get artifacts(): Array {
			var arts: Array = [];
			
			if (_pool) {
				for each (var node: Node in _pool.children) {
					if (node is Artifact)
						arts.push(node);
				}
			}
			
			return arts;
		}
		
		/**
		 * XPDL Transition들을 리턴한다.
		 * 현재 diagram link 와 xpld transition은 완전히 일대일이다.
		 */
		public function get transitions(): Array {
			return links;
		}

		/**
		 * 스윔레인 양 끝 여백 크기
		 */
		private var _lanePadding: Number = 10;
		
		public function get lanePadding(): Number {
			return _lanePadding;
		}
		
		public function set lanePadding(value: Number): void {
			_lanePadding = Math.max(0, value);
		}
		
		/**
		 * checkBackward
		 */
		public var checkBackward: Boolean;
		

		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------

		/**
		 * 다이어그램 로딩시 로딩후 다음 생성 id를 설정하도록
		 * id를 갖는 모든 경우에 호출하도록 한다.
		 */
		public function loadId(id: int): int {
			_nextId = Math.max(id, _nextId) + 1;
			return id;
		}
		
		/**
		 * 다이어그램 편집 시 새로 생성되는 id에 _nextId 값을 지정하고,
		 * _nextId는 하나 증가 시킨다.
		 */ 
		public function getNextId(): int {
			return _nextId++;
		}
		
		public function findActivity(id: int): Activity {
			for each (var act: Activity in activities) {
				if (act.id == id)
					return act;
			}
			
			return null;
		}
		
		/**
		 * activity의 종류를 변경한다.
		 * 현재, activity를 종류를 바꾸기 위해서는 기존 activity를 제거하고,
		 * 새로운 타입의 activity를 그 자리에 대신해야 한다.
		 */
		public function changeActivityType(activity: Activity, newType: String): void {
			if (activity == null)
				return;
			
			if (!ActivityTypes.isValidType(newType)) 
				throw new Error( resourceManager.getString("ProcessEditorMessages", "PEE001") + "(" + newType + ").");
				
			if (activity.activityType == newType)
				return;
				
			var newAct: Activity = null;
			
			switch (newType) {
				case ActivityTypes.START_EVENT:
					newAct = new StartEvent();
					break;
					
				case ActivityTypes.END_EVENT:
					newAct = new EndEvent();
					break;
					
				case ActivityTypes.INTERMEDIATE_EVENT:
					newAct = new IntermediateEvent();
					break;
					
				case ActivityTypes.TASK_APPLICATION:
					newAct = new TaskApplication();
					break;
					
				case ActivityTypes.TASK_APPROVAL:
					var tmpAct:TaskApplication = new TaskApplication();
					tmpAct.userTaskType = TaskApplication.USERTASKTYPE_APPROVAL;
					newAct = tmpAct;
					break;
					
				case ActivityTypes.AND_GATEWAY:
					newAct = new AndGateway();
					break;
					
				case ActivityTypes.XOR_GATEWAY:
					newAct = new XorGateway();
					break;
			}
			
			// assert(newAct != null);
			
			newAct.assign(activity);			
			newAct.center = activity.center;
			this.pool.replaceChild(activity, newAct);
		}
		
		public function laneChanged(lane: Lane, prop: String, oldValue: Object): void {
			dispatchEvent(new DiagramChangeEvent("lanePropChanged", lane, prop, oldValue));	
		}

		
		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------

		override protected function afterNodeAdded(node: Node): void {
			XPDLNode(node).id = getNextId();
			super.afterNodeAdded(node);
		}
		
		override protected function afterLinkAdded(link: Link): void {
			XPDLLink(link).id = getNextId();
			super.afterLinkAdded(link);
			
			if (checkBackward)
				DiagramUtils.checkBackwardLinks(pool.children);
		}
		
		override protected function afterLinkRemoved(link: Link): void {
			super.afterLinkRemoved(link);

			if (checkBackward)
				DiagramUtils.checkBackwardLinks(pool.children);
		}

		override protected function afterLinkChanged(link: Link, prop: String, oldValue: Object): void {
			super.afterLinkChanged(link, prop, oldValue);
			//DiagramUtils.checkBackwardLinks(pool.children);
		}
	}
}