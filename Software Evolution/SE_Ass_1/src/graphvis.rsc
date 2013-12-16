module graphvis

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

data extends_tree = leaf(tuple[str name,loc source_location,list[tuple[str name,loc source_location, int lines_of_code, int cyclomatic_complexity]] methods] N)
				| child_node(str name,loc source_location,list[tuple[str name,loc source_location, int lines_of_code, int cyclomatic_complexity]] methods,set[extends_tree] children)
				| child_node(str name,loc source_location,list[tuple[str name,loc source_location, int lines_of_code, int cyclomatic_complexity]] methods, extends_tree child);

public void drawVisual2()
{
 loc p = |project://hello|;																			// Get project as loc
 set[Declaration] project_ast = createAstsFromEclipseProject(p, false);									// Create Abstract Syntax Tree
 //println(project_ast);
 //return;
 list[tuple[str name,loc source_location,list[tuple[str name,loc source_location, int lines_of_code, int cyclomatic_complexity]] methods,str parent]] class_list = [];
 list[tuple[str name,loc source_location,list[tuple[str name,loc source_location, int lines_of_code, int cyclomatic_complexity]] methods,str parent]] class_list_copy = [];
//list[tuple[str name,loc source_location,list[tuple[str name,loc source_location, int lines_of_code, int cyclomatic_complexity]] methods,str parent]] subclass_list = [];


list[tuple[str name,loc source_location, int lines_of_code, int cyclomatic_complexity]] current_methods = []; 
tuple[str name,loc source_location,list[tuple[str name,loc source_location, int lines_of_code, int cyclomatic_complexity]] methods,str parent] current_class = <"",|tmp:///tmp|,current_methods,"">;

//data bla = rel[str name,loc source_location];
 
 top-down visit(project_ast)
 {
  case C: class(N,M,O,P): {
 // print(N);
 // print("  :  ");
 // print(O);
 // println("");
 // print("  ");
  //println(M);
  if(!isEmpty(current_class.name))
  {
    //println(current_class.name);
    current_class = <current_class.name,current_class.source_location,current_methods,current_class.parent>;
    class_list = class_list + current_class;
    current_methods = [];
    current_class= <"",|tmp:///tmp|,current_methods,"">;
    
  }
  bool isChild = false;
  visit(M)
  {
   case simpleName(Z): {
   // subclass_list = subclass_list + <N,C @ src,Z>;
    current_class = <N,C @ src,current_methods,Z>;
    isChild=true;
   }
  }
  if(!isChild) current_class = <N,C @ src,current_methods,"ROOT">;
  }
  case M:method(_,name,_,_,source):
  {
   current_methods = current_methods + <name,M@src,10,10>;
  }
 }
 if(!isEmpty(current_class.name)) class_list = class_list + current_class;
 //println(node_list);
 //println(subclass_node_list);
 //println(class_list);

set[extends_tree] root_leaves = {leaf(<class.name,class.source_location,class.methods>) | class<-class_list, class.parent=="ROOT"};
set[extends_tree] program_tree = {child_node("ROOT",|tmp:///test|,[], root_leaves) };
list[node] node_list = [];
node_list = [edge("ROOT", class.name) | class<-class_list,isEmpty(class.parent)];


println(root_leaves);
class_list_copy = [class | class<-class_list, class.parent!="ROOT"];
/*
for(class <-class_list_copy)
{
 print(class.name);
 print(" ");
 print(class.parent);
 print(" ");
 println(class.source_location);
}
println("---------------ROOT LIST----------------------------------------------------");
class_list_copy = [class | class<-class_list, class.parent=="ROOT"];

for(class <-class_list_copy)
{
 print(class.name);
 print(" ");
 print(class.parent);
 print(" ");
 println(class.source_location);
}
*/

//return;
 //
 //println(tmp);
 //return;
 
 //bla = {child_node("root",|tmp:///test|, tmp)};
  
  println("BUILDING NODE CONNECTIONS");
  //class_list_copy = class_list;
  int index = 0;
  int old_size = 0;
  while(size(class_list_copy) > 0)
  {
  println(size(class_list_copy));
  if(size(class_list_copy) == old_size)
  {
   println("STOPPING TO PREVENT ENDLESS LOOP");
   break;
  } else old_size = size(class_list_copy);
  	for(subclass <- class_list_copy)
  		{
  		 program_tree = visit(program_tree)
  				{
  		    			case leaf(tuple[str name,loc source_location,list[tuple[str name,loc source_location, int lines_of_code, int cyclomatic_complexity]] methods] N) : 
  	               		{
                 	 		if(N.name == subclass.parent)
                          	 	{
                          	 		node_list = node_list + edge(N.name,subclass.name);
                          	 		
                          	// 		println(class_list_copy);
                         // 	 		println(subclass.name);
                          	 		class_list_copy = delete(class_list_copy, indexOf(class_list_copy,subclass));
                           insert child_node(N.name,N.source_location,N.methods, {leaf(<subclass.name,subclass.source_location,subclass.methods>)});
                       //   break;		
                           	 	}

      						 } 
      						           
      				case child_node(str name,loc source_location,list[tuple[str name,loc source_location, int lines_of_code, int cyclomatic_complexity]] methods,N) :
                 		{
                 	 		if(name == subclass.parent)
                          	 	{
                          	 	     node_list = node_list + edge(subclass.name,name);
                          	 	     class_list_copy = delete(class_list_copy, indexOf(class_list_copy,subclass));
                                  	 insert child_node(name,source_location,methods, N+leaf(<subclass.name,subclass.source_location,subclass.methods>));
                            //        break;
                           	 	}
                 		}
  				}
   		}
   	}
   	for(class<-class_list_copy)
   	{
   	 println(class);
   	}
   	return;
   //		println(node_list);
   //println(program_tree);
  // return;
   
 set[node] node_set = toSet(node_list);
 ////println(node_set);
 // TODO INCLUDE IMPLEMENTS AS ARROWS
 list[Figure] nodes = getGraphNodes(toSet(class_list)+<"ROOT",|tmp:///tmp|,[],"">);
 print("Node size");
 println(node_set);
 //list[Figure] nodes_sublist = slice(nodes,0,100);
// println(nodes);

/*
 Figure g = box(onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
       println("bla");
		return true;
	}));
 */
 Figure g = graph(nodes,toList(node_set), hint("spring"),size(1000), gap(20),resizable(false),layer("A"));
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
Figure n(str nm,loc lc) = ellipse(text(" "),size(10,5),id(nm),align(0, 0), grow(1.2),fillColor(color("blue", 0.7)),layer("B"),onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
       edit(lc);
		return true;
	}));
	
	
public list[Figure] getGraphNodes(set[tuple[str name,loc source_location,list[tuple[str name,loc source_location, int lines_of_code, int cyclomatic_complexity]] methods,str parent]] class_list)
{
 return [n(class.name,class.source_location) | class <- class_list];
}


public FProperty popup(str S){
 return mouseOver(box(text(S), fillColor("lightyellow"),
 grow(1.2),resizable(false)));
}