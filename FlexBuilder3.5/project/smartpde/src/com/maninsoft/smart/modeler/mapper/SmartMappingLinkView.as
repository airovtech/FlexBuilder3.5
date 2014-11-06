////////////////////////////////////////////////////////////////////////////////
//  SmartMappingLinkView.as
//  2007.01.09, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.mapper
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * IMapplingLink 의 기본 view
	 */
	public class SmartMappingLinkView extends Sprite {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _link: IMappingLink;
		private var _source: SmartMappingPanelItem;
		private var _target: SmartMappingPanelItem;

		private var _selected: Boolean;
		private var _selectedColor: uint = 0x0000ff;
		
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function SmartMappingLinkView(link: IMappingLink,
		                                       source: SmartMappingPanelItem, target: SmartMappingPanelItem) {
			super();
			
			_link = link;
			_source = source;
			_target = target;
			
			draw();
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		//------------------------------
		// link
		//------------------------------
		
		public function get link(): IMappingLink {
			return _link;
		}

		//------------------------------
		// source
		//------------------------------
		
		public function get source(): SmartMappingPanelItem {
			return _source;
		}
		
		public function set source(value: SmartMappingPanelItem): void {
			_source = value;
		}

		//------------------------------
		// target
		//------------------------------
		
		public function get target(): SmartMappingPanelItem {
			return _target;
		}
		
		public function set target(value: SmartMappingPanelItem): void {
			_target = value;
		}

		//------------------------------
		// selected
		//------------------------------
		
		public function get selected(): Boolean {
			return _selected;
		}
		
		public function set selected(value: Boolean): void {
			_selected = value;
			refresh();
		}

		//------------------------------
		// selectededColor
		//------------------------------
		
		public function get selectedColor(): uint {
			return _selectedColor;
		}
		
		public function set selectedColor(value: uint): void {
			_selectedColor = value;
		}
		

		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------
		
		public function refresh(): void {
			draw();
		}
		
		protected function draw(): void {
			var g: Graphics = this.graphics;
			g.clear();

			var p1: Point = source.connectPoint;
			var p2: Point = target.connectPoint;

			/*
			g.lineStyle(3, 0, 0);
			g.moveTo(p1.x, p1.y);
			g.lineTo(p2.x, p2.y);
			
			g.lineStyle(selected ? 3 : 1, selected ? selectedColor : 0);
			g.moveTo(p1.x, p1.y);
			g.lineTo(p2.x, p2.y);
			*/
			
			g.beginFill(0);
			g.drawCircle(p1.x, p1.y, 4);
			g.drawCircle(p2.x, p2.y, 4);
			g.endFill();

			g.lineStyle(3, 0, 0);
			g.moveTo(p1.x, p1.y);
			g.curveTo(Math.min(p1.x, p2.x) + Math.abs(p1.x - p2.x) / 2, 
			          Math.min(p1.y, p2.y) - 20,
			          p2.x, p2.y);
			
			g.lineStyle(selected ? 3 : 1, selected ? selectedColor : 0);
			g.moveTo(p1.x, p1.y);
			g.curveTo(Math.min(p1.x, p2.x) + Math.abs(p1.x - p2.x) / 2, 
			          Math.min(p1.y, p2.y) - 20,
			          p2.x, p2.y);
		}
	}
}