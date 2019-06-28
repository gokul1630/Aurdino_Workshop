% create an arduino object

a = arduino();     

% start the loop to blink led for 5 seconds

for i=1:5

    writeDigitalPin(a, 'D13', 1);

    pause(2);

    writeDigitalPin(a, 'D13', 0);

    pause(0.5);

end

% end communication with arduino

clear a