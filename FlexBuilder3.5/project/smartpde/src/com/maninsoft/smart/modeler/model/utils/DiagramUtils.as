////////////////////////////////////////////////////////////////////////////////
//  DiagramUtils.as
//  2008.04.15, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved.
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.model.utils
{
	import com.maninsoft.smart.modeler.model.Link;
	import com.maninsoft.smart.modeler.model.Node;
	
	/**
	 * 다이어그램 관련 유틸리티 함수들
	 */
	public class DiagramUtils {

		public static function checkBackwardLinks(nodes: Array /* of Node */): void {
			var checked: Array /* of Node */ = [];
			var checkSum: Array /* of Link */ = []; 
			var node: Node;

			for each (node in getStarts(nodes)) {
				checked.push(node);
				
				for each (var link: Link in node.outgoingLinks) {
					checkPath(link, [node]);										
				}
			}			

			function isChecked(node: Node): Boolean {
				return checked.indexOf(node) >= 0;
			}

			function checkPath(link: Link, prevs: Array /* of Node */): void {
				if (checkSum.indexOf(link) >= 0)
					throw new Error("Already checked(" + link["id"] + ").");
					
				checkSum.push(link);
				link.isBackward = false;
				
				if (isChecked(link.target)) {
					if (prevs.indexOf(link.target) >= 0) {
						link.isBackward = true;
						tracePath(link, prevs);
					}
				}
				else {
					checked.push(link.target);
					var links: Array = link.target.outgoingLinks;

					prevs.push(link.target);
					var saved: Array = prevs.slice();

					if (links.length > 0) {
						checkPath(Link(links[0]), prevs);
					}
						
					for (var i: int = 1; i < links.length; i++) {
						checkPath(links[i] as Link, saved.slice());
					}
				}
			}
			
			function tracePath(link: Link, path: Array): void {
				var s: String = link["id"].toString() + ": ";
				
				for each (var node: Node in path) 
					s += node["name"] + ",";
					
				s += link.target["name"];
					
				trace(s); 
			}
		}		

		public static function getStarts(nodes: Array): Array {
			var arr: Array = [];
			
			for each (var n: Node in nodes) {
				if (!n.hasIncoming)
					arr.push(n);
			}
			
			return arr;
		}
	}
}