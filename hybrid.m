clc;
clear all;
close all;
[fname pname]=uigetfile('*.jpg','select the Cover Image');
imageinput=imread(fname);
n=input('enter the value of n');
A=rgb2gray(imageinput);
imageinput=imresize(imageinput,[256 256]);
img=im2double(A);
img=imresize(img,[1024 1024]);
imshow(img);
figure(1);
title('original image');
%------------3 Level DWT for cover image----------------------------
[LL,LH,HL,HH] = dwt2(img,'bior4.4');
a=[LL,LH;HL,HH];
figure;subplot(1,3,1);imshow(a);title('1st level');
[LL1,LH1,HL1,HH1] = dwt2(LL,'bior4.4');
aa1=[LL1,LH1;HL1,HH1];
subplot(1,3,2);imshow(aa1);title('2nd level');
[LL2,LH2,HL2,HH2] = dwt2(LL1,'bior4.4');
aa2=[LL2,LH2;HL2,HH2];
subplot(1,3,3);imshow(aa2);title('3rd level');
LL2=imresize(LL2,[256 256]); 
%-----------------HyBRID DWT DCT--------------------------------
 T = dctmtx(n);
dct = @(block_struct) T * block_struct.data * T';
B = blockproc(LL2,[n n],dct);
%figure;imshow([B LH2;HL2,HH2]);
mask1=[1 1 1 1 0;1 1 1 0 0 ; 1 1 0 0 0; 1 0 0 0 0 ; 0 0 0 0 0];
mask = [1   1   1   1   0   0   0   0
        1   1   1   0   0   0   0   0
        1   1   0   0   0   0   0   0
        1   0   0   0   0   0   0   0
        0   0   0   0   0   0   0   0
        0   0   0   0   0   0   0   0
        0   0   0   0   0   0   0   0
        0   0   0   0   0   0   0   0];
B2 = blockproc(B,[8 8],@(block_struct) mask .* block_struct.data);
invdct = @(block_struct) T' * block_struct.data * T;
I2 = blockproc(B2,[n n],invdct);
I2=imresize(I2,[135 135]);
 figure, imshow([I2 LH2;HL2,HH2]);
%----------idwt------------------------------------------------
ret1=idwt2(I2 ,LH2, HL2, HH2,'bior4.4');
ret2=idwt2(ret1 ,LH1, HL1, HH1,'bior4.4');
ret3=idwt2(ret2 ,LH, HL, HH,'bior4.4');
figure;
imshow(ret3);

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