%Return prdataset
function [dataset] = getLiveData()

addpath('/prtools')
addpath('/coursedata')

warning('off','all')
digit=cell([10,10]);

for number=0:9
    for i=1:10
        digit{number+1,i}=imageProcess(number,i); 
%         imshow(digit{number+1,i})
    end
    
end


labels=[];
% Generating labels
for i=0:9
    labels=[labels;genlab(10,strcat('digit_',int2str(i))) ];
end

dataset = prdataset(digit(:), labels);



end

