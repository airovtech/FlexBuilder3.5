////////////////////////////////////////////////////////////////////////////////
//  PackageTreeRoot.as
//  2008.04.25, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.packages
{
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
	import com.maninsoft.smart.modeler.xpdl.model.pool.Lane;
	import com.maninsoft.smart.modeler.assets.DiagramNavigatorAssets;
	import com.maninsoft.smart.modeler.xpdl.navigator.DiagramTreeActivity;
	import com.maninsoft.smart.modeler.xpdl.navigator.DiagramTreeLane;
	import com.maninsoft.smart.modeler.xpdl.navigator.DiagramTreeRoot;
	import com.maninsoft.smart.modeler.xpdl.server.Server;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * Package Navigator 의 root node. process + forms
	 * 임시 구현 !!!
	 */
	public class PackageTreeRoot extends DiagramTreeRoot {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		private var _server: Server;
		private var _packChildren: ArrayCollection;
		private var _processRoot: PackageTreeProcess;
		private var _formRoot: PackageTreeFormRoot;
		private var _name: String;
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function PackageTreeRoot(name: String, diagram: XPDLDiagram, server: Server)	{
			_name = name;
			_server = server;

			super(diagram);
		}

		
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		public function get hasProcess(): Boolean {
			return _processRoot != null
		}

		
		//----------------------------------------------------------------------
		// Overriden properties
		//----------------------------------------------------------------------
		
		override public function get label(): String {
			/*
			var str: String = null;
			
			if (_diagram)
				str = _diagram.xpdlPackage.name;
			
			if (!str)
				str = "Package";
				
			return str;	
			*/
			return _name ? _name : "Package";
		}
		
		override public function get icon(): Class {
			return DiagramNavigatorAssets.packageIcon;
		}
		
		override public function get children(): Array {
			return (_packChildren.length > 0) ? _packChildren.toArray() : null;
		}

		override public function get editable(): Boolean {
			return false;
		}

		override public function get removable(): Boolean {
			return false;
		}

		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function refreshChildren(): void {
			_packChildren = new ArrayCollection();

			//super.refreshChildren();
			
			if (_diagram) 
				_packChildren.addItem(_processRoot = new PackageTreeProcess(_diagram));
			else
				_processRoot = null;
			
			_formRoot = new PackageTreeFormRoot(_server, _diagram);
			_formRoot.refreshChildren();
			
			_packChildren.addItem(_formRoot);
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function getLaneItem(lane: Lane): DiagramTreeLane {
			if (_processRoot) 
				return _processRoot.getLaneItem(lane);
			else
				return null;
		}
		
		override public function getActivityItem(activity: Activity): DiagramTreeActivity {
			if (_processRoot) 
				return _processRoot.getActivityItem(activity);
			else
				return null;
		}
	}
}