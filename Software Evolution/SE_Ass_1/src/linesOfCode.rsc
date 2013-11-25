module linesOfCode

import List;
import IO;
import String;
import analysis::m3::Core;
import analysis::m3::metrics::LOC;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import util::Math;
import linesOfCode;


public int getProjectLinesOfCode(M3 model){
  int total_project_loc=0;
  set[loc] tmp_files = files(model);										// Get all project files as location( loc )
  for(tmp_file <- tmp_files)												// Iterate through all files
  {
   total_project_loc = total_project_loc + getUnitLinesOfCode(tmp_file);	// Read file as one unit and count lines of code
  }
  return total_project_loc;
}

public int getUnitLinesOfCode(loc unit){
   return size(getFilteredUnitLines(unit));									// Count the filtered unit lines
}

public list[str] getFilteredUnitLines(loc unit)
{
 	str unit_line = readFile(unit);											// Read file as one string
	str new_lines = "";
	for( /<item:\".*\">/ := unit_line) {unit_line = replaceFirst(unit_line, item, "");} // Replace all strings with ""
	for( /<item:\/\/.*>/ := unit_line) {unit_line = replaceFirst(unit_line, item, "");}     // Replace all single line comments
	for( /<item:\/\*(?s).*?\*\/>/ := unit_line) {unit_line = replaceFirst(unit_line, item, "");} // Replace all multi line comments // http://ostermiller.org/findcomment.html
	list[str] unit_lines = [];
	unit_lines = unit_lines + [trim(line) | /<line:^.*\S.*$>/ <- split("\n",unit_line )]; // Split the string through \n and trim all non readable characters
	return unit_lines;
}


public int linesOfCodeToMYBF(int linesOfCode)
{
	 if(linesOfCode <= 66000)
	 {
	  return 2;
	 }
	 else if (linesOfCode > 66000 && linesOfCode<=246000)
	 {
	  return 1;
	 }
	 else if(linesOfCode > 246000 && linesOfCode<=665000)
	 {
	  return 0;
	 }
	 else if(linesOfCode > 665000 && linesOfCode<=1310000)
	 {
	  return -1;
	 }
	 else if(effectLinesOfCode > 1310000)
	 {
	  return -2;
	 }
	}
	
		
	
public int getProjectUnitSize(rel[str name,int linesofcode,int cc] units){
 int simple = 0;
 int moderate = 0;
 int high = 0;
 int very_high = 0;
 int project_method_lines_of_code =0;
 bool debug = false;
 
 
 for(item <- units)
 {
  project_method_lines_of_code = project_method_lines_of_code+item.linesofcode;
  if(item.linesofcode <= 10) simple = simple + item.linesofcode;
  if(item.linesofcode > 10 && item.linesofcode <= 20 ) moderate = moderate + item.linesofcode;
  if(item.linesofcode > 20 && item.linesofcode <= 50 ) high = high + item.linesofcode;
  if(item.linesofcode > 50 ) very_high = very_high + item.linesofcode;
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
 
 if(moderate_perc <= 25 && high_perc == 0 && very_high_perc==0) return 2;
 if(moderate_perc <= 30 && high_perc <= 5 && very_high_perc==0) return 1;
 if(moderate_perc <= 40 && high_perc <= 10 && very_high_perc==0) return 0;
 if(moderate_perc <= 50 && high_perc <= 15 && very_high_perc <= 5) return -1;
 return -2;
}