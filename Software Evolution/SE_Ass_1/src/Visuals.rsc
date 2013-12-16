module Visuals

import vis::Figure;
import ParseTree;
import vis::Render;
import List;
import Type;
import IO;
import Loc;
import Set;
import String;
import Relation;
import analysis::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import util::Math;
import Node;
import vis::KeySym;
import util::Editors;


data extends_tree = leaf(tuple[str name,loc source_location] N)
				| child_node(str name,loc source_location,set[extends_tree] children)
				| child_node(str name,loc source_location, extends_tree child);

public void drawVisual()
{
 loc p = |project://smallsql0.21_src|;																			// Get project as loc
 set[Declaration] project_ast = createAstsFromEclipseProject(p, false);									// Create Abstract Syntax Tree
// M3 project_model = createM3FromEclipseProject(|project://hello|);										// Create M3 Model from prject
//println(project_ast);
 
list[tuple[str name,loc source_location,str parent]] class_list = [];
list[tuple[str name,loc source_location,str parent]] subclass_list = [];

list[tuple[str name,loc source_location, int lines_of_code, int cyclomatic_complexity]] test_lb = []; 
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
  case M:method(_,name,_,_,source):
  {
   println(name);
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
  
  list[node] node_list = [];
  node_list = [edge("ROOT", class.name) | class<-class_list];
  	for(subclass <- subclass_list)
  		{
  			bla = visit(bla)
  				{
  					case leaf(tuple[str name,loc source_location] N) : 
  	               		{
                 	 		if(N.name == subclass.parent)
                          	 	{
                          	 		node_list = node_list + edge(N.name,subclass.name);
                                  	insert child_node(N.name,N.source_location, {leaf(<subclass.name,subclass.source_location>)});		
                           	 	}

      						 } 
      						           
      				case child_node(str name,loc source_location,N) :
                 		{
                 	 		if(name == subclass.parent)
                          	 	{
                          	 	     node_list = node_list + edge(subclass.name,name);
                                  	 insert child_node(name,source_location, N+leaf(<subclass.name,subclass.source_location>));
                                    
                           	 	}
                 		}
  				}
   		}
   //		println(node_list);
 set[node] node_set = toSet(node_list);
 ////println(node_set);
 // TODO INCLUDE IMPLEMENTS AS ARROWS
 list[Figure] nodes = getGraphNodes(toSet(class_list)+toSet(subclass_list)+<"ROOT",toLocation("none"),"">);
 print("Node size");
 println(size(nodes));
 //list[Figure] nodes_sublist = slice(nodes,0,100);
// println(nodes);

/*
 Figure g = box(onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
       println("bla");
		return true;
	}));
 */
 Figure g = graph(nodes,toList(node_set), hint("spring"),size(1000), gap(20),resizable(false));
 //hcat(toList(node_set), hint("spring"),size(1000), gap(20),resizable(false));
 println(g);
 render(g);
 //println(bla);
 //render(drawChild_node(getOneFrom(bla),0,0));
}


 Color mapColor1(num avg, num uAvg) = uAvg < avg ? color("red") : color("green");
 int font_size = 20;

public Figure drawLeaf(leaf(tuple[str name,loc source_location] N), int totalClasses, int lines_of_code){
 c = mapColor1(50, 60);
 print("leaf");
 return ellipse(text(N.name,fontSize(font_size)), size(size(chars(N.name))*font_size, 50), resizable(false), fillColor("blue"));
}



public Figure drawChild_node(extends_tree NT, int totalClasses, int lines_of_code){

try{
println(NT.name);
}
catch:
{
 return drawLeaf(NT,0,0);
}

   return tree(ellipse(text(NT.name,fontSize(font_size)), fillColor("yellow"),resizable(false),size(size(chars(NT.name))*font_size,50)), 
    [drawChild_node(d,0,0) | d <- NT.children],
    std(gap(20)));
}


int s = 0;
Figure n(str nm,loc lc) = ellipse(text(" "),size(10,5),id(nm),align(0, 0), grow(1.2),fillColor(color("blue", 0.7)),onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
       edit(lc);
		return true;
	}));
	
	
public list[Figure] getGraphNodes(set[tuple[str name,loc source_location,str parent]] class_list)
{
 return [n(class.name,class.source_location) | class <- class_list];
}


public FProperty popup(str S){
 return mouseOver(box(text(S), fillColor("lightyellow"),
 grow(1.2),resizable(false)));
}