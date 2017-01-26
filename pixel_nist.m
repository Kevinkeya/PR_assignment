clc
clear
close all

% Suppressing warning
warning('off','all')

addpath('prtools')
addpath('coursedata')



%%
% This is for "vl_hog"...

% http://www.vlfeat.org/download.html
% Only need to run this at first time when you start up MATLAB
% Please uncomment the following two lines.
% run('vlfeat-0.9.20/toolbox/vl_setup')
% vl_version verbose

%%
%Set scenario
% scenario1: 10*200 in this case
scenario=1;

%Set online test, true if you want online test.
live=true;
method=1

%Default setting
load_interval=5;
loadRatio=5;


% scenario2: 10*10 in this case
if scenario==2
    load_interval=100;
    loadRatio=100;
end

% Using to store time, can be any dimension array.
t=zeros(7,1);

%start counting time
tic;

% prnist_data = prnist([0:9],[1:load_interval:1000]);
prnist_data = prnist([0:9],[1:1000/loadRatio]);

% Generating dataset with HOG as features
dataset=my_rep_pixel_nist(prnist_data);

% First time
t(1)=toc;

%Here you can choose different classfiers

% Choose classifier!

% Choose!!!

% With PCA:
%varFrac = 0.97;
%s = scalem([],'variance')*pcam([],varFrac)*ldc(); 
%W = dataset*s;

% Without PCA
s = knnc(); 
W = dataset*s;




% Second time gap, usually as the training time
t(2)=toc-t(1);



%Test Error from benchwork
error1=nist_eval('my_rep_pixel_nist',W,100);

% Test error from Live test.
if live == true
    liveDate=getLiveData(method);
    errorLive1=testc(liveDate*W);
  %  errorLive2=testc(liveDate*W2);
  %  errorLive3=testc(liveDate*W3);
  %  votec_errorLive=testc(liveDate*cvote);
  %  maxc_errorLive=testc(liveDate*cmax);
  %  error_combinedLive =  min(votec_errorLive,maxc_errorLive);
   
end

% To remove waiting bar
prwaitbar off;