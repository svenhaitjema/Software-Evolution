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