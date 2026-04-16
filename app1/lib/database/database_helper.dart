import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '/database/sqls/pessoa_sql.dart';

class DatabaseHelper {
  static final String _nomeCaminhoBanco = '/storage/emulated/0/Download/';
  static final String _nomeBancoDeDados = "meubanco.db";
  static final int _versaoBancoDeDados = 2;
  static late Database _bancoDeDados;

  inicializar() async {
    String caminhoBanco = join(_nomeCaminhoBanco, _nomeBancoDeDados);
    _bancoDeDados = await openDatabase(
      caminhoBanco,
      version: _versaoBancoDeDados,
      onCreate: criarBD,
      onUpgrade: atualizaBD,
    );
  }

  Future criarBD(Database db, int versao) async {
    db.execute(PessoaSql.criarTabelaPessoa());
  }

  Future atualizaBD(Database db, int oldVersion, int newVersion) async {
    if (newVersion == 2) {}
  }

  //Ao inves de deixar aqui passamos essa implementação específica para a classe de repositório.
  //Dessa forma o repositório de cada model implementa para sua tabela e realidade.
  // Future<int> adicionarPessoa(Pessoa pessoa) {
  //   return _bancoDeDados.insert("PESSOAS", pessoa.toMap());
  // }

  Future<int> inserir(String tabela, Map<String, Object?> valores) async {
    await inicializar();
    return await _bancoDeDados.insert(tabela, valores);
  }

  Future<int> atualizar(
    String tabela,
    Map<String, Object?> valores, {
    required String condicao,
    required List<Object> condicaoArgs,
  }) async {
    await inicializar();
    return await _bancoDeDados.update(
      tabela,
      valores,
      where: condicao,
      whereArgs: condicaoArgs,
    );
  }

  Future<int> remover(
    String tabela, {
    required String condicao,
    required List<Object> condicaoArgs,
  }) async {
    await inicializar();
    return await _bancoDeDados.delete(
      tabela,
      where: condicao,
      whereArgs: condicaoArgs,
    );
  }

  Future<List<Map<String, Object?>>> obterTodos(
    String tabela, {
    String? condicao,
    List<Object>? conidcaoArgs,
  }) async {
    await inicializar();
    return await _bancoDeDados.query(
      tabela,
      where: condicao,
      whereArgs: conidcaoArgs,
    );
  }

  //Ao inves de deixar aqui passamos essa implementação específica para a classe de repositório.
  //Dessa forma o repositório de cada model implementa para sua tabela e realidade.
  // Future<List<Pessoa>> obterPessoas() async {
  //   var pessoasNoBanco = await _bancoDeDados.query("PESSOAS");
  //   List<Pessoa> listaDePessoa = [];

  //   for (var i = 0; i < pessoasNoBanco.length; i++) {
  //     listaDePessoa.add(Pessoa.fromMap(pessoasNoBanco[i]));
  //   }

  //   return listaDePessoa;
  // }
}
