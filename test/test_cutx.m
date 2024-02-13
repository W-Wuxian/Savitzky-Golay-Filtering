% Gathering signal's file informations
fileID     = fopen("cut_x.txt","r");
formatSpec = '%f';
sizex      = [1 Inf];
% Savitzky-Golay parameters
polynomial_order = 3;
framelen         = 11;
derivative_order = 1;
% Reading from a file the input signal to be filtered
x = fscanf(fileID,formatSpec, sizex);
x_max = max(x);

% Filtering Normalized (Norm 1) input signal using SavitzkyGolay Method
y = sgolayfilt(x/x_max, polynomial_order, framelen,'classic');
% Ploting Normalized input signal
plot(x/x_max,':');
hold("on");
% Ploting output/filtered signal
plot(y,':');
legend('signal', 'filtered signal with 0-th derivative');
