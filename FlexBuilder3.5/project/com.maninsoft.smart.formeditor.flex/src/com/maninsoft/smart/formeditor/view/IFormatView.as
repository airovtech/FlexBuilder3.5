package com.maninsoft.smart.formeditor.view
{
	import com.maninsoft.smart.formeditor.model.FormEntity;
	import com.maninsoft.smart.formeditor.model.type.FormatType;
	import com.maninsoft.smart.formeditor.refactor.editor.FormEditDomain;
	
	public interface IFormatView extends IGraphicalView
	{
		function get fieldModel():FormEntity;
		function set fieldModel(formEntityModel:FormEntity):void;
		
		function get formatType():FormatType;
		
		function get option():Object;
		function set option(option:Object):void;
		
		function get fieldView():FieldView;
		function set fieldView(fieldView:FieldView):void;
		
		function get editDomain():FormEditDomain;
		function set editDomain(editDomain:FormEditDomain):void;
		
		function release():void;
	}
}