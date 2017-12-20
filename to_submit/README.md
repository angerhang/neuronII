# neuronII
## How to run the code
Move the `data.mat` into the working directory and execute `main.m` and the results are stored in `repo_ps_to_show` based on different cell types.


## Analysis
In our project, we attempt to learn how quickly Action Potentials decay to the corresponding AP thresholds for different cells. AP threshold for a certain cell is defined as the average AP threshold throughout the spike-train. We compute the durations between the peak and the first occurrence of the AP threshold after that peak, the average of which is the repolarization period of each cell. We recognise that using average AP thresholds does not account for short-term plasticity, but for a rough comparison of repolarisation periods for different cells, the average AP thresholds suffice.

We observe that parvalbumin-expressing inhibitory (PV) cells have the shortest refractory period (about 19.6 ms on average), much less than that of excitatory cells (44.73ms on average). This agrees with the experimental observation that PV cells can fire much more frequently than excitatory cells. A lower refractory period, which also contributes to a lower overall AP width, is one factor which enables the PV cells to fire at the high rates that are observed.

We also see that somatostatin-exppressing inhibitory (Sst) cells also have slightly lower refractory periods (36.24ms on average) than the excitatory cells. VIP cells seem to have a particularly long refractory period (91.36ms on average).

The refractory period is determined by the decay phase of the AP, which in turn, depends on the number and efficacy of potassium channels in the particular cell. Thus, we may conclude that PV cells have a very large concentration of K+ channels while VIP cells have very low concentrations.
