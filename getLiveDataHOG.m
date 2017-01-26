%Return prdataset with HOG as features
function [dataset] = getLiveDataHOG(method_num)

addpath('/prtools')
addpath('/coursedata')

warning('off','all')
digit=cell([10,10]);

hogAll=[];

for number=0:9
    for i=1:10
        digit{number+1,i}=imageProcess(number,i,32);
        
        %         Same method should be chosen as my_rep, since feature dimension
        %         should be agreed with each other
        if method_num==1
            %     1.vl_hog
            cellSize=8;
            hog = vl_hog(single(digit{number+1,i}), cellSize, 'verbose','variant', 'dalaltriggs');
            hog = hog(:)';
            
        elseif method_num==2
            %     2.extractHOGFeatures build_in function
            hog = extractHOGFeatures(single(digit{number+1,i}), 'CellSize', [8 8]);
        else
            %     3. HOG Download code
            hog = HOG(digit{number+1,i})';
        end
        hogAll=[hogAll;hog] ;
    end
    
end
% Generating labels
labels=[];
for i=0:9
    labels=[labels;genlab(10,strcat('digit_',int2str(i))) ];
end

dataset = prdataset(double(hogAll), labels);

end

