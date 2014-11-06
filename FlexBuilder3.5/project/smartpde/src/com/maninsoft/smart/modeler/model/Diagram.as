////////////////////////////////////////////////////////////////////////////////
//  Diagram.as
//  2007.12.15, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.model
{
	import com.maninsoft.smart.modeler.common.ObjectBase;
	import com.maninsoft.smart.modeler.editor.events.DiagramChangeEvent;
	import com.maninsoft.smart.modeler.model.events.LinkEvent;
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * node와 link들로 구성된 다어그램 모델
	 */
	public class Diagram extends ObjectBase {
		
		//----------------------------------------------------------------------
		// Internal variables
		//----------------------------------------------------------------------

		/** Storage for root */
		private var _root: RootNode;
		
		/** Storage for links */
		private var _links: ArrayCollection;
		

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function Diagram() {
			super();

			_root = new RootNode(this);
			_links = new ArrayCollection();
		}				

		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/** 
		 * Property root
		 */
		public function get root(): RootNode {
			return _root;
		}

		/**
		 * Property links
		 */
		public function get links(): Array {
			return _links ? _links.toArray() : null;
		}


		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------
		
		public function addLink(link: Link): void {
			if (!link.source || !link.target)
				return;
			
			/*
			 * 이미 링크 컬렉션에 존재하면 다시 추가하지 않는다.
		     */
			if (_links.contains(link)) 
				return;
				
			_links.addItem(link);
			link.source.addSourceLink(link);
			link.target.addTargetLink(link);
			
			// editor로 이벤트를 날린다.
			dispatchEvent(new LinkEvent(LinkEvent.CREATE, link));
			linkAdded(link);
		}
		
		public function addLinks(links: Array): void {
			for each (var link: Link in links) {
				addLink(link);
			}
		}
		
		public function removeLink(link: Link): void {
			var idx: int = _links.getItemIndex(link);
			
			if (idx >= 0) {
				link.source.removeSourceLink(link);
				link.target.removeTargetLink(link);

				_links.removeItemAt(idx);
				
				// 에디터로 이벤트를 날린다.
				dispatchEvent(new LinkEvent(LinkEvent.REMOVE, link));
				linkRemoved(link);
				if(link.target is Activity){
					Activity(link.target).startActivity = false;
				}
			}
		}
		
		public function removeLinks(links: Array): void {
			for each (var link: Link in links) {
				removeLink(link);
			}
		}

		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
		
		internal function nodeAdded(node: Node): void {
			dispatchEvent(new DiagramChangeEvent(DiagramChangeEvent.NODE_ADDED, node));
			afterNodeAdded(node);
		}
		
		internal function nodeRemoved(node: Node): void {
			dispatchEvent(new DiagramChangeEvent(DiagramChangeEvent.NODE_REMOVED, node));
			afterNodeRemoved(node);
		}
		
		internal function nodeReplaced(newNode: Node, node: Node): void {
			dispatchEvent(new DiagramChangeEvent(DiagramChangeEvent.NODE_REPLACED, newNode, null, node));
			afterNodeReplaced(node, newNode);
		}
		
		internal function nodeChanged(node: Node, prop: String, oldValue: Object): void {
			trace("Diagram.nodeChanged(" + prop + ", " + oldValue + ")");
			dispatchEvent(new DiagramChangeEvent(DiagramChangeEvent.PROP_CHANGED, node, prop, oldValue));
			afterNodeChanged(node, prop, oldValue);
		}
		
		internal function linkAdded(link: Link): void {
			dispatchEvent(new DiagramChangeEvent(DiagramChangeEvent.LINK_ADDED, link));
			afterLinkAdded(link);
		}
		
		internal function linkRemoved(link: Link): void {
			dispatchEvent(new DiagramChangeEvent(DiagramChangeEvent.LINK_REMOVED, link));
			afterLinkRemoved(link);
		}

		internal function linkChanged(link: Link, prop: String, oldValue: Object): void {
			trace("Diagram.linkChanged(" + prop + ", " + oldValue + ")");
			dispatchEvent(new DiagramChangeEvent(DiagramChangeEvent.PROP_CHANGED, link, prop, oldValue));
			afterLinkChanged(link, prop, oldValue);
		}
		
		protected function afterNodeAdded(node: Node): void {
		}
		
		protected function afterNodeRemoved(node: Node): void {
		}
		
		protected function afterNodeReplaced(newNode: Node, node: Node): void {
		}
		
		protected function afterNodeChanged(node: Node, prop: String, oldValue: Object): void {
		}
		
		protected function afterLinkAdded(link: Link): void {
		}
		
		protected function afterLinkRemoved(link: Link): void {
		}

		protected function afterLinkChanged(link: Link, prop: String, oldValue: Object): void {
		}
	}
}