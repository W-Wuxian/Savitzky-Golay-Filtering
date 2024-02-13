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

path="~/Bureau/GitHub_repo/Savitzky-Golay-Filtering/data/output/signal_zlens"

def = figure;
for i = 1:ncols
    subplot(3,6,i);
    x = data(:, i);
    x_max = max(x);
    y = sgolayfilt(x/x_max, polynomial_order, framelen);
    plot(x/x_max,'b');
    hold("on");
    plot(y,'r');
    txt = sprintf('curve %i',i);
    txt = strcat('filtered signal', txt);
    txt = strcat('default ', txt);
    title(txt);
    grid;
end
saveas(def, strcat(path,"/default"), "pdf");
savefig(def, strcat(path,"/default"));
hold off;

classic = figure;
for i = 1:ncols
    subplot(3,6,i);
    x = data(:, i);
    x_max = max(x);
    y = sgolayfilt(x/x_max, polynomial_order, framelen, "classic");
    plot(x/x_max,'b');
    hold("on");
    plot(y,'r');
    txt = sprintf('curve %i',i);
    txt = strcat('filtered signal', txt);
    txt = strcat('classic', txt);
    grid;
end
saveas(classic, strcat(path,"/classic"), "pdf");
savefig(classic, strcat(path,"/classic"));
hold off;

near = figure;
for i = 1:ncols
    subplot(3,6,i);
    x = data(:, i);
    x_max = max(x);
    y = sgolayfilt(x/x_max, polynomial_order, framelen, "nearest");
    plot(x/x_max,'b');
    hold("on");
    plot(y,'r');
    txt = sprintf('curve %i',i);
    txt = strcat('filtered signal', txt);
    txt = strcat('nearest-trst', txt);
    title(txt);
    grid;
end
saveas(near, strcat(path,"/nearest"), "pdf");
savefig(near, strcat(path,"/nearest"));
hold off;

near2 = figure;
for i = 1:ncols
    subplot(3,6,i);
    x = data(:, i);
    x_max = max(x);
    y = sgolayfilt(x/x_max, polynomial_order, framelen, "nearest","no");
    plot(x/x_max,'b');
    hold("on");
    plot(y,'r');
    txt = sprintf('curve %i',i);
    txt = strcat('filtered signal', txt);
    txt = strcat('nearest-notrst', txt);
    title(txt);
    grid;
end
saveas(near2, strcat(path,"/nearest-no-trst"), "pdf");
savefig(near2, strcat(path,"/nearest-no-trst"));
