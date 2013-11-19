module Tutor

import Map;
import Set;
import Number;
import String;

public bool isReplicated(list[str] words)
{
	return [*L1, L1] := words;
}
//isReplicated(["a", "b", "a", "b"]);


public list[str] text1 = ["An", "honest", "man", "is", "always", "a", "child"]; 
public list[str] find(list[str] text, str contains) = [ s | s <- text, /.*<contains>.*/ := s ];
//find(text1, "n") == ["An", "honest", "man"];


public map[str,int] inventory = ("orange" : 20, "apple" : 15, "banana" : 25, "lemon" : 15);
public set[str] lowest(map[str,int] inv)
{
	m = min({ inv[s] | s <- inv }); // Determine the minimal value in the map
	return { s | s <- inv, inv[s] == m };
}
//lowest(inventory) == {"apple", "lemon"};


public list[str] text2 = ["Quote", "from", "Steve", "Jobs", ":", "And", "one", "more", "thing"];
public list[str] largest(list[str] text)
{
	mx = ( 0 | max(it, size(s)) | s <- text );
	return for(s <- text)
		if(size(s) == mx)
			append s;
}
//largest(text2) == ["Quote", "Steve", "thing"];


data ColoredTree = leaf(int N)      
	| red(ColoredTree left, ColoredTree right) 
	| black(ColoredTree left, ColoredTree right);

ColoredTree rb = red(black(leaf(1), red(leaf(2),leaf(3))), black(leaf(3), leaf(4)));

public ColoredTree flipRedChildren(ColoredTree t)
{
	return visit(t)
	{
		case red(l,r) => red(r,l)
	};
}
//flipRedChildren(rb) == red( black(leaf(3), leaf(4)), black(leaf(1), red(leaf(3),leaf(2))));


public list[str] text3 = ["the", "jaws", "that", "bite", "the", "claws", "that", "catch"];
public list[str] duplicates(list[str] text)
{
	m = {};
    return for(s <- text)
		if(s in m)
			append s;
		else
			m += s;
}
//duplicates(text3) == ["the", "that"];

