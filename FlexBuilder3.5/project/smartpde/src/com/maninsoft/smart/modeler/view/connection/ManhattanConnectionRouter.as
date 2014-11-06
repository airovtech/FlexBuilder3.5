////////////////////////////////////////////////////////////////////////////////
//  ManhattanConnectionRouter.as
//  2007.12.26, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.view.connection
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	/**
	 * 기본 연결 라우터
	 */
	public class ManhattanConnectionRouter implements IConnectionRouter {
		
		private static var UP: Ray = new Ray(0, -1);
		private static var DOWN: Ray = new Ray(0, 1);
		private static var LEFT: Ray = new Ray(-1, 0);
		private static var RIGHT: Ray = new Ray(1, 0);
		
		private var rowsUsed: Dictionary;// = new Dictionary();
		private var colsUsed: Dictionary;// = new Dictionary();
		//private var reservedInfo: Dictionary = new Dictionary();
		
		/*
		private function getDirection(r: Rectangle, p: Point): Ray {
			var distance: Number = Math.abs(r.x - p.x);
			var direction: Ray = LEFT;
			var i: Number = Math.abs(r.y - p.y);
			
			if (i <= distance) {
				distance = i;
				direction = UP;
			}
		
			i = Math.abs(r.bottom - p.y);
			if (i <= distance) {
				distance = i;
				direction = DOWN;
			}
		
			i = Math.abs(r.right - p.x);
			if (i < distance) {
				distance = i;
				direction = RIGHT;
			}
		
			return direction;
		}
		
		private function getStartDirection(bounds: Rectangle, point: Point): Ray {
			return getDirection(bounds, point);
		}
		
		private function getEndDirection(bounds: Rectangle, point: Point): Ray {
			return getDirection(bounds, point);
		}
		*/
		
		public function getDirection(anchor: Number): Ray {
			switch (anchor) {
				case 0: 
					return UP;
				case 90: 
					return RIGHT;
				case 180: 
					return DOWN;
				default: 
					return LEFT;
			}
		}

		public function route(sourceBounds: Rectangle, sourcePoint: Point, sourceAnchor: Number,
								targetBounds: Rectangle, targetPoint: Point, targetAnchor: Number): Array {
									
			if (!sourceBounds || !targetBounds) {
				return new Array(sourcePoint.clone(), targetPoint.clone());
			} else {
				return routeInternal(getDirection(sourceAnchor), sourcePoint,
								      getDirection(targetAnchor), targetPoint);
			}
		}

		protected function routeInternal(startNormal: Ray, startPoint: Point, 
								           endNormal: Ray, endPoint: Point): Array {
			var scale: Number = 16;
			var start: Ray = Ray.valueOf(startPoint);
			var end: Ray = Ray.valueOf(endPoint);
			var average: Ray = start.getAveraged(end);
		
			var direction: Ray = Ray.getDifference(start, end);
			var positions: Array = new Array();
			var horizontal: Boolean = startNormal.isHorizontal();
			
			if (horizontal) {
				positions.push(start.y);
			} else {
				positions.push(start.x);
			}
			
			horizontal = !horizontal;

			var i: Number;
			
			if (startNormal.dotProduct(endNormal) == 0) {//두 점이 하나는 가로방향(Horizontal) 이고 다른 것은 세로방향(Vertical)인 것 
				if ((startNormal.dotProduct(direction) >= scale) && (endNormal.dotProduct(direction) <= -scale)) {
					// 시작점이 향하는 방향에 scale보다 큰 위치에  끝점이 있으면서, 다른 상하나 좌우로 끝점이 scale보다 저 적은 위치에 있는 경우에는 
					// 시작점과 끝점만 가지고 연결선을 작성한다.  
				} else {
					// 2
					if (startNormal.dotProduct(direction) <= scale)
						i = startNormal.similarity(start.getAdded(startNormal.getScaled(scale)));
					else {
						if (horizontal) 
							i = average.y;
						else 
							i = average.x;
					}
					
					positions.push(i);
					horizontal = !horizontal;
		
					if (endNormal.dotProduct(direction) > -scale)
						i = endNormal.similarity(end.getAdded(endNormal.getScaled(scale)));
					else {
						if (horizontal) 
							i = average.y;
						else 
							i = average.x;
					}
					positions.push(i);
					horizontal = !horizontal;
				}
			} else {// 두 점이 다 같은 가로 방향(Horizontal)이나 세로 방향(Vertical)인 것 
				if (startNormal.dotProduct(endNormal) > 0) { // 방향이 서로 왼쪽(left)/오른쪽(right) 이나 위(top)/아래(bottom)로 다른 것
					if (startNormal.dotProduct(direction) >= 0){ //시작점이 향하고 있는 방향에 끝점이 있는 것 들
						i = endNormal.similarity(end.getAdded(endNormal.getScaled(scale)));
					}else{ //시작정이 향하고 있는 반대의 방향에 끝점이 있는 것 들
						i = startNormal.similarity(start.getAdded(startNormal.getScaled(scale)));
					}
					positions.push(i);
					horizontal = !horizontal;
				} else { // 방향이 서로 같은 것 왼쪽(left), 오른쪽(right), 위(top), 아래(bottom)
					if (startNormal.dotProduct(direction) <= scale * 2) { //시작점이 향하는 방향에서 scale보다 안쪽에 있는 것들 
						i = startNormal.similarity(start.getAdded(startNormal.getScaled(scale)));
						positions.push(i);
						horizontal = !horizontal;
					}
		
					if (horizontal) 
						i = average.y;
					else 
						i = average.x;
						
					positions.push(i);
					horizontal = !horizontal;
		
					if (startNormal.dotProduct(direction) <= scale * 2) {//시작점이 향하는 방향에서 scale의 두배보다 안쪽에 있는 것들
						i = endNormal.similarity(end.getAdded(endNormal.getScaled(scale)));
						positions.push(i);
						horizontal = !horizontal;
					}
				}
			}
			
			if (horizontal) {
				positions.push(end.y);
			} else {
				positions.push(end.x);
			}
			
			return processPositions(start, end, positions, startNormal.isHorizontal());
		}
	
		protected function processPositions(start: Ray, end: Ray, positions: Array, horizontal: Boolean): Array {
			//removeReservedLines();
			rowsUsed = new Dictionary();
			colsUsed = new Dictionary();
		
			var pos: Array = new Array();
			
			if (horizontal)
				pos[0] = start.x;
			else
				pos[0] = start.y;
				
			var i: int;
			
			for (i = 0; i < positions.length; i++) {
				pos[i + 1] = positions[i];
			}
			
			if (horizontal == (positions.length % 2 == 1))
				pos[++i] = end.x;
			else
				pos[++i] = end.y;
		
			// add start point
			var points: Array = new Array();
			points.push(new Point(start.x, start.y));
			
			var p: Point;
			var current: int, prev: int, min: int, max: int;
			var adjust: Boolean;
			
			for (i = 2; i < pos.length - 1; i++) {
				horizontal = !horizontal;
				prev = pos[i - 1];
				current = pos[i];
		
				adjust = (i != pos.length - 2);
				
				if (horizontal) {
					if (adjust) {
						min = pos[i - 2];
						max = pos[i + 2];
						pos[i] = current = getRowNear(current, min, max);
					}
					p = new Point(prev, current);
				} else {
					if (adjust) {
						min = pos[i - 2];
						max = pos[i + 2];
						pos[i] = current = getColumnNear(current, min, max);
					}
					p = new Point(current, prev);
				}
				
				points.push(p);
			}
			
			points.push(new Point(end.x, end.y));
			
			for(i=0; i<points.length-1; i++){
				if(Math.abs(points[i].x-points[i+1].x)<=1.5) points[i+1].x = points[i].x;
				if(Math.abs(points[i].y-points[i+1].y)<=1.5) points[i+1].y = points[i].y;
			}
			return points;
		}
		
		protected function getRowNear(r: int, n: int, x: int): int {
			var min: int = Math.min(n, x);
			var max: int = Math.max(n, x);
			
			if (min > r) {
				max = min;
				min = r - (min - r);
			}
			if (max < r) {
				min = max;
				max = r + (r - max);
			}
		
			var proximity: int = 0;
			var direction: int = -1;
			
			if (r % 2 == 1)
				r--;
			
			var i: int;
			
			while (proximity < r) {
				i = r + proximity * direction;
			
				if (this.rowsUsed[i] == null) {
					rowsUsed[i] = i;
					//reserveRow(i);
					return i;
				}
			
				var j: int = i;
				
				if (j <= min)
					return j + 2;
				if (j >= max)
					return j - 2;
				if (direction == 1)
					direction = -1;
				else {
					direction = 1;
					proximity += 2;
				}
			}
			
			return r;
		}
		
		private function getColumnNear(r: int, n: int, x: int): int {
			var min: int = Math.min(n, x);
			var max: int = Math.max(n, x);
			
			if (min > r) {
				max = min;
				min = r - (min - r);
			}
			if (max < r) {
				min = max;
				max = r + (r - max);
			}
			
			var proximity: int = 0;
			var direction: int = -1;
			
			if (r % 2 == 1)
				r--;
			
			var i: int;
			
			while (proximity < r) {
				i = r + proximity * direction;
				
				if (this.colsUsed[i] == null) {
					this.colsUsed[i] = i;
					//reserveColumn(i);
					return i;
				}
				
				var j: int = i;
				
				if (j <= min)
					return j + 2;
				if (j >= max)
					return j - 2;
				if (direction == 1)
					direction = -1;
				else {
					direction = 1;
					proximity += 2;
				}
			}
			
			return r;
		}
		
		/*
		protected function removeReservedLines(): void {
			var info: Object = reservedInfo[connection];
			if (info == null) 
				return;
			
			var i: int;
			for (i = 0; i < info.reservedRows.length; i++) {
				delete rowsUsed[info.reservedRows[i]];
			}
			for (i = 0; i < info.reservedCols.length; i++) {
				delete colsUsed[info.reservedCols[i]];
			}
			delete reservedInfo[connection];
		}
		
		protected function reserveColumn(connection: Connection, column: int): void {
			var info: Object = reservedInfo[connection];
			if (info == null) {
				info = new Object();
				info.reservedRows = new Array();
				info.reservedCols = new Array();
				reservedInfo[connection] = info;
			}
			info.reservedCols.push(column);
		}
		
		protected function reserveRow(connection: Connection, row: int): void {
			var info: Object = reservedInfo[connection];
			if (info == null) {
				info = new Object();
				info.reservedRows = new Array();
				info.reservedCols = new Array();
				reservedInfo[connection] = info;
			}
			info.reservedRows.push(row);
		}
		*/
	}
}
