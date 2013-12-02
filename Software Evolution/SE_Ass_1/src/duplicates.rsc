module duplicates

import List;
import IO;
import String;
import Set;
import analysis::m3::Core;
import analysis::m3::metrics::LOC;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import util::Math;
import linesOfCode;


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


public int getProjectCodeDuplicates(M3 project_model,int usefull_lines)
{
 map[str,int] m = ();
 set[loc] tmp_files = files(project_model);	
 list[str] lines = [];		
 int i=0;			
 
rel[int origin,int duplicate] dup_list={};
	
 set[int] line_num = {};	
		
 for(tmp_file <- tmp_files)												
 {
    list[str] tmp = getFilteredUnitLines(tmp_file);
    
    for(int j <- [0..(size(tmp))])	
    {
     list[str] sub = [];
     if((j+6) > (size(tmp)-1)) break;
     sub = slice(tmp,j,6);
     str sub_line = toString(sub);
     if(sub_line in m)
     {
      dup_list = dup_list + <m[sub_line],j>;
      line_num = line_num + {N | N <- [m[sub_line]..(m[sub_line]+6)]};
      line_num = line_num + {N | N <- [j..(j+6)]};
     }
     else
     {
      m = m+ (sub_line:j);
     }
    }
   lines = lines + tmp;
 }
 
 real usefull = toReal(usefull_lines);
 real dups = toReal(size(line_num));
 real tot = (dups/usefull) * 100;
 
 if(tot < 3) return 2;
 if(tot >= 3 && tot < 5) return 1;
 if(tot >= 5 && tot < 10) return 0;
 if(tot >= 10 && tot < 20) return -1;
 if(tot >= 20) return -2;
 return -2;
}