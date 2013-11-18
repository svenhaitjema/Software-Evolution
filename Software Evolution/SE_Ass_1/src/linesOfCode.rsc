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
  return 1;
}

public int getUnitLinesOfCode(){
  return 1;
}


public str getLinesOfCodeToMYBF(int line_count)
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