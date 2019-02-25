% Clear all
clear all;

%Create webcam
%type webcamlist in comand line to scan your web cam name
devs = webcamlist;
cam = webcam(devs{1});

%create a global variable for interconnection of the name spaces
global LOOP_RUNNING;
LOOP_RUNNING = true;

img_display = figure('CloseRequestFcn',@my_closereq);

h_avg = ones(6,6)/36;
h_edge = [1 0 -1; 2 0 -2; 1 0 -1];

while (LOOP_RUNNING)
  %capture image  
  img = snapshot(cam);
  
  img_gray = rgb2gray(img);
  img_avg = imfilter(img_gray,h_avg);
  img_edge = imfilter(img,h_edge);
  
  subplot(2,2,1),imshow(img);
  subplot(2,2,2),imshow(img_gray);
  subplot(2,2,3),imshow(img_avg);
  subplot(2,2,4),imshow(img_edge);

  pause(0.05);
  
end

function my_closereq(~,~)
  global LOOP_RUNNING;
  LOOP_RUNNING = false;
  delete(gcf);
  clear('cam');
  return; 
end





