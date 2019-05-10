reset;

set source; set sink;

var x{source, sink} >= 0;

param distance{source, sink};
param sourceflow{source};
param sinkflow{sink};

minimize total_cost: sum{i in source, j in sink} distance[i,j] * x[i,j];

subject to source_goal{i in source}:  sum{j in sink} -x[i,j] + sourceflow[i] <=  3;
subject to source_limit{i in source}: sum{j in sink} -x[i,j] + sourceflow[i] >= -3;
subject to sink_goal{j in sink}:      sum{i in source}  x[i,j] + sinkflow[j] >= -3;
subject to sink_limit{j in sink}:     sum{i in source}  x[i,j] + sinkflow[j] <=  3;
#subject to source_status{i in source}: status[i] - sum{j in sink} x[i,j] + sourceflow[i] <= capacity[i]; 
#subject to sink_status{j in sink}: status[j] + sum{i in source} x[i,j] + sinkflow[j] >= 0;

data;

set source := so3 so6 so8 so15 so20 so88 so104 so350;
set sink := si21 si52 si71 si72 si86 si139 si321 si345 si369 si370 si375;

param distance: si21 si52 si71 si72 si86 si139 si321 si345 si369 si370 si375 :=								
so3		0.005227	0.038004	0.036675	0.03377		0.027784	0.036044	0.006494	0.02097		0.011787	0.008428	0.04321
so6		0.015337	0.047313	0.047855	0.045806	0.042595	0.054447	0.024625	0.038613	0.021989	0.020128	0.052649
so8		0.010578	0.048825	0.048658	0.046229	0.041716	0.050731	0.020322	0.03348		0.022077	0.019419	0.054193
so15	0.00877		0.050914	0.050123	0.047394	0.04177		0.047774	0.017638	0.029206	0.023845	0.02071		0.056234
so20	0.002429	0.044983	0.043986	0.041188	0.035429	0.042283	0.011857	0.024837	0.018038	0.014772	0.050267
so88	0.02243		0.031004	0.02752		0.024042	0.015117	0.019014	0.013313	0.013893	0.018006	0.017366	0.03515
so104	0.024687	0.052048	0.048618	0.045136	0.036063	0.026471	0.017927	0.007484	0.032845	0.030251	0.056254
so350	0.018862	0.036544	0.033331	0.029879	0.021146	0.02131		0.009128	0.008983	0.019272	0.017572	0.040901
;

param sourceflow:=
so3      8.0
so6      7.0
so8      8.0
so15     4.0
so20     4.0
so88     4.0
so104    5.0
so350    4.0
;

param sinkflow:=
si21    -4.0
si52    -4.0
si71    -4.0
si72    -4.0
si86    -4.0
si139   -4.0
si321   -4.0
si345   -5.0
si369   -4.0
si370   -4.0
si375   -4.0
;

solve;
display _objname, _obj, _varname, _var > optimization_5-9.txt;
