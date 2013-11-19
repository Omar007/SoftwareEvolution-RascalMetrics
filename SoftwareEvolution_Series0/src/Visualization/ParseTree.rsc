module Visualization::ParseTree

import vis::Figure;
import vis::ParseTree;
import vis::Render;
import demo::lang::Exp::Combined::Automatic::Parse;

public void renderParseTree()
{
	render(visParsetree(parse("(1 + 2) * 3")));
}
