////////////////////////////////////////////////////////////////////////////////
//  Ray.as
//  2007.12.26, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.view.connection
{
	import flash.geom.Point;
	
	/**
	 * Ray
	 */
	public class Ray {
		
		public var x: Number;
		public var y: Number;
		
		public function Ray(x: Number, y: Number) {
			this.x = x;
			this.y = y;
		}
		
		public static function valueOf(p: Point): Ray {
			return new Ray(p.x, p.y);
		}
		
		public static function getDifference(start: Ray, end: Ray): Ray {
			return new Ray(end.x - start.x, end.y - start.y);
		}

		public function getAveraged(r: Ray): Ray {
			return new Ray((this.x + r.x) / 2, (this.y + r.y) / 2);
		}

		public function getAdded(r: Ray): Ray {
			return new Ray(r.x + x, r.y + y);
		}
		
		public function getScaled(s: Number): Ray {
			return new Ray(x * s, y * s);
		}
		
		public function dotProduct(r: Ray): Number {
			return this.x * r.x + this.y * r.y;	
		}
		
		public function assimilarity(r: Ray): Number {
			var oldX: Number = this.x;
			var oldY: Number = this.y;
			this.x = Math.abs(this.x);
			this.y = Math.abs(this.y);
		
			var value: Number = x * r.y - y * r.x;
			this.x = oldX;
			this.y = oldY;
			
			return value;
		}
		
		public function similarity(r: Ray): Number {
			var oldX: Number = this.x;
			var oldY: Number = this.y;
			this.x = Math.abs(this.x);
			this.y = Math.abs(this.y);

			var value: Number = dotProduct(r);
			this.x = oldX;
			this.y = oldY;
			
			return value;
		}

		public function length(): Number {
			return Math.sqrt(dotProduct(this));
		}
		
		public function isHorizontal(): Boolean {
			return x != 0;
		}
		
		public function toString(): String {
			return "(" + this.x + "," + this.y + ")";
		}
		
		public function getDeltaToPlus(p1: Number, p2: Number): Number{
			var delta: Number = 0;
			if(p1 > 0 && p2 > 0) return delta;
			if(p1 < p2) delta = 1-p1;
			else delta = 1-p2;
			return delta  
		}
	}
}