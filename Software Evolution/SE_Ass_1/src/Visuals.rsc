module Visuals

import vis::Figure;
import ParseTree;
import vis::Render;
import List;
import Type;
import IO;
import Set;
import String;
import Relation;
import analysis::m3::Core;
import analysis::m3::metrics::LOC;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import util::Math;
import Node;


data extends_tree = leaf(tuple[str name,loc source_location] N)
				| child_node(str name,loc source_location,set[extends_tree] children)
				| child_node(str name,loc source_location, extends_tree child);

public void drawVisual()
{
 loc p = |project://hello|;																				// Get project as loc
 set[Declaration] project_ast = createAstsFromEclipseProject(p, false);									// Create Abstract Syntax Tree
 M3 project_model = createM3FromEclipseProject(|project://hello|);										// Create M3 Model from prject
 
 
//println(project_ast);
 
list[tuple[str name,loc source_location,str parent]] class_list = [];
list[tuple[str name,loc source_location,str parent]] subclass_list = [];
//data bla = rel[str name,loc source_location];
 
 top-down visit(project_ast)
 {
  case C: class(N,M,O,P): {
  bool isChild = false;
  visit(M)
  {
   case simpleName(Z): {
    subclass_list = subclass_list + <N,C @ src,Z>;
    isChild=true;
   }
  }
  if(!isChild) class_list = class_list + <N,C @ src,"">;
  }
 }
 
 //println(node_list);
 //println(subclass_node_list);
 
set[extends_tree] bla = {};
set[extends_tree] tmp = {};

 for(class <- class_list)
 {
  tmp = tmp+leaf(<class.name,class.source_location>);
 }
 
 bla = {child_node("root",|tmp:///test|, tmp)};
 
  int index = 0;
  
  
  	for(subclass <- subclass_list)
  		{
  			bla = visit(bla)
  				{
  					case leaf(tuple[str name,loc source_location] N) : 
  	               		{
                 	 		if(N.name == subclass.parent)
                          	 	{
                                  	insert child_node(N.name,N.source_location, {leaf(<subclass.name,subclass.source_location>)});
                           	 	}

      						 } 
      						           
      				case child_node(str name,loc source_location,N) :
                 		{
                 	 		if(name == subclass.parent)
                          	 	{
                                  	 insert child_node(name,source_location, N+leaf(<subclass.name,subclass.source_location>));
                           	 	}
                 		}
  				}
   		}
 
 
 println(bla);
 render(drawChild_node(getOneFrom(bla),0,0));
/*
t1 = tree(box(fillColor("green")),
          [ box(fillColor("red")),
     	    box(fillColor("blue"))
     	  ],
          std(size(50)), std(gap(20))
    	);
render(t1);
*/
}


 Color mapColor1(num avg, num uAvg) = uAvg < avg ? color("red") : color("green");

public Figure drawLeaf(leaf(tuple[str name,loc source_location] N), int totalClasses, int lines_of_code){
 c = mapColor1(50, 60);
 print("leaf");
 return box(text(N.name), size(50, 50), resizable(false), fillColor(c));
}



public Figure drawChild_node(extends_tree NT, int totalClasses, int lines_of_code){

try{
println(NT.name);
}
catch:
{
 return drawLeaf(NT,0,0);
}
if(startsWith(toString(NT),"leaf")) {
 return tree(box(text(name), fillColor("red")), 
  {drawLeaf(NT,0,0)},
   std(gap(20)));
}
else
{
   return tree(box(text(NT.name), fillColor("red")), 
    [drawChild_node(d,0,0) | d <- NT.children],
    std(gap(20)));
}
/*
 if(leaf(_,_) := N)
 {
  
 }
 else
 {
  println("LOL");
 }

*/
/*
if(size(N) >= 2)
{
 return tree(box(text(name), fillColor("grey")), 
 {drawChild_node(d,0,0) | d <- N,true},
 std(gap(20)));
}
else
{
 return tree(box(text(name), fillColor("grey")), 
 drawLeaf(N,0,0), 
 std(gap(20)));
 }
 */
}





public Figure classRepresentation(str name)
{
println(name);
 return box(text(name));
}