function firing_rates = AP_firing_rates(membrane_potential, delta_t)
    firing_times = find(membrane_potential>-30);
    firing_rates = zeros(size(membrane_potential,1),1);
    for j = 1:size(firing_times,1)
        for t = firing_times(j)-delta_t:firing_times(j)
            if t<0
                continue;
            end
            num_AP = size(find(firing_times<=t+delta_t),1);
            firing_rates(t) = num_AP/delta_t;
        end
    end
end