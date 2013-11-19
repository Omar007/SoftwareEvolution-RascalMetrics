module metrics::LOC

import IO;
import String;
import List;
import Set;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import helpers::ASTM3Helpers;


@memo public set[loc] compilationUnits(M3 m) = {e | e <- m@declarations<name>, isCompilationUnit(e)};


public list[str] CodeNoComments(set[loc] comments, loc unit)
{
	list[str] code = readFileLines(unit);
	bool isWholeFile = (unit.top == unit);
	
	for(comment <- comments)
	{
		tuple[int line, int column] cStart = comment.begin;
		tuple[int line, int column] cEnd = comment.end;
		
		if(!isWholeFile) //Specific file section; need to match up comment loc with the supplied loc
		{
			cStart.line -= unit.begin.line;
			cEnd.line -= unit.begin.line;
			int unitSize = size(code);
			
			if((cStart.line < 0 && cEnd.line < 0)
				|| (cStart.line >= unitSize && cEnd.line >= unitSize))
				continue;
			else if(cStart.line < 0 && cEnd.line > 0)
				cStart = <0, 0>;
			else if(cStart.line > 0 && cEnd.line < 0)
				cEnd = unit.end;
			else if(cStart.line == 0 && cStart.column == unit.begin.column)
			{
				if(cEnd.line == 0) cEnd.column -= cStart.column;
				cStart.column = 0;
			}
		}
		else
		{
			//File line count and list indices are off by 1. Fix here.
			cStart.line -= 1;
			cEnd.line -= 1;
		}
		
		str newLine = code[cStart.line][0..cStart.column];
		
		if(cStart.line == cEnd.line)
		{
			newLine += ("" | it + " " | col <- [cStart.column..cEnd.column]);
		}
		else
		{
			code[cStart.line] = newLine + ("" | it + " " | col <- [cStart.column..size(code[cStart.line])]);
			
			for(line <- [cStart.line + 1..cEnd.line])
				code[line] = "";
			
			newLine = ("" | it + " " | col <- [0..cEnd.column]);
		}
		
		code[cEnd.line] = newLine;
		
		int lineEnd = size(code[cEnd.line]);
		if(cEnd.column < lineEnd)
			code[cEnd.line] += code[cEnd.line][cEnd.column..lineEnd];
	}
	
	return code;
}

public map[loc, int] FileLinesOfCode(M3 model, set[loc] files) =
	(file: (0 | it + 1 | line <- CodeNoComments(model@documentation[file], file), /^\s*$/ !:= line) | file <- files);

public map[loc, int] MethodLinesOfCode(set[Declaration] ast)
{
	map[loc, int] linesOfCode = ();
	
	map[loc, list[str]] fileCode = ();
	
	for(decl <- ast)
	{
		visit(decl)
		{
			case \m:method(_,_,_,_):
				{
					if(m@src.top notin fileCode)
						fileCode += (m@src.top: CodeNoComments({ comment.comments | comment <- GetFileM3(m@src)@documentation }, m@src.top));
					linesOfCode[m@decl] ? 0 += (0 | it + 1 | line <- fileCode[m@src.top][m@src.begin.line-1..m@src.end.line], /^\s*$/ !:= line);
				}
			case \m:method(_,_,_,_,_):
				{
					if(m@src.top notin fileCode)
						fileCode += (m@src.top: CodeNoComments({ comment.comments | comment <- GetFileM3(m@src)@documentation }, m@src.top));
					linesOfCode[m@decl] ? 0 += (0 | it + 1 | line <- fileCode[m@src.top][m@src.begin.line-1..m@src.end.line], /^\s*$/ !:= line);
				}
			case \m:constructor(_,_,_,_):
				{
					if(m@src.top notin fileCode)
						fileCode += (m@src.top: CodeNoComments({ comment.comments | comment <- GetFileM3(m@src)@documentation }, m@src.top));
					linesOfCode[m@decl] ? 0 += (0 | it + 1 | line <- fileCode[m@src.top][m@src.begin.line-1..m@src.end.line], /^\s*$/ !:= line);
				}
		}
	}
	
	return linesOfCode;
}
