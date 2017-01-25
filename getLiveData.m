%Return prdataset
function [dataset] = getLiveData()
clc
clear
close all
addpath('/prtools')
addpath('/coursedata')

warning('off','all')
digit=cell([10,10]);
% figure
for number=0:9
    for i=1:10
        digit{number+1,i}=imread(strcat('digit/single/black_num',int2str(number),'_',int2str(i),'.jpeg'));
        %         se=strel('disk',1);
        se=strel('disk',2);
        digit{number+1,i}=imopen(digit{number+1,i},se);
                digit{number+1,i}=imclose(digit{number+1,i},se);
        digit{number+1,i}=~digit{number+1,i};
        %         show(digit{number+1,i})
        %         digit{number+1,i}+
        digit{number+1,i}=imresize(digit{number+1,i},[144,144]);

        imshow(digit{number+1,i},'InitialMagnification','fit');
        
    end
end


% imshow(digit{number+1,i});
% size(digit(:))
m=[];
for i=0:9
    m=[m;genlab(10,strcat('digit_',int2str(i))) ];
end
dataset = prdataset(digit(:), m);



end

