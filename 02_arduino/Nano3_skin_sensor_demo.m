% Clearing
clear all;

%Init
Nano3 = arduino('COM4','Nano3');

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

Voltage = animatedline('Color',[1 0 0],'MaximumNumPoints',1000); 
% axis([0,1000])
legend('Voltage');

i=0;
while (true)
    V = readVoltage(Nano3,'A0');
    i=i+1;
    addpoints(Voltage,i,V);
    drawnow limitrate;
end

