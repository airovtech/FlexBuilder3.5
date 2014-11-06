////////////////////////////////////////////////////////////////////////////////
//  NodeUtils.as
//  2008.04.07, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved.
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.model.utils
{
	import com.maninsoft.smart.modeler.model.Node;
	
	/**
	 * Node 관련 유틸리티 함수들
	 */ 
	public class NodeUtils {
		
		/**
		 * activityType을 갖는 액티비티들을 리턴한다.
		 */
		public static function getNodesByType(nodes: Array, nodeType: Class): Array /* of Node */ {
			var arr: Array = [];

			for each (var node: Node in nodes) {
				if (node is nodeType) {
					arr.push(node);
				}
			}
			
			return arr;
		} 
		
		public static function getNumNodesByType(nodes:Array, nodeType:Class): int{
			var numNodes: int = 0;
			
			for each (var node: Node in nodes) {
				if (node is nodeType) {
					numNodes++;
				}
			}
			return numNodes;
		}
	
		public static function getNodeIndexByType(nodes:Array, nodeType:Class, nodeObject:Object): int{
			var nodeIndex: int = -1;
			
			for each (var node: Node in nodes) {
				if (node is nodeType) {
					nodeIndex++;
				}
				if (node == nodeObject) {
					return nodeIndex;
				}
			}
			return -1;

		}
	}
}