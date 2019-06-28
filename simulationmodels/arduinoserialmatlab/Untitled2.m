clear all
clc
close all;

arduino = serial('COM4','BaudRate',9600);
         fopen(arduino);
         pause(2);
         fprintf(arduino,100);
         pause(3);
         fclose(arduino);
         delete(arduino);
         
         pause(5);
         
 arduino = serial('COM4','BaudRate',9600);
         fopen(arduino);
         pause(2);
         fprintf(arduino,101);
         pause(3);
         fclose(arduino);
         delete(arduino);
