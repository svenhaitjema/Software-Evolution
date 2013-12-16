module graph2

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
import linesOfCode;
import cyclomaticComplexity;

data extends_tree = leaf(tuple[str name,loc source_location,list[tuple[str name,loc source_location, int lines_of_code, int cyclomatic_complexity]] methods] N)
				| child_node(str name,loc source_location,list[tuple[str name,loc source_location, int lines_of_code, int cyclomatic_complexity]] methods,set[extends_tree] children)
				| child_node(str name,loc source_location,list[tuple[str name,loc source_location, int lines_of_code, int cyclomatic_complexity]] methods, extends_tree child);


int number = 0;
Figure g;

public void drawVisual3()
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
   current_methods = current_methods + <name,M@src,getUnitLinesOfCode(M@src),getNodeComplexity(source)>;
  }
 }
 
 if(!isEmpty(current_class.name)) 
 {
 	current_class = <current_class.name,current_class.source_location,current_methods,current_class.parent>;
 	class_list = class_list + current_class;
 }
 //println(node_list);
 //println(subclass_node_list);
 //println(class_list);

set[extends_tree] root_leaves = {leaf(<class.name,class.source_location,class.methods>) | class<-class_list, class.parent=="ROOT"};
set[extends_tree] program_tree = {child_node("ROOT",|tmp:///test|,[], root_leaves) };
list[node] node_list = [];
node_list = [edge("ROOT", class.name) | class<-class_list,class.parent=="ROOT"];

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
  int list_size = 0;
  while(size(class_list_copy) > 0)
  {
  list_size = size(class_list_copy);
  println(list_size);
  if(list_size == old_size)
  {
   println("STOPPING TO PREVENT ENDLESS LOOP");
   break;
  } else old_size = list_size;
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

 set[node] node_set = toSet(node_list);

 // TODO INCLUDE IMPLEMENTS AS ARROWS
 list[Figure] nodes = getGraphNodes(toSet(class_list)+<"ROOT",|tmp:///tmp|,[],"">);
 //FProperty ms = mouseOver(computeFigure(box(text("BLA"),size(100,100)),[size(100,100),resizable(false)])));
g = graph(nodes,toList(node_set), hint("spring"),vsize(1000),hsize(1600), gap(40),resizable(false),layer("A"));
/*
c = false;
void executeTimer(){
	println("DONE");
}
TimerAction timeAction(TimerInfo t){
        if(stopped(_) := t){
		return restart(300);
	} else {
		return noChange();
	}
}
*/
//b1 = computeFigure(Figure (){ return box(text("<number>"),size(50), resizable(false),timer(timeAction,executeTimer)); });
//b2 = computeFigure(bool(){return false;},Figure (){ return g; });
 //render(hcat([b1,b2]));
/// println(g);
 render("global",g);
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
//fillColor(color("blue", 0.7))
Figure n(str nm,loc lc,real lines,int cc,list[tuple[str name,loc source_location, int lines_of_code, int cyclomatic_complexity]] methods) = ellipse(text(" "),id(nm),hgrow(lines*4),vgrow(lines),fillColor(rgb(cc,127,127)),layer("B"),onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
     //  edit(lc);
     render(nm,getDetailedFigure(nm,lc,methods));
     //  println("YES YES");
      //  mouseOver(box(text("TEST"),size(100,100),layer("C")));
      number=10;
      
		return "B";
	}));
	
	
	
public list[Figure] getGraphNodes(set[tuple[str name,loc source_location,list[tuple[str name,loc source_location, int lines_of_code, int cyclomatic_complexity]] methods,str parent]] class_list)
{
  list[Figure] nodes = [];
  for(class<-class_list)
  {
    int lines = 0;
    int cc = 0;
    if(class.name != "ROOT") lines = getUnitLinesOfCode(class.source_location);
    else lines=0;
    for(method <- class.methods)
    {
     if(method.cyclomatic_complexity > cc) cc = 1+ method.cyclomatic_complexity;
    }
    real node_size = 0.5+(toReal(lines)/500);
    int cc_color = cc*20;
   // println(cc_color);
    nodes = nodes + n(class.name,class.source_location,node_size,cc_color,class.methods);
  }
 return nodes;
}


Figure m(str nm,loc lc,real node_size,int cc_color) = ellipse(text(" "),hgrow(node_size*4),vgrow(node_size),resizable(false),fillColor(rgb(cc_color,127,127)),onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
       edit(lc);
      number=10;
      
		return true;
	}));
	

public Figure getDetailedFigure(str name,loc location, list[tuple[str name,loc source_location, int lines_of_code, int cyclomatic_complexity]] methods)
{
 // list[Figure] nodes = [m("ROOT",|tmp:///tmp|)];
 // list[node] node_list =[];
 println(name);
 println(methods);
 list[list[Figure]] grid_display = [];
 list[Figure] method_list=[];
  for(method<-methods)
  {
    
    real node_size = 0.5+(toReal(method.lines_of_code)/500);
    int cc_color = method.cyclomatic_complexity*20;
   Figure left = m(method.name,method.source_location,node_size,cc_color);
   Figure right = text(method.name,resizable(false),height(10));
   grid_display = grid_display + [[left,right]];
  // nodes = nodes + m(method.name,method.source_location);
  // node_list= node_list + edge("ROOT",method.name);
  } 
  
 // set[node] node_set = toSet(node_list);
 // g = graph(nodes,toList(node_set), hint("spring"),vsize(500),hsize(500), gap(40),resizable(false),layer("A"));
// return g;
 // return vcat(method_list,resizable(false));
 return grid(grid_display,resizable(false));
}