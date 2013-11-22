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


public str linesOfCodeToMYBF(int linesOfCode)
{
	 if(linesOfCode <= 66000)
	 {
	  return "++";
	 }
	 else if (linesOfCode > 66000 && linesOfCode<=246000)
	 {
	  return "+";
	 }
	 else if(linesOfCode > 246000 && linesOfCode<=665000)
	 {
	  return "o";
	 }
	 else if(linesOfCode > 665000 && linesOfCode<=1310000)
	 {
	  return "-";
	 }
	 else if(effectLinesOfCode > 1310000)
	 {
	  return "--";
	 }
	}