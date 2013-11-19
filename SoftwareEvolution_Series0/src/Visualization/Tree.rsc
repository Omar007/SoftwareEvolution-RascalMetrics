module Visualization::Tree

import vis::Figure;
import vis::Render;
import Common::ColoredTree;

public Figure visColoredTree(leaf(int N)) = 
	box(text("<N>"), gap(2), fillColor("lightyellow"));

public Figure visColoredTree(red(ColoredTree left, ColoredTree right)) = 
	visNode("red", left, right);

public Figure visColoredTree(black(ColoredTree left, ColoredTree right)) = 
	visNode("black", left, right);

public Figure visColoredTree(green(ColoredTree left, ColoredTree right)) = 
	visNode("green", left, right);

public Figure visNode(str color, ColoredTree left, ColoredTree right) = 
	tree(ellipse(fillColor(color)), [visColoredTree(left), visColoredTree(right)]);

public ColoredTree rgb = red(black(leaf(1), red(leaf(2),leaf(3))), green(leaf(3), leaf(4)));


void renderTree1()
{
	render(space(visColoredTree(rgb), std(size(30)), std(gap(30))));
}

void renderTree2()
{
	render(space(visColoredTree(rgb), std(size(30)), std(gap(30)), std(manhattan(false))));
}

void renderTreeSide1()
{
	render(space(visColoredTree(rgb), std(size(30)), std(gap(30)), std(orientation(leftRight()))));
}

void renderTreeSide2()
{
	render(space(visColoredTree(rgb), std(size(30)), std(gap(30)), std(orientation(leftRight())), std(manhattan(false))));
}
