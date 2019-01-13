close all;
I = imread('ngc6543a.jpg'); 
for i = 1:1
    tic
    javaImage = im2java(I); 
    frame = javax.swing.JFrame; 
    icon = javax.swing.ImageIcon(javaImage); 
    label = javax.swing.JLabel(icon); 
    frame.getContentPane.add(label); 
    frame.pack 
    frame.show 
    1/toc
end
