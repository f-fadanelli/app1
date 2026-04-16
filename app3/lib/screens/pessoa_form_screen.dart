import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '/models/pessoa.dart';
import '/repositories/pessoa_repository.dart';

class PessoaFormScreen extends StatefulWidget {
  const PessoaFormScreen({super.key, this.pessoa});

  final Pessoa? pessoa;

  @override
  State<PessoaFormScreen> createState() => _PessoaFormScreenState();
}

class _PessoaFormScreenState extends State<PessoaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _idadeController = TextEditingController();
  final PessoaRepository _repository = PessoaRepository();

  bool get _isEditing => widget.pessoa != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _nomeController.text = widget.pessoa!.nome;
      _idadeController.text = widget.pessoa!.idade.toString();
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _idadeController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final nome = _nomeController.text.trim();
    final idade = int.parse(_idadeController.text.trim());

    if (_isEditing) {
      final atualizada = Pessoa(
        id: widget.pessoa!.id,
        nome: nome,
        idade: idade,
      );
      await _repository.atualizar(atualizada);
    } else {
      final nova = Pessoa(id: const Uuid().v4(), nome: nome, idade: idade);
      await _repository.adicionar(nova);
    }

    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Editar Pessoa' : 'Nova Pessoa')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _idadeController,
                decoration: const InputDecoration(labelText: 'Idade'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe a idade';
                  }
                  if (int.tryParse(value.trim()) == null) {
                    return 'Idade deve ser um número inteiro';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _salvar,
                  child: Text(_isEditing ? 'Salvar alterações' : 'Adicionar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
