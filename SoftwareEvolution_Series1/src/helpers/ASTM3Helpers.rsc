module helpers::ASTM3Helpers

import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

//Project
public set[Declaration] GetProjectAST(loc location) = createAstsFromEclipseProject(location, true);
public M3 GetProjectM3(loc location) = createM3FromEclipseProject(location);

//Directory
public set[Declaration] GetDirAST(loc location) = createAstsFromDirectory(location, true);
public M3 GetDirM3(loc location) = createM3FromDirectory(location);

//File
public Declaration GetFileAST(loc location) = createAstFromFile(location, true);
public M3 GetFileM3(loc location) = createM3FromEclipseFile(location);
