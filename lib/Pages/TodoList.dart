import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _todoListState();
}

class _todoListState extends State<TodoList> {
  List<Map<String, dynamic>> _tarefas = []; // Alteração aqui
  TextEditingController _novaTarefaController = TextEditingController();
  TextEditingController _editarTarefaController = TextEditingController();
  TextEditingController _controllerPesquisa = TextEditingController();
  Map<String, dynamic> _ultimaTarefaRemovida = Map();
  List<Map<String, dynamic>> _tarefasFiltradas = []; // Adicione esta linha



  Future<File> _GetFile() async {
    final diretorio = await getApplicationDocumentsDirectory();
    return File("${diretorio.path}/dados.json");
  }

  _SalvarTarefa(){
    String textoDigitado = _novaTarefaController.text;
    Map<String, dynamic> tarefa = Map();
    tarefa["titulo"]=textoDigitado;
    tarefa["done"]=false;
    setState(() {
      _tarefas.add(tarefa);
    });
    _SalvarArquivo();
    _novaTarefaController.text = "";
  }

  _SalvarArquivo() async {
    var arquivo = await _GetFile();
    String dados = jsonEncode(_tarefas);
    arquivo.writeAsString(dados);
  }

  /*
  _tarefas[
    {
      titulo: "bloob"
      done: false
    }
    {
      titulo: "yamette kudasai"
      done: true
    }
  ]
   */

  _LerArquivo() async {
    try{
      final arquivo = await _GetFile();
      return arquivo.readAsString();
    }catch(e){
      return 1;
    }
  }

  @override
  void initState() {
    super.initState();

    _LerArquivo().then((dados){
      setState(() {
        _tarefas = jsonDecode(dados);
      });
    });
  }
  void _atualizarTarefasFiltradas() {
    setState(() {
      if (_controllerPesquisa.text.isEmpty) {
        _tarefasFiltradas = List.from(_tarefas);
      } else {
        _tarefasFiltradas = _tarefas
            .where((tarefa) =>
            tarefa["titulo"]
                .toLowerCase()
                .contains(_controllerPesquisa.text.toLowerCase()))
            .toList();
      }
    });
  }

  // Modifique o método _executarPesquisa
  _executarPesquisa() {
    _atualizarTarefasFiltradas();
    int count = _tarefasFiltradas.length;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Resultado da Pesquisa"),
          content: count == 0
              ? Text("Nenhuma tarefa encontrada")
              : Text("Encontradas $count tarefas com essa descrição"),
          actions: [
            ElevatedButton(
              child: Text("Fechar"),
              onPressed: () {
                // Limpar o campo de pesquisa ao fechar o diálogo
                _controllerPesquisa.clear();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ToDo"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controllerPesquisa,
              onSubmitted: (value) {
                _atualizarTarefasFiltradas();
                _executarPesquisa();
              },
              decoration: InputDecoration(
                labelText: "Digite sua pesquisa",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
        ),
      ),
      body:
      ListView.builder(
        padding: EdgeInsets.all(0),
        itemCount: _controllerPesquisa.text.isEmpty ? _tarefas.length : _tarefasFiltradas.length,
        itemBuilder: (context, index){
          return Dismissible(
            onDismissed: (direction){
              _ultimaTarefaRemovida = _tarefas[index];

              if(direction == DismissDirection.endToStart){
                setState(() {
                  print("tamanho inicial da lista ${_tarefas.length}");
                  print("indice atual ${index}");
                  _tarefas.removeAt(index);
                  print("tamanho atual da lista ${_tarefas.length}");
                });
                final snackBar = SnackBar(
                  duration: Duration(seconds: 5),
                  content: Text("Tarefa removida"),
                  action: SnackBarAction(label: "Desfazer",
                      onPressed: (){
                        setState(() {
                          _tarefas.insert(index, _ultimaTarefaRemovida);
                        });
                        _SalvarArquivo();
                      }
                  ),
                );
                _SalvarArquivo();

                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }else if(direction == DismissDirection.startToEnd){
                setState(() {
                  showDialog(context: context, builder: (context){
                    _editarTarefaController.text = _tarefas[index]["titulo"];
                    return AlertDialog(
                      title: Text("Editar tarefa"),
                      content: TextField(decoration: InputDecoration(labelText: "Digite sua tarefa"),
                        onChanged: (text){},
                        controller: _editarTarefaController,
                      ),
                      actions: [
                        ElevatedButton(child: Text("Cancelar"), onPressed: () => Navigator.pop(context)),
                        ElevatedButton(child: Text("Salvar"), onPressed: (){
                          _tarefas[index]["titulo"] = _editarTarefaController.text;
                          setState(() {
                            _SalvarArquivo();
                          });
                          Navigator.pop(context);
                        }),
                      ],
                    );
                  });
                });
              }
            },
            background: Container(
              color: Colors.green,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Icon(Icons.edit,
                      color: Colors.white,
                    ),
                  ),
                  Text("Editar",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
            secondaryBackground: Container(
              color: Colors.red,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Excluir",
                    style: TextStyle(color: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Icon(Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            key: Key("key${_tarefas[index]}${DateTime.now().millisecondsSinceEpoch.toString()}"),
            child: CheckboxListTile(
              title: Text(_tarefas[index]["titulo"]),
              value: _tarefas[index]["done"],
              onChanged: (update){
                setState(() {
                  _tarefas[index]["done"] = update;
                });
                _SalvarArquivo();
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (){
            _SalvarArquivo();
            showDialog(context: context, builder: (context){
              return AlertDialog(
                title: Text("Nova tarefa"),
                content: TextField(decoration: InputDecoration(labelText: "Digite sua tarefa"),
                  onChanged: (text){},
                  controller: _novaTarefaController,
                ),
                actions: [
                  ElevatedButton(child: Text("Cancelar"), onPressed: () => Navigator.pop(context)),
                  ElevatedButton(child: Text("Adicionar"), onPressed: (){
                    _SalvarTarefa();
                    Navigator.pop(context);
                  }),
                ],
              );
            }
            );
          }
      ),
    );
  }

}
