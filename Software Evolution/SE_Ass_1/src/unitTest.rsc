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

/*
 Rationale:
 
 The number is too low, reason: 
 
 The used application has abstracted testfunctions 
*/

public int getUnitTestCount(M3 project_model)
{
  int asserts = 0;
  set[loc] tmp_files = files(project_model);										
  for(tmp_file <- tmp_files)												
  {
   list[str] lines =  getFilteredUnitLines(tmp_file);
   for(line <- lines)
   {
    for(/<word: assertArrayEquals>/ := line) {asserts = asserts+1;}
    for(/<word:assertEquals>/ := line) {asserts = asserts+1;}
    for(/<word:assertFalse>/ := line) {asserts = asserts+1;}
    for(/<word:assertNotNull>/ := line) {asserts = asserts+1;}
    for(/<word:assertNotSame>/ := line) {asserts = asserts+1;}
    for(/<word:assertNull>/ := line) {asserts = asserts+1;}
    for(/<word:assertSame>/ := line) {asserts = asserts+1;}
    for(/<word:assertTrue>/ := line) {asserts = asserts+1;}
   }
  }

 return asserts;
}