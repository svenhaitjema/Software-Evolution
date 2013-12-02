module Visuals

import vis::Figure;
import ParseTree;
import vis::Render;
import List;
import IO;
import String;
import Relation;
import analysis::m3::Core;
import analysis::m3::metrics::LOC;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import util::Math;
import Node;


data extends_tree = leaf(rel[str name,loc source_location] N)
				| child_node(str name,set[extends_tree] children);

public void drawVisual()
{
 loc p = |project://hello|;																				// Get project as loc
 set[Declaration] project_ast = createAstsFromEclipseProject(p, false);									// Create Abstract Syntax Tree
 M3 project_model = createM3FromEclipseProject(|project://hello|);										// Create M3 Model from prject
 
 
//println(project_ast);
 
rel[str name,loc source_location,str parent] class_list = {};
rel[str name,loc source_location,str parent] subclass_list = {};
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
 for(class <- class_list)
 {
  bla = bla+leaf({<class.name,class.source_location>});
 }
 
 int index = 0;
  	for(subclass <- subclass_list)
  		{
  		    index=index+1;
  			bla = visit(bla)
  				{
  					case leaf(rel[str name,loc source_location] N) : 
  						{
  						println(toString(N.name));
  						println(subclass.parent);
  	 			 			if(N.name == {subclass.parent})
  	 			 			{
  	 			 			 insert child_node(N.name, {<subclass.name,subclass.source_location>});
  	 			 			}
  						} 
  				}
 		}
 
 
 println(bla);
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


public Figure classRepresentation(str name)
{
println(name);
 return box(text(name));
}