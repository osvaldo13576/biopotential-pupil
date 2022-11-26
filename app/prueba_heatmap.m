bmpfile = '/home/osvaldo13576/Documents/BMPfiles/d2t.bmp';
im = imread(bmpfile);
data = readtable('/home/osvaldo13576/Documents/14_11_2022/003/exports/005/surfaces/gaze_positions_on_surface_Surface 1.csv');
i_0 = 32700;
i_f = 32865;
posONsurf=xy_scaled_index(data,i_0,i_f);
p=gkde2(posONsurf);
p.xylim=[0 0 1283 720];
dat_x = zeros(52,52);dat_y = zeros(52,52);dat_pdf = zeros(52,52);
for i = 2:51
    dat_x(:,i) = p.x(1,i-1);
end

for i = 2:51
    dat_y(i,:) = p.y(i-1,1);
end
dat_x(:,1) = 0; dat_x(:,52) = 1283;
dat_y(1,:) = 0; dat_y(52,:) = 720;
dat_pdf(2:51,2:51) = 2.03524970807053e-37;
dat_pdf(3:50,3:50) = p.pdf(2:49,2:49); 
%%
f=figure();

image([0, 1283],[720,0], im);
hold on
ax = gca;
set(gca, 'Visible', 'off')
ax.YDir='normal';
xlim([0, 1283]);
ylim([0,720]);
surf(dat_x,dat_y,dat_pdf,'FaceAlpha',0.5,'AlphaDataMapping','scaled','AlphaData',dat_pdf,'FaceColor','interp','EdgeAlpha',0);colormap(jet);
%view(2)
export_fig('/home/osvaldo13576/Documents/GitHub/biopotential-pupil/app/test999.png', '-native')
%imwrite(img, '/home/osvaldo13576/Documents/GitHub/biopotential-pupil/app.png');
%%
%export_fig

%%
A=convert_timestamp(1668452186424/1000)
B=convert_timestamp(1668452030.664301-6532.796161+6688.611484)
%%
datos = loadEmoFlechas('/home/osvaldo13576/Documents/14_11_2022/003/eeg_tarea/Emo_Flechas.data.2022-11-14--19-07.txt')
%%
datos.Var6(1)
%%
%
%convert_timestamp(1668451922)

datosECG= loadEEG('/home/osvaldo13576/Documents/14_11_2022/003/eeg_tarea/eeg_data_data.txt',1668451922);
%%
data=datosECG(:,2:end);










