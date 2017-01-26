%Return prdataset
% Type can be 'imfeature' or 'pixel'
function [dataset] = getLiveData(feat_size,type)

addpath('/prtools')
addpath('/coursedata')

warning('off','all')
digit=cell([10,10]);

for number=0:9
    for i=1:10
        digit{number+1,i}=imageProcess(number,i,feat_size);
        %         imshow(digit{number+1,i})
    end
    
end


labels=[];
% Generating labels
for j=0:9
    for i=0:9
        labels=[labels;genlab(1,strcat('digit_',int2str(i))) ];
    end
end
test=digit(:);
dataset = prdataset(digit(:), labels);

% for i=1:5
%     figure,imshow(single(digit{i}));
% end

if(type=='imfeature')
    dataset = im_features(dataset, 'all');
end


end

