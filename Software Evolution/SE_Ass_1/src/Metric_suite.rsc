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
import cyclomaticComplexity;
import duplicates;
import unitTest;



/*
*My point today is that, if we wish to count lines of code, 
*we should not regard them as "lines produced" but as "lines spent", 
*the current conventional wisdom is so foolish as to book that count on the wrong side of the ledger.
*
* Dijkstra
*/

public void runAnalytics()
{
 loc p = |project://smallsql0|;																				// Get project as loc
 set[Declaration] project_ast = createAstsFromEclipseProject(p, false);									// Create Abstract Syntax Tree
 M3 project_model = createM3FromEclipseProject(|project://smallsql0|);										// Create M3 Model from prject
 total_project_loc = getProjectLinesOfCode(project_model);												
 println(total_project_loc);
 


 
 
 println("-------------------Software Evolution Metric Suite ------------------------------");
 print("Project name: ");println(p.uri);
 
 print("Total lines of code: ");println(total_project_loc);
 print("Total MYBF: ");println(linesOfCodeToMYBF(total_project_loc));
 
 rel[str name,int linesofcode,int cc] unit_list = {};
 unit_list = getUnitList(project_ast);
// println(unit_list);
 
 
 print("Cyclomatic Complexity: ");println(getProjectComplexity(unit_list));
 
 print("Duplicate %: ");
 println(getProjectCodeDuplicates(project_model));

 print("Unit tests: ");
 println(getUnitTestCount(project_model));
}



public rel[str name,int linesofcode,int cc] getUnitList(set[Declaration] ast)
{
  rel[str name,int linesofcode,int cc] local_unit_list = {};
   top-down visit(ast){
  	case C:constructor(name,_,_,source) :{
    int unit_size = getUnitLinesOfCode(source @ src);
    int cc = getNodeComplexity(source);
    local_unit_list = local_unit_list + <name,unit_size,cc>;
 	}
 	
   case M:method(_,name,_,_,source) :{
    int unit_size = getUnitLinesOfCode(source @ src);
    int cc = getNodeComplexity(source);
    local_unit_list = local_unit_list + <name,unit_size,cc>;
    }   
   } 
  return local_unit_list;
}