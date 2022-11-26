% funcion que regresa un valor logico si un folder esta vacio
function valor = is_an_empty(directorio)
    d = dir(directorio);
    isub = [d(:).isdir];
    nameFolds = {d(isub).name}';
    nameFolds(ismember(nameFolds,{'.','..'})) = [];
    valor = isempty(nameFolds);
end

