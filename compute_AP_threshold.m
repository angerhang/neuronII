function AP_threshold = compute_AP_threshold(membrane_potential, threshold, diff_threshold, rise_time)
    [~,peak_times] = findpeaks(membrane_potential,'MinPeakHeight', threshold);
    derivative = 40*diff(membrane_potential);
    start_times = find(derivative>diff_threshold);
    AP_threshold = 0;
    counter = 0;
    rise_time = rise_time*40;
    final_results = [];
    for i=1:length(peak_times)
        idx = start_times(start_times>(peak_times(i)-rise_time) & start_times<peak_times(i));
        if isempty(idx)
            disp("Membrane potential not found");
        else
            final_results = [final_results; idx(1) membrane_potential(idx(1))];
            AP_threshold = AP_threshold + membrane_potential(idx(1));
            counter = counter + 1;
        end
    end
    AP_threshold = AP_threshold/counter;
    figure()
    hold on;
    plot(membrane_potential,'k')
    scatter(final_results(:,1),final_results(:,2),'ro'); 
end