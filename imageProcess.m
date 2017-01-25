% Function for preprocess our live test picture, only for one single digit
function [img] = imageProcess(number,i)
% First read the digit pic based on input
img=imread(strcat('digit/single/black_num',int2str(number),'_',int2str(i),'.jpeg'));

%Default setting was 1, but I think 2 looks better.
se=strel('disk',1);
%Reduce noise based on se setting
img=imopen(img,se);
% img=imclose(img,se);
img=imerode(img,se);
% Makes black to white and white to black
img=~img;
% Make it square by filling up it with black blocks.
img=makeSquare(img);
% figure,imshow(img,'InitialMagnification','fit');
% Resize it
img=imresize(img,[32,32]);
% Uncomment it if you want to see the graph
% figure,imshow(img,'InitialMagnification','fit');
end


% Return an image with center the image, but the left and right are the
% black blocks
function [img] = makeSquare(m)

yLength=size(m,1);
xLength=size(m,2);
% If we have y length larger;
if yLength>xLength
    fillLength=floor((yLength-xLength)/2);
    leftFillLength=fillLength;
    rightFillLength=fillLength;
    %     Make up for odd number
    if (yLength-xLength)/2 ~= fillLength
        leftFillLength =fillLength;
        rightFillLength=fillLength+1;
    end
    %     img=[black m black]
    img=[zeros(yLength,leftFillLength),m,zeros(yLength,rightFillLength)];
    % If we have x length larger;
elseif yLength<xLength
    fillLength=floor((xLength-yLength)/2);
    topFillLength=fillLength;
    bottomFillLength=fillLength;
    %     Make up for odd number
    if (yLength-xLength)/2 ~= fillLength
        topFillLength =fillLength;
        bottomFillLength=fillLength+1;
    end
    %      img=[black; m ;black]
    img=[zeros(topFillLength,xLength);m;zeros(bottomFillLength,xLength)];
else
    img=m;
end



end