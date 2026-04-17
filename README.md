# 📱 Experimento: SQLite compartilhado entre apps (Flutter + Nativo)

## 🎯 Objetivo

Testar se múltiplos apps conseguem acessar o **mesmo banco SQLite** no Android.

---

## 🧪 Apps utilizados

* **AppA** → Flutter
* **AppB** → Nativo
* **AppC** → Flutter

✔️ Todos usam a mesma estrutura de banco

---

## 🔁 Fluxo do teste

1. Inserir dados no AppA e AppC
2. Abrir o AppB
3. Verificar se os dados são acessíveis

---

## 💾 Local do banco

```bash
/storage/emulated/0/Download/meubanco.db
```

Arquivos gerados:

* meubanco.db
* meubanco.db-journal

---

## ⚙️ Configuração

### 1. Permissão no Manifest

```xml
<uses-permission android:name="android.permission.MANAGE_EXTERNAL_STORAGE" />
```

---

### 2. Rodar o app

```bash
flutter run
```

---

### 3. Liberar permissão via ADB

```bash
adb shell appops set --uid com.example.app1 MANAGE_EXTERNAL_STORAGE allow
```

(Substituir pelo package de cada app)

Esse comando **força o Android a liberar acesso total ao armazenamento** para o app.

* Permite acessar arquivos fora da pasta privada
* Faz com que vários apps consigam usar o mesmo `.db`


---

## 📊 Resultado

Os três apps conseguem acessar o mesmo banco e compartilhar dados.

---

## 📌 Conclusão

É possível compartilhar SQLite entre apps, mas exige permissões especiais e foge do padrão seguro do Android.
