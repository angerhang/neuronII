function firing_rate = AP_firing_rates(membrane_potential)
%% Finds the mean firing rate for one trial
    dt = 1/40000;
    num_AP = length(findpeaks(membrane_potential,'MinPeakHeight',-30));
    firing_rate = num_AP/(length(membrane_potential)*dt);
end