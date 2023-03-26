# Adaptive-Design-Functional-Response


---------------------------------------------------------------------
INSTRUCTIONS FOR FINDING THE NEXT OPTIMAL DESIGN
---------------------------------------------------------------------

1. After receiving a new observation (initial prey density and number prey killed), we would update the 
male.txt and female.txt files as appropriate. These files would contain the current 
sequential design data.  The dataset needs to be stored in a Matlab matrix called dataset,
with the first column being the initial prey densities and the second column being
the responses.

2. We would then open the analysis.m matlab script and run it. You may need to 
look at the SMC.m script to ensure all the set up parameters are correct.
For the paper we used the total entropy criterion to select the next time point,
for this option select R = 3 in SMC.m. 

3. analysis.m creates the utility plots and a text file with the model 
probabilites and 95 percent credible intervals for parameters.

---------------------------------------------------------------------
OTHER
---------------------------------------------------------------------

- "complete_analysis.m" conducts Bayesian inference on pilot, 
sequential and baseline data.
- If a dataset is already collect, posterior inference can be generated
  using option R = 4 in SMC.m (this option won't do any optimal design).
- All visualisations are generated from the file "all_inference_plots.m".



