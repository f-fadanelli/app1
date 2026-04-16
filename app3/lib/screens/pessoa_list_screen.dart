import 'package:flutter/material.dart';
import '/models/pessoa.dart';
import '/repositories/pessoa_repository.dart';
import '/screens/pessoa_form_screen.dart';

class PessoaListScreen extends StatefulWidget {
  const PessoaListScreen({Key? key}) : super(key: key);

  @override
  _PessoaListScreenState createState() => _PessoaListScreenState();
}

class _PessoaListScreenState extends State<PessoaListScreen> {
  List<Pessoa> _pessoas = [];
  PessoaRepository repository = PessoaRepository();

  @override
  void initState() {
    super.initState();
    carregarPessoas();
  }

  void carregarPessoas() async {
    var pessoasBanco = await repository.todos();
    setState(() {
      _pessoas = pessoasBanco;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pessoas')),
      body: ListView.builder(
        itemCount: _pessoas.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_pessoas[index].nome),
            subtitle: Text('Idade: ${_pessoas[index].idade}'),
            onTap: () async {
              final atualizado = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PessoaFormScreen(pessoa: _pessoas[index]),
                ),
              );
              if (atualizado == true) carregarPessoas();
            },
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                final confirmado = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Confirmar exclusão'),
                    content: Text('Deseja excluir "${_pessoas[index].nome}"?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text(
                          'Excluir',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
                if (confirmado == true) {
                  await repository.remover(_pessoas[index]);
                  carregarPessoas();
                }
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final adicionado = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (context) => const PessoaFormScreen()),
          );
          if (adicionado == true) carregarPessoas();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
