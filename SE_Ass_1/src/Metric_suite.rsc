module Metric_suite

public void createMetrics()
{
 loc p = |project://hello|;
 ast = createAstsFromEclipseProject(p, false);
 M3 model3 = createM3FromEclipseProject(|project://hello|);

 int project_loc = getProjectsLinesOfCode();
 println(project_loc);
}