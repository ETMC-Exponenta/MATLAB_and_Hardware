% Clearing
clear all;

%Init
Nano3 = arduino;

%Hello blink
for i = 1:4
      writeDigitalPin(Nano3, 'D3', 1);
      pause(0.25);
      readDigitalPin(Nano3,'D2');
      fprintf('D2 digital value: %d \n',readDigitalPin(Nano3,'D2'));
      writeDigitalPin(Nano3, 'D3', 0);
      fprintf('D2 digital value: %d \n',readDigitalPin(Nano3,'D2'));
      pause(0.25);
end

%Trajectory logging
h = animatedline;
axis([0 5 0 5]);
title('Controller Trajectory');
xlabel('Vx'); 
ylabel('Vy'); 

while (true)
    Vx = readVoltage(Nano3,'A2');
    Vy = readVoltage(Nano3,'A3');
    addpoints(h,Vx,Vy);
    drawnow limitrate;
    text = sprintf('Vx= %f Vy = %f',Vx,Vy);
    disp(text);
end

