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

set source := so3 so6 so8 so20 so21 so66 so88 so104 so350;
set sink := si52 si62 si72 si86 si139 si145 si324 si345 si369 si375;

param distance: si52 si62 si72 si86 si139 si145 si324 si345 si369 si375 :=								
so3		0.038004	0.008720	0.033770	0.027784	0.036044	0.047982	0.004105	0.020970	0.011787	0.043210
so6		0.047313	0.027168	0.045806	0.042595	0.054447	0.065476	0.017301	0.038613	0.021989	0.052649
so8		0.048825	0.023531	0.046229	0.041716	0.050731	0.062976	0.015359	0.033480	0.022077	0.054193
so20	0.044983	0.015394	0.041188	0.035429	0.042283	0.055115	0.009943	0.024837	0.018038	0.050267
so21	0.042805	0.013102	0.038862	0.033010	0.040169	0.052786	0.007833	0.023287	0.016003	0.048066
so66	0.049115	0.013724	0.043374	0.035367	0.033701	0.048882	0.018458	0.013466	0.025412	0.053946
so88	0.031004	0.009394	0.024042	0.015117	0.019014	0.030356	0.018547	0.013893	0.018006	0.035150
so104	0.052048	0.018942	0.045136	0.036063	0.026471	0.042892	0.027658	0.007484	0.032845	0.056254
so350	0.036544	0.006392	0.029879	0.021146	0.021310	0.034810	0.017090	0.008983	0.019272	0.040901
;

param sourceflow:=
so3		8.0
so6     7.0
so8     7.0
so20    4.0
so21    5.0
so66    4.0
so88    4.0
so104   4.0
so350   4.0
;

param sinkflow:=
si52   -4.0
si62   -4.0
si72   -4.0
si86   -5.0
si139  -4.0
si145  -4.0
si324  -4.0
si345  -4.0
si369  -4.0
si375  -5.0
;

solve;
display _objname, _obj, _varname, _var > optimization2.txt;
