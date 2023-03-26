function C = weightedcov(Y, w)

%   weightedcov returns a symmetric matrix C of weighted covariances
%   calculated from an input T-by-N matrix Y whose rows are
%   observations and whose columns are variables and an input T-by-1 vector
%   w of weights for the observations. This function may be a valid
%   alternative to COV if observations are not all equally relevant
%   and need to be weighted.

[T, N] = size(Y);  % T: number of observations; N: number of variables
C = Y - repmat(w' * Y, T, 1);  % Remove mean (which is, also, weighted)
C = C' * (C .* repmat(w, 1, N)); % Weighted Covariance Matrix
C = 0.5 * (C + C');   % Must be exactly symmetric
