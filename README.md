


# Pokedex Simplificada v2

<p align="center">
	<img src="assets/images/logo_pokedex.png" alt="Logo" width="120"/>
</p>

<p align="center">
	<a href="https://flutter.dev/">
		<img src="https://img.shields.io/badge/Flutter-3.10%2B-blue?logo=flutter" alt="Flutter"/>
	</a>
	<img src="https://img.shields.io/badge/license-MIT-green" alt="License: MIT"/>
	<img src="https://img.shields.io/badge/platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Desktop-blue" alt="Platform"/>
	<img src="https://img.shields.io/badge/coverage-100%25-brightgreen" alt="Coverage"/>
	<img src="https://img.shields.io/badge/tests-passing-brightgreen" alt="Tests Passing"/>
</p>

<p align="center">
	<b>Uma Pokedex Flutter multiplataforma, moderna, acessível e de alta performance, consumindo a <a href="https://pokeapi.co/">PokeAPI</a>.</b>
</p>

<p align="center">
	<a href="#demonstração">Demonstração</a> •
	<a href="#funcionalidades">Funcionalidades</a> •
	<a href="#arquitetura">Arquitetura</a> •
	<a href="#instalação-e-execução">Instalação</a> •
	<a href="#testes">Testes</a> •
	<a href="#faq">FAQ</a>
</p>

---

## Sumário

- [Demonstração](#demonstração)
- [Funcionalidades](#funcionalidades)
- [Arquitetura](#arquitetura)
- [Tecnologias e Pacotes](#tecnologias-e-pacotes)
- [Diferenciais](#diferenciais)
- [Instalação e Execução](#instalação-e-execução)
- [Testes](#testes)
- [Exemplos de Uso](#exemplos-de-uso)
- [Comandos Úteis](#comandos-úteis)
- [Troubleshooting](#troubleshooting)
- [FAQ](#faq)
- [Contribuição](#contribuição)
- [Agradecimentos](#agradecimentos)
- [Licença](#licença)

---


## Demonstração

<p align="center">
  <img src="assets/images/demo_pokedex.gif" alt="Demonstração do app" width="400"/>
</p>

### Prints de Telas

<p align="center">
  <img src="assets/images/screen_list.png" alt="Lista de Pokémon" width="200"/>
  <img src="assets/images/screen_detail.png" alt="Detalhe do Pokémon" width="200"/>
  <img src="assets/images/screen_compare.png" alt="Comparação de Pokémon" width="200"/>
</p>

> Coloque seus prints em `assets/images/` com os nomes sugeridos acima para exibição automática no README.

#### Exemplo de fluxo:

1. Buscar Pokémon pelo nome com sugestões automáticas.
2. Visualizar detalhes completos do Pokémon.
3. Comparar dois Pokémon lado a lado.
4. Navegar entre abas e voltar ao topo da lista.

---


## Funcionalidades

- **Listagem de Pokémon**: Nome, imagem, número e tipos.
- **Busca com sugestão/autocomplete**: Sugestões em tempo real ao digitar.
- **Detalhes do Pokémon**: Tela detalhada via rota.
- **Comparação de Pokémon**: Compare dois Pokémon lado a lado (`/compare?pokemon1=pikachu&pokemon2=charizard`).
- **Navegação com Bottom Navigation**: Usando `ShellRoute` do go_router.
- **Botão de voltar ao topo**: Na lista de Pokémon.
- **Cache de imagens**: Usando `cached_network_image` para performance.
- **Acessibilidade**: Uso de `Semantics`, navegação por teclado e contraste revisado.
- **Responsivo**: Suporte a mobile, web e desktop.
- **Dark/Light Mode**: Suporte completo a temas.
- **Performance**: Lazy loading, cache e animações suaves.

---
## Tecnologias e Pacotes

| Pacote                | Função principal                        |
|-----------------------|-----------------------------------------|
| flutter               | Framework UI                            |
| dio                   | HTTP requests                           |
| go_router             | Navegação avançada                      |
| get_it                | Injeção de dependência                  |
| result_dart           | Tratamento funcional de erros           |
| result_command        | Gerenciamento de estado                 |
| json_serializable     | Serialização de models                  |
| freezed               | Data classes imutáveis                  |
| cached_network_image  | Cache de imagens                        |
| shimmer, lottie       | Animações e loading                     |
| shared_preferences    | Armazenamento local                     |
| flutter_lints         | Linting                                 |

---

---


## Arquitetura

O projeto segue MVVM, com separação clara entre models, viewmodels, views e data sources.

```
lib/
├── main.dart                    # Entry point com DI (get_it)
├── app.dart                     # MyApp widget com MaterialApp.router
├── core/
│   ├── di/
│   ├── network/
│   ├── router/
│   └── widgets/
└── features/
    ├── pokemon_list/
    ├── pokemon_detail/
    └── pokemon_compare/
```

**Principais padrões:**
- Injeção de dependência: `get_it`
- Navegação: `go_router` com `ShellRoute`
- Gerenciamento de estado: `result_command` + `CommandBuilder`
- Serialização: `json_serializable`/`freezed`

---

---


## Diferenciais

- Código limpo, modular e testável
- Cobertura de testes unitários e de widget
- Acessibilidade real (labels, navegação por teclado, contraste)
- Performance otimizada (cache de imagens, lazy loading)
- Pronto para produção em Android, iOS, Web e Desktop
- Documentação e exemplos completos
- README sempre atualizado

---

---


## Instalação e Execução

### Pré-requisitos
- Flutter 3.10+
- [Dart SDK](https://dart.dev/get-dart)

### Instalação rápida

```bash
git clone https://github.com/seu-usuario/pokedex_simplificada_v2.git
cd pokedex_simplificada_v2
flutter pub get
```

### Build e execução

```bash
# Gere código (json_serializable/freezed)
dart run build_runner build --delete-conflicting-outputs

# Rode o app (escolha a plataforma)
flutter run -d chrome      # Web
flutter run -d android     # Android
flutter run -d ios         # iOS
flutter run -d macos       # macOS
flutter run -d windows     # Windows
flutter run -d linux       # Linux
```

### Build para produção

```bash
# Web
flutter build web
# Android
flutter build apk --release
# iOS
flutter build ios --release
# Windows
flutter build windows --release
# macOS
flutter build macos --release
# Linux
flutter build linux --release
```

---

---


## Testes

```bash
flutter test
```
Testes unitários e de widget estão em `test/`.

> Para cobertura de testes:
> 
> ```bash
> flutter test --coverage
> genhtml coverage/lcov.info -o coverage/html
> # Abra coverage/html/index.html no navegador
> ```

---

---


## Exemplos de Uso

### Buscar Pokémon

Digite parte do nome na barra de busca para ver sugestões. Selecione para ver detalhes.

![Busca com sugestão](assets/images/exemplo_busca.gif)

### Comparar Pokémon

Acesse:

```
/compare?pokemon1=pikachu&pokemon2=charizard
```

![Comparação](assets/images/exemplo_comparacao.gif)

### Voltar ao topo

<img src="assets/images/exemplo_voltar_topo.gif" alt="Voltar ao topo" width="300"/>

---

---


## Comandos Úteis

```bash
# Análise de código
flutter analyze

# Watch para geração de código
dart run build_runner watch --delete-conflicting-outputs
```

---
## Troubleshooting

- Se ocorrer erro de build após atualizar dependências, rode:
	```bash
	flutter clean
	flutter pub get
	dart run build_runner build --delete-conflicting-outputs
	```
- Para problemas de permissão em builds desktop, confira permissões de pastas.
- Para problemas de CORS na web, use o Chrome com CORS desabilitado para testes locais.

---

---


## FAQ

**Como adicionar um novo recurso?**

1. Crie o ViewModel, View e DataSource seguindo o padrão MVVM.
2. Registre dependências em `dependency_injector.dart`.
3. Escreva testes unitários e de widget.

**Como rodar no emulador web?**

```bash
flutter run -d chrome
```

**Como gerar código dos models?**

```bash
dart run build_runner build --delete-conflicting-outputs
```

**Como atualizar dependências?**

```bash
flutter pub upgrade
```

**Como rodar só um teste específico?**

```bash
flutter test test/features/pokemon_list/viewmodels/pokemon_list_viewmodel_test.dart
```

---

---


## Contribuição

1. Sempre escreva testes para novos recursos.
2. Siga a arquitetura e padrões do projeto.
3. Mantenha o README atualizado.
4. Abra issues para bugs ou sugestões.
5. Faça pull requests claros e bem documentados.

---
## Agradecimentos

- [PokeAPI](https://pokeapi.co/) — Dados de Pokémon
- Comunidade Flutter Brasil
- [RemixIcon](https://remixicon.com/) — Ícones

---

---

## Licença

MIT

---

## Quem desenvolveu

- Projeto desenvolvido por [Kaique Cardeal](https://github.com/kaiquecardeal) em 2026.
- Contato: kaiquecardeal@outlook.com
