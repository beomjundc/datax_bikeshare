reset;

set source; set sink;

var x{source, sink} >= 0;

param distance{source, sink};
param sourceflow{source};
param sinkflow{sink};

minimize total_cost: sum{i in source, j in sink} distance[i,j] * x[i,j];

subject to source_goal{i in source}:  sum{j in sink} -x[i,j] + sourceflow[i] <=  10;
subject to source_limit{i in source}: sum{j in sink} -x[i,j] + sourceflow[i] >= -10;
subject to sink_goal{j in sink}:      sum{i in source}  x[i,j] + sinkflow[j] >= -10;
subject to sink_limit{j in sink}:     sum{i in source}  x[i,j] + sinkflow[j] <=  10;


data;

set source := so22 so26 so53 so66 so70 so73 so80 so81 so85 so92 so132 so133 so285 so324 so349;
set sink := si6 si8 si15 si16 si21 si30 si49 si67 si88 si223;

param distance: si6 si8 si15 si16 si21 si30 si49 si67 si88 si223 :=
so22	0.017298	0.010911	0.005653	0.004379	0.006169	0.013174	0.009003	0.013147	0.026095	0.035667
so26	0.019594	0.013324	0.008104	0.006840	0.006842	0.010730	0.006558	0.010712	0.024470	0.034182
so53	0.044990	0.046012	0.047717	0.047007	0.039416	0.042501	0.043058	0.042257	0.026715	0.020924
so66	0.028064	0.021986	0.016714	0.015481	0.013549	0.003325	0.003022	0.003490	0.020888	0.030714
so70	0.051725	0.052957	0.054741	0.054034	0.046442	0.049121	0.049863	0.048880	0.032732	0.025666
so73	0.044901	0.045064	0.046017	0.045185	0.037419	0.038725	0.039743	0.038488	0.022053	0.015324
so80	0.030099	0.024742	0.020415	0.019133	0.014781	0.002550	0.006043	0.002371	0.015207	0.024956
so81	0.030593	0.024661	0.019539	0.018293	0.015726	0.002231	0.005208	0.002476	0.019456	0.029125
so85	0.043303	0.042784	0.043154	0.042239	0.034429	0.034495	0.035796	0.034263	0.017430	0.010509
so92	0.034036	0.028194	0.023121	0.021874	0.018993	0.004853	0.008684	0.005007	0.018836	0.028093
so132	0.057883	0.055730	0.054305	0.053160	0.045772	0.039946	0.042868	0.039780	0.023522	0.014496
so133	0.052637	0.050057	0.048282	0.047109	0.039885	0.033429	0.036441	0.033268	0.017467	0.009593
so285	0.035089	0.036537	0.038815	0.038229	0.030955	0.036538	0.036274	0.036290	0.023656	0.021777
so324	0.017301	0.015359	0.015987	0.015258	0.007833	0.017677	0.015499	0.017467	0.018547	0.026221
so349	0.023884	0.020245	0.018392	0.017274	0.009889	0.011282	0.010680	0.011042	0.012541	0.021725
;

param sourceflow:=
so22     22.002025
so26     10.454267
so53     12.359233
so66     21.604388
so70     11.864577
so73     10.323896
so80     20.059266
so81     29.384088
so85     10.793502
so92     15.154595
so132    14.071705
so133    10.137044
so285    15.301824
so324    19.699290
so349    12.276099
;

param sinkflow:=
si6      -34.531287
si8      -14.979113
si15     -49.375599
si16     -21.011031
si21     -31.625091
si30     -19.523631
si49     -15.987738
si67    -104.550635
si88     -12.295251
si223    -13.948610
;

solve;
display _objname, _obj, _varname, _var > optimization.txt;