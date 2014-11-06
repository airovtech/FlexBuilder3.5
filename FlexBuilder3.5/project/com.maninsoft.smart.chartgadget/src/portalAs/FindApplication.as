package portalAs
{
	import flash.display.DisplayObjectContainer;
	
	import mx.core.Application;
	
	public class FindApplication{
		public static function getApplciation(thisObj:DisplayObjectContainer):SmartWorkPortal {
			return SmartWorkPortal(searchParent(thisObj));
		}
		
		public static function searchParent(obj:DisplayObjectContainer):DisplayObjectContainer {
			var returnObj:DisplayObjectContainer=obj;
			if(!(obj is SmartWorkPortal)){
				returnObj = searchParent(obj.parent);
			}
			return returnObj;
		}
	}
}