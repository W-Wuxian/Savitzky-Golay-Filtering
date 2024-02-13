% Gathering signal's file informations
fileID     = fopen("signal_zlens.txt","r");
formatSpec = '%f';
sizex      = [1 inf];
abs_X = 0.0:0.025:0.8;
% Savitzky-Golay parameters
polynomial_order = 7;
framelen         = 13;
derivative_order = 1;
% Reading from a file the input signal to be filtered
%x = fscanf(fileID,formatSpec, sizex);
data=load("signal_zlens.txt");
data_size = size(data);
nrows = data_size(1,1);
ncols = data_size(1,2);

for i = 1:ncols
    subplot(3,6,i);
    x = data(:, i);
    x_max = max(x);
    y = sgolayfilt(x/x_max, polynomial_order, framelen);
    %figure;
    plot(x/x_max,'b');
    hold("on");
    plot(y,'r');
    txt = sprintf('curve %i',i);
    txt = strcat('filtered signal', txt);
    txt = strcat('default ', txt);
    title(txt);
    le = [le, txt];
    %legend('signal', txt);
    %hold("on");
    grid;
end
hold off;
figure;
for i = 1:ncols
    subplot(3,6,i);
    x = data(:, i);
    x_max = max(x);
    y = sgolayfilt(x/x_max, polynomial_order, framelen, "classic");
    %figure;
    plot(x/x_max,'b');
    hold("on");
    plot(y,'r');
    txt = sprintf('curve %i',i);
    txt = strcat('filtered signal', txt);
    txt = strcat('classic', txt);
    title(txt);
    le = [le, txt];
    %legend('signal', txt);
    %hold("on");
    grid;
end
hold off;
figure;
for i = 1:ncols
    subplot(3,6,i);
    x = data(:, i);
    x_max = max(x);
    y = sgolayfilt(x/x_max, polynomial_order, framelen, "nearest");
    %figure;
    plot(x/x_max,'b');
    hold("on");
    plot(y,'r');
    txt = sprintf('curve %i',i);
    txt = strcat('filtered signal', txt);
    txt = strcat('nearest-trst', txt);
    title(txt);
    le = [le, txt];
    %legend('signal', txt);
    %hold("on");
    grid;
end
hold off;
figure;
for i = 1:ncols
    subplot(3,6,i);
    x = data(:, i);
    x_max = max(x);
    y = sgolayfilt(x/x_max, polynomial_order, framelen, "nearest","no");
    %figure;
    plot(x/x_max,'b');
    hold("on");
    plot(y,'r');
    txt = sprintf('curve %i',i);
    txt = strcat('filtered signal', txt);
    txt = strcat('nearest-notrst', txt);
    title(txt);
    le = [le, txt];
    %legend('signal', txt);
    %hold("on");
    grid;
end
