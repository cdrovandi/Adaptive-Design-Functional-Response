%% Importing all datasets and conducting Bayesian inference

% Start fresh
clear; 

% Manually input
total_datasets = 8; % total number of datasets to conduct inference

% Other
counter = 1; % initialise counter 
the_data = cell(total_datasets, 1); % initialise empty list of datasets

% Fill list with actual data
for gender = ["male", "female"]
       
    % Generate file names
    filenames = {['data/', char(gender), '_pilot.txt'],...
        ['data/', char(gender), '_sequential_design.txt'], ...
        ['data/', char(gender), '_baseline_design.txt'], ...
        ['data/all_', char(gender), '_data.txt']};
            
    for i = 1:length(filenames)
        % Load data
        string = filenames{i};
        the_data{counter} = load(string);
        
        % Update counter
        counter = counter + 1;  
    end
end

clearvars gender counter string i filenames

% Determine maximum number of observations collected across all datasets
up = max(cellfun(@length, the_data)); 

% Initialise matrices containing results from inference
all_mp = zeros(up,2,total_datasets);
all_prec = zeros(up,2,total_datasets);
all_theta = zeros(500, 3, 2, total_datasets);

% Reference names
 names = {'male_pilot', 'male_seq', 'male_base', 'male_all',...
     'female_pilot', 'female_seq', 'female_base', 'female_all'};

%%% Conduct Bayesian inference for each dataset
for dos = 1:total_datasets
    
    % Load data
    dataset = the_data{dos}; 
    
    % Reorder baseline data
    if ismember(dos, [3, 7]) == true
        dataset = dataset([1:8, 33:40, 9:32],:);
    end
       
    disp(dataset);
    rng(1);
    utility_plots = false;
    SMC; % run SMC algorithm
    txt_files;
    
    % Save results
    all_theta(:,:,:,dos) = theta;
    all_prec(1:(I+1),:,dos) = precision;
    all_mp(1:(I+1),:,dos) = model_probs;
    
    % clear variables that are no longer required
    clearvars -except all_mp all_prec all_theta dos the_data names
    
end

clearvars dos

% Save results
save('all_inferences');

