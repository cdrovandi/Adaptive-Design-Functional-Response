% This script determines the design point from the discrete design space
% which maximises the total entropy utility

Nt = Nmin:Nmax; % define possible design points
utility = zeros(length(Nt),1); % set up vector of utility values

for j = 1:length(Nt)
    disp(j);
    clearvars log_wsum B b log_p_y log_Z_n
    
    log_wsum = zeros(K, Nt(j)+1);
    B = zeros(K, Nt(j)+1);
    
    for M = 1:K
        clearvars parameters y llh log_w_hat log_W_hat
        
        % COMPUTE THE LOG LIKELIHOOD FOR EACH POSSIBLE Y VALUE USING THE SET OF PARTICLES FROM MODEL M
        parameters = find_parameters(theta(:,:,M), Nt(j), time, Models(M));  % Determine the mu and lambda parameters for all particles      
        y = 0:Nt(j); % All possible y values
        llh = log_lik(y, Nt(j), parameters(:,1), parameters(:,2)); % Calculate the log likelihood of observing the datapoint [Nt(j), y]
          
        log_w_hat = log(W(:,M))+ llh; % updated log unnormalised weights of particles if y was the new observation
        log_wsum(M,:) = logsumexp(log_w_hat,1);
        log_W_hat = log_w_hat - log_wsum(M,:); % updated log normalised weights
        
        marginal_likelihoods;
        b = lmlh.*exp(log_W_hat); % multiply log likelihood by normalised weights
        b(isnan(b)) = 0;
        B(M,:) = sum(b,1);
    end
    
    log_Z_n = log_Z - logsumexp(log_Z); % normalised evidence
    log_p_y = logsumexp(log_Z_n + log_wsum.',2); % posterior predictive probabilities
    log_p_y = log_p_y - logsumexp(log_p_y); % normalised posterior predictive probabilities
    
    
    % DETERMINE THE EXPECTED UTILITY
    utility(j) = exp(log_Z_n)* sum(exp(log_wsum).* B,2) - (log_p_y.' * exp(log_p_y));
    disp(utility(j))
end


% Show optimal design point
idx = find(max(utility)==utility);
disp(['Optimal design point at ', num2str(Nt(idx))]);

% PLOT THE EXPECTED UTILITIES FOR EACH DESIGN POINT
fig2 = figure;
plot(Nt, utility, '-', 'LineWidth', 1.2);
ylabel('Expected Information Gain')
xlabel('Initial number of prey (N_{0})');
title(title1);
hold on;
grid on;
plot(Nt(idx), utility(idx), 'm.', 'Markersize', 25);

plot([0, Nt(idx)], [utility(idx), utility(idx)], 'm--', 'LineWidth', 0.25);
plot([Nt(idx), Nt(idx)], [0, utility(idx)], 'm--');

text(Nt(idx), utility(idx)+0.015, ['N_0 = ', num2str(Nt(idx))]);

legend('Utility Curve','Optimal Design', 'Location', 'southeast');
ylim([min(utility)-0.1, max(utility)+0.1])

