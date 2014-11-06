package mxmlComponet.home.chartInfo.util{

	import com.maninsoft.smart.common.event.CustormEvent;
	
	import mx.containers.Box;
	import mx.containers.TitleWindow;
	import mx.core.Application;
	import mx.core.Container;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import mxmlComponet.home.chartInfo.filter.Filter;
	
	[Event(name="custormClose", type="com.maninsoft.smart.common.event.CustormEvent")]
	public class FilterPopUpLayOut extends Box{
		private var pop:TitleWindow;
		
		public function FilterPopUpLayOut(){
		}
		
		public function createPop(popTitle:String, filter:Filter, app:Application, parent:Container):void{
			pop = TitleWindow(PopUpManager.createPopUp(parent, TitleWindow, false));
			pop.title = popTitle;
			pop.setStyle("fontSize", 12);
			pop.setStyle("titleStyleName", "normalLabel");
			pop.setStyle("borderStyle", "solid");
			pop.setStyle("borderThickness", 2);
			pop.setStyle("borderColor", "#666666");
   			pop.setStyle("backgroundColor", "#f3e5d4");
   			pop.alpha = 3;
			pop.showCloseButton = true;
			pop.owner = parent;
			pop.addEventListener(CloseEvent.CLOSE, popCloseHandler);
			filter.addEventListener(CloseEvent.CLOSE, filterCloseHandler);
			//pop.removeAllChildren();
			pop.addChild(filter);
			filter.crComplete();
			if((app.mouseX + filter.width + pop.width) > app.width){
				pop.x = app.width - (filter.width+pop.width);
			}else{
				pop.x = app.mouseX;	
			}
			pop.y = app.mouseY;
			pop.width=filter.width + 50;
			pop.height = filter.height + 70;
		}
		
		public function popCloseHandler(event:CloseEvent):void{
			var target:TitleWindow = TitleWindow(event.target);
			target.removeAllChildren();
			PopUpManager.removePopUp(target);
			var eventObj:CustormEvent = new CustormEvent("custormClose");
			dispatchEvent(eventObj);
		}
		
		public function filterCloseHandler(event:CloseEvent):void{
			var target:TitleWindow = TitleWindow(Filter(event.target).parent);
			target.removeAllChildren();
			PopUpManager.removePopUp(target);
		}
	}
}