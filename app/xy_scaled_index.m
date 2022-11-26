% regresa posisiones dentro de la superficie
function  xy_positions = xy_scaled_index(data,i_0,i_f)
    %data = readtable('/home/osvaldo13576/Documents/14_11_2022/003/exports/005/surfaces/gaze_positions_on_surface_Surface 1.csv');
    %i_0 = 1020;
    %i_f = 1037;
    false_true = data.on_surf(i_0:i_f);
    k =0;
    for i = 1:length(false_true)
        if contains(char(false_true(i)),'True')
            k = k+1;
        end
    end
    %%
    xy_positions = zeros(k,2);
    i = 1;
    for n = 1:length(false_true)
        if contains(char(false_true(n)),'True')
            xy_positions(i,:) = [data.x_scaled(i_0+n-1),data.y_scaled(i_0+n-1)];
            i = i+1;
        end
    end

end
