% Generate a random signal and smooth it using sgolay. Specify a polynomial order of 3 and a frame length of 11. Plot the original and smoothed signals.

lx = 34;           % lenght
x  = randn(lx, 1); % signal
disp("size(x)");
display(size(x));
% Use sgolay to smooth the signal. Use 11-sample frames and third order polynomials.

order    = 3;
framelen = 11;
frame_half_len = (framelen - 1) / 2;

[FIRFiltersCoeff, MatrixOfDiffFilter, frame_half_len] =  SavitzkyGolayFIR(order, framelen);
% Compute the steady-state portion of the signal by convolving it with the center row of b.
ycenter = conv(x,FIRFiltersCoeff(frame_half_len,:),'same');
%ycenter = conv(x,FIRFiltersCoeff((framelen+1)/2,:),'same');

plot(x,':');
hold on
plot(ycenter,'.-')

%Samples close to the signal edges cannot be placed at the center of a symmetric window and have to be treated differently.
%To determine the startup transient, matrix multiply the first (framelen-1)/2 rows of B by the first framelen samples of the signal.
ybeg = FIRFiltersCoeff(1:frame_half_len,:) * x(1:framelen);
%To determine the terminal transient, matrix multiply the final (framelen-1)/2 rows of B by the final framelen samples of the signal.
yend = FIRFiltersCoeff(framelen-frame_half_len+1:framelen,:) * x(lx-framelen+1:lx);

%Concatenate the transients and the steady-state portion to generate the complete signal.
cmplt                         = ycenter;
cmplt(1:frame_half_len)       = ybeg;
cmplt(lx-frame_half_len+1:lx) = yend;
disp("size(cmplt)");
display(size(cmplt));
plot(cmplt)
legend('Signal','Steady','complete')
