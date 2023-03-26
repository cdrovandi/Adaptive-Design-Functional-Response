clear;
suffix = ["th", "st", "nd", "rd", repelem("th", 6)];
labs = ["a"; "T_h"; "\lambda"];
labs2 = ["a"; "Th"; "lambda"];

for gender = ["female", "male"]
    
    gen = char(gender);
    fprintf("\n################################################################ \n")
    disp([upper(gen(1)), gen(2:end), 's: SMC']);
    fprintf("################################################################ \n\n")
    dataset = load([char(gender), '.txt']);
    current_experiment_number = size(dataset, 1);
    new_number = char(num2str(current_experiment_number+ 1));
    rng(5);
    SMC;
    %txt_files;
    
    if gender == "male"
        theta_male = theta;
    else
        theta_female = theta;
    end
    
    
    title1 = ['Optimal Design for ', char(new_number), char(suffix(str2double(new_number(end))+1)), ' Experiment (', [upper(gen(1)), gen(2:end), 's'], ')'];
    te_marginal;   % use the total entropy criterion for determining next design point
    %saveas(fig2, [gen, '_', new_number, '.png']);
    %close all;
    
    % Add utility plots for a bunch of other experimental goals e.g.
    % marginal paramter estimation, purely model discrimination
    
    
    
    % clearvars -except theta_male theta_female suffix modeltype Models labs labs2 K
    
end
