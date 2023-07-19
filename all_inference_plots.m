%% Setup 1
% Start fresh
clear;

%% Visualisations of the raw data

% List of datasets that we want to plot
datasets = {"data/male_baseline_design.txt", ...
    "data/male_sequential_design.txt", ...
    "data/female_baseline_design.txt", ...
    "data/female_sequential_design.txt"};

legend_labels = {"Baseline design data", ...
    "Adaptive design data", ...
    "Baseline design data", ...
    "Adaptive design data"};

title_labels = {"(a) Male baseline design data", ...
    "(b) Male adaptive design data", ...
    "(c) Female baseline design data", ...
    "(d) Female adaptive design data"};

% Graphing settings which differ across the datasets
pilot_indicies = {[1:8, 33:40], 1:16, [1:8, 33:40] , 1:16};
xlims = {[0, 50], [0, 140], [0, 50],  [0, 140] };
ylims = {[0, 25], [0, 25], [0, 50]  [0, 50]};
col =  {[0 0.4470 0.7410], [0 0.4470 0.7410], [0.8500 0.3250 0.0980],  [0.8500 0.3250 0.0980]};

tiledlayout(2,2,"TileSpacing","compact","Padding","tight")

% Iterate through the datasets and plot them
for index = 1:4

    nexttile
    
    
    % Plot data (different shape for data points in pilot experiments)
    %f1 = figure;
    ind = pilot_indicies{index};
    data = load(datasets{index});
    jitter = normrnd(0, 0.2, size(data, 1), 1);
    data(:, 2) = data(:, 2) + jitter;
    scatter(data(setdiff(1:size(data, 1), ind),1), data(setdiff(1:size(data, 1), ind),2), 60, 'x', 'LineWidth',2, 'MarkerEdgeColor',col{index});
    hold on;
    grid on;
    scatter(data(ind,1), data(ind,2), 15, 'o', 'filled', 'MarkerFaceColor',col{index}, 'MarkerEdgeColor',col{index});
    
    % Adjust axis and axis labels
    xlabel('Number of prey available (N)');
    ylabel('Number predated (n)');
    legend(legend_labels{index}, 'Pilot data', 'Location' , 'northwest');
    set(gcf,'color','w');
    xlim(xlims{index});
    ylim(ylims{index});

    title(title_labels{index});
    
end


%% Setup 2
% Start fresh
clear;

% Load in data
load('all_inferences.mat');

%% Pilot Marginals

% Plot settings
model = 1;
columns = {1, 5};
col = {[0 0.4470 0.7410], [0.8500 0.3250 0.0980]};

for index = 1:2
    
    % Set up figure
    f2 = figure;
    
    set(f2, ...
        'DefaultFigureColor', 'w', ...
        'DefaultAxesLineWidth', 0.5, ...
        'DefaultAxesXColor', 'k', ...
        'DefaultAxesYColor', 'k', ...
        'DefaultAxesFontUnits', 'points', ...
        'DefaultAxesFontSize', 8, ...
        'DefaultAxesFontName', 'Helvetica', ...
        'DefaultLineLineWidth', 1, ...
        'DefaultTextFontUnits', 'Points', ...
        'DefaultTextFontSize', 8, ...
        'DefaultTextFontName', 'Helvetica', ...
        'DefaultAxesBox', 'off', ...
        'DefaultAxesTickLength', [0.02 0.025]);
    
    % Draw densities
    for par = 1:2
        subplot(1, 2, par);
        [f,xi] = ksdensity(exp(all_theta(:,par,model,columns{index})));
        plot(xi,f,'color',col{index},'LineWidth',1.2)
        hold on;
        grid on;
        hold off;
        if par == 1
            xlabel('a');
        else
            xlabel('T_h')
        end
        ylabel('Density');
    end
    
    % Set background colour to white
    set(gcf,'color','w');
    
end




%% Bivariate posterior comparison of adaptive design and pilot design

% Plot settings
model = 1;
columns = {[1 2], [5 6]};
col = {[0 0.4470 0.7410], [0.8500 0.3250 0.0980]};

xlims = {[0 0.4], [0.05 0.4]};
ylims = {[0.1 0.9], [0 0.4]};

tiledlayout(1,2,"TileSpacing","compact","Padding","tight")

title_labels = {"(a) Male data", ...
    "(b) Female data"};

for index = 1:2

    nexttile;
    
    x1 = meshgrid(0:0.01:1);
    x2 = x1';
    xi = [x1(:), x2(:)];
    
    % Set up figure
    %fp = figure;
    
    set(gcf, ...
        'DefaultFigureColor', 'w', ...
        'DefaultAxesLineWidth', 0.5, ...
        'DefaultAxesXColor', 'k', ...
        'DefaultAxesYColor', 'k', ...
        'DefaultAxesFontUnits', 'points', ...
        'DefaultAxesFontSize', 8, ...
        'DefaultAxesFontName', 'Helvetica', ...
        'DefaultLineLineWidth', 1, ...
        'DefaultTextFontUnits', 'Points', ...
        'DefaultTextFontSize', 8, ...
        'DefaultTextFontName', 'Helvetica', ...
        'DefaultAxesBox', 'off', ...
        'DefaultAxesTickLength', [0.02 0.025]);
    
    % Plot the pilot density
    dim = size(x1, 1);
    x = exp(all_theta(:,1,model,columns{index}(1)));
    y = exp(all_theta(:,2,model,columns{index}(1)));
    f1 = mvksdensity([x, y], [x, y],'Bandwidth',0.03);
    f_quant = quantile(f1, 0.1:0.1:0.9);
    f = mvksdensity([x, y], xi,'Bandwidth',0.03);
    Z = reshape(f, [dim, dim]);
    %[~, c2] = contour(x1, x2, Z, 20, '--');
    [~, c2] = contour(x1, x2, Z, f_quant, '--');
    c2.LineWidth = 0.2;
    c2.Color = col{index};
    c2.LineStyle = '-';
    
    hold on;
    
    % Plot the adaptive density
    x = exp(all_theta(:,1,model,columns{index}(2)));
    y = exp(all_theta(:,2,model,columns{index}(2)));
    f1 = mvksdensity([x, y], [x, y],'Bandwidth',0.03);
    f_quant = quantile(f1, 0.1:0.1:0.9);
    f = mvksdensity([x, y], xi,'Bandwidth',0.03);
    Z = reshape(f, [dim, dim]);
    %[~, c2] = contour(x1, x2, Z, 20, '--');
    [~, c2] = contour(x1, x2, Z, f_quant, '--');
    c2.LineWidth = 0.8;
    c2.Color = col{index};
    
    % Aesthetics
    xlabel("a");
    ylabel("T_h");
    legend("Pilot", "Adaptive design", "Location", "southeast");
    set(gcf,'color','w');
    xlim(xlims{index});
    ylim(ylims{index});

    title(title_labels{index});
    
end






%% Bivariate posterior comparison of adaptive design and baseline design

% Plot settings
model = 1;
columns = {[2 3], [6 7]};
col = {[0 0.4470 0.7410], [0.8500 0.3250 0.0980]};

xlims = {[0 0.25], [0.1 0.45]};
ylims = {[0.1 0.9], [0.1 0.45]};


tiledlayout(1,2,"TileSpacing","compact","Padding","tight")

title_labels = {"(a) Male data", ...
    "(b) Female data"};


for index = 1:2

    nexttile
    
    x1 = meshgrid(0:0.01:1);
    x2 = x1';
    xi = [x1(:), x2(:)];
    
    % Set up figure
    %f3 = figure;
    
    set(gcf, ...
        'DefaultFigureColor', 'w', ...
        'DefaultAxesLineWidth', 0.5, ...
        'DefaultAxesXColor', 'k', ...
        'DefaultAxesYColor', 'k', ...
        'DefaultAxesFontUnits', 'points', ...
        'DefaultAxesFontSize', 8, ...
        'DefaultAxesFontName', 'Helvetica', ...
        'DefaultLineLineWidth', 1, ...
        'DefaultTextFontUnits', 'Points', ...
        'DefaultTextFontSize', 8, ...
        'DefaultTextFontName', 'Helvetica', ...
        'DefaultAxesBox', 'off', ...
        'DefaultAxesTickLength', [0.02 0.025]);
    
    % Plot the baseline density
    dim = size(x1, 1);
    x = exp(all_theta(:,1,model,columns{index}(2)));
    y = exp(all_theta(:,2,model,columns{index}(2)));
    f1 = mvksdensity([x, y], [x, y],'Bandwidth',0.03);
    f_quant = quantile(f1, 0.1:0.1:0.9);
    f = mvksdensity([x, y], xi,'Bandwidth',0.03);
    Z = reshape(f, [dim, dim]);
    %[~, c2] = contour(x1, x2, Z, 20, '--');
    [~, c2] = contour(x1, x2, Z, f_quant, '--');
    c2.LineWidth = 0.2;
    c2.Color = col{index};
    c2.LineStyle = '-';
    
    hold on;
    
    % Plot the adaptive density
    x = exp(all_theta(:,1,model,columns{index}(1)));
    y = exp(all_theta(:,2,model,columns{index}(1)));
    f1 = mvksdensity([x, y], [x, y],'Bandwidth',0.03);
    f_quant = quantile(f1, 0.1:0.1:0.9);
    f = mvksdensity([x, y], xi,'Bandwidth',0.03);
    Z = reshape(f, [dim, dim]);
    %[~, c2] = contour(x1, x2, Z, 20, '--');
    [~, c2] = contour(x1, x2, Z, f_quant, '--');
    c2.LineWidth = 0.8;
    c2.Color = col{index};
    
    % Aesthetics
    xlabel("a");
    ylabel("T_h");
    legend("Baseline design", "Adaptive design", "Location", "southeast");
    set(gcf,'color','w');
    xlim(xlims{index});
    ylim(ylims{index});

    title(title_labels{index});
    
end


%% Model Probabilities over time

tiledlayout(1,2,"TileSpacing","compact","Padding","tight")

title_labels = {"(a) Model 1 probability", ...
    "(b) Model 1 log determinant posterior covariance"};

nexttile;

% Plot settings
model = 1;

line_types = ["--","-", "--","--","--", "-", "--", "--"];

line_colours = [0 0.4470 0.7410;
    0 0.4470 0.7410;
    0 0.4470 0.7410;
    0 0.4470 0.7410;
    0.8500 0.3250 0.0980;
    0.8500 0.3250 0.0980;
    0.8500 0.3250 0.0980;
    0.8500 0.3250 0.0980;];

line_widths = [0.4, 1, 0.4, 0.2, 0.4, 1, 0.4, 0.2];

% Set up figure
%f4 = figure;

set(gcf, ...
    'DefaultFigureColor', 'w', ...
    'DefaultAxesLineWidth', 0.5, ...
    'DefaultAxesXColor', 'k', ...
    'DefaultAxesYColor', 'k', ...
    'DefaultAxesFontUnits', 'points', ...
    'DefaultAxesFontSize', 8, ...
    'DefaultAxesFontName', 'Helvetica', ...
    'DefaultLineLineWidth', 1, ...
    'DefaultTextFontUnits', 'Points', ...
    'DefaultTextFontSize', 8, ...
    'DefaultTextFontName', 'Helvetica', ...
    'DefaultAxesBox', 'off', ...
    'DefaultAxesTickLength', [0.02 0.025]);


% Construct plot
for dos = [2 3 6 7]
    non_zeros = (all_mp(:,model,dos) ~= 0);
    plot(1:sum(non_zeros), all_mp(non_zeros,model,dos), 'Color', line_colours(dos,:), 'LineStyle', line_types(dos), 'LineWidth', line_widths(dos));
    hold on;
    grid on;
end

% Draw line to indicate the pilot study
line([16 16],[0 1], 'LineStyle',':', 'Color','black', 'HandleVisibility', 'off', 'LineWidth', 1.3);

% Add legends and labels
legend("Males (adaptive design)", "Males (baseline design)", "Females (adaptive design)", "Females (baseline design)", 'Location', 'southeast');
xlabel("Observations Collected");
ylabel("Model Probability");
set(gcf,'color','w');

title(title_labels{1});

%% Precision model parameters over time

nexttile;

% Plot settings
model = 1;

line_types = ["--","-", "--","--","--", "-", "--", "--"];

line_colours = [0 0.4470 0.7410;
    0 0.4470 0.7410;
    0 0.4470 0.7410;
    0 0.4470 0.7410;
    0.8500 0.3250 0.0980;
    0.8500 0.3250 0.0980;
    0.8500 0.3250 0.0980;
    0.8500 0.3250 0.0980;];

line_widths = [0.4, 1, 0.4, 0.2, 0.4, 1, 0.4, 0.2];

% Set up figure
%f5 = figure;

set(gcf, ...
    'DefaultFigureColor', 'w', ...
    'DefaultAxesLineWidth', 0.5, ...
    'DefaultAxesXColor', 'k', ...
    'DefaultAxesYColor', 'k', ...
    'DefaultAxesFontUnits', 'points', ...
    'DefaultAxesFontSize', 8, ...
    'DefaultAxesFontName', 'Helvetica', ...
    'DefaultLineLineWidth', 1, ...
    'DefaultTextFontUnits', 'Points', ...
    'DefaultTextFontSize', 8, ...
    'DefaultTextFontName', 'Helvetica', ...
    'DefaultAxesBox', 'off', ...
    'DefaultAxesTickLength', [0.02 0.025]);



% Construct plot
for dos = [2 3 6 7]
    non_zeros = (all_prec(:,model,dos) ~= 0);
    plot(0:(sum(non_zeros)-1), (all_prec(non_zeros,model,dos)), 'Color', line_colours(dos,:), 'LineStyle', line_types(dos), 'LineWidth', line_widths(dos));
    hold on;
    grid on;
end

% Draw line to indicate the pilot study
line([16 16],[-2 16], 'LineStyle',':', 'Color','black', 'HandleVisibility', 'off', 'LineWidth', 1.3);

% Aesthetics
legend("Males (adaptive design)", "Males (baseline design)", "Females (adaptive design)", "Females (baseline design)", 'Location', 'southeast');
xlabel("Observations collected");
ylabel("Log determinant of the posterior covariance matrix");
set(gcf,'color','w');

title(title_labels{2});

%% All data

% Plot settings
model = 1;
columns = {1, 5};
col = {[0 0.4470 0.7410], [0.8500 0.3250 0.0980]};

xlims = {[0 0.4], [0 0.6]};
ylims = {[0 1.2], [0 0.5]};


for index = 1:2
    
    x1 = meshgrid(0:0.01:1);
    x2 = x1';
    xi = [x1(:), x2(:)];
    
    f6 = figure;
    
    set(f6, ...
        'DefaultFigureColor', 'w', ...
        'DefaultAxesLineWidth', 0.5, ...
        'DefaultAxesXColor', 'k', ...
        'DefaultAxesYColor', 'k', ...
        'DefaultAxesFontUnits', 'points', ...
        'DefaultAxesFontSize', 8, ...
        'DefaultAxesFontName', 'Helvetica', ...
        'DefaultLineLineWidth', 1, ...
        'DefaultTextFontUnits', 'Points', ...
        'DefaultTextFontSize', 8, ...
        'DefaultTextFontName', 'Helvetica', ...
        'DefaultAxesBox', 'off', ...
        'DefaultAxesTickLength', [0.02 0.025]);
    
    dim = size(x1, 1);
    
    x = exp(all_theta(:,1,1,columns{index}));
    y = exp(all_theta(:,2,1,columns{index}));
    f = mvksdensity([x, y], xi,'Bandwidth',0.06);
    Z = reshape(f, [dim, dim]);
    [~, c] = contour(x1, x2, Z, 50, '--');
    c.LineWidth = 0.3;
    c.Color = col{index};
    c.LineStyle = ':';
    
    hold on;
    grid on;
    
    
    x = exp(all_theta(:,1,1,columns{index}+1));
    y = exp(all_theta(:,2,1,columns{index}+1));
    f = mvksdensity([x, y], xi,'Bandwidth',0.03);
    Z = reshape(f, [dim, dim]);
    [~, c2] = contour(x1, x2, Z, 30, '--');
    c2.LineWidth = 1;
    c2.Color = col{index};
    c2.LineStyle = '--';
    
  
    x = exp(all_theta(:,1,1,columns{index}+2));
    y = exp(all_theta(:,2,1,columns{index}+2));
    f = mvksdensity([x, y], xi,'Bandwidth',0.03);
    Z = reshape(f, [dim, dim]);
    [~, c3] = contour(x1, x2, Z, 30, '--');
    c3.LineWidth = 0.3;
    c3.Color = col{index};
    c3.LineStyle = '-';
    
    x = exp(all_theta(:,1,1,columns{index}+3));
    y = exp(all_theta(:,2,1,columns{index}+3));
    f = mvksdensity([x, y], xi,'Bandwidth',0.03);
    Z = reshape(f, [dim, dim]);
    [~, c4] = contour(x1, x2, Z, 30, '--');
    c4.LineWidth = 2;
    c4.Color = [0.9290, 0.6940, 0.1250];
    c4.LineStyle = '-.';
    
    
    
    xlabel("a");
    ylabel("T_h");
    set(gcf,'color','w');
    legend("Pilot study","Adaptive design", "Baseline design", "All data")
    xlim(xlims{index});
    ylim(ylims{index});
    

end






