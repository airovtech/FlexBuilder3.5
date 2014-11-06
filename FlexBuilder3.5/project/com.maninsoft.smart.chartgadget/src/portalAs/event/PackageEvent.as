package portalAs.event
{
	import flash.events.Event;
	
	public class PackageEvent extends Event
	{
		public static const LOAD_PACKAGE:String = "loadPackage";
		
		public var packId:String;
		public var packVer:int;
		public var categoryId:String;
		public var categoryName:String;
		
		public function PackageEvent(type:String, packId:String, packVer:int)
		{
			super(type);
			
			this.packId = packId;
			this.packVer = packVer;
		}

	}
}