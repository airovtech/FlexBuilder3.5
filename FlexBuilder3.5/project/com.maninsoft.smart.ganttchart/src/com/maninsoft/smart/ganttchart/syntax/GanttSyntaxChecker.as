package com.maninsoft.smart.ganttchart.syntax
{
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.syntax.SyntaxChecker;
	import com.maninsoft.smart.modeler.xpdl.syntax.TaskApplicationErrors;

	public class GanttSyntaxChecker extends SyntaxChecker
	{
		public function GanttSyntaxChecker()
		{
			super();
		}

		override protected function checkDiagram(dgm: XPDLDiagram): void {
			//TaskApplicationErrors.checkIt(problems, dgm);
			//ConnectionErrors.checkIt(_problems, dgm);
			//TransitionErrors.checkIt(_problems, dgm);
			//BackwardLinkError.checkIt(_problems, dgm);
		}
	}
}