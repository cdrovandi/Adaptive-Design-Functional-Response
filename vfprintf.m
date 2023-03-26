% Function which prints to console if verbose is set to true
function vfprintf(verbose, varargin)
if verbose
    fprintf(varargin{:})
end
end

