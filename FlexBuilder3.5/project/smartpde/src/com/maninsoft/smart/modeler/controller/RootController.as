////////////////////////////////////////////////////////////////////////////////
//  RootController.as
//  2007.12.17, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.controller
{
	import com.maninsoft.smart.modeler.command.Command;
	import com.maninsoft.smart.modeler.command.LinkCreateCommand;
	import com.maninsoft.smart.modeler.command.NodeCreateCommand;
	import com.maninsoft.smart.modeler.editor.DiagramEditor;
	import com.maninsoft.smart.modeler.model.Diagram;
	import com.maninsoft.smart.modeler.model.DiagramObject;
	import com.maninsoft.smart.modeler.model.Link;
	import com.maninsoft.smart.modeler.model.Node;
	import com.maninsoft.smart.modeler.model.events.LinkEvent;
	import com.maninsoft.smart.modeler.request.LinkCreationRequest;
	import com.maninsoft.smart.modeler.request.NodeCreationRequest;
	import com.maninsoft.smart.modeler.request.Request;
	import com.maninsoft.smart.modeler.view.IView;
	
	import flash.geom.Rectangle;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * Root 컨트롤러
	 */
	public class RootController extends Controller {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _owner: DiagramEditor;
		private var _rootNodeController: RootNodeController;
		private var _links: ArrayCollection;
		

		//----------------------------------------------------------------------
		// Initialization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function RootController(owner: DiagramEditor) {
			super(null);
			
			_owner = owner;
			_links = new ArrayCollection();
		}
		

		/**
		 * diagram 의 각 모델에 대한 컨트롤러를 생성시킨다.
		 */	
		override public function activate(): void {
			if (owner) {
				var dgm: Diagram = owner.diagram;
				
				if (dgm) {
					_rootNodeController = new RootNodeController(dgm.root);
					
					addChild(_rootNodeController);
					_rootNodeController.activate();
					createNodeChildren(_rootNodeController, dgm.root);
					createLinks(dgm.links);
					
					dgm.addEventListener(LinkEvent.CREATE, linkAdded);
					dgm.addEventListener(LinkEvent.REMOVE, linkRemoved);
				}
			}
		}
		
		private function createNodeChildren(pCtrl: Controller, pNode: Node): void {
			for each (var node: Node in pNode.children) {
				var ctrl: Controller = owner.createController(node);
				pCtrl.addChild(ctrl);
				ctrl.activate();
				createNodeChildren(ctrl, node);
			}
		}

		override public function deactivate(): void {
			if (owner) {
				if (_rootNodeController) {
					_rootNodeController.deactivate();
					removeChild(_rootNodeController);
				}
				
				for each (var lnk: LinkController in _links)
					lnk.deactivate();

				_links.removeAll();
				
				var dgm: Diagram = owner.diagram;
	
				if (dgm) {
					dgm.removeEventListener(LinkEvent.CREATE, linkAdded);
					dgm.removeEventListener(LinkEvent.REMOVE, linkRemoved);
				}
			}			
		}
		
		
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/**
		 * owner
		 */
		public function get owner(): DiagramEditor {
			return _owner;
		}
		
		/**
		 * links
		 */
		public function get links(): Array {
			return _links.toArray();
		}
		
		public function get nodeController(): NodeController {
			return _rootNodeController;
		}
		
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
				
		/**
		 * editor
		 */
		override public function get editor(): DiagramEditor {
			return owner;
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		/**
		 * getCommand
		 */
		override public function getCommand(request:Request): Command {
			if (request is NodeCreationRequest) {
				var req: NodeCreationRequest = request as NodeCreationRequest;
				
				var node: Node = owner.createNode(req.objectType); 
				
				node.x = req.pos.x;
				node.y = req.pos.y; 
				
				return new NodeCreateCommand(owner.diagram.root, node);	
			} else if (request is LinkCreationRequest) {
				var req2: LinkCreationRequest = request as LinkCreationRequest;
				var path: String = req2.sourceAnchor + "," + req2.targetAnchor;
				
				var link: Link = owner.createLink(req2.linkType, req2.source, req2.target, path);
				
				return new LinkCreateCommand(link);
			}
			
			return super.getCommand(request);
		}
	
		override public function findByModel(model:DiagramObject): Controller {
			/*
			 * 링크들 중에서 먼저 찾는다. Why?
			 */
			for each (var ctrl: Controller in _links) {
				if (ctrl.model == model) {
					return ctrl;
				}
			}
			
			return _rootNodeController.findByModel(model);
		}

		override public function findByView(view: IView): Controller {
			/*
			 * 링크들 중에서 먼저 찾는다. Why?
			 */
			for each (var ctrl: Controller in _links) {
				if (ctrl.view == view) {
					return ctrl;
				}
			}
			
			return _rootNodeController.findByView(view);
		}
		
		override public function findController(x: Number, y: Number): Controller {
			return _rootNodeController.findController(x, y);
		}

		override public function findControllersByRect(rect: Rectangle): Array {
			return _rootNodeController.findControllersByRect(rect);
		}
		
		
		//----------------------------------------------------------------------
		// Event handlers
		//----------------------------------------------------------------------
		
		private function linkAdded(event: LinkEvent): void {
			trace("linkAdded: " + event);
			
			addLink(event.link);
		}
		
		private function linkRemoved(event: LinkEvent): void {
			trace("linkRemoved: " + event);
			
			var ctrl: Controller = findByModel(event.link);
			ctrl.deactivate();
			ctrl.setParent(null);
			_links.removeItemAt(_links.getItemIndex(ctrl));	
		}


		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------

		private function addLink(link: Link): void {
			var ctrl: Controller = owner.createController(link);

			_links.addItem(ctrl);
			ctrl.setParent(this);
			ctrl.activate();
		}
		
		private function createLinks(links: Array): void {
			for each (var link: Link in links) {
				addLink(link);
			}
		}
	}
}