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

int usefull_lines =0;

public void runAnalytics()
{
 loc p = |project://hello|;																				// Get project as loc
 set[Declaration] project_ast = createAstsFromEclipseProject(p, false);									// Create Abstract Syntax Tree
 M3 project_model = createM3FromEclipseProject(|project://hello|);										// Create M3 Model from prject
 total_project_loc = getProjectLinesOfCode(project_model);												
 

 rel[str name,int linesofcode,int cc] unit_list = getUnitList(project_ast);
 
 
 println("-------------------Software Evolution Metric Suite ------------------------------");
 print("Project name: ");println(p.uri);
 
 print("Total lines of code: ");println(total_project_loc);
 
 int volume = linesOfCodeToMYBF(total_project_loc);
 print("Total MYBF: "); println(volume);


 int cc = getProjectComplexity(unit_list);
 print("Cyclomatic Complexity: "); println(cc);
 
 int duplicates = getProjectCodeDuplicates(project_ast,total_project_loc,usefull_lines);
 print("Duplicates : "); println(duplicates);
 
 print("Unit tests: "); println(getUnitTestCount(project_model));
 
 
 int unit_size = getProjectUnitSize(unit_list);
 int unit_test = 0;
 
 
 println("---------------------------------------------------------------------------------");
 println("Mapping source code property scores back to system-level scores");
 println("Volume , Complexity , Duplication , unit size , unit testing ");
 print("   ");print(numToScale(volume));print("         "); print(numToScale(cc));print("          "); print(numToScale(duplicates));print("           "); print(numToScale(unit_size));print("             "); println(numToScale(unit_test));
 println("");
 println("");
 print("Analysability: "); println(numToScale(volume+duplicates+unit_size+unit_test));
 print("Changeability: "); println(numToScale(cc+duplicates));
 print("Stability: "); println(numToScale(unit_test));
 print("Testability: "); println(numToScale(cc+unit_size+unit_test));
}


public str numToScale(int numb)
{
 if(numb >= 2) return "++"; 
 if(numb == 1) return "+";
 if(numb == 0) return "0";
 if(numb == -1) return "-";
 if(numb == -2) return "--";
 else return "0";
}


public rel[str name,int linesofcode,int cc] getUnitList(set[Declaration] ast)
{
  rel[str name,int linesofcode,int cc] local_unit_list = {};
  int total_usefull_size = 0;
   top-down visit(ast){
  	case C:constructor(name,_,_,source) :{
    int unit_size = getUnitLinesOfCode(source @ src);
    int cc = getNodeComplexity(source);
    local_unit_list = local_unit_list + <name,unit_size,cc>;
    usefull_lines= usefull_lines + unit_size;
 	}
 	
   case M:method(_,name,_,_,source) :{
    int unit_size = getUnitLinesOfCode(source @ src);
    int cc = getNodeComplexity(source);
    local_unit_list = local_unit_list + <name,unit_size,cc>;
    usefull_lines =usefull_lines+unit_size;
    }   
   } 
  return local_unit_list;
}
