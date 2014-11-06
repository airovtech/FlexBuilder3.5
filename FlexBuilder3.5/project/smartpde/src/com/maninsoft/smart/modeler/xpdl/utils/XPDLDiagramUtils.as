////////////////////////////////////////////////////////////////////////////////
//  XPDLDiagramUtils.as
//  2008.04.07, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved.
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.utils
{
	import com.maninsoft.smart.modeler.model.Link;
	import com.maninsoft.smart.modeler.model.Node;
	import com.maninsoft.smart.modeler.xpdl.model.EndEvent;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
	import com.maninsoft.smart.modeler.xpdl.model.base.Gateway;
	
	/**
	 * Diagram 관련 유틸리티 함수들
	 */
	public class XPDLDiagramUtils {
		
		/**
		 * incoming link가 없는 노드들을 반환한다.
		 */
		public static function getStartNodes(dgm: XPDLDiagram): Array {
			var nodes: Array = [];
			
			for each (var node: Node in dgm.pool.getActivities(Activity)) {
				if (node.incomingLinks.length < 1)
					nodes.push(node);
			}
			
			return nodes;
		}

		/**
		 * 링크 관계만으로 실행 순서를 계산해 순서대로 리턴한다.
		 */
		public static function getSortedNodes(dgm: XPDLDiagram): Array /* of Node */ {
			var nodes: Array = [];
			var starts: Array = getStartNodes(dgm);
			var weight: Number = 0;
				
			for each (var node: Node in starts) {
				node.sortWeight = weight++;
				nodes.push(node);
			}
			
			for each (node in starts) {
				getNexts(node, nodes);
			}
			
			nodes.sort(compareWeights);
			
			return nodes;
			
			/**
			 * 앞선 액티비티들이 모두 지나왔으면 true 반환
			 */
			function isCompleted(n: Node, buff: Array): Boolean {
				//if (n is AndGateway)
				if (n is Gateway)
					for each (var link: Link in n.incomingLinks)
						if (buff.indexOf(link.source) < 0)
							return false;
						
				return true;
			}
			
			function getNexts(n: Node, buff: Array): void {
				var w: Number = 0;
				
				for each (var link: Link in n.outgoingLinks) {
					if (buff.indexOf(link.target) < 0 && isCompleted(link.target, buff)) {
						link.target.sortWeight = n.sortWeight + 10000 + w++;
						buff.push(link.target);
						getNexts(link.target, buff);
					}
				}
			}
			
			function compareWeights(node1: Node, node2: Node): Number {
				if (node1 is EndEvent)
					return 1;
				
				if (node2 is EndEvent)
					return -1;
					
				return node1.sortWeight - node2.sortWeight;
			}
		}
		
		/**
		 * Activity의 effectStatus가 COMPLETED인 것들을 리턴한다.
		 */
		public static function getCompletedNodes(dgm: XPDLDiagram): Array /* of Node */ {
			var nodes: Array = [];
			var starts: Array = getStartNodes(dgm);
			var weight: Number = 0;
				
			for each (var node: Activity in starts) {
				node.sortWeight = weight++;

				if (checkNode(node)) {
					nodes.push(node);
					getNexts(node, nodes);
				}
			}
			
			nodes.sort(compareWeights);
			
			return nodes;
			
			function checkNode(node: Activity): Boolean {
				return node.effectStatus == Activity.STATUS_COMPLETED;
			}
			
			function getNexts(n: Node, buff: Array): void {
				var w: Number = 0;
				
				for each (var link: Link in n.outgoingLinks) {
					if (buff.indexOf(link.target) < 0 && checkNode(link.target)) {
						link.target.sortWeight = n.sortWeight + 10000 + w++;
						buff.push(link.target);

						getNexts(link.target, buff);
					}
				}
			}
			
			function compareWeights(node1: Node, node2: Node): Number {
				return node1.sortWeight - node2.sortWeight;
			}
		}
	}
}