function [repo_p] = compute_repo_period(membrane_potential, threshold, diff_threshold, rise_time, AP_threshold)
    [~,peak_times] = findpeaks(membrane_potential,'MinPeakHeight', threshold);
    derivative = 40*diff(membrane_potential);
    start_times = find(derivative>diff_threshold);
    counter = 0;
    rise_time = rise_time*40;

    repo_p = [];
    for i=1:length(peak_times)
        idx = start_times(start_times>(peak_times(i)-rise_time) & start_times<peak_times(i));
        if isempty(idx)
            disp('Membrane potential not found');
        else
            amplitude = membrane_potential(peak_times(i))-membrane_potential(idx(1));
            new_repo_p = find(membrane_potential(peak_times(i):min(length(membrane_potential),peak_times(i)+100*rise_time)) < AP_threshold, 1, 'first');
            new_repo_p = find(membrane_potential(peak_times(i):min(length(membrane_potential),peak_times(i)+100*rise_time)) < AP_threshold, 1, 'first');
            repo_p = [repo_p; new_repo_p];
            counter = counter + 1;
        end
    end
    repo_p = mean(repo_p);
    
end
