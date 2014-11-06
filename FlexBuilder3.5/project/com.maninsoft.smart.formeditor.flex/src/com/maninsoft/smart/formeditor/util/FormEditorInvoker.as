package com.maninsoft.smart.formeditor.util
{
	import com.maninsoft.smart.common.util.SmartUtil;
	import com.maninsoft.smart.formeditor.command.UpdateFormInfoCommand;
	import com.maninsoft.smart.formeditor.command.mapping.AddFieldMappingCommand;
	import com.maninsoft.smart.formeditor.command.mapping.AddFormMappingFormCommand;
	import com.maninsoft.smart.formeditor.command.mapping.AddMappingFormCondCommand;
	import com.maninsoft.smart.formeditor.command.mapping.AddMappingFormParamCommand;
	import com.maninsoft.smart.formeditor.command.mapping.AddServiceMappingFormCommand;
	import com.maninsoft.smart.formeditor.command.mapping.RemoveFieldMappingCommand;
	import com.maninsoft.smart.formeditor.command.mapping.RemoveMappingFormCommand;
	import com.maninsoft.smart.formeditor.command.mapping.RemoveMappingFormCondCommand;
	import com.maninsoft.smart.formeditor.command.mapping.RemoveMappingFormParamCommand;
	import com.maninsoft.smart.formeditor.command.mapping.RemoveMappingServiceCommand;
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridCell;
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridLayout;
	import com.maninsoft.smart.formeditor.layout.grid.util.FormGridCommandUtil;
	import com.maninsoft.smart.formeditor.layout.grid.util.FormGridUtil;
	import com.maninsoft.smart.formeditor.model.ActualParameter;
	import com.maninsoft.smart.formeditor.model.ActualParameters;
	import com.maninsoft.smart.formeditor.model.Cond;
	import com.maninsoft.smart.formeditor.model.Conds;
	import com.maninsoft.smart.formeditor.model.FormDocument;
	import com.maninsoft.smart.formeditor.model.FormEntity;
	import com.maninsoft.smart.formeditor.model.FormLink;
	import com.maninsoft.smart.formeditor.model.FormLinks;
	import com.maninsoft.smart.formeditor.model.Mapping;
	import com.maninsoft.smart.formeditor.model.Mappings;
	import com.maninsoft.smart.formeditor.model.ServiceLink;
	import com.maninsoft.smart.formeditor.model.ServiceLinks;
	import com.maninsoft.smart.formeditor.refactor.simple.util.FormDocumentCommandUtil;
	import com.maninsoft.smart.formeditor.refactor.simple.util.FormItemCommandUtil;
	import com.maninsoft.smart.workbench.common.command.model.Command;
	import com.maninsoft.smart.workbench.common.editor.EditDomain;
	
	import mx.collections.ArrayCollection;
	
	public class FormEditorInvoker
	{
		public static var editDomain:EditDomain;
		
		public static function updateFormatAttribute(field:FormEntity, attribute:String, value:Object):void {
			FormItemCommandUtil.executeUpdateFormItemFormat(editDomain, field, value, attribute);
		}
		
		public static function setFormLink(form:FormDocument, formLink:FormLink):void {
			if (form == null || formLink == null)
				return;
			
			var oldFormLink:FormLink = null;
			if (form.formLinks == null) {
				form.formLinks = new FormLinks(form);
			} else {
				oldFormLink = getOldFormLink(form.formLinks, formLink.id);
			}
			
			var command:Command = null;
			if (oldFormLink == null) {
				command = new AddFormMappingFormCommand(form.formLinks, formLink);
				
			} else {
				command = new UpdateFormInfoCommand(oldFormLink, "name", formLink.name);
				command = command.chain(new UpdateFormInfoCommand(oldFormLink, "targetFormId", formLink.targetFormId));
				command = command.chain(new UpdateFormInfoCommand(oldFormLink.conds, "operator", formLink.conds.operator));
				
				var oldConds:ArrayCollection = null;
				if (oldFormLink.conds == null) {
					oldFormLink.conds = new Conds();
				} else if (!SmartUtil.isEmpty(oldFormLink.conds.conds)) {
					oldConds = oldFormLink.conds.conds;
				}
				
				var i:int = 0;
				if (formLink.conds != null && !SmartUtil.isEmpty(formLink.conds.conds)) {
					if (oldConds == null)
						oldConds = new ArrayCollection();
					for each (var cond:Cond in formLink.conds.conds) {
						if (oldConds.length <= i++) {
							command = command.chain(new AddMappingFormCondCommand(oldFormLink.conds, cond));
							continue;
						}
						
						var oldCond:Cond = oldConds.getItemAt(i - 1) as Cond;
						command = command.chain(new UpdateFormInfoCommand(oldCond, "operator", cond.operator));
						command = command.chain(new UpdateFormInfoCommand(oldCond, "firstOperand", cond.firstOperand));
						command = command.chain(new UpdateFormInfoCommand(oldCond, "firstOperandName", cond.firstOperandName));
						command = command.chain(new UpdateFormInfoCommand(oldCond, "firstOperandType", cond.firstOperandType));
						command = command.chain(new UpdateFormInfoCommand(oldCond, "firstExpr", cond.firstExpr));
						command = command.chain(new UpdateFormInfoCommand(oldCond, "secondOperand", cond.secondOperand));
						command = command.chain(new UpdateFormInfoCommand(oldCond, "secondOperandName", cond.secondOperandName));
						command = command.chain(new UpdateFormInfoCommand(oldCond, "secondOperandType", cond.secondOperandType));
						command = command.chain(new UpdateFormInfoCommand(oldCond, "secondExpr", cond.secondExpr));
					}
				}
				
				if (oldConds != null && oldConds.length > i) {
					var oldCondsLength:int = oldConds.length;
					for (; i < oldCondsLength; i++)
						command = command.chain(new RemoveMappingFormCondCommand(oldConds.getItemAt(i) as Cond));
				}
				
			}
			
			editDomain.getCommandStack().execute(command);
		}
		public static function removeFormLink(formLink:FormLink):void {
			if (formLink == null || formLink.parent == null)
				return;
			editDomain.getCommandStack().execute(new RemoveMappingFormCommand(formLink));
		}
		private static function getOldFormLink(formLinks:FormLinks, id:String):FormLink {
			if (formLinks == null || SmartUtil.isEmpty(formLinks.formLinks) || SmartUtil.isEmpty(id))
				return null;
			for each (var formLink:FormLink in formLinks.formLinks) {
				if (formLink.id == id)
					return formLink;
			}
			return null;
		}
		
		public static function setServiceLink(form:FormDocument, serviceLink:ServiceLink):void {
			if (form == null || serviceLink == null)
				return;
			
			var oldServiceLink:ServiceLink = null;
			if (form.serviceLinks == null) {
				form.serviceLinks = new ServiceLinks(form);
			} else {
				oldServiceLink = getOldServiceLink(form.serviceLinks, serviceLink.id);
			}
			
			var command:Command = null;
			if (oldServiceLink == null) {
				command = new AddServiceMappingFormCommand(form.serviceLinks, serviceLink);
				
			} else {
				command = new UpdateFormInfoCommand(oldServiceLink, "name", serviceLink.name);
				command = command.chain(new UpdateFormInfoCommand(oldServiceLink, "targetServiceId", serviceLink.targetServiceId));
				command = command.chain(new UpdateFormInfoCommand(oldServiceLink.actualParams, "execution", serviceLink.actualParams.execution));
				
				var oldParams:ArrayCollection = null;
				if (oldServiceLink.actualParams == null) {
					oldServiceLink.actualParams = new ActualParameters();
				} else if (!SmartUtil.isEmpty(oldServiceLink.actualParams.actualParameters)) {
					oldParams = oldServiceLink.actualParams.actualParameters;
				}
				
				var i:int = 0;
				if (serviceLink.actualParams != null && !SmartUtil.isEmpty(serviceLink.actualParams.actualParameters)) {
					if (oldParams == null)
						oldParams = new ArrayCollection();
					for each (var param:ActualParameter in serviceLink.actualParams.actualParameters) {
						if (oldParams.length <= i++) {
							command = command.chain(new AddMappingFormParamCommand(oldServiceLink.actualParams, param));
							continue;
						}
						var oldParam:ActualParameter = oldParams.getItemAt(i - 1) as ActualParameter;
						command = command.chain(new UpdateFormInfoCommand(oldParam, "formalParameterId", param.formalParameterId));
						command = command.chain(new UpdateFormInfoCommand(oldParam, "formalParameterName", param.formalParameterName));
						command = command.chain(new UpdateFormInfoCommand(oldParam, "formalParameterType", param.formalParameterType));
						command = command.chain(new UpdateFormInfoCommand(oldParam, "targetType", param.targetType));
						command = command.chain(new UpdateFormInfoCommand(oldParam, "targetFieldId", param.targetFieldId));
						command = command.chain(new UpdateFormInfoCommand(oldParam, "targetFieldName", param.targetFieldName));
						command = command.chain(new UpdateFormInfoCommand(oldParam, "targetValueType", param.targetValueType));
						command = command.chain(new UpdateFormInfoCommand(oldParam, "expression", param.expression));
					}
				}
				
				if (oldParams != null && oldParams.length > i) {
					var oldParamsLength:int = oldParams.length;
					for (; i < oldParamsLength; i++)
						command = command.chain(new RemoveMappingFormParamCommand(oldParams.getItemAt(i) as ActualParameter));
				}
				
			}
			
			editDomain.getCommandStack().execute(command);
		}
		public static function removeServiceLink(serviceLink:ServiceLink):void {
			if (serviceLink == null || serviceLink.parent == null)
				return;
			editDomain.getCommandStack().execute(new RemoveMappingServiceCommand(serviceLink));
		}
		private static function getOldServiceLink(serviceLinks:ServiceLinks, id:String):ServiceLink {
			if (serviceLinks == null || SmartUtil.isEmpty(serviceLinks.serviceLinks) || SmartUtil.isEmpty(id))
				return null;
			for each (var serviceLink:ServiceLink in serviceLinks.serviceLinks) {
				if (serviceLink.id == id)
					return serviceLink;
			}
			return null;
		}
		
		public static function createMapping(field:FormEntity, mapping:Mapping, isIn:Boolean):void {
			if (field == null || mapping == null)
				return;
			if (field.mappings == null)
				field.mappings = new Mappings(field);
			var command:Command = new AddFieldMappingCommand(field.mappings, mapping, isIn);
			editDomain.getCommandStack().execute(command);
		}
		public static function updateMapping(mapping:Mapping, oldMapping:Mapping):void {
			if (mapping == null || oldMapping == null)
				return;
			var command:Command = new UpdateFormInfoCommand(oldMapping, "name" , mapping.name);
			command = command.chain(new UpdateFormInfoCommand(oldMapping, "type" , mapping.type));
			command = command.chain(new UpdateFormInfoCommand(oldMapping, "eachTime" , mapping.eachTime));
			command = command.chain(new UpdateFormInfoCommand(oldMapping, "mappingType" , mapping.mappingType));
			command = command.chain(new UpdateFormInfoCommand(oldMapping, "formLinkId" , mapping.formLinkId));
			command = command.chain(new UpdateFormInfoCommand(oldMapping, "formLinkName" , mapping.formLinkName));
			command = command.chain(new UpdateFormInfoCommand(oldMapping, "activityId" , mapping.activityId));
			command = command.chain(new UpdateFormInfoCommand(oldMapping, "fieldId" , mapping.fieldId));
			command = command.chain(new UpdateFormInfoCommand(oldMapping, "fieldName" , mapping.fieldName));
			command = command.chain(new UpdateFormInfoCommand(oldMapping, "valueFunction" , mapping.valueFunction));
			command = command.chain(new UpdateFormInfoCommand(oldMapping, "expression" , mapping.expression));
			command = command.chain(new UpdateFormInfoCommand(oldMapping, "expressionTree" , mapping.expressionTree));
			command = command.chain(new UpdateFormInfoCommand(oldMapping, "fieldMappings" , mapping.fieldMappings));
			editDomain.getCommandStack().execute(command);
		}
		public static function removeMapping(mapping:Mapping, isIn:Boolean):void {
			if (mapping == null)
				return;
			editDomain.getCommandStack().execute(new RemoveFieldMappingCommand(mapping, isIn));
		}
		
		public static function removeField(field:FormEntity):void {
			if (field == null || field.root == null)
				return;
			
			var gridItem:FormGridCell = FormGridUtil.getFormGridItemByFieldId(field.root.layout as FormGridLayout, field.id);
			var command:Command = FormGridCommandUtil.updateItemCommand(gridItem, "fieldId", null);
			command = command.chain(FormDocumentCommandUtil.createRemoveSchemaItem(field));
			editDomain.getCommandStack().execute(command);
		}
	}
}