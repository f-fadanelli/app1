# app1

Usando o android studio, copiei o arquivo meubanco.db do app 1 e colei em /storage/emulated/0/Download/

Alterei manifest dele:     <uses-permission android:name="android.permission.MANAGE_EXTERNAL_STORAGE" />

Para baixar o app no emulador, rodei o comando flutter run 

Rodei comando shell para permitir acessar arquivo adb: shell appops set --uid com.example.app1 MANAGE_EXTERNAL_STORAGE allow
