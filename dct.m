clc;
close all;
clear all;
[fname pname]=uigetfile('*.jpg','select the Cover Image');
I = imread(fname);
I = imresize(I,[256 256]);
n=input('no.of.coefficients');
I = rgb2gray(I);
I = im2double(I);
T = dctmtx(n);
dct = @(block_struct) T * block_struct.data * T';
B = blockproc(I,[n n],dct);
figure;imshow(I); title('original image');
figure;imshow(B); title('compressed image');
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
figure:imshow(I2); title('reconstructed image');

%----------Calculation of Mean Square Error-----------------------
mseimage=(I-I2).^2;
[rows columns]=size(I);
mse=sum(mseimage(:))/(rows*columns);
disp('mse=');
disp(mse);

%-----calculation of peak signal to noise ratio(PSNR)------------
psnr_value=(10*log10(255^2)-10*log10(mse));
disp('PSNR=');
disp(psnr_value);
