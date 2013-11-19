module metrics::CC

import IO;
import String;
import List;
import Set;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import helpers::ASTM3Helpers;


public map[loc, int] MethodCC(set[Declaration] ast)
{
	map[loc, int] ccMethods = ();

	for(decl <- ast)
	{
		visit(decl)
		{
			case Declaration x:
				if(method(_,_,_,_, stmnt) := x || constructor(_, _, _, stmnt) := x)
					ccMethods += (x@decl: GetStatementCount(stmnt));
				else fail;
			case \m:method(_,_,_,_):
				ccMethods += (m@decl: 1);
		}
	}
	
	return ccMethods;
}

private int GetStatementCount(Statement stmnt)
{
	int count = 1;
	
	visit(stmnt)
	{
		case \if(_, _):
			count += 1;
		case \if(_, _, _):
			count += 1;
		case \case(_):
			count += 1;
		case \while(_, _):
			count += 1;
		case \foreach(_, _, _):
			count += 1;
		case \for(_, _, _, _):
			count += 1;
		case \for(_, _, _):
			count += 1;
		case \catch(_, _):
			count += 1;
		case \infix(_, operator, _, _):
			if(operator == "&&" || operator == "||") count += 1;
		case \conditional(_, _, _):
			count += 1;
	}
	
	return count;
}
