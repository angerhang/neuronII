function [amplitude, width] = compute_width(membrane_potential, threshold, diff_threshold, rise_time)
    [~,peak_times] = findpeaks(membrane_potential,'MinPeakHeight', threshold);
    derivative = 40*diff(membrane_potential);
    start_times = find(derivative>diff_threshold);
    counter = 0;
    rise_time = rise_time*40;
    final_results = [];
    

    half_times_ones = [];
    half_times_twos = [];
    real_amp = [];
    for i=1:length(peak_times)
        idx = start_times(start_times>(peak_times(i)-rise_time) & start_times<peak_times(i));
        if isempty(idx)
            disp('Membrane potential not found');
        else
            amplitude = membrane_potential(peak_times(i))-membrane_potential(idx(1));
            real_amp =  [real_amp ; membrane_potential(peak_times(i)) - amplitude / 2];
            half_time_1 = idx(1) + find(membrane_potential(idx(1):peak_times(i)) > membrane_potential(idx(1)) + amplitude/2,1,'first');
            half_time_2 = peak_times(i) + find(membrane_potential(peak_times(i):min(length(membrane_potential),peak_times(i)+100*rise_time)) < membrane_potential(idx(1)) + amplitude/2,1,'first');
            half_times_ones = [half_times_ones; half_time_1];
            half_times_twos = [half_times_twos; half_time_2];
            width = half_time_2 - half_time_1;
            final_results = [final_results; idx(1) amplitude width];
            counter = counter + 1;
        end
    end

    figure()
    plot(membrane_potential,'k')
    hold on; 
    
  
    for i=1:size(half_times_ones, 1) 
        a = [half_times_ones(i), real_amp(i)];
        b =  [half_times_twos(i), real_amp(i)];
        xq =  a(1):1:b(1);
        vq1 = interp1([a(1) b(1)], [a(2) b(2)], xq);
        plot([a(1) b(1)], [a(2) b(2)], 'o',xq,vq1,':.');
        scatter([a(1) b(1)], [a(2) b(2)])
    end
    
    amplitude = mean(final_results(:,2));
    width = mean(final_results(:,3))/40;
end
