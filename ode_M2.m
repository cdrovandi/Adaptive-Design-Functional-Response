% Equation for Holling's Type II model
% u is the prey population
% p is a vector of the parameters, p(1) is attack rate (a), p(2) is
% handling time (Th)

function eqns = ode_M2(~,u,p)
eqns = -p(1)*u./(1+p(1)*p(2)*u);
end