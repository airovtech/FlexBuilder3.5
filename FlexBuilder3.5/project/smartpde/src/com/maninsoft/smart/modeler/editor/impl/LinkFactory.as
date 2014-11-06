////////////////////////////////////////////////////////////////////////////////
//  LinkFactory.as
//  2008.01.07, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.editor.impl
{
	import com.maninsoft.smart.modeler.editor.DiagramEditor;
	import com.maninsoft.smart.modeler.editor.ILinkFactory;
	import com.maninsoft.smart.modeler.model.Link;
	import com.maninsoft.smart.modeler.model.Node;
	
	/**
	 * 기본 Link Factory
	 */
	public class LinkFactory implements ILinkFactory	{
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		private var _owner: DiagramEditor;


		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */		
		public function LinkFactory(owner: DiagramEditor) {
			super();
			
			_owner = owner;
		}


		//----------------------------------------------------------------------
		// INodeFactory
		//----------------------------------------------------------------------

		public function createLink(linkType: String, source: Node, target: Node, 
									path: String = null, connectType: String = null): Link {
			var link: Link = new Link(source, target, path, connectType);
			
			return link;
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		public function get owner(): DiagramEditor {
			return _owner;
		}
	}
}