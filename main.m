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
    % [AP_amplitudes(i),AP_widths(i)] = compute_width(membrane_potential, threshold, diff_threshold, rise_time);
    % Vm_mean(i) = mean(membrane_potential);
    % Vm_sd(i) = std(membrane_potential);
end

results{2} = AP_rates';
results{3} = AP_thresholds';
results{4} = AP_amplitudes';
results{5} = AP_widths';
results{6} = AP_repo_p';

amps_to_show = zeros(5,4);
widths_to_show = zeros(5,4);
means_to_show = zeros(5,4);
sds_to_show = zeros(5,4);
repo_ps_to_show = zeros(5,4);

amps_to_show(:,1) = [AP_amplitudes(2);AP_amplitudes(1);AP_amplitudes(3:5)];
amps_to_show(:,2) = [AP_amplitudes(6:9);AP_amplitudes(20)];
amps_to_show(:,3) = [AP_amplitudes(15:19)];
amps_to_show(:,4) = [AP_amplitudes(10:14)];

widths_to_show(:,1) = [AP_widths(2);AP_widths(1);AP_widths(3:5)];
widths_to_show(:,2) = [AP_widths(6:9);AP_widths(20)];
widths_to_show(:,3) = [AP_widths(15:19)];
widths_to_show(:,4) = [AP_widths(10:14)];

means_to_show(:,1) = [Vm_mean(2);Vm_mean(1);Vm_mean(3:5)];
means_to_show(:,2) = [Vm_mean(6:9);Vm_mean(20)];
means_to_show(:,3) = [Vm_mean(15:19)];
means_to_show(:,4) = [Vm_mean(10:14)];

sds_to_show(:,1) = [Vm_sd(2);Vm_sd(1);Vm_sd(3:5)];
sds_to_show(:,2) = [Vm_sd(6:9);Vm_sd(20)];
sds_to_show(:,3) = [Vm_sd(15:19)];
sds_to_show(:,4) = [Vm_sd(10:14)];

repo_ps_to_show(:,1) = [AP_repo_p(2);AP_repo_p(1);AP_repo_p(3:5)];
repo_ps_to_show(:,2) = [AP_repo_p(6:9);AP_repo_p(20)];
repo_ps_to_show(:,3) = [AP_repo_p(15:19)];
repo_ps_to_show(:,4) = [AP_repo_p(10:14)];