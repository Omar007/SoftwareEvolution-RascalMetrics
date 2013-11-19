module Basic::Quine

import IO;
import String;

public void quine()
{
	println(program);
	println("\"" + escape(program, ("\"" : "\\\"", "\\" : "\\\\")) + "\";");
}

str program = "module Quine

import IO;
import String;

public void quine()
{
	println(program);
	println(\"\\\"\" + escape(program, (\"\\\"\" : \"\\\\\\\"\", \"\\\\\" : \"\\\\\\\\\")) + \"\\\";\");
}

str program =";
