% create an arduino object

a = arduino();     

% start the loop to blink led for 5 seconds

ans=readDigitalPin(a,'D3')
if(ans==1)
    writeDigitalPin(a, 'D13', 1);
end

% end communication with arduino

clear a