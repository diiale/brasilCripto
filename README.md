# BrasilCripto

Aplicativo de pesquisa de criptomoedas, visualização do preço, histórico, detalhes e persistência de favoritos. 

## Executando o projeto

1. Clone o repositório do projeto:
   git clone https://github.com/diiale/brasilCripto

2. Instale as dependências do projeto:
   dart pub get

3. Execute o projeto:
   flutter run


## Tecnologias

Flutter + Dart: Escolhidos por serem multiplataforma.

Riverpod: Gerenciamento de estado, seguro em tempo de compilação e mais previsível que alternativas como Provider.

Dio: Cliente HTTP com suporte avançado a interceptors e cancelamento de requisições.

fl_chart: Biblioteca flexível para gráficos interativos, atendendo bem ao requisito de visualização de histórico de preços.


## Padrões de Projeto e Arquitetura

![My First Board](https://github.com/user-attachments/assets/a14607c7-e920-4a89-9663-415907a62209)


### Estratégias Adotadas

Validação de entrada: Prevenção contra requisições inválidas ou injection de parâmetros na API.

Conversão segura de tipos: Evita TypeError ao trabalhar com listas e mapas vindos do JSON.

Formatação regional (BRL): Melhora a experiência do usuário brasileiro com datas e valores no formato local.

Otimização de chamadas: Uso de CancelToken do Dio para evitar requisições desnecessárias e minimizar consumo de rede.


## UX e Apresentação

Gráficos via fl_chart com datas inicial e final exibidas.

Conversão automática para R$ nos preços.

Skeleton loaders para feedback visual enquanto dados carregam.

## APK

Colocado a APK dentro da pasta release-apks para ser utilizadas em testes conforme solicitado.
