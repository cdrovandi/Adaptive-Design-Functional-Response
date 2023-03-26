value = 50;

parm = [repelem(parameters(:,1), N/value, 1), repmat(parameters(:,2), N/value, 1)];
lmlh = log_lik(y, Nt(j), parm(:,1), parm(:,2)); 
lmlh = reshape(lmlh, [N/value, N, length(y)]);
lmlh = permute(lmlh,[2 1 3]);       
lmlh = lmlh + log(value/N).';
lmlh = logsumexp(lmlh, 2);
lmlh = reshape(lmlh, [N, length(y)]);

% parm = [repelem(parameters(:,1), N, 1), repmat(parameters(:,2), N, 1)];
% lmlh = log_lik(y, Nt(j), parm(:,1), parm(:,2)); 
% lmlh = reshape(lmlh, [N, N, length(y)]);
% lmlh = permute(lmlh,[2 1 3]);       
% lmlh = lmlh + log(W(:,M)).';
% lmlh = logsumexp(lmlh, 2);
% lmlh = reshape(lmlh, [N, length(y)]);