package portalAs
{
	public class Properties{
		[Bindable]
		public static var compId:String; //회사 아이디
		[Bindable]
		public static var userId:String; //사용자 아이디
		[Bindable]
		public static var userName:String; //userName
		[Bindable]
		public static var today:String; //오늘날짜
		[Bindable]
		public static var basePath:String; //서버Url
		[Bindable]
		public static var serviceUrl:String; //서비스 url
		[Bindable]
		public static var workBenchNewWindow:String = "0"; //WorkBench 새로운 창으로 띄우기 여부 '0':새로운창으로 안띄우기, '1':새로운창으로 띄우기
	}
}