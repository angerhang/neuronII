load('data.mat');

indices = getIdx(data);
AP_rates = zeros(size(indices));
AP_thresholds = zeros(size(indices));
AP_amplitudes = zeros(size(indices));
AP_widths = zeros(size(indices));
AP_repo_p =  zeros(size(indices));
Vm_mean = zeros(size(indices));
Vm_sd = zeros(size(indices));
results = {};
results{1} = {};
threshold = -20;
diff_threshold = 10;
rise_time = 0.5;

for i = 1:length(indices)
    membrane_potential = data.Trial_MembranePotential{indices(i)};
    AP_rates(i) = AP_firing_rates(membrane_potential,threshold);
    results{1}{i} = data.Mouse_Name{indices(i)};
    [AP_thresholds(i), ~] = compute_AP_threshold(membrane_potential, threshold, diff_threshold, rise_time);
    AP_repo_p(i) = compute_repo_period(membrane_potential, threshold, diff_threshold, rise_time, AP_thresholds(i));
end

results{2} = AP_rates';
results{3} = AP_thresholds';
results{4} = AP_amplitudes';
results{5} = AP_widths';
results{6} = AP_repo_p';

repo_ps_to_show = zeros(5,4);

% storing repolarization periods
repo_ps_to_show(:,1) = [AP_repo_p(2);AP_repo_p(1);AP_repo_p(3:5)];
repo_ps_to_show(:,2) = [AP_repo_p(6:9);AP_repo_p(20)];
repo_ps_to_show(:,3) = [AP_repo_p(15:19)];
repo_ps_to_show(:,4) = [AP_repo_p(10:14)];
