module cyclomaticComplexity

import List;
import IO;
import String;
import analysis::m3::Core;
import analysis::m3::metrics::LOC;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import util::Math;


public int getProjectComplexity(rel[str name,int linesofcode,int cc] units){
 int simple = 0;
 int moderate = 0;
 int high = 0;
 int very_high = 0;
 int project_method_lines_of_code =0;
 bool debug = false;
 
 
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
 
 if(moderate_perc <= 25 && high_perc == 0 && very_high_perc==0) return 2;
 if(moderate_perc <= 30 && high_perc <= 5 && very_high_perc==0) return 1;
 if(moderate_perc <= 40 && high_perc <= 10 && very_high_perc==0) return 0;
 if(moderate_perc <= 50 && high_perc <= 15 && very_high_perc <= 5) return -1;
 return -2;
}


public int getNodeComplexity(Statement unit){

 ifs = 0;
 elifs =0;
 cases = 0;
 infinite_loops=0;
 while_loops = 0;
 do_while_loops =0;
 fors = 0;
 trys =0;

 bool debug = false;
///println(unit);
 
  visit(unit){
 
     case \if(B,_): ifs= ifs+1;
     case \infix(_,op,_,_) : {if(op == "&&" || op=="||" ) ifs=ifs+1; }
     case \conditional(_,_,_) : {ifs=ifs+1;}
     case \if(_,_,_): elifs= elifs+1;
     case \case(_): cases= cases+1;
   //  case \while(booleanLiteral(true),_): infinite_loops = infinite_loops+1;
     case \while(_,_): while_loops = while_loops+1;
   //  case \do(_,_): do_while_loops = do_while_loops+1;
     case \for(_,_,_,_) : fors = fors+1;
     case \catch(_,_) : trys = trys+1;
    }
  if(debug){  
 	print("Cases: ");
 	println(cases);
 	print("Ifs: ");
 	println(ifs);
 	print("Elifs: ");
 	println(elifs);
 	print("Ininite loops: ");
 	println(infinite_loops);
 	print("while loops: ");
 	println(while_loops);
 	print("Do while loops: ");
 	println(do_while_loops);
 	print("Fors: ");
 	println(fors);
 	print("trys: ");
 	println(trys);
 	print("Complexity: ");
 	println(1+cases+ifs+elifs+while_loops+do_while_loops+fors+trys);
  }
 return 1+cases+ifs+elifs+while_loops+do_while_loops+fors+trys;
}

