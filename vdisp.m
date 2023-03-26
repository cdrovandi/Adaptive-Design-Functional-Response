% Function which displays values to the console if verbose is set to true
function vdisp(verbose, varargin)
if verbose
    disp(varargin{:});
end
end

