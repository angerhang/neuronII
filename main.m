% load('data.mat');

indices = getIdx(data);
AP_rates = zeros(size(indices));
AP_thresholds = zeros(size(indices));
AP_results = {};
AP_results{1} = {};
threshold = -20;
diff_threshold = 10;
rise_time = 0.5;

for i = 1:length(indices)
    membrane_potential = data.Trial_MembranePotential{indices(i)};
    AP_rates(i) = AP_firing_rates(membrane_potential,threshold);
    AP_results{1}{i} = data.Mouse_Name{indices(i)};
    AP_thresholds(i) = compute_AP_threshold(membrane_potential, threshold, diff_threshold, rise_time);
end

AP_results{2} = AP_rates';
AP_results{3} = AP_thresholds';