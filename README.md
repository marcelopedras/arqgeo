# Arqgeo

#### Uma adaptação do Dspace para utilização em um Repositório Arqueológico Digital

O resultado desse projeto pode ser visto em: https://arqueologia.ict.ufvjm.edu.br/



##### Apresentação

Esse projeto surgiu da necessidade de manter um catálogo digital das peças da Reserva Técnica do LAEP (Laboratório de Arqueologia e Estudo da Paisagem), localizado no Cegeo (Centro de Estudos em Geociências) da Universidade Federal dos Vales do Jequitinhonha e Mucuri - UFVJM. Além das peças em si, esse laboratório faz a guarda de vários relatórios referente a catalogação de peças e informações referentes ao depósito e identificação das caixas onde esses objetos são guardados na reserva.

Apesas da existência da informação, recuperá-la não era tão simples, visto que não havia um índice geral de que relatórios fazem referências a quais caixas, eram apenas um conjunto de tabelas não pesquisáveis. Dessa forma, localizar uma caixa ou um relatório era um pouco custoso. É aí que entra o Dspace.

O Dspace permite a personalização de metadados, de forma que podemos criar descritores (metadados) personalizados para descrever um item da reserva. Como esses dados são indexados, agora temos vários campos de busca para procurar por termos, acelerando muito a localização dos relatórios e dos itens na reserva.

Além disso, esses dados estão disponíveis na Internet de forma que outros pesquisadores e o público em geral, possa recuperar informações dos itens da reserva técnica. E mais, o repositório também é indexado pelo Google!



##### Instalação

Para abstrair as configurações e dependências, se utilizou Docker e Docker Compose para criar imagens.  Logo, os arquivos principais para configuração das imagens são o dockerfile e o docker-compose.yml.

Para construir o projeto use:

`docker-compose up --build`

Foram feitos vários ajustes nas configurações do Dspace. Para descobrir as alterações/configurações feitas, procure por "Marcelo" (eu mesmo, rsrs ) no código. Procurei deixar comentários para que outros conseguissem entender o motivo das configurações. Afinal, a documentação do Dspace (https://wiki.lyrasis.org/display/DSDOC6x) é muito extensa e as vezes nem tão clara.



##### Contribuição, ajuda, dúvidas...

Contribuições sempre são bem vindas. Confesso que esse projeto foi feito na raça, aprendendo a cada dia, apanhando bastante. Mas aprender dói, é a vida! Caso precise de ajuda ou tenha alguma contribuição, entre em contato: marcelo.pedras@ict.ufvjm.edu.br .



##### Agradecimentos

Agradeço ao ICT/UFVJM por ceder os recursos computacionais para hospedar o projeto, a meu amigo Bruno Pastre Máximo que trabalhou arduamente para levantar os requisitos dos metadados e a todos os colaboradores que ajudaram no cadastro dos itens:  Mateus Pereira, Allan dos Santos, Isabel Bonfim e Lucas Rodrigues.



##### Contatos

Marcelo Bráulio Pedras

Analista de Tec. da Informação - ICT/UFVJM

marcelo.pedras@ict.ufvjm.edu.br



Bruno Pastre Máximo

Arqueólogo - Laboratório de Arqueologia - Museu Amazônico / Universidade Federal do Amazonas

pastrebruno@ufam.edu.br
