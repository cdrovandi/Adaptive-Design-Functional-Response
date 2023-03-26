% Clear workspace
% clear;
verbose = true;

%% PROBLEM AND SMC SET UP (INPUT REQUIRED)
% Specify method of determining next design point
 R = 4;

% Methods (R):
% 0 - selects design point randomly and generates data
% 1 - selects design point that maximises utility for parameter estimation and generates data
% 2 - selects design point that maximises utility for model discrimination and generates data
% 3 - selects design point that maximises total entropy utility and generates data
% 4 - selects both design and observation points from an example experiment (i.e. the dataset has already been collected)
% 5 - selects design points used in an example experiment and generates data

% Specify models to be considered
Models = [1 2];

modeltype= ["Beta Binomial type 2 functional response model";
    "Beta Binomial type 3 functional response model";
    "Beta Binomial Zero handling time type 2 function response model";
    "Beta Binomial Zero handling time type 3 function response model";
    "Binomial type 2 functional response model";
    "Binomial type 3 functional response model";
    "Binomial Zero handling time type 2 function response model";
    "Binomial Zero handling time type 3 function response model"];


% Models:
% 1 - Beta Binomial type 2 functional response model
% 2 - Beta Binomial type 3 functional response model
% 3 - Beta Binomial Zero handling time type 2 function response model
% 4 - Beta Binomial Zero handling time type 3 function response model
% 5 - Binomial type 2 functional response model
% 6 - Binomial type 3 functional response model
% 7 - Binomial Zero handling time type 2 function response model
% 8 - Binomial Zero handling time type 3 function response model

% Load example dataset for methods that require it
% if ismember(R, [4,5])
%     dataset = load('data/male_pilot.txt') ;
% end

%  Select "true values" of parameters for methods that require it
% if ismember(R, [0:3,5,6])
%     a = 0.05;
%     Th = 0.7;
%     lambda= 0.8;
%     M_true = 5;
% end

% Assign values to parameters (Input required for these values)
utility_plots = false;
I = size(dataset, 1); % number of data points
K = length(Models); % number of models
N = 500; % number of particles for SMC
E = N/2; % threshold for ESS for SMC
Nmin = 1; % min value in the discrete design space
Nmax = 130; % max value in the discrete design space
time = 8; % length of time that predator has access to prey in hours

%% CONDUCTING THE SMC (NO INPUT REQUIRED)

% Initialise other required quantities (Input not needed for these values)
data = zeros(I, 2); % Set up data
log_Z = zeros(1,K); % initialise log estimate of evidence
loglik = zeros(N,K); % initialise vector of log likelihood
logpri = zeros(N,K); % initialise vector of log prior
px = zeros(N,K); % initialise vector of the log posterior
w = zeros(N, K); % initialise vector of unnormalised weights of particles
ESS = repelem(N, 1, K); % initialise vector of effective sample size of each model

weights = zeros(N, K, I+1);
particles = zeros(N, 3, K, I+1);

% Draw theta from prior distribution and set intial weighting
prior_sampling;
W(1:N,1:K)= 1/N;
model_probs = zeros(I+1, K);
precision = zeros(I+1, K);

% Determine the precision of model parameters
for M = 1:K
    covariance = weightedcov(exp(theta(:,:,M)), W(:,M));
    covariance = covariance(1:2, 1:2);
    log_D_post_prec = -log(det(covariance));
    precision(1,M) = log_D_post_prec;
end


utils = zeros(300, I);

for i= 1:I
    
    if ismember(R, [0 1 2 3 5 6])
        if  R == 0
            % Selecting design points randomly
            data(i,1)= randsample(Nmax - Nmin+1,1)+Nmin-1;
            
        elseif R==1
            % Select design points by maximising the parameter estimation utility
            parameter_estimation_utility;
            data(i,1)= Nt(idx); % Include the optimal design point in data
            
        elseif R==2
            % Select design points by maximising the model discrimination utility
            model_discrimination_utility;
            data(i,1)= Nt(idx); % Include the optimal design point in data
            
        elseif R==3
            % Select design points by maximising the total entropy utility
            total_entropy_utility;
            data(i,1)= Nt(idx); % Include the optimal design point in data
            
 
        else
            data(i,1) = dataset(i,1); % take design point from example experiment
            
        end
        
        generate_data; % Generate observation from the design point
        
    elseif R==4
        data(i,:)= dataset(i,:); % Take all design point and observations from example dataset
        
    end
    
    data_subset = data(1:i,:); % current data available
    
    for M = 1:K
        %  Re-weight
        w(:,M) = W(:,M).* exp(log_likelihood(theta(:,:,M), data(i,:), time, Models(M)).');
        log_Z(M) = log_Z(M) + log(sum(w(:,M)));
        
        % Normalise weights
        W(:,M) = w(:,M)/sum(w(:,M));
        
        % Compute ESS at time t
        ESS(M) = 1/ sum(W(:,M).^2);
        
        % Plots the SMC approximation after each data point is included
        % (Commented out to reduce running time but can be quite helpful with understanding the data)
        %                 clf;
        %                 plotSMC; % Plot parameter posterior
        %                 drawnow;
        
        % Displays ESS for each observation
        vfprintf(verbose, 'Model %i -> ESS: %5.2f (%i observations) \n', M, ESS(M), i)
        
        if ESS(M)<E
            
            % Resample the particles
            theta(:,:,M) = residual_resampling(W(:,M),N,theta(:,:,M)); % residual resampling
            W(1:N,M) = 1/N; % set weights to 1/N
            ESS(M)=N;
            
            move_step; % conducts the move step of the resampled particles
            n_unique = length(unique(theta(:,1,M))); % number of unique particles after resampling step
            vfprintf(verbose, 'Number of unique particles = %i \n', n_unique);
        end
        
        covariance = weightedcov(exp(theta(:,:,M)), W(:,M));
        covariance = covariance(1:2, 1:2);
        log_D_post_prec = -log(det(covariance));
        precision(i+1, M) = log_D_post_prec;
        
    end
    
    particles(:,:,:,i+1) = theta;
    weights(:,:,i+1) = W;
    
    
    model_probs(i+1,:) = exp(log_Z - logsumexp(log_Z));
    
    
    % For every iteration after the pilot study generate a utility plot
    if utility_plots == true
        if ismember(i, 16:39)
            te_marginal;
            saveas(fig, ['../Optimal design iterations/regenerated/', gen, '_', num2str(i+1), '.png']);
            close all;
        end
    end
    

end

% Conduct a final resampling and move step to ensure all weights of particles are equal
for M= 1:K
    if ESS(M) ~= N
        theta(:,:,M) = residual_resampling(W(:,M),N, theta(:,:,M)); % residual resampling
        move_step;
        n_unique = length(unique(theta(:,1,M)+1-1)); % number of unique particles after resampling step
        vfprintf(verbose, 'Number of unique particles = %i \n', n_unique);
        ESS(M)= N;
        W(1:N,M) = 1/N; % set weights to 1/N
    end
    
    vdisp(verbose, ['log_Estimate_of_Evidence = ', num2str(log_Z(M))]); % displaying log evidence
    
    % Credible Intervals for parameters
    vdisp(verbose,'95% Credible Intervals: ');
    vdisp(verbose,num2str(quantile(exp(theta(:,:,M)), [0.025 0.5 0.975])));
    
    % Kullback-Leibler divergence for each of the models
    %     KLD = (log_likelihood(theta(:,:,M), data, time, Models(M))*W(:,M))- log_Z(M);
    %     vdisp(verbose,(['KLD = ', num2str(KLD)])
    
    % Log Bayesian D-posterior precision for the parameters for each model
    covariance = cov(exp(theta(:,:,M)));
    covariance(all(~covariance,2),:) = []; % remove rows of parameters not used
    covariance(:,all(~covariance,1)) = []; % remove columns of parameters not used
    covariance = covariance(1:2, 1:2);
    log_D_post_prec = -log(det(covariance));
    vdisp(verbose,['log D-posterior precision = ', num2str(log_D_post_prec)])
    
    % Plot parameter posterior
    % plotSMC;
    
    
end

% Calculate Posterior Model Probabilities
posterior_model_prob = exp(log_Z - logsumexp(log_Z));
vdisp(verbose,'Posterior Model Probabilities ');
for M = 1:K
    vdisp(verbose,[char(modeltype(Models(M))), '(' , num2str(Models(M)) ,'): ', num2str(posterior_model_prob(M))]);
end


