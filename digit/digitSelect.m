clc
clear
close all
A=imread('digit_init.jpeg');

%rotate first
B=imrotate(A,270);
%Make it grey
C=rgb2gray(B);
%We have a cell array
part=cell([10,1]);

% figure,imshow(C);

%Now each part is one digit
part{1}=C(800:1080,190:2750);
part{2}=C(1080:1350,190:2750);
part{3}=C(1350:1600,190:2750);
part{4}=C(1600:1880,190:2750);
part{5}=C(1880:2130,190:2750);
part{6}=C(2130:2380,190:2800);
part{7}=C(2380:2640,190:2750);
part{8}=C(2640:2900,190:2750);
part{9}=C(2900:3180,190:2750);
part{10}=C(3180:3450,190:2750);

for i=1:10
    imwrite(part{i},strcat('separate/grey',int2str(i-1),'.jpeg'))
    imwrite(imbinarize(part{i}),strcat('separate/black',int2str(i-1),'.jpeg'))
end





% Black and white
% D=imbinarize(C);
% imshow(D);
% imwrite(D,'blackGlobal.jpeg')


