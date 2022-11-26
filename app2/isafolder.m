% funcion que regresa un valor logico si un folder esta en el directorio
function valor = isafolder(directorio,folds)
    d = dir(directorio);
    isub = [d(:).isdir];
    nameFolds = {d(isub).name}';
    valor = any(strcmp(nameFolds,folds));
end