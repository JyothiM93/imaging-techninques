clc;
clear all;
close all;
[fname pname]=uigetfile('*.jpg','select the Cover Image');
imageinput=imread(fname);
A=rgb2gray(imageinput);
img=im2double(A);
img=imresize(img,[1024 1024]);
imshow(img);
figure(1);
title('original image');
n=4;
%------------3 Level DWT for cover image----------------------------
mask2=[1 0;0 0];
mask1=[1 1 0 0;1 0 0 0;0 0 0 0 ;0 0 0 0];
mask = [1   1   1   1   0   0   0   0
        1   1   1   0   0   0   0   0
        1   1   0   0   0   0   0   0
        1   0   0   0   0   0   0   0
        0   0   0   0   0   0   0   0
        0   0   0   0   0   0   0   0
        0   0   0   0   0   0   0   0
        0   0   0   0   0   0   0   0];
B2 = blockproc(img,[n n],@(block_struct) mask1 .* block_struct.data);
[LL,LH,HL,HH] = dwt2(B2,'bior4.4');
a=[LL,LH;HL,HH];
figure;subplot(1,3,1);imshow(a);title('1st level');
[LL1,LH1,HL1,HH1] = dwt2(LL,'bior4.4');
aa1=[LL1,LH1;HL1,HH1];
subplot(1,3,2);imshow(aa1);title('after 2nd level');
[LL2,LH2,HL2,HH2] = dwt2(LL1,'bior4.4');
aa2=[LL2,LH2;HL2,HH2];
subplot(1,3,3);imshow(aa2);
LL2=imresize(LL2,[256 256]);
title('3 level dwt of cover image');
LL2=imresize(LL2,[135 135]);
figure, imshow([LL2 LH2;HL2,HH2]); title('compressed image');
%----------idwt------------------------------------------------
ret1=idwt2(LL2 ,LH2, HL2, HH2,'bior4.4');
ret2=idwt2(ret1 ,LH1, HL1, HH1,'bior4.4');
ret3=idwt2(ret2 ,LH, HL, HH,'bior4.4');
figure;
imshow(ret3);
title('reconstructed image');

%----------Calculation of Mean Square Error-----------------------
mseimage=(ret3-img).^2;
[rows columns]=size(img);
mse=sum(mseimage(:))/(rows*columns);
disp('mse=');
disp(mse);

%-----calculation of peak signal to noise ratio(PSNR)------------
psnr_value=(10*log10(255^2)-10*log10(mse));
disp('PSNR=');
disp(psnr_value);
