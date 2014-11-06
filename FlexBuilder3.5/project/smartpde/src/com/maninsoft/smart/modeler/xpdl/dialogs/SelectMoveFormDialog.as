package com.maninsoft.smart.modeler.xpdl.dialogs
{
	import com.maninsoft.smart.common.dialog.AbstractDialog;
	import com.maninsoft.smart.modeler.xpdl.server.Server;
	import com.maninsoft.smart.modeler.xpdl.server.TaskForm;
	import com.maninsoft.smart.modeler.xpdl.server.service.GetCategoryListService;
	import com.maninsoft.smart.modeler.xpdl.server.service.GetFormListService;
	import com.maninsoft.smart.modeler.xpdl.server.service.GetFullPackageService;
	import com.maninsoft.smart.modeler.xpdl.server.service.GetPackageListService;
	import com.maninsoft.smart.workbench.common.assets.TreeAssets;
	import com.maninsoft.smart.workbench.common.meta.impl.SWForm;
	import com.maninsoft.smart.workbench.common.model.WorkCategory;
	import com.maninsoft.smart.workbench.common.model.WorkPackage;
	import com.maninsoft.smart.workbench.common.util.MsgUtil;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.controls.Tree;
	import mx.core.Application;
	import mx.core.ScrollPolicy;
	import mx.events.TreeEvent;
	import mx.managers.PopUpManager;

	public class SelectMoveFormDialog extends AbstractDialog
	{

		//----------------------------------------------------------------------
		// Class Variables
		//----------------------------------------------------------------------

		private static var _dialog: SelectMoveFormDialog;

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		[Bindable]
		public var _moveFormIds: ArrayCollection;

		private var _acceptFunc: Function;
		private var _server:Server;
		
		private var moveFormIdTree:Tree = new Tree();

		//----------------------------------------------------------------------
		// Class methods
		//----------------------------------------------------------------------

		public function SelectMoveFormDialog()
		{
			super();
			this.title = resourceManager.getString("ProcessEditorETC", "moveFormSelectionText");
			this.showOkButton=true;
			this.showCancelButton=true;
			this.showCloseButton=true;
		}
	
		override protected function childrenCreated():void{
			moveFormIdTree.styleName="selectMoveFormTree";
			moveFormIdTree.showRoot=false;
			moveFormIdTree.percentWidth=100;
			moveFormIdTree.percentHeight=100;
			moveFormIdTree.setStyle("disclosureClosedIcon", TreeAssets.plusIcon);
			moveFormIdTree.setStyle("disclosureOpenIcon", TreeAssets.minusIcon);
			moveFormIdTree.iconFunction = moveFormIdIcon;
			moveFormIdTree.verticalScrollPolicy=ScrollPolicy.AUTO;
			moveFormIdTree.verticalScrollPolicy=ScrollPolicy.OFF;
			BindingUtils.bindProperty(moveFormIdTree, "dataProvider", this, ["_moveFormIds"]);
			contentBox.addChild(moveFormIdTree);
			
			moveFormIdTree.addEventListener(TreeEvent.ITEM_OPENING, moveFormIdTree_itemOpening);
		}		
		
		public static function execute(server:Server, current:Object, acceptFunc: Function, position:Point=null, width:Number=0, height:Number=0): void {
			if (!server)
				return;
					
			_dialog = PopUpManager.createPopUp(Application.application as DisplayObject, SelectMoveFormDialog, true) as SelectMoveFormDialog;

			_dialog._acceptFunc = acceptFunc;
			_dialog._server = server;
			if(position){
				_dialog.x = position.x;
				_dialog.y = position.y;
			}else{
				PopUpManager.centerPopUp(_dialog);	
			}

			if(width) _dialog.width = width;
			if(height) _dialog.height = height;

			_dialog.moveFormIdTree.verticalScrollPolicy=ScrollPolicy.AUTO;

			_dialog.getMoveFormIds();
			_dialog.moveFormIdTree.setFocus();
	
		}

		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
		private function getMoveFormIds():void{
			this._moveFormIds = new ArrayCollection();
		 	_server.getCategoryList(null, getRootCategoryResult);
		 	function getRootCategoryResult(svc:GetCategoryListService):void{
		 		if(svc.categories.length){
		 			var category:WorkCategory = svc.categories[0];
		 			_moveFormIds.addItem(category);
		 			if(!category.id) return;
		 			_server.getCategoryList(category.id, getChildrenByCategoryIdResult);
		 			function getChildrenByCategoryIdResult(svc:GetCategoryListService):void{
		 				if(svc.categories.length){
		 					WorkCategory(_moveFormIds[0]).addItems(svc.categories);
		 					WorkCategory(_moveFormIds[0]).loaded=true;
							moveFormIdTree.expandItem(category, true);
		 				}
		 			}	
		 		}
		 	}
		}

		private function closeDialog(accept: Boolean = true): void {
			var taskForm:TaskForm;				
			if (accept && (_acceptFunc != null) && moveFormIdTree.selectedItem){	
				if(moveFormIdTree.selectedItem is TaskForm){
					 taskForm = moveFormIdTree.selectedItem as TaskForm;
					_server.getFullPackage(taskForm.packageId, taskForm.version, getFullPackageResult);
				}else if(moveFormIdTree.selectedItem is WorkPackage){
					var workPackage:WorkPackage = moveFormIdTree.selectedItem as WorkPackage;
					if(workPackage.type == WorkPackage.PACKAGE_TYPE_SINGLE){
						_server.getFullPackage(workPackage.id, workPackage.version, getFullPackageResult);
					}else{
						PopUpManager.removePopUp(this);							
					}
				}else{
					PopUpManager.removePopUp(this);
				}
				function getFullPackageResult(svc:GetFullPackageService):void{
					if(svc.swPackage){
						var swForm:SWForm;
						var arr:ArrayCollection = svc.swPackage.getFormResources();
						if(taskForm){
							for(var i:int; i<arr.length; i++){
								if(taskForm.formId == SWForm(arr.getItemAt(i)).id){
									swForm = SWForm(arr.getItemAt(i));
									break;
								}
							}
						}else{
							swForm = arr[0] as SWForm;
						}
					}
					if(swForm){
						_acceptFunc(swForm);
					}
					close();
				}
			}else{
				PopUpManager.removePopUp(this);					
			}
		}

		override protected function ok(event:Event = null):void {
			if(!moveFormIdTree.selectedItem || (moveFormIdTree.selectedItem is WorkCategory)){
				MsgUtil.showMsg(resourceManager.getString("ProcessEditorMessages", "PEI003"));
				return;
			}else if(moveFormIdTree.selectedItem is WorkPackage){
				var workPackage:WorkPackage = moveFormIdTree.selectedItem as WorkPackage;
				if(workPackage.type != WorkPackage.PACKAGE_TYPE_SINGLE){
					MsgUtil.showMsg(resourceManager.getString("ProcessEditorMessages", "PEI003"));
					return;
				}
			}
			closeDialog(true);
		}

		//----------------------------------------------------------------------
		// Event handlers
		//----------------------------------------------------------------------

		//------------------------
		// Dialog
		//------------------------

		private function dlg_keyDown(event: KeyboardEvent): void {
			if (event.keyCode == Keyboard.ESCAPE){
				closeDialog(false);
			}
		}	

		//------------------------
		// refFormIdTree
		//------------------------

		private function moveFormIdIcon(item:Object): Class{
			return item.icon;
		}

		private function moveFormIdTree_itemOpening(event: TreeEvent): void {
			if (event.item is WorkCategory) {
				var openingCategory: WorkCategory = event.item as WorkCategory;
	
				if (!openingCategory.loaded) {
					event.preventDefault();
					var childrenLoaded:Boolean=false;
					var packageLoaded:Boolean=false;						
		 			_server.getCategoryList(openingCategory.id, getChildrenByCategoryIdResult);
		 			function getChildrenByCategoryIdResult(svc:GetCategoryListService):void{
		 				if(svc.categories.length){
 							openingCategory.addItems(svc.categories);
		 				}
		 				childrenLoaded=true;
		 				if(packageLoaded){
		 					openingCategory.loaded=true;
		 					moveFormIdTree_childrenLoaded(openingCategory)
		 				}
		 			}	
		 			_server.getPackageList(openingCategory.id, getPackageByCategoryIdResult);
		 			function getPackageByCategoryIdResult(svc:GetPackageListService):void{
		 				if(svc.packages.length){
		 					for(var i:int=0; i<svc.packages.length; i++){
		 						if(svc.packages[i].type == WorkPackage.PACKAGE_TYPE_PROCESS || svc.packages[i].type == WorkPackage.PACKAGE_TYPE_GANTT){
		 							svc.packages[i].clearChildren();
		 							svc.packages[i].loaded = false;
		 						}
		 					}
 							openingCategory.addItems(svc.packages);
		 				}
		 				packageLoaded=true;
		 				if(childrenLoaded){
		 					openingCategory.loaded=true;
		 					moveFormIdTree_childrenLoaded(openingCategory)
		 				}
		 			}	
				}
			}else if(event.item is WorkPackage){
				var openingPackage: WorkPackage = event.item as WorkPackage;
	
				if (!openingPackage.loaded) {
					event.preventDefault();
		 			_server.getTaskForms(openingPackage.id, openingPackage.version, getTaskFormsResult);
		 			function getTaskFormsResult(svc:GetFormListService):void{
		 				if(svc.forms.length){
 							openingPackage.addItems(svc.forms);
		 				}
	 					openingPackage.loaded=true;
		 				moveFormIdTree_childrenLoaded(openingPackage)
		 			}
		 		}						
			}
		}
		
		private function moveFormIdTree_childrenLoaded(openingItem:Object): void {
			moveFormIdTree.expandItem(openingItem, true);
		}
	}
}