load mtlb;
t = (0:length(mtlb)-1)/Fs;

rd = 9;
fl = 21;

mirror = sgolayfilt(mtlb,rd,fl,'mirror');
wrap = sgolayfilt(mtlb,rd,fl,'wrap');
classic = sgolayfilt(mtlb,rd,fl,'classic');
default = sgolayfilt(mtlb,rd,fl,'default');

subplot(2,2,1)
plot(t,mtlb)
hold on
plot(t,mirror)
axis([0.2 0.22 -3 2])
title('mirror')
grid

subplot(2,2,2)
plot(t,mtlb)
hold on
plot(t,wrap)
axis([0.2 0.22 -3 2])
title('wrap')
grid

subplot(2,2,3)
plot(t,mtlb)
hold on
plot(t,classic)
axis([0.2 0.22 -3 2])
title('classic')
grid

subplot(2,2,4)
plot(t,mtlb)
hold on
plot(t,default)
axis([0.2 0.22 -3 2])
title('.default')
grid
