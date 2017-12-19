function plot_fft(membrane_potential)

    L = 40000/0.5;
    y = fft(membrane_potential,L);
    p2 = abs(y/L);
    p1 = p2(1:L/2+1);
    p1(2:end-1) = 2*p1(2:end-1);
    f = 40000*(0:L/2)/L;
    figure()
    plot(f,p1);
    xlabel('f (Hz)');
    xlim([0,2000])
    ylabel('|P1(f)|');
end

