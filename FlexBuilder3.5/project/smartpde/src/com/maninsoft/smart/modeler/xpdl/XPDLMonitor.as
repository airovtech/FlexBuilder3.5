////////////////////////////////////////////////////////////////////////////////
//  XPDLMonitor.as
//  2008.03.26, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl
{
	import com.maninsoft.smart.modeler.controller.LinkController;
	import com.maninsoft.smart.modeler.editor.ILinkFactory;
	import com.maninsoft.smart.modeler.model.Link;
	import com.maninsoft.smart.modeler.view.LinkView;
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * XPDL 프로세스 모니터
	 */
	public class XPDLMonitor extends XPDLEditor {

		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function XPDLMonitor() {
			super();
			
			_running = true;
			readOnly = true;
			horizontalScrollPolicy = "off";
			verticalScrollPolicy = "off";
		}


		//----------------------------------------------------------------------
		// Overriden methdods
		//----------------------------------------------------------------------

		override public function get scrollMargin():Number{
			return 0;
		}

		override protected function createLinkFactory(): ILinkFactory {
			return new MonitorLinkFactory(this);
		}


		//----------------------------------------------------------------------
		// Effect methods
		//----------------------------------------------------------------------
			
		private var _linkViews: Array /* of LinkView */;
		private var _currentLinking: int = -1;

		public function playRuntimeEffect(sortedNodes: Array, repeatDelay: Number = 30): void {
			_linkViews = [];
			
			for each (var node: Activity in sortedNodes) {
				// 시작 액티비티면 Status를 원복한다.
				if (!node.hasIncoming)
					node.status = node.effectStatus;
				
				for each (var link: Link in node.outgoingLinks) {
					var ctrl: LinkController = rootController.findByModel(link) as LinkController;
					
					if (_linkViews.indexOf(ctrl.view) < 0) {
						_linkViews.push(ctrl.view);
						LinkView(ctrl.view).effectData = link.target;
					}
				}
			}

			for each (var view: LinkView in _linkViews) {
				view.startEffect();
			}
			
			_currentLinking = 0;

			var timer: Timer = new Timer(repeatDelay, 0);
			timer.addEventListener(TimerEvent.TIMER, doLinkingEffectTimer);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, doLinkingEffectTimerComplete);
			timer.start();
		}
		
		private function doLinkingEffectTimer(event: TimerEvent): void {
			if (_currentLinking >= _linkViews.length) {
				Timer(event.target).reset();
			}
			else {
				var view: LinkView = _linkViews[_currentLinking] as LinkView;
				view.lineColor = 0x555555;
				view.lineWidth = 3;
				
				if (view.playEffect()) { 
					Activity(view.effectData).status = Activity(view.effectData).effectStatus;
					_currentLinking++;
				}
			}
				
			event.updateAfterEvent();
		}
		
		private function doLinkingEffectTimerComplete(event: TimerEvent): void {
			for each (var view: LinkView in _linkViews)
				view.endEffect();
		}
}
}