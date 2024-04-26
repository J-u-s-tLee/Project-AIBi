% Criação de um vetor de 3 vetores de imagens onde são armazendas 
% todas as imagens originais, os GT do ROI e os GT da segmentaçao 
function vetores_de_imagens = read_data(pasta_principal)
subpastas = {'cells1', 'images1', 'ROIs1'};
vetores_de_imagens = cell(1,3);

for k = 1:3
    pasta_atual = fullfile(pasta_principal, subpastas{k});% Caminho completo para a subpasta atual
    arquivos = dir(pasta_atual);% Obtém a lista de arquivos na subpasta atual
    num_imagens = numel(arquivos)-2; % Número total de imagens na subpasta (2 primeiros nao tem dados)
    image_vector = cell(1, num_imagens); % Vetor de imagens

    for i = 1:num_imagens
        nome_arquivo = fullfile(pasta_atual, arquivos(i+2).name); % Caminho completo para o arquivo (sem 2 primeiros)
        extensao = nome_arquivo(end-2:end);

        if (extensao == 'mat')
            image_vector{i} = load(nome_arquivo); % Le o ficheiro e armazena-o no vetor
        else
        image_vector{i} = imread(nome_arquivo); % Le a imagem e armazena-a no vetor
        end

    end

    vetores_de_imagens{k} = image_vector;% Armazena o vetor de imagens desta subpasta no vetor principal
end

end
