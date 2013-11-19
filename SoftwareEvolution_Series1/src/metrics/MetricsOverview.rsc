module metrics::MetricsOverview

import IO;
import String;
import List;
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
	methodLOCs = (k: methodLOCs[k] | k <- methodLOCs, !(contains(k.path, exclLoc.path)));
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
	map[loc, int] cuLOC = FileLinesOfCode(model, files);
	int totalLOC = (0 | it + cuLOC[location] | location <- cuLOC);
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
	str mlocRank = GetMethodLOCRank(methodLOCs, totalLOC);
	str duplRank = GetDuplicationRank(duplLOC, totalLOC);
	
	appendToFile(resultsFile, "Calc Rating Time:\t<now() - startTime>\r\n");
	appendToFile(resultsFile, "Duplicated Lines:\t<duplLOC>\r\n");
	appendToFile(resultsFile, "\r\n");
	appendToFile(resultsFile, "LOC Rating:\t\t\t<locRank>\r\n");
	appendToFile(resultsFile, "CC Rating:\t\t\t<ccRank>\r\n");
	appendToFile(resultsFile, "mLOC Rating:\t\t<mlocRank>\r\n");
	appendToFile(resultsFile, "Dupl Rating:\t\t<duplRank>\r\n");
}

//++	0-66k
//+		66k-246k
//o		246k-665k
//-		665k-1310k
//--	>1310k
private str GetLOCRank(int totalLOC)
{
	if(totalLOC <= 66000) return "++ (<totalLOC>)";
	else if(totalLOC <= 246000) return "+ (<totalLOC>)";
	else if(totalLOC <= 665000) return "o (<totalLOC>)";
	else if(totalLOC <= 1310) return "- (<totalLOC>)";
	else return "-- (<totalLOC>)";
}

//Low Risk			0-10
//Moderate Risk		11-40
//High Risk			41-100
//Very High Risk	> 100
private int GetMethodLOCRisk(int linesOfCode)
{
	if(linesOfCode <= 10) return 0;
	else if(linesOfCode <= 40) return 1;
	else if(linesOfCode <= 100) return 2;
	else return 3;
}

//++	Moderate: <= 25%	High: 0%		Very High: 0%
//+		Moderate: <= 30%	High: <= 5%		Very High: 0%
//o		Moderate: <= 40%	High: <= 10%	Very High: 0%
//-		Moderate: <= 50%	High: <= 15%	Very High: <= 5%
//--	Moderate: > 50%		High: > 15%		Very High: > 5%
private str GetMethodLOCRank(map[loc, int] methodLOCs, int totalLOC)
{
	map[int, num] riskLOC = (1: 0, 2: 0, 3: 0);
	
	for(method <- methodLOCs)
	{
		int risk = GetMethodLOCRisk(methodLOCs[method]);
		
		//We don't care about 'Low' risk.
		if(risk > 0) riskLOC[risk] += methodLOCs[method];
	}
	
	//Convert to percentages
	riskLOC = ( risk: ((riskLOC[risk] / totalLOC) * 100.0) | risk <- riskLOC );
	
	if(riskLOC[1] <= 30 && riskLOC[2] <= 10 && riskLOC[3] <= 0) return "++ <riskLOC>";
	else if(riskLOC[1] <= 40 && riskLOC[2] <= 15 && riskLOC[3] <= 5) return "+ <riskLOC>";
	else if(riskLOC[1] <= 50 && riskLOC[2] <= 20 && riskLOC[3] <= 10) return "o <riskLOC>";
	else if(riskLOC[1] <= 60 && riskLOC[2] <= 25 && riskLOC[3] <= 15) return "- <riskLOC>";
	else return "-- <riskLOC>";
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
private str GetCCRank(map[loc, int] methodCCs, map[loc, int] methodLOCs, int totalLOC)
{
	map[int, num] riskLOC = (1: 0, 2: 0, 3: 0);
	
	assert (domain(methodCCs) == domain(methodLOCs)) : "Not comparing the same methods: <methodCCs - methodLOCs>";
	
	for(method <- methodCCs)
	{
		int ccRisk = GetCCRisk(methodCCs[method]);
		
		//We don't care about 'Low' risk.
		if(ccRisk > 0) riskLOC[ccRisk] += methodLOCs[method];
	}
	
	//Convert to percentages
	riskLOC = ( risk: ((riskLOC[risk] / totalLOC) * 100.0) | risk <- riskLOC );
	
	if(riskLOC[1] <= 25 && riskLOC[2] <= 0 && riskLOC[3] <= 0) return "++ <riskLOC>";
	else if(riskLOC[1] <= 30 && riskLOC[2] <= 5 && riskLOC[3] <= 0) return "+ <riskLOC>";
	else if(riskLOC[1] <= 40 && riskLOC[2] <= 10 && riskLOC[3] <= 0) return "o <riskLOC>";
	else if(riskLOC[1] <= 50 && riskLOC[2] <= 15 && riskLOC[3] <= 5) return "- <riskLOC>";
	else return "-- <riskLOC>";
}

//++	0-3%
//+		3-5%
//o		5-10%
//-		10-20%
//--	20-100%
private str GetDuplicationRank(num duplLOC, num totalLOC)
{
	num percentage = (duplLOC / totalLOC) * 100.0;
	
	if(percentage <= 3) return "++ (<percentage>%)";
	else if(percentage <= 5) return "+ (<percentage>%)";
	else if(percentage <= 10) return "o (<percentage>%)";
	else if(percentage <= 20) return "- (<percentage>%)";
	else return "-- (<percentage>%)";
}
