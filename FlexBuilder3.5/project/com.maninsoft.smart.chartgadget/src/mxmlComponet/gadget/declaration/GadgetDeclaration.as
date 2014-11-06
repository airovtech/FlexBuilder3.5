package mxmlComponet.gadget.declaration
{
	import flash.utils.*;
	
	import mx.collections.ArrayCollection;
	
	import mxmlComponet.gadget.ChartGadget;
	import mxmlComponet.gadget.DefaultGadget;
	import mxmlComponet.gadget.FormWorkGadget;
	import mxmlComponet.gadget.WorkListedGadget;
	import mxmlComponet.gadget.WorkListingGadget;
	import mxmlComponet.gadget.column.WorkListedGadgetColumns;
	import mxmlComponet.gadget.column.WorkListingGadgetColumns;
	import mxmlComponet.gadget.model.GadgetContent;
	import mxmlComponet.test.fucker;
	import mxmlComponet.test.girl;
	import mxmlComponet.test.testGaject;
	
	import smartWork.custormObj.GadgetPanel;
	
	public class GadgetDeclaration{
		//Gadget
		private var gadgetPanel:GadgetPanel;
		private var gadget1:testGaject;
		private var gadget2:fucker;
		private var gadget3:girl;
		private var workListingGadget:WorkListingGadget;
		private var workListedGadget:WorkListedGadget;
		private var formWorkGadget:FormWorkGadget;
		private var chartGadget:ChartGadget;
		private var defaultGadget:DefaultGadget;
		
		//Gadget Column
		private var workListingGadgetColumns:WorkListingGadgetColumns;
		private var workListedGadgetColumns:WorkListedGadgetColumns;
		
		public var gadgetContents:ArrayCollection = new ArrayCollection([
			new GadgetContent("1", "처리할 업무", "처리할 업무입니다.", "mxmlComponet.gadget::WorkListingGadget", 
				"mxmlComponet.gadget.column::WorkListingGadgetColumns", false, null),	
				
			new GadgetContent("2", "지시할 업무", "지시할 업무입니다.", "", "", false, null),
			
			new GadgetContent("3", "완료할 업무", "완료할 업무입니다.", "mxmlComponet.gadget::WorkListedGadget", 
				"mxmlComponet.gadget.column::WorkListedGadgetColumns", false, null)
		]);
		
		public function getGadgetContentArray():ArrayCollection{
			return gadgetContents;
		}
		
		public function getGadgetContent(id:String):GadgetContent{
			var gac:GadgetContent;
			for(var i:int=0; i<gadgetContents.length; i++){
				gac = GadgetContent(gadgetContents.getItemAt(i));
				if(gac.id == id){
					break;
				}
			}
			return gac;
		}
	}
}