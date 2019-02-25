%  Clear workspace
clear all;
%Setup parameters
f = 10000;
rate = 300e3;
duration = 1;
t = (1:(duration*rate))/rate;

%Configure Analog Disvocery
s = daq.createSession('digilent');
ch_in = addAnalogInputChannel(s,'AD1', 1, 'Voltage');

s.Rate = rate;
s.DurationInSeconds = duration;

%Calculate Quadratures
Q = sin(2*pi*f*t)';
I = cos(2*pi*f*t)';

%Design filter
LP_filter_specs = fdesign.lowpass;
LP_filter_specs.Fpass = 0.01;
LP_filter_specs.Fstop = 0.05;
LP_filter_specs.Astop = 80;
LP_filter = design (LP_filter_specs);

%Acqure data
[data, timestamps, triggerTime] = startForeground(s);

%Carry to zero
fmQ = data.*Q;
fmI = data.*I;

%Filter upper component  
fmQ = filter(LP_filter,fmQ);
fmI = filter(LP_filter,fmI);

% Calculating envelop
Env = (fmQ.^2+fmI.^2).^0.5;

%Plot
subplot(2,1,1);
plot(timestamps, data);
title(['Clocked Data Triggered on: ' datestr(triggerTime)]);
xlabel('Time (seconds)'); ylabel('Voltage (Volts)');

subplot(2,1,2);
plot(timestamps, Env);
title(['Envelope: ' datestr(triggerTime)]);
xlabel('Time (seconds)'); ylabel('Units');



    




