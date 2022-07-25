% funcion que regresa un valor logico si un archivo esta en el directorio
[file, path] = uigetfile('.mp4', 'Select Video File');
if isequal(file, 0)
    disp('User selected cancel');
else
    disp(['User selected ', fullfile(path,file)]);
    %Displaying Video on Axes
    input_video_file = fullfile(path,file);
    vidObj = VideoReader(input_video_file);
    while(hasFrame(vidObj))
        frame = readFrame(vidObj);
        imshow(frame, 'Parent', app.UIAxes);   % <--- use the Parent property
        pause(2/vidObj.FrameRate);
    end
end
