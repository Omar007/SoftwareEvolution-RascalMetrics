module Visualization::RenderBox

import vis::Figure;
import vis::Render;

void renderRedBoxBig()
{
	b1 = box(fillColor("red"));
	render(b1);
}

void renderRedBoxSmall()
{
	b2 = box(fillColor("red"), size(100, 50));
	render(b2);
}

void renderRedBox50()
{
	b3 = box(fillColor("red"), shrink(0.5));
	render(b3);
}

void renderRedBoxH50()
{
	b4 = box(fillColor("red"), hshrink(0.5));
	render(b4);
}

void renderNestedBox()
{
	bn1 = box(fillColor("red"), hshrink(0.5));
	bn2 = box(bn1, fillColor("yellow"), size(200,100));
	render(bn2);
}
