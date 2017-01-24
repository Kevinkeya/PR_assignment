function [dataset] = my_rep(m)

addpath('/prtools')
addpath('/coursedata')

warning('off','all')

% Remove all empty rows, columns
a=m;
a = m*im_box([],0);

% add a bounding box to the images to make it square.
a = a*im_box([],0,1);

% Change data to image, so we can apply HOG to it.
arrayCell = data2im (a);

hogAll=[];

% arrayCell{i} is one number image, the the length arrayCell is of how
% many digit do we have in the training set.

% The following is three different codes of extracting HOG feature,
% the first 1 "vl_hog" is not steady, but sometimes it has a very low error.
% The second one "extractHOGFeatures" is the most steady one.
% The third one "HOG.m" is really bad.

for i = 1:length(arrayCell)
    arrayCell{i}=arrayCell{i}*im_resize([],[32,32]);
    %     1.vl_hog
    %     cellSize=8;
    %     hog = vl_hog(single(arrayCell{i}), cellSize, 'verbose','variant', 'dalaltriggs');
    %     hog = vl_hog(single(arrayCell{i}), cellSize, 'verbose');
    %     hog = hog(:)';
    
    
    %     2.extractHOGFeatures build_in function
    hog = extractHOGFeatures(single(arrayCell{i}), 'CellSize', [8 8]);
    %     3. HOG Download code
    %         hog = HOG(arrayCell{i})';
    
    hogAll=[hogAll;hog] ;
end


% Generating new dataset and get labels
dataset = prdataset(double(hogAll), getlabels(m));



end

