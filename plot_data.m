% Plotting example datasets. The sample means (o-o-o)
% for each value N are also shown.

% Select dataset to use
D = 4;
% Datasets:
% 1- Example dataset from Papanikolau et al. (2016)
% 2- The orginal data from Hassell et al. (1977)
% 3 - Male functional response data collected through a baseline design
% 4 - Female functional response data collected through a baseline design

% Load the dataset
if D == 1
    raw_data = load('data/papanikolau_data.mat');
    data = raw_data.data;
    
elseif D == 2
    raw_data = load('data/hassell_data.mat');
    data = [raw_data.N.' raw_data.n.'];
  
elseif D == 3
    data = load('data/male_baseline_design.txt');
    
elseif D == 4
    data = load('data/female_baseline_design.txt');

end

% Plot the data with jitter on the y axis
scatter(data(:,1), data(:,2) + normrnd(0, 0.1, size(data, 1), 1), 60, '.');
hold on;
grid on;
means = grpstats(data, data(:,1));
plot(means(:,1),means(:,2), '-o');
xlabel('Number of prey available (N)');
ylabel('Number predated (n)');
legend('Individual samples', 'Means for each value of N', 'Location', 'northwest')
