module unitTest

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



public int getUnitTestCount(M3 project_model)
{
  int asserts = 0;
  set[loc] tmp_files = files(project_model);										
  for(tmp_file <- tmp_files)												
  {
   list[str] lines =  getFilteredUnitLines(tmp_file);
   for(line <- lines)
   {
    if(/assertArrayEquals/ := line) asserts = asserts+1;
    if(/assertEquals/ := line) asserts = asserts+1;
    if(/assertFalse/ := line) asserts = asserts+1;
    if(/assertNotNull/ := line) asserts = asserts+1;
    if(/assertNotSame/ := line) asserts = asserts+1;
    if(/assertNull/ := line) asserts = asserts+1;
    if(/assertSame/ := line) asserts = asserts+1;
    if(/assertTrue/ := line) asserts = asserts+1;
   }
  }

 return asserts;
}