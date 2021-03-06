clc;
clear all;
close all;
set(0,'defaultlinelinewidth',1.5);
x=[4 16 64];
c=[54.97 54.62 54.46];
l=[56.51 56.16 56.00];
w=[55.89 55.56 55.38];
figure;
plot(x,c,'r-o',x,l,'g-o',x,w,'-o');
legend('cameraman','lena','wbarb');
title('DWT graphs');
xlabel('no.of.coeff----->');
ylabel('PSNR---->');