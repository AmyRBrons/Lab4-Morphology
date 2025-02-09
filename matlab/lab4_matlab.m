%Task 1: Dilation and Erosion
%Dilation Operation
A = imread('assets/text-broken.tif');
B1 = [0 1 0;
     1 1 1;
     0 1 0];  
A1 = imdilate(A, B1);
montage({A,A1})


%Changed the structuring element to 1's
A = imread('assets/text-broken.tif');
B1 = ones(3,3);   
A1 = imdilate(A, B1);
montage({A,A1})

%Making the SE larger and diagonal
A = imread('assets/text-broken.tif');
B1 = [1 0 1;
    0 1 0;
    1 0 1];
A1 = imdilate(A, B1);
montage({A,A1})

%What happens if you dilate the original image with B1 twice (or more times)?
A = imread('assets/text-broken.tif');
B1 = [0 1 0;
     1 1 1;
     0 1 0];    
A1 = imdilate(A, B1);
A2 = imdilate(A1,B1);
A3 = imdilate(A2,B1);
montage({A,A1,A2,A3})

%Generate SE
SE = strel('disk',4);
SE.Neighborhood

%Erosion Operation
clear all
close all
A = imread('assets/wirebond-mask.tif');
SE2 = strel('disk',2);
SE10 = strel('disk',10);
SE20 = strel('disk',20);
E2 = imerode(A,SE2);
E10 = imerode(A,SE10);
E20 = imerode(A,SE20);
montage({A, E2, E10, E20}, "size", [2 2])

%Task 2: Morphological Filtering with Open and Close

%Opening = Erosion and Dialation
f = imread('assets/fingerprint-noisy.tif');
SE = strel('disk',3);
fe = imerode(f,SE);
fed = imdilate(fe,SE);
fo = imopen(fed,SE);
montage({f, fe, fed, fo}, "size", [2 2])

%Using an ones SE
f = imread('assets/fingerprint-noisy.tif');
SE =ones(3,3);
fe = imerode(f,SE);
fed = imdilate(fe,SE);
fo = imopen(fed,SE);
montage({f, fe, fed, fo}, "size", [2 2])

%Using an array SE
f = imread('assets/fingerprint-noisy.tif');
SE =[0 1 0;
    1 1 1 ;
    0 1 0];
fe = imerode(f,SE);
fed = imdilate(fe,SE);
fo = imopen(fed,SE);
montage({f, fe, fed, fo}, "size", [2 2])

%Improve fo with a close operation
f = imread('assets/fingerprint-noisy.tif');
SE = ones(3,3);
fe = imerode(f,SE);
fed = imdilate(fe,SE);
fo = imopen(fed,SE);
fo = imclose(fo,SE);
montage({f, fe, fed, fo}, "size", [2 2])

%Compare morphological filtering to a gaussian filter
f = imread('assets/fingerprint-noisy.tif');
SE = ones(3,3);
fe = imopen(f,SE);
fo = imclose(fe,SE);
gaus = fspecial('Gaussian', [7 7], 1.0)
fu = imfilter(f,gaus,0);
montage({fo, fu})


%Task 3: Boundary Detection
%Turn binary
I = imread('assets/blobs.tif');
I = imcomplement(I);
level = graythresh(I);
BW = imbinarize(I, level);
imshow(BW)

%Diplay as montage {I, BW, erosed BW and boundary detected image}
I = imread('assets/blobs.tif');
I = imcomplement(I);
level = graythresh(I);
BW = imbinarize(I, level); 
SE = ones(3,3);
BW_eroded = imerode(BW, SE);
BW_boundary = BW - BW_eroded;
montage({I,BW,BW_eroded,BW_boundary})

%Task 4: Function bwmorph - thinning and thickening
f = imread('fingerprint.tif');
f = imcomplement(f); 
level = graythresh(f);
BW_f = imbinarize(f, level);
g1 = bwmorph(BW_f, 'thin', 1);
g2 = bwmorph(BW_f, 'thin', 2);
g3 = bwmorph(BW_f, 'thin', 3);
g4 = bwmorph(BW_f, 'thin', 4);
g5 = bwmorph(BW_f, 'thin', 5);

montage({f,g1,g2,g3,g4,g5})

%What will happen if you keep thinning the image?
f = imread('fingerprint.tif');
f = imcomplement(f); 
level = graythresh(f);
BW_f = imbinarize(f, level);
g1 = bwmorph(BW_f, 'thin', 1);
g2 = bwmorph(BW_f, 'thin', 2);
g3 = bwmorph(BW_f, 'thin', 3);
g4 = bwmorph(BW_f, 'thin', 4);
g5 = bwmorph(BW_f, 'thin', 5);
g_inf = bwmorph(BW_f, 'thin', inf);

montage({f,g1,g2,g3,g4,g5.g_inf})

%Display black lines on white background instead of white on black.
f = imread('fingerprint.tif');
f = imcomplement(f); 
level = graythresh(f);
BW_f = imbinarize(f, level);
BW_f = imcomplement(BW_f)
g1 = bwmorph(BW_f, 'thin', 1);
g2 = bwmorph(BW_f, 'thin', 2);
g3 = bwmorph(BW_f, 'thin', 3);
g4 = bwmorph(BW_f, 'thin', 4);
g5 = bwmorph(BW_f, 'thin', 5);
g_inf = bwmorph(BW_f, 'thin', inf);

montage({f,g1,g2,g3,g4,g5.g_inf})

%Task 5: Connected Components and Labels
t = imread('assets/text.png');
imshow(t)
CC = bwconncomp(t)

%Determine largest component
t = imread('assets/text.png');
imshow(t)
CC = bwconncomp(t)
numPixels = cellfun(@numel, CC.PixelIdxList);
[biggest, idx] = max(numPixels);
t(CC.PixelIdxList{idx}) = 0;
figure
imshow(t)

%Task 6: Morphological Reconstruction
f = imread('assets/text_bw.tif');
se = ones(17,1);
g = imerode(f, se);
fo = imopen(f, se);     
fr = imreconstruct(g, f);
montage({f, g, fo, fr}, "size", [2 2])

%Test the imfill function
ff = imfill(f);
figure
montage({f, ff})

%Task 7: Morphological Operations on Greyscale Images
f = imread('assets/headCT.tif');
se = strel('square',3);
gd = imdilate(f, se);
ge = imerode(f, se);
gg = gd - ge;
montage({f, gd, ge, gg}, 'size', [2 2])

%Challenges (with comments):
%Challenge 1 - The grayscale image file _'assets/fillings.tif'_ is a dental 
% X-ray corrupted by noise.  Find how many fills this patient has and their 
% sizes in number of pixels.

f = imread('assets/fillings.tif');
%find threshold
level = graythresh(f);
%convert to binary
BW_fillings = imbinarize(f, level);
%create a SE
se = strel('disk', 3);
%create verion with opening to expand fillings
BW_fillings_cleaned = imopen(BW_fillings, se);
%to find most promenent area and earse it, to reveal 
%only fillings
CC_fillings = bwconncomp(BW_fillings_cleaned);
%count the number of fillings identified
numFillings = CC_fillings.NumObjects;
numPixelsFillings = cellfun(@numel, CC_fillings.PixelIdxList);
%print montage with filling number
montage({f, BW_fillings_cleaned})
title(['Number of fillings: ', num2str(numFillings)]);

%Challenge 2 - The file _'assets/palm.tif'_ is a palm print image in 
% grayscale. Produce an output image that contains the main lines without 
% all the underlining non-characteristic lines.

f = imread("palm.jpg")
%find threshold and make binary
level = graythresh(f);
BW = imbinarize(f, level); 
%create SE -- after experiementation, this was most effective
SE = ones(3,3);
%erode image with SE
BW_eroded = imerode(BW, SE);
%open image to allow remaining structures to gain pixels
BW_open = imopen(BW_eroded, SE); 
%allow most important connected element to be removed and
%left with lines
CC = bwconncomp(BW_open)
numPixels = cellfun(@numel, CC.PixelIdxList);
[biggest, idx] = max(numPixels);
f(CC.PixelIdxList{idx}) = 0;
%print final adjusted image
imshow(f)

%Challenge 3 - The file _'assets/normal-blood.png'_ is a microscope i
% mage of red blood cells. Using various techniques you have learned, write 
% a Matlab .m script to count the number of red blood cells.

f = imread('assets/normal-blood.png');
%find threshold and make binary
level = graythresh(f);
BW_blood = imbinarize(f, level);
%create SE -- after experiementation, this was most effective
se3 = strel('disk', 2);
%open the image to allow important strucures to gain pixels
BW_blood_cleaned = imopen(BW_blood, se3);
%allow most important connected element to be removed and
%left with blobs to count
CC_blood = bwconncomp(BW_blood_cleaned);
%count structures
numCells = CC_blood.NumObjects;
imshow(f);
%print with title count
title(['Number of Red Blood Cells: ', num2str(numCells)]);