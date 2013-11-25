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

/*
public int getProjectCodeDuplicates(M3 project_model)
{
  set[loc] tmp_files = files(project_model);
  list[str] project_lines = [];										
  for(tmp_file <- tmp_files)												
  {
	str unit_line = readFile(tmp_file);														// Read file as one string
	project_lines = project_lines + [trim(line) | /<line:^.*\S.*$>/ <- split("\n",unit_line)];
  }

 list[str] project_lines_duplicate = project_lines;
 
 //println(project_lines);
 
 //for(
 return 1;
}
*/

public int getProjectCodeDuplicates(set[Declaration] ast,int total_project_loc, int usefull_project_loc)
{
 map[int,list[value]] m = ();

 int hashMapSize = toInt(0.1 * toReal(total_project_loc));
 int duplicate_lines = 0;

 top-down visit(ast)
 {
  case method(_,B,_,_,source): { 
    int index = (getUnitTextLength(source @ src,false)%hashMapSize);
  	if(index in m){
  		if(source in m[index])
  		{
  		  int line_count = size(getFilteredUnitLines(source @ src));
  			if( line_count>= 6)
  			{
  			 duplicate_lines = duplicate_lines+ line_count;
  			}
  		}
  	 }
  	m = m + ( (getUnitTextLength(source @ src,false)%hashMapSize):[source]);
  }
 }
 println("DUPLICATES");
 println(duplicate_lines);
  real comp=0.0;
   if(duplicate_lines > 0)
 { 
  comp = (toReal(duplicate_lines)/toReal(usefull_project_loc)) * 100;
 }
 if(comp >= 0 && comp < 3) return 2;
 if(comp >= 3 && comp < 5) return 1;
 if(comp >= 5 && comp < 10) return 0;
 if(comp >= 10 && comp < 20) return -1;
 if(comp >= 20 && comp <= 100) return -2;
 return -2;
}

public int getUnitTextLength(loc unit,bool debug)
{
	int length=0;
	str unit_line = readFile(unit);
	list[str] unit_lines = split("\n", unit_line );
	for(line <- unit_lines)
	{
		length = length + size(line);
	}
	return length;
}

