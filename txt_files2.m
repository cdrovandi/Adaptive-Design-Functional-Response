filename = [gen, '_inference', num2str(current_experiment_number), '.txt'];

fid = fopen(filename, 'wt' );
fprintf( fid, [upper(gen), ' DATA \n\n######################################',...
'############################## \n Current data \n##################',...
'################################################## \n\n']);
fwrite(fid, evalc('disp(data)'));
fprintf(fid, ['\n######################################################',...
    '############## \n 95 percent Credible Intervals for each model \n', ...
'####################################################################\n\n']);

variables = {'a', 'Th', 'lambda'};
for M = 1:K
    
    str = [char(modeltype(Models(M))), ' (Model ' , num2str(M) ,'): '];
    fprintf(fid, [str, '\n']);
    
    if ismember(Models(M), [1, 2])
        nvar = 3;
        str1 = "               ------------------------------------------------------------\n";
    elseif ismember(Models(M), [5, 6])
        nvar = 2;
        str1 = "               ------------------------------------\n";
    end
    
    CI = quantile(exp(theta(:,1:nvar,M)), [0.025 0.5 0.975]);    
    table = array2table(CI, 'VariableNames', variables(1:nvar), 'RowNames', {'2.5% ', '50%  ', '97.5%'});
    table2 = [{'   '; '2.5% '; '50%  '; '97.5%'} , [table.Properties.VariableNames;table2cell(table)]];
    format = ['%3s', char(join(repelem("%20s ", nvar))), '\n'];
    format2 = ['%3s', char(join(repelem("%20f ", nvar))), '\n'];
    
fprintf(fid, format, table2{1,:});
fprintf(fid, str1);
Pt = table2.'; 
fprintf(fid, format2, Pt{:,2:end});
fprintf(fid, '\n\n');
    
    
end

fprintf(fid, ['\n######################################################',...
    '############## \n Posterior Model Probabilities \n', ...
'#################################################################### \n\n']);
for M = 1:K
    string = [char(modeltype(Models(M))), ' (Model ' , num2str(M) ,'): ', num2str(posterior_model_prob(M))];
    fprintf(fid, [string, '\n']);
end

fclose(fid);
