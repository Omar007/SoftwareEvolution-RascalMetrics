module metrics::Duplication

import IO;
import String;
import List;
import Set;
import Map;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import helpers::ASTM3Helpers;
import metrics::LOC;


//Doesn't cover duplicate chains of { and }, if not next to executable code.
//Cases such as:
//	}
//	}
//	}
//	}
//	}
//	}
//But this would be false positives anyway imo
public int DuplLOC(M3 model, set[loc] compilationUnits)
{
	map[loc, list[str]] loadedFiles = ();
	map[str, map[loc, list[int]]] occurences = ();
	
	for(cu <- compilationUnits)
	{
		list[str] cuLines = [ line | line <- CodeNoComments(model@documentation[cu], cu), /^\s*$/ !:= line];
		
		if (size(cuLines) < 6)
			continue;
		
		loadedFiles += (cu: cuLines);
		
		list[int] emptyIntList = [];
		int i = 0;
		for(cuLine <- cuLines)
		{
			cuLine = trim(cuLine);
			loadedFiles[cu][i] = cuLine;

			map[loc, list[int]] tmp = occurences[cuLine] ? (cu: emptyIntList);
			tmp[cu] ? emptyIntList += [ i ];
			occurences[cuLine] = tmp;

			i += 1;
		}
	}
	
	occurences -= (s: () | s <- occurences, size(occurences[s]) == 1,
		l <- occurences[s], size(occurences[s][l]) == 1);
	
	
	println("SETUP PHASE COMPLETE! <size(loadedFiles)> files have been loaded.");
	int dupedLines = (0 | it + 1 | s <- occurences, s != "{", s != "}", l <- occurences[s]);
	println("<dupedLines> line/file duplication occurences detected.");
	int dupeCheckLineCount = 0;
	
	
	int duplLineCount = 0;
	
	for(codeLine <- occurences, codeLine != "{", codeLine != "}",
		fileLoc <- occurences[codeLine])
	{
		dupeCheckLineCount += 1;
		println("Checking line/file occurence <dupeCheckLineCount> of <dupedLines>. File = <fileLoc>");
		
		int mySize = size(loadedFiles[fileLoc]);
		
		for(int lineNr <- occurences[codeLine][fileLoc], lineNr in occurences[codeLine][fileLoc],
			other <- occurences[codeLine])
		{
			int otherSize = size(loadedFiles[other]);
			
			for(int otherLineNr <- occurences[codeLine][other], otherLineNr in occurences[codeLine][other],
				(other == fileLoc ? otherLineNr - lineNr >= 6 : true))
			{
				int i = -1;
				int j = 1;
				bool iDone = false;
				bool jDone = false;
				while(!iDone || !jDone)
				{
					if(!iDone && lineNr + i >= 0 && otherLineNr + i >= 0
						&& loadedFiles[fileLoc][lineNr + i] == loadedFiles[other][otherLineNr + i])
					{
						i -= 1;
					}
					else
					{
						iDone = true;
					}
					
					if(!jDone && lineNr + j < mySize && otherLineNr + j < otherSize
						&& loadedFiles[fileLoc][lineNr + j] == loadedFiles[other][otherLineNr + j])
					{
						j += 1;
					}
					else
					{
						jDone = true;
					}
				}
				
				i += 1; //Exclude i itself
				if((j - i) >= 6)
				{
					//Amount of clones
					duplLineCount += (0 | it + 1 | k <- [i..j],
						lineNr + k in occurences[loadedFiles[fileLoc][lineNr + k]][fileLoc]
						|| otherLineNr + k in occurences[loadedFiles[other][otherLineNr + k]][other] );
					
					//occurences[loadedFiles[fileLoc][lineNr + k]][fileLoc] -= [ lineNr + k | k <- [i..j] ];
					//occurences[loadedFiles[other][otherLineNr + k]][other] -= [ otherLineNr + k | k <- [i..j] ];
					
					//If using a 'checked' list instead
					////Amount of clones
					//duplLineCount += (0 | it + 1 | k <- [i..j], lineNr + k notin alreadyChecked[fileLoc]
					//	|| otherLineNr + k notin alreadyChecked[other] );
					//
					//alreadyChecked[fileLoc] += { lineNr + k | k <- [i..j] };
					//alreadyChecked[other] += { otherLineNr + k | k <- [i..j] };
					
					
					for(k <- [i..j])
					{
						bool origIn = loadedFiles[fileLoc][lineNr + k] in occurences
							&& lineNr + k in occurences[loadedFiles[fileLoc][lineNr + k]][fileLoc];
						bool otherIn = loadedFiles[other][otherLineNr + k] in occurences
							&& otherLineNr + k in occurences[loadedFiles[other][otherLineNr + k]][other];
						
						if(origIn)
							occurences[loadedFiles[fileLoc][lineNr + k]][fileLoc] -= [ lineNr + k ];
						
						if(otherIn)
							occurences[loadedFiles[other][otherLineNr + k]][other] -= [ otherLineNr + k ];
						
						//Amount of clones
						if(origIn && otherIn)
							duplLineCount += 1;
						
						//Cloned line count
						//if(origIn && otherIn)
						//	duplLineCount += 2;
						//else if(origIn || otherIn)
						//	duplLineCount += 1;
					}
				}
			}
		}
	}
	
	return duplLineCount;
}
