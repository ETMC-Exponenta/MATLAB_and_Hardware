% Clearing
clear all;

%Init
Nano3 = arduino('COM8','Nano3');
    
% Hello blink
for i = 1:4
      writeDigitalPin(Nano3, 'D3', 1);
      pause(0.25);
      writeDigitalPin(Nano3, 'D3', 0);
      pause(0.25);
end

addrs = scanI2CBus(Nano3);


%Disable Sleep mode

mpu=i2cdev(Nano3,'0x68'); %mpu adress is normally 0x68
writeRegister(mpu, hex2dec('6B'), hex2dec('00'), 'int16'); %reset

%Read Data
data=zeros(10000,14,'int8'); %prelocating for the speed
j=1;
Axl_1 = animatedline('Color',[1 0 0]); 
Axl_2 = animatedline('Color',[0 1 0]);
Axl_3 = animatedline('Color',[0 0 1]);
legend('Axl_x','Axl_y','Axl_z');


% loop
while(true)
    x=1;
    for i=59:72 % 14 Data Registers for Axl,Temp,Gyro
        data(j,x)= readRegister(mpu, i, 'int8');
        test = readRegister(mpu, 71, 'int8');
        x=x+1;
    end
    
    y = swapbytes(typecast(data(j,:), 'int16'));
    
    addpoints(Axl_1,j,double(y(5)));
    addpoints(Axl_2,j,double(y(6)));
    addpoints(Axl_3,j,double(y(7)));
    j=j+1;
    drawnow limitrate;
end



