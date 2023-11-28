# Avaliação final de flutter.
## Criterios de avaliação

Desenvolvimento do escopo passado
Envio do código por link do git ou projeto zipado
Print de todas as telas e interações do aplicativo
Legibilidade e organização de código
Documentação para a aplicação (Pontuação bônus significativa)
Escopo da avaliação:

appbar dinamico dependendo da tela atual
bottom navigation bar
3 telas (api clima / api moedas / todo list)
### 1 - Tela de Clima 
a tela de api climatico deve mostrar o clima atual de uma cidade ou estado
ao clicar no icone de busca no appbar deve ser aberta uma modal com selectoption, onde poderemos escolher outra cidade ou estado para ver o clima
cancelar deve apenas fechar o modal
buscar deve mudar o contexto consultado da api para o local selecionado.

### 2 - Tela de Moedas
o app bar desta tela não precisa de actions
a tela deve conter um selectoption para escolhermos qual moeda usaremos de base
a tela deve apresentar no minimo 5 outras moedas e sua relação monetaria sobre o contexto da moeda selecionada.

### 3 - Lista de tarefas
o appbar desta tela deve ter duas actions
incluir nova tarefa
buscar uma tarefa cadastrada por nome
ao pressionar o icone de nova tarefa, a tela deve abrir um modal com textfield e 2 actions, o textfield será para digitar o titulo da tarefa, e as actions para "cancelar" fechando a modal sem criar tarefa e "criar" adicionando uma nova tarefa à lista
ao criar uma nova tarefa a mesma deve estar com o checkbox desmarcado por padrão
ao tocar rapidamente em cima de uma tarefa o checkbox deve ser marcado
deve-se usar dismissible para editar arrastando a tarefa para a direita
ao editar a tarefa deve-se abrir uma modal com o textfield já preenchido com o titulo atual da tarefa permitindo assim a edição do mesmo, e as actions para "cancelar" fechando a modal sem editar a tarefa e "salvar" modificando o titulo da tarefa na lista
deve-se usar dismissible para excluir arrastando a tarefa para a esquerda
ao excluir a tarefa, deve ser exibido um snackbar com a ação de desfazer a exclusão, ao acionar esta ação a tarefa excluida deve retornar a lista na mesma posição em que estava
ao pressionar o botão de busca no appbar, deve ser possivel filtrar em tempo real apenas as tarefas que possuem um titulo semelhante ao valor digitado na busca
BONUS (valendo uma nota significativa) - ao digitar [true] na busca (junto com os colchetes) devem ser retornadas todas as tarefas com o checkbox marcado, e ao digitar [false] (junto com os colchetes) devem ser retornadas todas as tarefas com o checkbox desmarcado.
