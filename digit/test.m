clc
clear
close all
digitColumn=cell([10,1])


for i=1:10
    digitColumn{i}=imread(strcat('separate/black',int2str(i-1),'.jpeg'))
end

I = digitColumn{i};
% 
% figure,imshow(I);
% 
% seg = regionprops( I.', 'Image' ); %'// transpose input mask
% seg = arrayfun( @(x) x.Image.', seg, 'Uni', 0 ); %'// flip back


