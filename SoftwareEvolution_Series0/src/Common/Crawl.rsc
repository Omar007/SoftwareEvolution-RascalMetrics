module Common::Crawl

import IO;
import String;

public list[loc] crawl1(loc dir, str suffix)
{
	res = [];
	for(str entry <- listEntries(dir))
	{
		loc sub = dir + entry;
		if(isDirectory(sub))
		{
			res += crawl1(sub, suffix);
		}
		else
		{
			if(endsWith(entry, suffix))
			{ 
				res += [sub];
			}
		}
	};
	return res;
}

//DEAD!
public list[loc] crawl2(loc dir, str suffix)
{
	return
		for(str entry <- listEntries(dir))
		{
			loc sub = dir + entry;
			if(isDirectory(sub))
			{
				append *[*crawl(sub, suffix)];
			}
			else
			{
				if(endsWith(entry, suffix))
				{
					append sub;
				}
			}
		};
}

public list[loc] crawl3(loc dir, str suffix) = isDirectory(dir)
	? [*crawl3(e, suffix) | e <- dir.ls]
	: (dir.extension == suffix ? [dir] : []);


//crawl2(|file:///C:/Eclipse_Workspace/|, ".rsc")