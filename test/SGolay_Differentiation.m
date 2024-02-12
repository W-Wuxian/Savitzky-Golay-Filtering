% Generate a signal that consists of a 0.2 Hz sinusoid embedded in white Gaussian noise and sampled four times a second for 20 seconds.
dt    = 0.25;
t     = (0:dt:20-1)';
freq  = 0.2;          % frequency
omega = 2.0*pi*freq;  % pulsation i.e angular frequency, omega*t angle in radians.
Amp   = 5.0;          % Amplitude
x     = Amp*sin(omega*t)+0.5*randn(size(t));
disp("size(x)");
display(size(x));
% Estimate the first three derivatives of the sinusoid using the Savitzky-Golay method. Use 25-sample frames and fifth order polynomials. Divide the columns by powers of dt to scale the derivatives correctly.
order    = 5
framelen = 25;
[FIRFiltersCoeff, MatrixOfDiffFilter, frame_half_len] =  SavitzkyGolayFIR(order, framelen);
display(frame_half_len);
dx = zeros(length(x),4);
for p = 0:3
    display("p")
    disp(p)
    display("factorial")
    disp(factorial(p))
    display("(-dt)^p")
    disp((-dt)^p)
    display("factorial(p)/(-dt)^p)")
    disp(factorial(p)/(-dt)^p)
    display("------------------------------------------------")
    coeff = factorial(p)/(-dt)^p;
    dx(:,p+1) = conv(x, coeff * MatrixOfDiffFilter(:,p+1), 'same');
end
% Plot the original signal, the smoothed sequence, and the derivative estimates.
plot(x,'.-')
hold on
plot(dx)
hold off

legend('x','x (smoothed)','x''','x''''', 'x''''''')
title('Savitzky-Golay Derivative Estimates')
