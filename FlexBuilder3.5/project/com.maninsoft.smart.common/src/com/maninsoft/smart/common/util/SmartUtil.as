package com.maninsoft.smart.common.util
{
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import mx.collections.IList;
	import mx.controls.Alert;
	import mx.controls.Menu;
	import mx.events.MenuEvent;
	import mx.graphics.ImageSnapshot;
	import mx.graphics.codec.PNGEncoder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	public class SmartUtil
	{
		public static function isEmpty(obj:Object):Boolean {
			if (obj == null)
				return true;
			if (obj is String) {
				var str:String = String(obj);
				return str.length == 0 || str == "null";
			} else if (obj is Array) {
				var array:Array = obj as Array;
				return array.length == 0;
			} else if (obj is IList) {
				var list:IList = IList(obj);
				return list.length == 0;
			} else if (obj is Map) {
				var map:Map = Map(obj);
				return map.isEmpty();
			} else if (obj is XMLList) {
				var xmlList:XMLList = XMLList(obj);
				return xmlList.length() == 0;
			} else {
				return false;
			}
		}
		public static function toDefault(obj:Object, def:String):String {
			return isEmpty(obj)? def : obj.toString();
		}
		public static function toString(obj:Object, length:Number = NaN, align:String = "center"):String {
			var value:String = toDefault(obj, null);
			if (length > 0) {
				if (value.length < length) {
					var diff:Number = length - value.length;
					if (align == "left") {
						for (var i:int=0; i<diff; i++)
							value += " ";
					} else if (align == "center") {
						diff = diff / 2;
						for (var _i:int=0; _i<diff; _i++)
							value = " " + value;
						for (var __i:int=0; __i<diff; __i++)
							value += " ";
					} else if (align == "right") {
						for (var ___i:int=0; ___i<diff; ___i++)
							value = " " + value;
					}
				} else if (value.length > length) {
					value = value.substring(0, length);
				}
			}
			return value;
		}
		public static function toBoolean(obj:Object, def:Boolean = false):Boolean {
			if (isEmpty(obj))
				return def;
			if (obj is Boolean)
				return obj;
			if (obj is XMLList)
				obj = obj[0];
			var str:String = obj.toString();
			if (str == "true")
				return true;
			if (str == "false")
				return false;
			return def;
		}
		public static function toNumber(obj:Object, def:Number = 0):Number {
			if (SmartUtil.isEmpty(obj))
				return def;
			if (obj is Number)
				return Number(obj);
			return Number(obj.toString());
		}
		public static function toXml(obj:Object):XML {
			if (obj == null)
				return null;
			if (obj is XML)
				return XML(obj);
			if (obj is XMLList)
				return isEmpty(obj)? null : XMLList(obj)[0];
			return null;
		}
		
		private static var send_id:Number = 0;
		private static var send_paramHashMap:Map = new Map();
		public static function send(url:String, params:Object = null, callback:Function = null, callbackParams:Object=null):void {
			var service:HTTPService = new HTTPService();
			service.useProxy = false;
			service.addEventListener(ResultEvent.RESULT, sendResponse);
			service.addEventListener(FaultEvent.FAULT, serviceFault);
			service.resultFormat = HTTPService.RESULT_FORMAT_E4X;
			
			service.url = url;
			if (params == null) {
				service.method = "GET";
			} else {
				service.method = "POST";
			}
			var paramHash:Object = new Object();
			if (callback != null)
				paramHash["send_callback"] = callback;
			if (callbackParams != null)
				paramHash["send_callbackParams"] = callbackParams;
			var id:Number = send_id++;
			service.headers["send_id"] = id;
			send_paramHashMap.put(id, paramHash);
			
			try {
				service.send(params);
			} catch (e:Error) {
				send_paramHashMap.remove(id);
				throw e;
			}
		}
		private static function sendResponse(re:ResultEvent):void {
			var id:Number = re.target.headers["send_id"];
			var paramHash:Object = send_paramHashMap.remove(id);
			
			var result:XML = XML(re.result);
			var status:String = result.@status;
			if (!SmartUtil.isEmpty(status)) {
				status = status.toLowerCase();
				if (status == "fail" || status == "failed") {
					serviceFault(re);
					return;
				}
			}
			
			var callback:Function = paramHash["send_callback"];
			var callbackParams:Object = paramHash["send_callbackParams"];
			if (callback != null)
				if(callbackParams != null)
					callback(result, callbackParams);
				else
					callback(result);
		}
		private static function serviceFault(e:Event):void {
			var id:Number = Number(e.target.headers["send_id"]);
			if(send_paramHashMap.containsKey(id)){
				var paramHash:Object = send_paramHashMap.remove(id);
				var error:String = paramHash["send_error"];
				if (isEmpty(error))
					return;
			
				// TODO
				Alert.show(error);
			}
		}
		
		public static function encodeImageAsBase64(source:IBitmapDrawable, opts:EncodeImageOpts = null):String {
			var encoder:Class = opts.encoder;
			var left:Number = opts.left;
			var top:Number = opts.top;
			var width:Number = opts.width;
			var height:Number = opts.height;
			var minWidth:Number = opts.minWidth;
			var minHeight:Number = opts.minHeight;
			var maxWidth:Number = opts.maxWidth;
			var maxHeight:Number = opts.maxHeight;
			var fixedScale:Boolean = opts.fixedScale;
			var cutWidthEnabled:Boolean = opts.cutWidthEnabled;
			var cutHeightEnabled:Boolean = opts.cutHeightEnabled;
			if (cutWidthEnabled || cutHeightEnabled)
				fixedScale = true;
			
			if (encoder == null) {
				ImageSnapshot.defaultEncoder = PNGEncoder;
			} else {
				ImageSnapshot.defaultEncoder = encoder;
			}
			
			var snapshot:ImageSnapshot = ImageSnapshot.captureImage(source);
			var currentWidth:Number = Number(snapshot.width);
			var currentHeight:Number = Number(snapshot.height);
			var changedWidth:Number = -1;
			var changedHeight:Number = -1;
			
			if (width > 0 && width != currentWidth)
				changedWidth = width;
			if (height > 0 && height != currentHeight)
				changedHeight = height;
			
			if (changedWidth <= 0 && 
				minWidth > 0 && minWidth > currentWidth)
				changedWidth = minWidth;
			if (changedHeight <= 0 && 
				minHeight > 0 && minHeight > currentHeight)
				changedHeight = minHeight;
			
			if (changedWidth <= 0 && 
				maxWidth > 0 && maxWidth < currentWidth)
				changedWidth = maxWidth;
			if (changedHeight <= 0 && 
				maxHeight > 0 && maxHeight < currentHeight)
				changedHeight = maxHeight;
			
			if (changedWidth <= 0 && changedHeight <= 0)
				return ImageSnapshot.encodeImageAsBase64(snapshot);
			
			if (changedWidth <= 0) {
				changedWidth = currentWidth;
			} else if (changedHeight <= 0) {
				changedHeight = currentHeight;
			}
			var matrix:Matrix = new Matrix();
			var widthScale:Number = changedWidth/currentWidth;
			var heightScale:Number = changedHeight/currentHeight;
			var scale:Number = 1;
			if (fixedScale) {
				if (cutWidthEnabled && cutHeightEnabled) {
					
				} else if (cutWidthEnabled) {
					scale = heightScale;
				} else if (cutHeightEnabled) {
					scale = widthScale;
				} else {
					scale = Math.min(widthScale, heightScale);
				}
				widthScale = scale;
				heightScale = scale;
				if (!cutWidthEnabled && !cutHeightEnabled) {
					changedWidth = currentWidth * scale;
					changedHeight = currentHeight * scale;
				}
			}
			if (left > 0) {
				matrix.tx = -left * scale;
				if (scale > 0.8) {
					
				} else if (scale > 0.6) {
					changedWidth = changedWidth + 1;
				} else if (scale > 0.4) {
					changedWidth = changedWidth + 2;
				} else if (scale > 0.2) {
					changedWidth = changedWidth + 3;
				} else {
					changedWidth = changedWidth + 4;
				}
			}
			if (top > 0) {
				matrix.ty = -top * scale;
				if (scale > 0.8) {
					
				} else if (scale > 0.6) {
					changedHeight = changedHeight + 1;
				} else if (scale > 0.4) {
					changedHeight = changedHeight + 2;
				} else if (scale > 0.2) {
					changedHeight = changedHeight + 3;
				} else {
					changedHeight = changedHeight + 4;
				}
			}
			matrix.scale(widthScale, heightScale);
			matrix.transformPoint(new Point(left, top));
			var bmd:BitmapData = new BitmapData(changedWidth, changedHeight);
//			matrix.scale(1, 1);
//			var bmd:BitmapData = new BitmapData(800, 600);
			bmd.draw(source, matrix);
			
			snapshot = ImageSnapshot.captureImage(bmd);
			return ImageSnapshot.encodeImageAsBase64(snapshot);
		}
		
		public static function showMenu(menu:Menu, x:Number, y:Number):void {
			menu.removeEventListener(MenuEvent.ITEM_CLICK, clickMenu);
			menu.addEventListener(MenuEvent.ITEM_CLICK, clickMenu);
			menu.show(x, y);
		}
		private static function clickMenu(event:MenuEvent):void {
				var click:Object = event.item["click"];
				if (click != null && click is Function)
					click(event);
		}
	}
}