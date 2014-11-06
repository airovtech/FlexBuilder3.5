package com.maninsoft.smart.formeditor.refactor.simple.util
{
	import com.maninsoft.smart.formeditor.model.FormEntity;
	import com.maninsoft.smart.formeditor.model.type.FormatType;
	import com.maninsoft.smart.formeditor.model.type.FormatTypes;
	import com.maninsoft.smart.formeditor.model.property.FormFormatInfo;
	import com.maninsoft.smart.formeditor.refactor.command.UpdateFormEntityCommand;
	import com.maninsoft.smart.workbench.common.command.model.Command;
	import com.maninsoft.smart.workbench.common.editor.EditDomain;
	
	public class FormItemCommandUtil
	{
		public static function executeUpdateFormItemFormat(editDomain:EditDomain, formItem:FormEntity, value:Object, type:String):void{
			var command:Command = FormItemCommandUtil.updateFormItemFormat(formItem, value, type);
			editDomain.getCommandStack().execute(command);
		}
		
		public static function updateFormItemFormat(formItem:FormEntity, value:Object, type:String):Command{
			var formFormatInfo:FormFormatInfo = formItem.format.clone();
			formFormatInfo[type] = value;
			
			var command:Command = updateFormItemProperty(formItem, formFormatInfo, FormEntity.PROP_FORMAT);
			
			return command;
		}
		
		public static function executeUpdateFormItemProperty(editDomain:EditDomain, formItem:FormEntity, value:Object, type:String):void{
			var command:Command = FormItemCommandUtil.updateFormItemProperty(formItem, value, type);
			editDomain.getCommandStack().execute(command);
		}
		
		public static function updateFormItemProperty(formItem:FormEntity, value:Object, type:String):Command{
			var command:UpdateFormEntityCommand = new UpdateFormEntityCommand(formItem.name);
			command.formEntityModel = formItem;
			command.newValue = value;
			command.type = type;
			
			return command;
		}
		
		public static function resizeFormItem(formItem:FormEntity, labelWidth:int, contentsWidth:int, height:int):Command{
			var command:Command  = FormItemCommandUtil.updateFormItemProperty(formItem, labelWidth, FormEntity.PROP_LABEL_WIDTH);
			command = command.chain(FormItemCommandUtil.updateFormItemProperty(formItem, contentsWidth, FormEntity.PROP_CONTENT_WIDTH));
			command = command.chain(FormItemCommandUtil.updateFormItemProperty(formItem, height, FormEntity.PROP_HEIGHT));
			command = command.chain(FormDocumentCommandUtil.resizeDocumentCommand(height - formItem.height, formItem.root));
			  
			return command;
		}

		public static function executeResizeFormItem(editDomain:EditDomain, formItem:FormEntity, labelWidth:int, contentsWidth:int, height:int):void{
			editDomain.getCommandStack().execute(resizeFormItem(formItem, labelWidth, contentsWidth, height));
		}
		
		public static  function changeSchemaItemNextType(editDomain:EditDomain, formEntity:FormEntity):void{				
			var typeNum:int = 0;
			var formatTypeArray:Array = FormatTypes.getEnableFormatTypeArray(formEntity);
			for(var i:int = 0 ; i < formatTypeArray.length ; i++){
				var formatType:FormatType = FormatType(formatTypeArray[i]);
				if(formatType.type == formEntity.format.type){
					typeNum = (i == (formatTypeArray.length - 1))?0:i+1;
				} 
			}
			
			executeUpdateFormItemFormat(editDomain, formEntity, FormatType(formatTypeArray[typeNum]).type, "type");
		}
		
		public static  function rename(editDomain:EditDomain, name:String, formEntity:FormEntity):void{				
			var command:Command = FormItemCommandUtil.updateFormItemProperty(formEntity, name, FormEntity.PROP_NAME);
			
			editDomain.getCommandStack().execute(command);
		}
	}
}