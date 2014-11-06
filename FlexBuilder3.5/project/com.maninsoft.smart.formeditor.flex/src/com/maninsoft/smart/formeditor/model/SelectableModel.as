package com.maninsoft.smart.formeditor.model
{
	import com.maninsoft.smart.formeditor.util.FormEditorEvent;
	
	import flash.events.EventDispatcher;
	
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	public class SelectableModel extends EventDispatcher implements ISelectableModel
	{
		private var _resourceManager:IResourceManager = ResourceManager.getInstance();
		
		public function get resourceManager():IResourceManager{
			if(_resourceManager==null)
				_resourceManager = ResourceManager.getInstance();
			return _resourceManager;
		}
		
		public function select(selection:Boolean = true):void{
			var event:FormEditorEvent;
			if (selection) {
				event = new FormEditorEvent(FormEditorEvent.SELECT);
			} else {
				event = new FormEditorEvent(FormEditorEvent.UNSELECT);
			}
			event.model = this;
			this.dispatchEvent(event);
			trace("[Event]SelectableModel select dispatch event : " + event);
		}
	}
}