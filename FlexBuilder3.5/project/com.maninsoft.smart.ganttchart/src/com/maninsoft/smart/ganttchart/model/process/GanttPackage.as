package com.maninsoft.smart.ganttchart.model.process
{
	import com.maninsoft.smart.ganttchart.model.GanttChartGrid;
	import com.maninsoft.smart.modeler.model.Link;
	import com.maninsoft.smart.modeler.model.Node;
	import com.maninsoft.smart.modeler.xpdl.model.Annotation;
	import com.maninsoft.smart.modeler.xpdl.model.base.Artifact;
	import com.maninsoft.smart.modeler.xpdl.model.process.WorkflowProcess;
	import com.maninsoft.smart.modeler.xpdl.model.process.XPDLPackage;
	import com.maninsoft.smart.workbench.common.meta.impl.SWPackage;
	
	import mx.utils.UIDUtil;

	public class GanttPackage extends XPDLPackage
	{

		public static const GANTTCHART_BASEDATE:Date = new Date(1968, 0);
		public static const GANTTCHART_BASEDATE_STRING:String = "1968-01-01 00:00:00";

		public static var GANTTCHART_DUEDATE:Date;
		
		private var _totalPages:String;
		private var _currentPage:String;
		
		public function GanttPackage(dueDate:Date)
		{
			if(dueDate)
				GANTTCHART_DUEDATE = dueDate;
			else
				GANTTCHART_DUEDATE = new Date(GANTTCHART_BASEDATE.time);
	
			super();
			pool = null;
			pool = new GanttChartGrid(this);
			process = null;
			process = new GanttProcess(this);			
		}
			
		public function get ganttProcess():GanttProcess{
			return super.process as GanttProcess;
		}

		public function get ganttChartGrid(): GanttChartGrid{
			return super.pool as GanttChartGrid;
		}
		
		public function get baseDateDiff():Number{
			return GANTTCHART_DUEDATE.time - GANTTCHART_BASEDATE.time;
		}

		public function get totalPages(): String{
			return _totalPages;
		}
		
		public function get currentPage(): String{
			return _currentPage;
		}
		
		override protected function doRead(src: XML): void {
			id = src.@Id;
			name = src.@Name;
			_totalPages = src.@TotalPages;
			_currentPage = src.@CurrentPage;
			
			if (src._ns::PackageHeader.length() > 0)
				packageHeader.read(src._ns::PackageHeader[0]);
			
			if (src._ns::RedefinableHeader.length() > 0)
				redefinableHeader.read(src._ns::RedefinableHeader[0]);
			
			if (src._ns::Script.length() > 0)
				script.read(src._ns::Script[0])
			
			ganttChartGrid.read(src._ns::Pools._ns::Pool[0]);
			
			if(src._ns::WorkflowProcesses.length() > 0)
				readProcesses(src._ns::WorkflowProcesses[0]);
			
			if (src._ns::Artifacts.length() > 0)
				readArtifacts(src._ns::Artifacts[0]);
		}
		
		override protected function doWrite(dst: XML): void {
			dst.@Id = id;
			dst.@Name = name;
			
			dst._ns::PackageHeader = "";
			packageHeader.write(dst._ns::PackageHeader[0]);
			
			dst._ns::RedefinableHeader = "";
			redefinableHeader.write(dst._ns::RedefinableHeader[0]);
			
			dst._ns::Script = "";
			script.write(dst._ns::Script[0]);
			
			dst._ns::Pools._ns::Pool = "";
			ganttChartGrid.write(dst._ns::Pools._ns::Pool[0]);
			
			dst._ns::WorkflowProcesses = "";
			writeProcesses(dst._ns::WorkflowProcesses[0]);
			
			dst._ns::Artifacts = "";
			writeArtifacts(dst._ns::Artifacts[0]);
		}
		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------

		private function readProcesses(src: XML): void {
			for each (var xml: XML in src._ns::WorkflowProcess) {
			
				if(xml.@ParentId==null || xml.@ParentId==""){
					process.read(xml); 
					processes.push(process);
				}
				else{
					var subProcess: GanttProcess = new GanttProcess(this);
					subProcess.read(xml);
					processes.push(subProcess);
				}
			}
		}

		private function writeProcesses(dst: XML): void {
			if(processes.length>0){
				var numProcess:int=0;
				for (var i: int = 0; i < processes.length-1; i++) {
					var ganttProcess:GanttProcess = processes[i] as GanttProcess;
					if(ganttProcess.isInternalSubProcess){
						dst._ns::WorkflowProcess[numProcess] = "";
						GanttProcess(processes[i]).write(XML(dst._ns::WorkflowProcess[numProcess]));
						numProcess++;
					}
				}
				dst._ns::WorkflowProcess[numProcess] = "";
				GanttProcess(processes[processes.length-1]).write(XML(dst._ns::WorkflowProcess[numProcess]));
			}
		}
		
		private function readArtifacts(src: XML): void {
			for each (var xml: XML in src._ns::Artifact) {
				var art: Artifact = null;
			
				switch (xml.@ArtifactType.toString()) {
					case "Annotation":
						art = new Annotation();
						break;			
				}
			
				if (art) { 
					art.read(xml);
					artifacts.push(art);
				}
			}
		}
		
		private function writeArtifacts(dst: XML): void {
			for (var i: int = 0; i < artifacts.length; i++) {
				dst._ns::Artifact[i] = "";
				writeArtifact(artifacts[i], dst._ns::Artifact[i]);
			}
		}
		
		private function writeArtifact(art: Artifact, dst: XML): void {
			art.write(dst);
		}
		
		public function addSubProcess(subProcess: WorkflowProcess):void{
			for(var i:int=0; i<processes.length-1; i++){
				if(processes[i] == subProcess)
					break;
			}
			if(i==processes.length-1)
				processes.splice(0, 0, subProcess);			
		}
		
		public function removeSubProcess(subProcess:WorkflowProcess):void{
			for(var i:int=0; i<processes.length-1; i++){
				if(processes[i] == subProcess)
					processes.splice(i, 1);
			}			
		}
		
		public function addLinksInSubProcess(subProcessId: String, links: Array): void{
			for(var i: int=0; i<links.length; i++){
				addLinkInSubProcess(subProcessId, links[i]);
			}
		}
		
		
		public function addLinkInSubProcess(subProcessId: String, link: Link): void{
			for(var i: int=0; i<processes.length-1; i++){
				if(GanttProcess(processes[i]).id == subProcessId){
					GanttProcess(processes[i]).transitions.push(link);	
				}
			}		
		}
		
		public function removeLinksInSubProcess(links: Array): Array{
			var ids: Array = new Array();
			for each(var link: Link in links){
				ids.push(removeLinkInSubProcess(link));
			}
			return ids; 
		}
		
		public function removeLinkInSubProcess(link: Link): String{
			for(var i: int=0; i<processes.length-1; i++){
				for(var j: int=0; j<GanttProcess(processes[i]).transitions.length; j++){
					if(GanttProcess(processes[i]).transitions[j] == link){
						GanttProcess(processes[i]).transitions.splice(j, 1);
						return GanttProcess(processes[i]).id;
					}
				}
			}
			return null;
		}
		
		public function addNodeInSubProcess(subProcessId: String, index: int, node: Node): void{
			for(var i: int=0; i<processes.length-1; i++){
				if(GanttProcess(processes[i]).id == subProcessId){
					if(index>=0 || index<GanttProcess(processes[i]).activities.length)
						GanttProcess(processes[i]).activities.splice(index, 0, node);
					else
						GanttProcess(processes[i]).activities.push(node);
				}
			}
		}
		
		public function removeNodeInSubProcess(subProcessId:String, node: Node): void{
			for(var i: int=0; i<processes.length-1; i++){
				if(processes[i].id != subProcessId) continue;
				for(var j: int=0; j<GanttProcess(processes[i]).activities.length; j++){
					if(GanttProcess(processes[i]).activities[j] == node){
						GanttProcess(processes[i]).activities.splice(j, 1);
					}
				}
			}
		}
		
		public function createSubProcessId(): String{
			return(SWPackage.SUBPROCESS_ID_PREFIX + UIDUtil.createUID()); 
		}
	}
}