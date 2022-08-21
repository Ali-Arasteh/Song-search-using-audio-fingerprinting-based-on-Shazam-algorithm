function single_sided_power_spectrum = FFT(X)
    L = length(X);
    % fft of the signal
    fft_X = fft(X);
    % get magnitude of the components
    fft_X = (abs(fft_X)/L).^2;
    % one-sided spectrum
    single_sided_power_spectrum = fft_X(1:floor(L/2)+1);
    single_sided_power_spectrum(2:end-1) = 2*single_sided_power_spectrum(2:end-1);
end