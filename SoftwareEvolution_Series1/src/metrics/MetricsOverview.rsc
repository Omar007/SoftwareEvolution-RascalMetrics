module metrics::MetricsOverview

import IO;
import String;
import Map;
import DateTime;
import util::FileSystem;
import analysis::m3::Core;
import lang::java::m3::AST;
import helpers::LocationHelpers;
import helpers::ASTM3Helpers;
import metrics::LOC;
import metrics::CC;
import metrics::Duplication;

//:set profiling true

public void RunDefaultMetrics()
{
	MetricsOverview(MetricsTest());
	//MetricsOverview(SmallSQL());
	MetricsOverview(SmallSQL(), SmallSQLTest());
	//MetricsOverview(HyperSQL());
	MetricsOverview(HyperSQL(), HyperSQLTest());
}

public void MetricsOverview(loc projectLoc)
{
	loc resultsFile = ResultsFile();
	datetime startTime = now();
	
	appendToFile(resultsFile, "--------------------\r\n");
	appendToFile(resultsFile, "Metrics for: <projectLoc>\r\n");
	appendToFile(resultsFile, "Start Time: <startTime>\r\n");
	appendToFile(resultsFile, "--------------------\r\n");
	
	M3 model = CalcM3(resultsFile, projectLoc);
	set[Declaration] ast = CalcAST(resultsFile, projectLoc);
	int totalLOC = CalcLOC(resultsFile, model, compilationUnits(model));
	map[loc, int] methodLOCs = CalcMethodLOCs(resultsFile, ast);
	map[loc, int] methodCCs = CalcMethodCCs(resultsFile, ast);
	int duplLOC = CalcDuplLOC(resultsFile, model, compilationUnits(model));
	
	CalcRatings(resultsFile, totalLOC, methodLOCs, methodCCs, duplLOC);
	
	appendToFile(resultsFile, "Total Time:\t\t\t<now() - startTime>\r\n");
	appendToFile(resultsFile, "\r\n");
	appendToFile(resultsFile, "\r\n");
}

public void MetricsOverview(loc projectLoc, loc exclLoc)
{
	loc resultsFile = ResultsFile();
	datetime startTime = now();
	
	appendToFile(resultsFile, "--------------------\r\n");
	appendToFile(resultsFile, "Metrics for: <projectLoc>\r\n");
	appendToFile(resultsFile, "Excluding: <exclLoc>\r\n");
	appendToFile(resultsFile, "Start Time: <startTime>\r\n");
	appendToFile(resultsFile, "--------------------\r\n");
	
	M3 model = CalcM3(resultsFile, projectLoc);
	set[Declaration] ast = CalcAST(resultsFile, projectLoc);
	int totalLOC = CalcLOC(resultsFile, model, { cu | cu <- compilationUnits(model), !contains(cu.path, exclLoc.path) });
	map[loc, int] methodLOCs = CalcMethodLOCs(resultsFile, ast);
	methodLocs = (k: methodLOCs[k] | k <- methodLOCs, !(contains(k.path, exclLoc.path)));
	map[loc, int] methodCCs = CalcMethodCCs(resultsFile, ast);
	methodCCs = (k: methodCCs[k] | k <- methodCCs, !(contains(k.path, exclLoc.path)));
	int duplLOC = CalcDuplLOC(resultsFile, model, { cu | cu <- compilationUnits(model), !(contains(cu.path, exclLoc.path)) });
	
	CalcRatings(resultsFile, totalLOC, methodLOCs, methodCCs, duplLOC);
	
	appendToFile(resultsFile, "Total Time:\t\t\t<now() - startTime>\r\n");
	appendToFile(resultsFile, "\r\n");
	appendToFile(resultsFile, "\r\n");
}

private M3 CalcM3(loc resultsFile, loc projectLoc)
{
	datetime startTime = now();
	M3 model = GetProjectM3(projectLoc);
	appendToFile(resultsFile, "M3 Time:\t\t\t<now() - startTime>\r\n");
	//appendToFile(|project://SoftwareEvolution_Series1/Results/M3.txt|, model);
	
	return model;
}

private set[Declaration] CalcAST(loc resultsFile, loc projectLoc)
{
	datetime startTime = now();
	set[Declaration] ast = GetProjectAST(projectLoc);
	appendToFile(resultsFile, "AST Time:\t\t\t<now() - startTime>\r\n");
	//appendToFile(|project://SoftwareEvolution_Series1/Results/AST.txt|, ast);
	
	return ast;
}

private int CalcLOC(loc resultsFile, M3 model, set[loc] files)
{
	datetime startTime = now();
	map[loc, int] cuLoc = FileLinesOfCode(model, files);
	int totalLOC = (0 | it + cuLoc[location] | location <- cuLoc);
	appendToFile(resultsFile, "LOC Time:\t\t\t<now() - startTime>\r\n");
	
	return totalLOC;
}

//TODO: Filter locations before calculating the LOC
private map[loc, int] CalcMethodLOCs(loc resultsFile, set[Declaration] ast)
{
	datetime startTime = now();
	map[loc, int] methodLOCs = MethodLinesOfCode(ast);
	appendToFile(resultsFile, "Method LOC Time:\t<now() - startTime>\r\n");
	
	return methodLOCs;
}

//TODO: Filter locations before calculating the CC
private map[loc, int] CalcMethodCCs(loc resultsFile, set[Declaration] ast)
{
	datetime startTime = now();
	map[loc, int] methodCCs = MethodCC(ast);
	appendToFile(resultsFile, "Method CC Time:\t\t<now() - startTime>\r\n");
	
	return methodCCs;
}

private int CalcDuplLOC(loc resultsFile, M3 model, set[loc] files)
{
	datetime startTime = now();
	int duplLOC = DuplLOC(model, files);
	appendToFile(resultsFile, "Duplication Time:\t<now() - startTime>\r\n");
	
	return duplLOC;
}

private void CalcRatings(loc resultsFile, int totalLOC, map[loc, int] methodLOCs, map[loc, int] methodCCs, int duplLOC)
{
	datetime startTime = now();
	str locRank = GetLOCRank(totalLOC);
	str ccRank = GetCCRank(methodCCs, methodLOCs, totalLOC);
	str duplRank = GetDuplicationRank(duplLOC, totalLOC);
	appendToFile(resultsFile, "Calc Rating Time:\t<now() - startTime>\r\n");
	
	appendToFile(resultsFile, "Duplicated Lines:\t<duplLOC>\r\n");
	appendToFile(resultsFile, "LOC Rating:\t\t\t<locRank>\r\n");
	appendToFile(resultsFile, "CC Rating:\t\t\t<ccRank>\r\n");
	appendToFile(resultsFile, "Dupl Rating:\t\t<duplRank>\r\n");
}

//++	0-66k
//+		66k-246k
//o		246k-665k
//-		665k-1310k
//--	>1310k
private str GetLOCRank(int totalLoc)
{
	if(totalLoc <= 66000) return "++ (<totalLoc>)";
	else if(totalLoc <= 246000) return "+ (<totalLoc>)";
	else if(totalLoc <= 665000) return "o (<totalLoc>)";
	else if(totalLoc <= 1310) return "- (<totalLoc>)";
	else return "-- (<totalLoc>)";
}





//MethodCC(astModel) MethodLinesOfCode(astModel)
//methodCCs methodLocs
//
//
//
//import analysis::statistics::Descriptive;
//
//median([ methodLocs[method] | method <- methodLocs, methodCCs[method] > 50 ])
//percentile([ methodLocs[method] | method <- methodLocs, methodCCs[method] > 50 ], 50)

//Low Risk			1-10
//Moderate Risk		11-20
//High Risk			21-50
//Very High Risk	> 50
private int GetMethodLOCRisk(int linesOfCode)
{
	if(linesOfCode <= 10) return 0;
	else if(linesOfCode <= 20) return 1;
	else if(linesOfCode <= 50) return 2;
	else return 3;
}

//++	Moderate: <= 25%	High: 0%		Very High: 0%
//+		Moderate: <= 30%	High: <= 5%		Very High: 0%
//o		Moderate: <= 40%	High: <= 10%	Very High: 0%
//-		Moderate: <= 50%	High: <= 15%	Very High: <= 5%
//--	Moderate: > 50%		High: > 15%		Very High: > 5%
private str GetMethodLOCRank(map[loc, int] methodLocs, int totalLoc)
{
	map[int, num] riskLoc = (1: 0, 2: 0, 3: 0);
	
	for(method <- methodLocs)
	{
		int risk = GetMethodLOCRisk(methodLocs[method]);
		
		//We don't care about 'Low' risk.
		if(risk > 0) riskLoc[risk] += methodLocs[method];
	}
	
	//Convert to percentages
	riskLoc = ( risk: ((riskLoc[risk] / totalLoc) * 100.0) | risk <- riskLoc );
	
	if(riskLoc[1] <= 25 && riskLoc[2] <= 0 && riskLoc[3] <= 0) return "++ <riskLoc>";
	else if(riskLoc[1] <= 30 && riskLoc[2] <= 5 && riskLoc[3] <= 0) return "+ <riskLoc>";
	else if(riskLoc[1] <= 40 && riskLoc[2] <= 10 && riskLoc[3] <= 0) return "o <riskLoc>";
	else if(riskLoc[1] <= 50 && riskLoc[2] <= 15 && riskLoc[3] <= 5) return "- <riskLoc>";
	else return "-- <riskLoc>";
}





//Low Risk			1-10
//Moderate Risk		11-20
//High Risk			21-50
//Very High Risk	> 50
private int GetCCRisk(int cc)
{
	if(cc <= 10) return 0;
	else if(cc <= 20) return 1;
	else if(cc <= 50) return 2;
	else return 3;
}

//++	Moderate: <= 25%	High: 0%		Very High: 0%
//+		Moderate: <= 30%	High: <= 5%		Very High: 0%
//o		Moderate: <= 40%	High: <= 10%	Very High: 0%
//-		Moderate: <= 50%	High: <= 15%	Very High: <= 5%
//--	Moderate: > 50%		High: > 15%		Very High: > 5%
private str GetCCRank(map[loc, int] methodCCs, map[loc, int] methodLocs, int totalLoc)
{
	map[int, num] riskLoc = (1: 0, 2: 0, 3: 0);
	
	assert (domain(methodCCs) == domain(methodLocs)) : "Not comparing the same methods: <methodCCs - methodLocs>";
	
	for(method <- methodCCs)
	{
		int ccRisk = GetCCRisk(methodCCs[method]);
		
		//We don't care about 'Low' risk.
		if(ccRisk > 0) riskLoc[ccRisk] += methodLocs[method];
	}
	
	//Convert to percentages
	riskLoc = ( risk: ((riskLoc[risk] / totalLoc) * 100.0) | risk <- riskLoc );
	
	if(riskLoc[1] <= 25 && riskLoc[2] <= 0 && riskLoc[3] <= 0) return "++ <riskLoc>";
	else if(riskLoc[1] <= 30 && riskLoc[2] <= 5 && riskLoc[3] <= 0) return "+ <riskLoc>";
	else if(riskLoc[1] <= 40 && riskLoc[2] <= 10 && riskLoc[3] <= 0) return "o <riskLoc>";
	else if(riskLoc[1] <= 50 && riskLoc[2] <= 15 && riskLoc[3] <= 5) return "- <riskLoc>";
	else return "-- <riskLoc>";
}

//++	0-3%
//+		3-5%
//o		5-10%
//-		10-20%
//--	20-100%
private str GetDuplicationRank(num duplLoc, num totalLoc)
{
	num percentage = (duplLoc / totalLoc) * 100.0;
	
	if(percentage < 3) return "++ (<percentage>%)";
	else if(percentage < 5) return "+ (<percentage>%)";
	else if(percentage < 10) return "o (<percentage>%)";
	else if(percentage < 20) return "- (<percentage>%)";
	else return "-- (<percentage>%)";
}
