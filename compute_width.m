function [amplitude, width] = compute_width(membrane_potential, threshold, diff_threshold, rise_time)
    [~,peak_times] = findpeaks(membrane_potential,'MinPeakHeight', threshold);
    derivative = 40*diff(membrane_potential);
    start_times = find(derivative>diff_threshold);
    counter = 0;
    rise_time = rise_time*40;
    final_results = [];
    for i=1:length(peak_times)
        idx = start_times(start_times>(peak_times(i)-rise_time) & start_times<peak_times(i));
        if isempty(idx)
            disp("Membrane potential not found");
        else
            amplitude = membrane_potential(peak_times(i))-membrane_potential(idx(1));
            half_time_1 = idx(1) + find(membrane_potential(idx(1):peak_times(i)) > membrane_potential(idx(1)) + amplitude/2,1,'first');
            half_time_2 = peak_times(i) + find(membrane_potential(peak_times(i):min(length(membrane_potential),peak_times(i)+100*rise_time)) < membrane_potential(idx(1)) + amplitude/2,1,'first');
            width = half_time_2 - half_time_1;
            final_results = [final_results; idx(1) amplitude width];
            counter = counter + 1;
        end
    end
    amplitude = mean(final_results(:,2));
    width = mean(final_results(:,3))/40;
end