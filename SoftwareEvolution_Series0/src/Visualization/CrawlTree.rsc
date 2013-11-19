module Visualization::CrawlTree

import List;
import IO;
import vis::Figure;
import vis::Render;

data CTree = leaf(loc l) | dirNode(loc l, list[CTree] t) | leaf();

//public Figure visCTree(leaf()) = 
//	box(gap(2), fillColor("lightyellow"));

public Figure visCTree(leaf(loc l)) = 
	box(text("<l.file>"), gap(2), fillColor("lightyellow"));

public Figure visCTree(dirNode(loc l, list[CTree] t)) =
	tree(ellipse(text("<l.file>"), gap(2), fillColor("lightblue")), [ visCTree(subTree) | subTree <- t, leaf() !:= subTree ]);

//public default Figure visCTree(CTree t) { throw "<t> forgotten"; }

public CTree crawlTree(loc dir, str suffix)
{
	if(isDirectory(dir))
	{
		//node
		return dirNode(dir, [ crawlTree(e, suffix) | e <- dir.ls ]);
	}
	else if(dir.extension == suffix)
	{
		return leaf(dir);
	}
	
	return leaf();
}

public bool f(list[CTree] args) = (true | it && leaf() := arg | arg <- args);

public void renderCrawlTree1(loc dir, str suffix)
{
	CTree t = crawlTree(dir, suffix);
	t = visit(t)
	{
		case dirNode(_, args) => leaf()
			when f(args)
	};

	render(space(visCTree(t), std(size(30)), std(gap(30))));
	//render(space(visCTree(t), std(size(30)), std(gap(30)), std(manhattan(false))));
}

public loc testLoc = |file:///C:/Eclipse_Workspace/|;
