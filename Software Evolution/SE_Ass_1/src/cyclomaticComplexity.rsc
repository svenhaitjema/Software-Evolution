module cyclomaticComplexity

import List;
import IO;
import String;
import analysis::m3::Core;
import analysis::m3::metrics::LOC;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import util::Math;


public str getProjectComplexity(rel[str name,int linesofcode,int cc] units){
	return "--";
}

public int getUnitComplexity(loc unit){
    return 0;
}

public int getNodeComplexity(Statement unit){
    return 0;
}

public str calculateProjectComplexity(rel[str name,int linesofcode,int cc] units, bool debug)
{
 int simple = 0;
 int moderate = 0;
 int high = 0;
 int very_high = 0;
 int project_method_lines_of_code =0;
 
 for(item <- units)
 {
  project_method_lines_of_code = project_method_lines_of_code+item.linesofcode;
  if(item.cc <= 10) simple = simple + item.linesofcode;
  if(item.cc > 10 && item.cc <= 20 ) moderate = moderate + item.linesofcode;
  if(item.cc > 20 && item.cc <= 50 ) high = high + item.linesofcode;
  if(item.cc > 50 ) very_high = very_high + item.linesofcode;
 }
 if(debug){
 println(simple);
 println(moderate);
 println(high);
 println(very_high);
 }
 
real simple_perc = (toReal(simple) / toReal(project_method_lines_of_code)) * 100.0;
real moderate_perc = (toReal(moderate) / toReal(project_method_lines_of_code)) * 100.0;
real high_perc = (toReal(high) / toReal(project_method_lines_of_code)) * 100;
real very_high_perc = (toReal(very_high) / toReal(project_method_lines_of_code)) * 100;
 
 if(debug){
 println(simple_perc);
 println(moderate_perc);
 println(high_perc);
 println(very_high_perc);
 }
 
 if(moderate_perc <= 25 && high_perc == 0 && very_high_perc==0) return "++";
 if(moderate_perc <= 30 && high_perc <= 5 && very_high_perc==0) return "+";
 if(moderate_perc <= 40 && high_perc <= 10 && very_high_perc==0) return "o";
 if(moderate_perc <= 50 && high_perc <= 15 && very_high_perc <= 5) return "-";
 if(moderate_perc <= 40 && high_perc <= 10 && very_high_perc==0) return "o";
 
 
}