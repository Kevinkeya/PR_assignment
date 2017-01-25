clc
clear
close all
digitColumn=cell([10,1])


for i=1:10
    digitColumn{i}=imread(strcat('separate/grey',int2str(i-1),'.jpeg'))
end

% figure,imshow(digitColumn{1});

currentNum=1;


readIndex=currentNum+1;
digit=cell([10,10]);
columnSize=size(digitColumn{readIndex});
len=columnSize(2);

for i=1:10
    figure,imshow(digitColumn{readIndex});
    [x,y] = ginput(2);
    digit{1,i}=digitColumn{readIndex}(y(1):y(2),x(1):x(2));
    imwrite(digit{1,i},strcat('single/grey_num',int2str(currentNum),'_',int2str(i),'.jpeg'))
    imwrite(imbinarize(digit{1,i}),strcat('single/black_num',int2str(currentNum),'_',int2str(i),'.jpeg'))
    figure,imshow(digit{1,i})
    pause(1.5)
    close all
end


% for i=1:10
%     imwrite(part{i},strcat('separate/black0',int2str(i-1),'.jpeg'))
% end






% D=imbinarize(C);
% imshow(D);
% imwrite(D,'blackGlobal.jpeg')


