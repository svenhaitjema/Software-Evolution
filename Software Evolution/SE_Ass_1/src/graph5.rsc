module graph5

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

tuple[str name,loc location, list[tuple[str name,loc source_location, int lines_of_code, int cyclomatic_complexity]] methods] selected_class= <"",|tmp:///tmp|,[]>;

loc glob_loc;

public void draw_detailled_view(str name,loc location, list[tuple[str name,loc source_location, int lines_of_code, int cyclomatic_complexity]] methods)
{
  selected_class = <name,location,methods>;
  draw_detailled_view(location);
}


public void draw_detailled_view(loc location)
{
glob_loc = location;
  render(selected_class.name,computeFigure(Figure(){return get_screen_cat(glob_loc);}));
}

public Figure get_screen_cat(loc location)
{
 Figure class_name = text("Selected Class: "+ selected_class.name,height(20),fontSize(14),resizable(false),left());
 //Figure back_button = button("Back",draw_detailled_view(selected_class.name),resizable(false),width(100),height(20));
   Figure edit_button = box(text("Edit"),right(),width(100),height(10),resizable(false),onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
       edit(location); 
		return true;
	}));
  Figure back_button = box(text("Back"),right(),width(100),height(10),resizable(false),onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
       draw_detailled_view(selected_class.location); 
		return true;
	}));
 Figure top_bar = hcat([class_name,edit_button,back_button]);
 return vcat([top_bar,hcat([get_method_list(),get_text_field(location)])]);
}


public Figure get_text_field(loc location)
{
 str lines = readFile(location);
 return scrollable(box(text(lines,left(),top())),left(),width(500),height(500));
}

public Figure get_method_list()
{
 list[Figure] method_list = [];
 method_list = method_list + text("Methods",top(),left(), fontSize(14), fontColor("blue"));
 for(method <- selected_class.methods)
 {
  method_list = method_list + get_method_box(method.name,method.source_location,method.lines_of_code,method.cyclomatic_complexity);
 }
// return vcat(method_list,resizable(false),top(),left());
 return scrollable(vcat(method_list,resizable(false),top(),left()),left(),top(),width(200),resizable(false),height(500));
}

Figure method_box(str nm,loc lc,int node_size,int cc_color) = box(text(nm),top(),left(),resizable(false),width(100),height(10),onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
      // draw_detailled_view(lc); 
      glob_loc = lc;
		return true;
	}));

	
	public Figure get_method_box(str nm,loc lc,int node_size,int cc_color)
	{
	 Figure texta = text(nm,top(),left(),resizable(false),width(100),height(10));
	 
	 real real_node_size = 0.5+(toReal(node_size)/500);
     cc_color = cc_color*20;
	 
	 Figure meta2 = ellipse(text(" "),hgrow(real_node_size*4),vgrow(real_node_size),resizable(false),fillColor(rgb(cc_color,127,127)));
	 return hcat([meta2,texta],onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
      // draw_detailled_view(lc); 
      glob_loc = lc;
		return true;
	}));
	}
