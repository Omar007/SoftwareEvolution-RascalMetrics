module Visualization::Ellipses

import vis::Figure;
import vis::Render;

void renderEllipse()
{
	e = ellipse(size(200, 100), shrink(0.8));
	render(e);
}

void renderEllipseDotted()
{
	e = ellipse(size(200, 100), shrink(0.8), lineStyle("dot"));
	render(e);
}

void renderEllipseThick()
{
	e = ellipse(size(200, 100), shrink(0.8), lineWidth(5));
	render(e);
}

void renderEllipseBlue()
{
	e = ellipse(size(200, 100), shrink(0.8), lineColor("blue"));
	render(e);
}

void renderEllipseFillYellow()
{
	e = ellipse(size(200, 100), shrink(0.8), fillColor("yellow"));
	render(e);
}

void renderEllipseShadow()
{
	e = ellipse(size(200, 100), shrink(0.8), shadow(true));
	render(e);
}

void renderEllipseDarkShadow()
{
	e = ellipse(size(200, 100), shrink(0.8), shadow(true), shadowColor("grey"));
	render(e);
}

void renderEllipseDottedBlueFillYellowShadow()
{
	e = ellipse(size(200,100), shrink(0.8), lineStyle("dot"), lineWidth(5), lineColor("blue"), fillColor("yellow"), shadow(true), shadowColor("grey"));
	render(e);
}
