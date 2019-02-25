% Clear all
clear all;

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
  
  img_med_def(:,:,1) = medfilt2(img(:,:,1));
  img_med_def(:,:,2) = medfilt2(img(:,:,2));
  img_med_def(:,:,3) = medfilt2(img(:,:,3));
  
  img_med_10x10(:,:,1) = medfilt2(img(:,:,1),[10,10]);
  img_med_10x10(:,:,2) = medfilt2(img(:,:,2),[10,10]);
  img_med_10x10(:,:,3) = medfilt2(img(:,:,3),[10,10]);
  
  img_med_20x20(:,:,1) = medfilt2(img(:,:,1),[20,20]);
  img_med_20x20(:,:,2) = medfilt2(img(:,:,2),[20,20]);
  img_med_20x20(:,:,3) = medfilt2(img(:,:,3),[20,20]);
  
  
  subplot(2,2,1),imshow(img);
  subplot(2,2,2),imshow(img_med_def);
  subplot(2,2,3),imshow(img_med_10x10);
  subplot(2,2,4),imshow(img_med_20x20);

  pause(0.05);
  
end

function my_closereq(~,~)
  global LOOP_RUNNING;
  LOOP_RUNNING = false;
  delete(gcf);
  clear('cam');
  return; 
end





