package com.maninsoft.smart.formeditor.refactor.simple.util
{
	import com.maninsoft.smart.formeditor.refactor.command.CreateFormEntityCommand;
	import com.maninsoft.smart.formeditor.refactor.command.RemoveFormEntityCommand;
	import com.maninsoft.smart.formeditor.refactor.command.UpdateFormModelCommand;
	import com.maninsoft.smart.formeditor.refactor.editor.FormEditDomain;
	import com.maninsoft.smart.formeditor.model.FormDocument;
	import com.maninsoft.smart.formeditor.model.FormEntity;
	import com.maninsoft.smart.workbench.common.command.model.Command;
	
	public class FormDocumentCommandUtil
	{
		public static function resizeDocumentCommand(plusHeight:int, formDocument:FormDocument):Command{
			
			var command:Command;
			
        	var itemsHeight:int = 0;
        	
        	if(formDocument.children != null){
            	for each(var formItem:FormEntity in formDocument.children){
            		itemsHeight += formItem.height;
//            		itemsHeight += formDocument.itemHeightGap;
            		itemsHeight += 7;
            	}
        	}
        	
        	var realHeight:int = formDocument.topSpace + formDocument.bottomSpace + itemsHeight + plusHeight;
//        	var realHeight:int = formDocument.topSpace + formDocument.bottomSpace 
//        							+ formDocument.headSpace + 30 + itemsHeight
//       							+ plusHeight;
        							
        	if(formDocument.height < realHeight){
        		command = updateFormDocumentProperty(formDocument, realHeight, FormDocument.PROP_HEIGHT);
        	}
        	return command;         	
		}
		
		public static function executeUpdateFormDocumentProperty(editDomain:FormEditDomain, formDocument:FormDocument, value:Object, type:String):void{
			var command:Command = updateFormDocumentProperty(formDocument, value, type);
			editDomain.getCommandStack().execute(command);
		}
		
		public static function updateFormDocumentProperty(formDocument:FormDocument, value:Object, type:String):Command{
			var command:UpdateFormModelCommand = new UpdateFormModelCommand(formDocument.name);
			command.formModel = formDocument;
			command.newValue = value;
			command.type = type;
			
			return command;
		}

		public static function insertSchemaItemUp(editDomain:FormEditDomain, current:FormEntity, name:String = ""):void{
			var insertNum:int = -1;
			if(current.parent != null){
				insertNum = current.parent.children.getItemIndex(current);
			}else{
				insertNum = current.root.children.getItemIndex(current);
			}
			insertSchemaItem(editDomain, current.root, current.parent, null, insertNum, name);
		}
		
		public static function insertSchemaItemDown(editDomain:FormEditDomain, current:FormEntity, name:String = ""):void{
			var insertNum:int = -1;
			if(current.parent != null){
				insertNum = current.parent.children.getItemIndex(current) + 1;
			}else{
				insertNum = current.root.children.getItemIndex(current) + 1;
			}
			insertSchemaItem(editDomain, current.root, current.parent, null, insertNum, name);
		}
		
		// 스키마 아이템 추가
		public static function insertSchemaItem(editDomain:FormEditDomain, formDocument:FormDocument, parent:FormEntity = null, insert:FormEntity = null, insertNum:int = -1, name:String = ""):void{
        	var command:Command = createInsertSchemaItem(formDocument, parent, insert, insertNum, name);
        	editDomain.getCommandStack().execute(command);
		}
		
		// 스키마 아이템 추가
		public static function createInsertSchemaItem(formDocument:FormDocument, parent:FormEntity = null, insert:FormEntity = null, insertNum:int = -1, name:String = ""):Command{
			var child:FormEntity;
			if(insert == null){
				child = new FormEntity(formDocument);
				if(name == ""){
					child.name = FormDocument.ITEM_NAME_PREFIX + (formDocument.currentEntityNum+1);
				}else{
	            	child.name = name;
				}
            	child.root = formDocument;

			}else{
				child = insert;
			}
        	        	           	
        	var command:Command = new CreateFormEntityCommand(formDocument, child, parent, insertNum);
        	
//        	command = command.chain(FormDocumentCommandUtil.resizeDocumentCommand(child.height + formDocument.itemHeightGap, formDocument));	
        	command = command.chain(FormDocumentCommandUtil.resizeDocumentCommand(child.height + 7, formDocument));
        	
        	return command;
		}
		
		public static function removeSchemaItem(editDomain:FormEditDomain, formEntity:FormEntity):void{				
			var command:Command = createRemoveSchemaItem(formEntity);
			editDomain.getCommandStack().execute(command);
		}
		
		public static function createRemoveSchemaItem(formEntity:FormEntity):Command{				
			var command:RemoveFormEntityCommand = new RemoveFormEntityCommand("Remove Item");
			command.child = formEntity;	
			return command;
		}
		
		public static  function rename(editDomain:FormEditDomain, name:String, formDocument:FormDocument):void{				
			var command:Command = FormDocumentCommandUtil.updateFormDocumentProperty(formDocument, name, FormDocument.PROP_NAME);
			
			editDomain.getCommandStack().execute(command);
		}
	}
}