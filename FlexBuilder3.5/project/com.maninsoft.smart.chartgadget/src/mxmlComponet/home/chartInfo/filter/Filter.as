package mxmlComponet.home.chartInfo.filter{

	import mx.containers.Box;
	import mx.events.CloseEvent;
	
	public class Filter extends Box{
		public function Filter(){
		}
		public function crComplete():void{}
		public function close():void{
			var eventObj:CloseEvent = new CloseEvent(CloseEvent.CLOSE);
			dispatchEvent(eventObj);
		}
	}
}