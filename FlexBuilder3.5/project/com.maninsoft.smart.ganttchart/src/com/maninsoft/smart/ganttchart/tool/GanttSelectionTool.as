package com.maninsoft.smart.ganttchart.tool
{
	import com.maninsoft.smart.ganttchart.assets.GanttIconLibrary;
	import com.maninsoft.smart.ganttchart.controller.GanttMilestoneController;
	import com.maninsoft.smart.ganttchart.controller.GanttTaskController;
	import com.maninsoft.smart.ganttchart.controller.GanttTaskGroupController;
	import com.maninsoft.smart.ganttchart.editor.GanttChart;
	import com.maninsoft.smart.ganttchart.model.GanttChartGrid;
	import com.maninsoft.smart.ganttchart.model.GanttTaskGroup;
	import com.maninsoft.smart.ganttchart.view.ConstraintLineView;
	import com.maninsoft.smart.ganttchart.view.GanttChartGridView;
	import com.maninsoft.smart.ganttchart.view.GanttMilestoneView;
	import com.maninsoft.smart.ganttchart.view.GanttTaskGroupView;
	import com.maninsoft.smart.ganttchart.view.GanttTaskView;
	import com.maninsoft.smart.modeler.controller.Controller;
	import com.maninsoft.smart.modeler.controller.IControllerTool;
	import com.maninsoft.smart.modeler.editor.DiagramEditor;
	import com.maninsoft.smart.modeler.editor.handle.IDraggableHandle;
	import com.maninsoft.smart.modeler.editor.tool.IDraggable;
	import com.maninsoft.smart.modeler.editor.tool.SelectTracker;
	import com.maninsoft.smart.modeler.editor.tool.SelectionTool;
	import com.maninsoft.smart.modeler.view.IView;
	import com.maninsoft.smart.modeler.xpdl.model.base.XPDLNode;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	
	import mx.controls.scrollClasses.ScrollBar;
	import mx.core.SpriteAsset;

	

	public class GanttSelectionTool extends SelectionTool
	{
		public function GanttSelectionTool(editor:DiagramEditor)
		{
			super(editor);
		}
		
		override public function mouseDown(event: MouseEvent): void {
			
			handleIconClick(event);
			super.mouseDown(event);
		}

		protected function handleIconClick(event: MouseEvent): void {
			if (event.target is TextField)
				return;
				
			if (event.target.parent is ScrollBar || event.target is ScrollBar)
				return;

			if(event.target is GanttIconLibrary.overRightIcon || event.target is GanttIconLibrary.overLeftIcon){
				if(event.target.parent is GanttTaskView){
					var taskCtrl:GanttTaskController = editor.findControllerByView(event.target.parent as GanttTaskView) as GanttTaskController;
					taskCtrl.moveToTheDate(event.target);
				}else if(event.target.parent is GanttTaskGroupView){
					var groupCtrl:GanttTaskGroupController = editor.findControllerByView(event.target.parent as GanttTaskGroupView) as GanttTaskGroupController;
					groupCtrl.moveToTheDate(event.target);
				}else if(event.target.parent is GanttMilestoneView){
					var milestoneCtrl:GanttMilestoneController = editor.findControllerByView(event.target.parent as GanttMilestoneView) as GanttMilestoneController;
					milestoneCtrl.moveToTheDate(event.target);
				}
			}
			else if (event.target is GanttTaskGroupView){
				var ctrl: GanttTaskGroupController = editor.findControllerByView(event.target as GanttTaskGroupView) as GanttTaskGroupController;
				if(ctrl){
					if( 	event.localY >= GanttTaskGroup(ctrl.model).taskRect.y+GanttTaskGroup(ctrl.model).taskRect.height/2
						&&  event.localY <= GanttTaskGroup(ctrl.model).taskRect.y+GanttTaskGroup(ctrl.model).taskRect.height){
						if(ctrl.canExpand()){
							ctrl.expandTaskGroup();
						}else if(ctrl.canCollapse()){
							ctrl.collapseTaskGroup();
						}
					}
				}
			}else if(event.target is SpriteAsset && event.stageY > editor.parentDocument.editorHeaderToolBar.height && event.stageY < editor.parentDocument.editorHeaderToolBar.height+GanttChartGrid.CHARTHEADER_HEIGHT){
				if(event.target.x < event.target.width)
					GanttChart(editor).chartMoveToLeftStep();
				else 
					GanttChart(editor).chartMoveToRightStep();
			}
		}		

		override public function doubleClick(event: MouseEvent): void {

			if(dragTracker && event.target is IView && !(event.target is GanttChartGridView)){
				selManager.clear();
				dragTracker.deactivate();
				dragTracker = null;
				hideEditor();
			}
						
			handleDoubleClick(event);
		}
		
		override protected function handleDoubleClick(event: MouseEvent): void {
			if (event.target is TextField)
				return;
				
			if (event.target.parent is ScrollBar || event.target is ScrollBar)
				return;

			if (event.target is IView && !(event.target is GanttChartGridView)){
				var ctrl: Controller = editor.findControllerByView(event.target as IView);
				
				selManager.clear();							
				if (ctrl) {
					ctrl.showPropertyView = true;
					selManager.add(ctrl);
					if (!editor.readOnly && !(event.target is ConstraintLineView)){
						dragTracker = new GanttMoveTracker(ctrl);
					}
				} 
			} 

			if (dragTracker) {
				dragTracker.activate();
			}
		}

		override protected function handleMouseDown(event: MouseEvent): void {
			if (event.target is TextField)
				return;
				
			if (event.target.parent is ScrollBar || event.target is ScrollBar)
				return;

			if (event.target is IDraggable) {
				if (!editor.readOnly)
					dragTracker = IDraggable(event.target).getDragTracker(event);				
			} 
			else if (event.target is IControllerTool) {
			} 
			else if (event.target == menuHandle) {
				menuHandle.showMenu();
			} 
			else if (event.target is IView) {
				var ctrl: Controller = editor.findControllerByView(event.target as IView);
				
				/**
				 * 선택 가능한 위치일 경우에만 선택되도록
				 */
				if (ctrl.canSelect(event.localX, event.localY)) {
					// 메뉴핸들을 표시한다.
					//if (!editor.readOnly)
					//	_menuHandle.controller = ctrl.canPopUp ? ctrl : null;
						
					
					/*
					 * 기존에 선택된 개체가 아니면 선택 처리를 한다.
					 */
					if (!editor.selectionManager.contains(ctrl)) {
						if (ctrl) {
							// 에디터가 복수선택 가능하고, 쉬프트나 컨트롤키가 눌린 상태여야 복수 선택 가능하다.
							if (!editor.multiSelecatble || !(event.shiftKey || event.ctrlKey))
								selManager.clear();
								
							selManager.add(ctrl);
							
							if (!editor.readOnly && !(event.target is ConstraintLineView)) 
								dragTracker = new GanttMoveTracker(ctrl);
						} 
						else {
							selManager.clear();
						}
					} 
					/**
					 * 이미 선택된 상태라면
					 * 1. 텍스트 편집 상태로 진입해야 할 위치를 클릭한 경우라면 편집 시작
					 * 2. 이동 트래킹 시작
					 */
					else {
						/* 일단 막는다.
						if (selManager.uniqueSelected == ctrl && !editor.readOnly &&
						    ctrl is ITextEditable && ITextEditable(ctrl).canModifyText()) {
							showEditor(ctrl);
							
						} else*/ {
							if ((!editor.readOnly && !(event.target is ConstraintLineView)) || (editor.readOnly && (event.target is GanttChartGridView))) 
								dragTracker = new GanttMoveTracker(ctrl);
						}
					}
				} else {
					selManager.clear();
					// 자식들 선택
					dragTracker = ctrl.getSelectTracker(event.localX, event.localY);
				}
				
			} 
			else if (event.target is IDraggableHandle) {
				if (!editor.readOnly && !(event.target is ConstraintLineView)) {
					var handle: IDraggableHandle = event.target as IDraggableHandle;
					dragTracker = handle.getDragTracker();
				}
								
			} 
			else {
				selManager.clear();
				dragTracker = new SelectTracker(editor.rootController);
			}
			
			// 하위 클래스에서 tracker를 생성할 기회를 준다.
			if (dragTracker == null && !(event.target is ConstraintLineView)) {
				dragTracker = getDragTracker(event);
			}
			
			if (dragTracker) {
				dragTracker.activate();
				dragTracker.mouseDown(event);
			}
		}

		override protected function handleKeyDown(event: KeyboardEvent): void {			
			var shift: Boolean = event.ctrlKey;
			switch (event.keyCode) {
				case Keyboard.RIGHT:
					if ((!editor.readOnly) || (editor.readOnly && !(selManager.items)))
						moveSelection(shift ? 1 : editor.editConfig.gridSizeX, 0);				
					break;

				case Keyboard.LEFT:
					if ((!editor.readOnly) || (editor.readOnly && !(selManager.items)))
						moveSelection(shift ? -1 : -editor.editConfig.gridSizeX, 0);						
					break;

				default:
					super.handleKeyDown(event);
					break;
			}
		}
	}	
}