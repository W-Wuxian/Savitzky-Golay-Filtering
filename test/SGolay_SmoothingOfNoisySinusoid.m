% Generate a signal that consists of a 0.2 Hz sinusoid embedded in white Gaussian noise and sampled five times a second for 200 seconds.

dt    = 1.0/5.0;
LB    = 0.;
UB    = 200.;
t     = (LB:dt:UB-dt)';
freq  = 0.2;             % frequency Hz
omega = 2.0*pi*freq;     % angular frequency (pulsation) rad/s
Amp   = 5.0;             % amplitude
x     = Amp*sin(omega*t) + randn(size(t));

% Use sgolay to smooth the signal. Use 21-sample frames and fourth order polynomials.

order    = 4;
framelen = 21;

[FIRFiltersCoeff, MatrixOfDiffFilter] =  SavitzkyGolayFIR(order, framelen); %sgolay(order, framelen);
% Compute the steady-state portion of the signal by convolving it with the center row of b.
ycenter = conv(x,FIRFiltersCoeff((framelen+1)/2,:),'valid');
%Compute the transients. Use the last rows of b for the startup and the first rows of b for the terminal.
ybegin = FIRFiltersCoeff(end:-1:(framelen+3)/2,:) * x(framelen:-1:1);
yend = FIRFiltersCoeff((framelen-1)/2:-1:1,:) * x(end:-1:end-(framelen-1));
%Concatenate the transients and the steady-state portion to generate the complete smoothed signal. Plot the original signal and the Savitzky-Golay estimate.
y = [ybegin; ycenter; yend];
plot([x y])
legend('Noisy Sinusoid','S-G smoothed sinusoid')
