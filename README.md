# Adaptive-Design-Functional-Response

Matlab code for the paper:

Nikos E. Papanikolaou, Hayden Moffat, Argyro Fantinou, Dionysios P. Perdikis, Michael Bode and Christopher Drovandi. Adaptive experimental design produces superior and more efficient estimates of predator functional response. 

This article is dedicated to Dr Nikos E. Papanikolaou, who sadly and unexpectedly passed away after the majority of this manuscript had been completed

---------------------------------------------------------------------
INSTRUCTIONS FOR FINDING THE NEXT OPTIMAL DESIGN
---------------------------------------------------------------------

1. After receiving a new observation (initial prey density and number prey killed), we would update the 
male.txt and female.txt files as appropriate. These files would contain the current 
sequential design data.  

2. We would then open the analysis.m matlab script and run it. You may need to 
look at the SMC.m script to ensure all the set up parameters are correct.
The analysis script runs SMC to get the posterior distributions for the data collected so far,
and then it calls te_marginal, which uses the total entropy criterion for determining next design point.

If you run analysis.m without any changes to the code, then it will produce the 
optimal design for the 41st observation related to male and female data.

---------------------------------------------------------------------
OTHER
---------------------------------------------------------------------

- "complete_analysis.m" conducts Bayesian inference on pilot, 
sequential and baseline data.
- If a dataset is already collect, posterior inference can be generated
  using option R = 4 in SMC.m (this option won't do any optimal design).
- All visualisations are generated from the file "all_inference_plots.m".
- The data folder holds the baseline, pilot and adaptive datasets collected for the paper.



