module Metric_suite

import List;
import IO;
import String;
import analysis::m3::Core;
import analysis::m3::metrics::LOC;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import util::Math;
import linesOfCode;



/*
*My point today is that, if we wish to count lines of code, 
*we should not regard them as "lines produced" but as "lines spent", 
*the current conventional wisdom is so foolish as to book that count on the wrong side of the ledger.
*
* Dijkstra
*/

public void runAnalytics()
{
 loc p = |project://hello|;
 set[Declaration] project_ast = createAstsFromEclipseProject(p, false);
 M3 project_model = createM3FromEclipseProject(|project://hello|);

 total_project_loc = getProjectLinesOfCode(project_model);
 println(total_project_loc);
}