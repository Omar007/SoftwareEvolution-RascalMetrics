module TestCode

//import analysis::statistics::Descriptive;
import metrics::MetricsOverview;


//:set profiling true


//SmallSQL 0:	Min=1		Max=88		Avg=6.776145203
//SmallSQL 1:	Min=16		Max=71		Avg=35.55319149
//SmallSQL 2:	Min=27		Max=289		Avg=75.18181818
//SmallSQL 3:	Min=151		Max=360		Avg=209.1666667
//
//HyperSQL 0:	Min=1		Max=320		Avg=9.506284712
//HyperSQL 1:	Min=16		Max=219		Avg=55.64285714
//HyperSQL 2:	Min=40		Max=355		Avg=108.7639752
//HyperSQL 3:	Min=116		Max=1090	Avg=339.1363636
public map[int, tuple[num min, num max, num median, num mean, num deviation]] GetMethodCCLOCInfo(loc project)
{
	set[Declaration] ast = GetProjectAST(project);
	methodCCs = MethodCC(ast);
	methodLOCs = MethodLinesOfCode(ast);
	
	assert (domain(methodCCs) == domain(methodLOCs)) : "Not comparing the same methods: <methodCCs - methodLocs>";
	
	map[int, tuple[num min, num max, num median, num mean, num deviation]] resultMap = ();
	
	filteredTemp = [ methodLOCs[method] | method <- methodLOCs, methodCCs[method] > 0, methodCCs[method] <= 10 ];
	//resultMap += (0: <min(filteredTemp), max(filteredTemp), median(filteredTemp), mean(filteredTemp), standardDeviation(filteredTemp)>);
	resultMap += size(filteredTemp) > 0
		? (0: <min(filteredTemp), max(filteredTemp), 0, (0.0 | it + i | i <- filteredTemp) / size(filteredTemp), 0>)
		: (0: <0,0,0,0,0>);
	
	filteredTemp = [ methodLOCs[method] | method <- methodLOCs, methodCCs[method] > 10, methodCCs[method] <= 20 ];
	//resultMap += (1: <min(filteredTemp), max(filteredTemp), median(filteredTemp), mean(filteredTemp), standardDeviation(filteredTemp)>);
	resultMap += size(filteredTemp) > 0
		? (1: <min(filteredTemp), max(filteredTemp), 0, (0.0 | it + i | i <- filteredTemp) / size(filteredTemp), 0>)
		: (1: <0,0,0,0,0>);
	
	filteredTemp = [ methodLOCs[method] | method <- methodLOCs, methodCCs[method] > 20, methodCCs[method] <= 50 ];
	//resultMap += (2: <min(filteredTemp), max(filteredTemp), median(filteredTemp), mean(filteredTemp), standardDeviation(filteredTemp)>);
	resultMap += size(filteredTemp) > 0
		? (2: <min(filteredTemp), max(filteredTemp), 0, (0.0 | it + i | i <- filteredTemp) / size(filteredTemp), 0>)
		: (2: <0,0,0,0,0>);
	
	filteredTemp = [ methodLOCs[method] | method <- methodLOCs, methodCCs[method] > 50 ];
	//resultMap += (3: <min(filteredTemp), max(filteredTemp), median(filteredTemp), mean(filteredTemp), standardDeviation(filteredTemp)>);
	resultMap +=  size(filteredTemp) > 0
		? (3: <min(filteredTemp), max(filteredTemp), 0, (0.0 | it + i | i <- filteredTemp) / size(filteredTemp), 0>)
		: (3: <0,0,0,0,0>);
	
	
	println(GetMethodLOCRank(methodLOCs, 18716));
	
	
	return resultMap;
}
