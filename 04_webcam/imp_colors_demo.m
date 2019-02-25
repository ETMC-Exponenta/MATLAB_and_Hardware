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

while (LOOP_RUNNING)
  %capture image  
  img = snapshot(cam);
  
  img_R(:,:,1) = img(:,:,2);
  img_R(:,:,2) = img(:,:,3);
  img_R(:,:,3) = img(:,:,1);
  
  img_G(:,:,2) = img(:,:,1);
  img_G(:,:,1) = img(:,:,3);
  img_G(:,:,3) = img(:,:,2);
  
  img_B(:,:,3) = img(:,:,1);
  img_B(:,:,1) = img(:,:,3);
  img_B(:,:,2) = img(:,:,3);
  
  
  subplot(2,2,1),imshow(img);
  subplot(2,2,2),imshow(img_R);
  subplot(2,2,3),imshow(img_G);
  subplot(2,2,4),imshow(img_B);

  pause(0.05);
  
end

function my_closereq(~,~)
  global LOOP_RUNNING;
  LOOP_RUNNING = false;
  delete(gcf);
  clear('cam');
  return; 
end





