%% abriendo pupil positions
directorio = '/home/osvaldo13576/Documentos/Servicio/pupil_data/2022_06_03/000/exports/000/pupil_positions.csv';
datos = readtable(directorio);
%% vamos a leer un video
video_eye_dir = ['/home/osvaldo13576/Documentos/Servicio/pupil_data/2022_06_03/000/exports/003/' ...
    'world.mp4'];
vid_eye0 = VideoReader(video_eye_dir);
fra = vid_eye0.NumFrames
%%
frames = read(vid_eye0,2);
imagen = imshow(frames);
%%
vid_frames = zeros(12438,1);
for k = 1:12438/2
    vid_frames(2*(k-1)+1) = k;
    vid_frames(2*(k-1)+2) = k;
end
%%
directorio_blink = '/home/osvaldo13576/Documentos/Servicio/pupil_data/2022_06_03/000/exports/003/blinks.csv';
datos = readtable(directorio_blink);
datos_var = ones(1513,1);
len_datos = length(datos.start_frame_index);
for k = 1:len_datos
    datos_var(datos.start_frame_index(k):datos.end_frame_index(k)) = 0;
end
%%
pupil_dir = '/home/osvaldo13576/Documentos/Servicio/pupil_data/2022_06_03/000/exports/003/pupil_positions.csv';
data = readtable(pupil_dir);
datos_frame = data.world_index+1;
tiempo = data.pupil_timestamp - data.pupil_timestamp(1);
%%
value = 10;
for k = 1:1000
    value*k
    pause(1)
end

