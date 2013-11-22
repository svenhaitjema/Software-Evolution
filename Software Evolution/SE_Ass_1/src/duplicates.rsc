module duplicates

import List;
import IO;
import String;
import analysis::m3::Core;
import analysis::m3::metrics::LOC;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import util::Math;
import linesOfCode;


public real getProjectCodeDuplicates(M3 project_model)
{
  set[loc] tmp_files = files(project_model);
  list[str] project_lines = [];										
  for(tmp_file <- tmp_files)												
  {
	str unit_line = readFile(tmp_file);														// Read file as one string
	project_lines = project_lines + [trim(line) | /<line:^.*\S.*$>/ <- split("\n",unit_line)];
  }

 list[str] project_lines_duplicate = project_lines;
 
 println(project_lines);
 
 //for(
 return 1.0;
}