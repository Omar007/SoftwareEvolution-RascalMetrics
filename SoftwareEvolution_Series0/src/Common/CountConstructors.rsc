module Common::CountConstructors

import Node;
import Map;
import Common::ColoredTree;

// Define a Card data type.
data Suite = hearts() | diamonds() | clubs() | spades();

data Card =  two(Suite s) | three(Suite s) | four(Suite s) | five(Suite s) |
             six(Suite s) | seven(Suite s) | eight(Suite s) | nine(Suite s) | ten(Suite s) |
             jack(Suite s) | queen(Suite s) | king(Suite s) | ace(Suite s);
             
data Hand = hand(list[Card] cards);

public Hand H = hand([two(hearts()), jack(diamonds()), six(hearts()), ace(spades())]);

// Count frequencies of constructors
public map[str,int] count(node N)
{
	freq = ();
	visit(N)
	{
		case node M:
			{
				name = getName(M);
				freq[name] ? 0 += 1;
			}
	}
	return freq;
}

public map[str,int] countRelevant(node N, set[str] relevant) = domainR(count(N), relevant);
