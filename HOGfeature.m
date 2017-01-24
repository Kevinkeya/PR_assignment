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

load_interval=5;
loadRatio=5;

% scenario2: 10*10 in this case
if scenario==2
    load_interval=100;
    loadRatio=100;
end

% prnist_data = prnist([0:9],[1:load_interval:1000]);
prnist_data = prnist([0:9],[1:1000/loadRatio]);
% Generating HOC as the dataset 
dataset=my_rep(prnist_data);


%Here you can choose different classfiers
s = parzenc();
s2 = fisherc();
s3 = knnc([],2);

% Combined classfier
W = dataset*s;
W2 = dataset*s2;
W3 = dataset*s3;
W_array=[W W2 W3];
cvote=W_array*votec;%votec
cmax=W_array*maxc;

%Test Error
error1=nist_eval('my_rep',W,100)
error2=nist_eval('my_rep',W2,100)
error3=nist_eval('my_rep',W3,100)
vote_error=nist_eval('my_rep',cvote,100)
max_error=nist_eval('my_rep',cmax,100)
error_test_temp =  min(vote_error,max_error)


% To remove waiting bar
prwaitbar off;