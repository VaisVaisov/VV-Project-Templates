# IT Project Templates

<div align="center">

![License](https://img.shields.io/badge/license-MIT-E91E63?style=for-the-badge&labelColor=0D1117)
![Stars](https://img.shields.io/github/stars/VaisVaisov/IT-Project-Templates?style=for-the-badge&labelColor=0D1117&color=E91E63&logo=github&logoColor=white)
![Last Commit](https://img.shields.io/github/last-commit/VaisVaisov/IT-Project-Templates?style=for-the-badge&labelColor=0D1117&color=00BCD4&logo=git&logoColor=white)
![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20Windows-00BCD4?style=for-the-badge&labelColor=0D1117)

**Готовые шаблоны проектов с поддержкой VS Code Dev Containers**

*Arch Linux · Clang toolchain · AI-агенты предустановлены*

[Шаблоны](#доступные-шаблоны) • [Быстрый старт](#быстрый-старт) • [Установка](#установка) • [Dev Containers](#возможности-dev-container) • [CI/CD](#качество-кода--cicd) • [PlatformIO](#platformio-шаблоны) • [Возможности](#возможности-и-использование)

**[🇬🇧 English](README.md)**

</div>

---

## Что это такое?

Набор шаблонов проектов, позволяющих начать разработку за считанные минуты. Каждый шаблон поставляется с полностью настроенным **VS Code Dev Container** на основе Arch Linux — одинаковое окружение на любой машине, независимо от хост-системы.

### Зачем это нужно?

- 🚀 **Никакой настройки**: открой в VS Code, нажми "Reopen in Container" — и сразу кодить
- 🤖 **AI-готовность**: Claude Code, Qwen Code и Cline предустановлены в каждом контейнере
- 🔒 **Контроль качества**: pre-commit хуки ловят проблемы до попадания в репозиторий
- ⚙️ **CI/CD из коробки**: GitHub Actions для линтинга, сборки, тестов, покрытия, документации и релизов
- 📝 **Conventional Commits**: commitlint проверяет формат сообщений коммитов
- 🌍 **Кроссплатформенность**: один скрипт работает на Linux, macOS и Windows (через WSL2)

---

## Доступные шаблоны

### C/C++ (`c-cpp/`)

| Шаблон | Описание |
| --- | --- |
| `pure` | C/C++ с CMake, Ninja, GoogleTest, Google Benchmark, Doxygen, покрытие через lcov |
| `hybrid` | C/C++ + Python/Cython — оба языка в одном проекте, Sphinx + ReadTheDocs |
| `platformio/` | Разработка для встраиваемых систем (Arduino, ESP32, ESP8266, Pico, STM32) |

### Python (`python/`)

| Шаблон | Описание |
| --- | --- |
| `pure` | Python с pytest, ruff, pylint, mypy, Sphinx + ReadTheDocs |

### Verilog / FPGA (`verilog/`)

| Шаблон | Описание |
| --- | --- |
| `pure` | Verilog HDL с Icarus Verilog, Verilator, GTKWave, Quartus + openFPGALoader — все таски идут внутри Docker-контейнера сборки |

> **Примечание:** при создании Verilog-проекта сразу собирается его Docker-образ, поэтому **нужен доступ к сети** (сборка тянет пакеты из зеркал). Флаг `--no-host-network` — собирать со стандартной сетью Docker вместо `--network=host`.

### Устройства PlatformIO (`c-cpp/platformio/`)

| Директория | Плата | Архитектура | Wokwi CI |
| --- | --- | --- | --- |
| `arduino-nano` | Arduino Nano | ATmega328P (AVR) | ✓ |
| `arduino-pro-micro` | Arduino Pro Micro | ATmega32U4 (AVR, USB HID) | ✓ |
| `esp32-devkit` | ESP32 DevKit V1 | Xtensa LX6, WiFi + BT | ✓ |
| `esp32-s2-saola` | ESP32-S2 Saola | Xtensa LX7, USB OTG | ✓ |
| `esp32-s3-devkitc` | ESP32-S3 DevKitC | Xtensa LX7, AI+IoT | ✓ |
| `esp32-c3-devkitm` | ESP32-C3 DevKitM | RISC-V, WiFi + BT | ✓ |
| `esp32-c6-devkitc` | ESP32-C6 DevKitC | RISC-V, WiFi 6 + Zigbee | ✓ |
| `esp32-h2-devkitm` | ESP32-H2 DevKitM | RISC-V, Zigbee + Thread | ✓ |
| `esp8266-wemos-d1-mini` | Wemos D1 Mini | ESP8266, WiFi | — |
| `rpi-pico` | Raspberry Pi Pico | RP2040, ARM Cortex-M0+ | ✓ |
| `stm32f411-blackpill` | STM32F411 Black Pill | Cortex-M4, 100 MHz | ✓ * |
| `stm32f103-bluepill` | STM32F103 Blue Pill | Cortex-M3, 72 MHz | ✓ |

> \* STM32F411: Wokwi не поддерживает BlackPill напрямую — используется `board-st-nucleo-f411re` (тот же MCU, другой пинаут). ESP8266: Wokwi не поддерживает — только сборка.

---

## Быстрый старт

### Linux / macOS

```bash
# Клонировать в любое место
git clone https://github.com/VaisVaisov/IT-Project-Templates.git ~/IT-Project-Templates

# Создать симлинк в ~/.local/bin (один раз)
ln -s ~/IT-Project-Templates/new-project.sh ~/.local/bin/new-project

# Создать новый проект
new-project --c-cpp --pure ~/Projects/my_cpp_app
new-project --python --pure ~/Projects/my_python_app
new-project --c-cpp --hybrid ~/Projects/my_hybrid_app
new-project --c-cpp --platformio --esp32-devkit ~/Projects/sensor_node
```

### Windows (WSL2)

На Windows вся экосистема работает через WSL2. Установи WSL2 и используй тот же скрипт:

```bash
# Клонировать в WSL2 home
git clone https://github.com/VaisVaisov/IT-Project-Templates.git ~/IT-Project-Templates

# Создать симлинк в ~/.local/bin (в WSL2)
ln -s ~/IT-Project-Templates/new-project.sh ~/.local/bin/new-project

# Создать новый проект (из WSL2)
new-project --c-cpp --pure ~/Projects/my_cpp_app
new-project --python --pure ~/Projects/my_python_app
new-project --c-cpp --hybrid ~/Projects/my_hybrid_app
new-project --c-cpp --platformio --esp32-devkit ~/Projects/sensor_node
```

### После создания проекта

1. Открой папку проекта в VS Code
2. Нажми **"Reopen in Container"** (или `Ctrl+Shift+P` → "Dev Containers: Reopen in Container")
3. При первом запуске контейнер соберётся автоматически
4. Pre-commit хуки установятся сами — можно приступать!

---

## Справка по флагам

```
new-project [--help] <язык> <тип> [устройство] <путь>

Язык:
  --c-cpp            C/C++ проект
  --python           Python проект

Тип:
  --pure             Чистый C/C++ или Python
  --hybrid           Гибридный C/C++ + Python/Cython  (только --c-cpp)
  --platformio       Встраиваемые системы             (только --c-cpp)

Устройства PlatformIO (Arduino):
  --arduino-nano          Arduino Nano (ATmega328P)
  --arduino-pro-micro     Arduino Pro Micro (ATmega32U4, USB HID)

Устройства PlatformIO (ESP32):
  --esp32-devkit          ESP32 DevKit V1 (Xtensa LX6, WiFi + BT)
  --esp32-s2-saola        ESP32-S2 Saola (Xtensa LX7, USB OTG)
  --esp32-s3-devkitc      ESP32-S3 DevKitC (Xtensa LX7, AI+IoT)
  --esp32-c3-devkitm      ESP32-C3 DevKitM (RISC-V, WiFi + BT)
  --esp32-c6-devkitc      ESP32-C6 DevKitC (RISC-V, WiFi 6 + Zigbee)
  --esp32-h2-devkitm      ESP32-H2 DevKitM (RISC-V, Zigbee + Thread)

Устройства PlatformIO (прочие):
  --esp8266-wemos-d1-mini Wemos D1 Mini (ESP8266, WiFi) — только сборка, без Wokwi
  --rpi-pico              Raspberry Pi Pico (RP2040, dual-core ARM Cortex-M0+)
  --stm32f411-blackpill   STM32F411 Black Pill (Cortex-M4, 100 MHz)
  --stm32f103-bluepill    STM32F103 Blue Pill (Cortex-M3, 72 MHz)

Опции:
  --help, -h         Показать эту справку и выйти
```

---

## Установка

### 1. Клонировать репозиторий

```bash
# Linux / macOS / Windows (WSL2)
git clone https://github.com/VaisVaisov/IT-Project-Templates.git ~/IT-Project-Templates
```

### 2. Создать симлинк

```bash
ln -s ~/IT-Project-Templates/new-project.sh ~/.local/bin/new-project
```

> **Примечание:** `new-project.sh` уже исполняемый после клонирования. Если нет: `chmod +x new-project.sh`

### 3. Требования

| Инструмент | Linux / macOS | Windows |
| --- | --- | --- |
| **Docker** | Обязательно — [docker.com](https://www.docker.com/) | Обязательно — [Docker Desktop](https://www.docker.com/products/docker-desktop/) |
| **WSL2** | — | Обязательно — [Руководство по установке WSL2](https://learn.microsoft.com/ru-ru/windows/wsl/install) + расширение **WSL** в VS Code |
| **VS Code** | Обязательно — [code.visualstudio.com](https://code.visualstudio.com/) | Обязательно |
| **Dev Containers extension** | Обязательно — установить из VS Code | Обязательно (открывать проект из WSL2) |
| **GitHub CLI** | Рекомендуется | Рекомендуется (для Windows — в WSL2) |
| **uv** | Для hybrid/python шаблонов — [astral.sh/uv](https://astral.sh/uv) | Для hybrid/python шаблонов — устанавливать в WSL2 |
| **Git** | Обязательно | Обязательно — устанавливать в WSL2 |

> **Совет по GitHub CLI:** авторизуйся один раз на хосте (для Windows — в WSL2) через `gh auth login`. Контейнер монтирует `~/.config/gh` с хоста — повторная авторизация внутри Dev Container не нужна.

---

## Структура репозитория

```
IT-Project-Templates/
├── .github/
│   └── dependabot.yml          # Автообновление зависимостей (Actions + pre-commit)
├── c-cpp/
│   ├── pure/                   # Чистый C/C++ шаблон
│   │   ├── .devcontainer/      # Clang + CMake + Ninja + GDB + lcov + valgrind
│   │   ├── .github/
│   │   │   ├── workflows/      # ci.yml + release.yml
│   │   │   └── ISSUE_TEMPLATE/
│   │   ├── .vscode/
│   │   ├── benchmarks/         # Google Benchmark примеры
│   │   ├── tools/profiler/     # Valgrind + perf скрипты
│   │   └── ...
│   ├── hybrid/                 # C/C++ + Python/Cython шаблон
│   │   ├── .devcontainer/      # Clang + Python + Cython + ruff + pylint
│   │   ├── .github/
│   │   │   ├── workflows/      # ci.yml + release.yml
│   │   │   └── ISSUE_TEMPLATE/
│   │   ├── .vscode/
│   │   ├── benchmarks/         # Google Benchmark примеры
│   │   ├── tools/profiler/     # Valgrind + perf + Python профилировщики
│   │   └── ...
│   └── platformio/             # Шаблоны для встраиваемых систем
│       ├── devcontainers/      # Dev Container'ы по семействам плат
│       │   ├── base/           # Arduino + ESP (PlatformIO + Clang)
│       │   ├── stm32/          # STM32 (+ ST-Link инструменты + GDB)
│       │   └── pico/           # Raspberry Pi Pico (+ picotool)
│       ├── .vscode/            # Общая конфигурация VS Code
│       ├── arduino/            # Шаблон семейства Arduino
│       ├── esp32/              # Шаблон семейства ESP32
│       ├── esp8266/            # Шаблон семейства ESP8266
│       ├── stm32/              # Шаблон семейства STM32
│       └── pico/               # Шаблон Raspberry Pi Pico
├── python/
│   └── pure/                   # Чистый Python шаблон
│       ├── .devcontainer/      # Python + ruff + pylint + mypy
│       ├── .github/
│       │   ├── workflows/      # ci.yml + release.yml
│       │   └── ISSUE_TEMPLATE/
│       ├── .vscode/
│       ├── tools/profiler/     # Python профилировщики
│       └── ...
├── meta-template/              # Основа для создания новых шаблонов
├── new-project.sh              # Скрипт для Linux / macOS / Windows (WSL2)
├── LICENSE
└── README.md
```

---

## Возможности Dev Container

Каждый контейнер собран на **Arch Linux (latest)** и включает:

- **Оболочка**: Zsh с Oh My Zsh + Powerlevel10k
- **Редактор**: Neovim
- **VCS**: Git, git-delta, GitHub CLI
- **AI-агенты**: Claude Code, Qwen Code, Cline CLI (из AUR) — все доступны как CLI-инструменты
- **Docker**: Docker + Docker Buildx + Lazydocker (для запуска контейнеров внутри контейнеров)
- **GitHub auth**: `~/.config/gh` монтируется с хоста — повторная авторизация не нужна

### C/C++ контейнеры

- Clang, LLD, LLDB, compiler-rt
- CMake, Ninja
- GDB, valgrind
- cppcheck, lcov
- pre-commit

### Гибридные контейнеры (C/C++ + Python)

Всё из C/C++, плюс:

- Python 3, pip, uv, virtualenv
- Cython, NumPy
- pytest, pytest-cov
- ruff, pylint, mypy
- Sphinx, furo, breathe (документация)
- py-spy, memory-profiler (профилирование Python)

### Python контейнеры

- Python 3, pip, uv, virtualenv
- pytest, pytest-cov
- ruff, pylint, mypy
- Sphinx, furo
- pre-commit

### PlatformIO контейнеры (Arduino + ESP)

- PlatformIO Core + udev правила
- Clang, cppcheck (статический анализ)
- Python 3, pip
- pre-commit
- Доступ к USB-устройствам (контейнер запускается с `--privileged`)

### PlatformIO контейнеры (STM32)

Всё из Arduino + ESP, плюс:

- stlink (`st-flash`, `st-info`, `st-util` — прошивка и отладка через ST-Link)
- GDB (отладчик для подключения к `st-util` GDB-серверу)

### PlatformIO контейнеры (Pico)

Всё из Arduino + ESP, плюс:

- picotool (работа с прошивкой Raspberry Pi Pico без BOOTSEL)

---

## Расширения VS Code

Все шаблоны автоматически устанавливают расширения при открытии в Dev Container и показывают их как рекомендации при открытии без Docker.

### Общие (все шаблоны)

| Категория | Расширение | Назначение |
| --- | --- | --- |
| **AI** | Claude Code | AI-агент (CLI + VS Code) |
| | TONGYI Lingma | AI-ассистент и автодополнение |
| | Cline | AI-агент с поддержкой 400+ моделей |
| **Git** | GitLens | Расширенные возможности Git (blame, история) |
| | Git Graph | Визуальный граф коммитов |
| **Качество кода** | Better Comments | Цветные TODO/FIXME/NOTE комментарии |
| | Code Spell Checker | Проверка орфографии в коде и комментариях |
| **Docker** | Docker | Управление контейнерами |
| **Markdown** | Markdown All in One | Полная поддержка Markdown |
| | Markdown Converter | Экспорт в PDF/HTML/Word |
| **Форматы** | YAML (Red Hat) | Поддержка YAML |
| | JSON (Meezilla) | Расширенное редактирование JSON |

### C/C++ шаблоны

- **C/C++ Tools** — IntelliSense и отладка
- **clangd** — Расширенный анализ кода и навигация
- **Code Runner** — Быстрый запуск кода

### Python шаблоны

- **Python** + **Pylance** — Базовая поддержка и языковой сервер
- **debugpy** — Отладчик Python
- **Python Envs** — Управление виртуальными окружениями
- **autodocstring** — Автогенерация docstring
- **Django** + **Jinja** — Поддержка фреймворков (Pure Python)

### Гибридные шаблоны

Все расширения для C/C++ и Python вместе.

### PlatformIO шаблоны

- **PlatformIO IDE** — Платформа для встраиваемых систем
- **Wokwi Simulator** — Интерактивный симулятор Arduino/ESP32/STM32 прямо в VS Code
- **C/C++ Tools** — Поддержка кода для микроконтроллеров

---

## Качество кода & CI/CD

### Pre-commit хуки

Хуки запускаются автоматически перед каждым коммитом. Устанавливаются при старте Dev Container (`postCreateCommand`) — и обычные хуки, и хук для проверки сообщения коммита.

#### C/C++ проекты
- **clang-format** — Автоматическое форматирование кода (стиль LLVM)
- **clang-tidy** — Статический анализ на баги и стилевые проблемы
- **cppcheck** — Утечки памяти, null pointer, неопределённое поведение
- **valgrind memcheck** — Обнаружение ошибок памяти во время выполнения (hybrid + pure)

#### Python проекты
- **ruff** — Быстрый линтинг + сортировка импортов (заменяет flake8 + isort)
- **ruff-format** — Форматирование кода (совместимо с black)
- **pylint** — Глубокий семантический анализ: недостижимый код, неверное количество аргументов, обращение к несуществующим атрибутам
- **mypy** — Статическая проверка типов

#### Все проекты
- **commitlint** — Проверка формата сообщений коммитов по [Conventional Commits](https://www.conventionalcommits.org/)
- **detect-secrets** — Блокирует коммит при обнаружении секретов (API-ключи, токены, пароли)
- Валидация YAML
- Обнаружение больших файлов (> 1 МБ)
- Удаление пробелов в конце строк
- Исправление конца файла
- Обнаружение конфликтов слияния

> Если хук падает — коммит блокируется до исправления проблемы. Это не даёт сломанному коду попасть в репозиторий.

### GitHub Actions

Каждый шаблон включает два воркфлоу: `ci.yml` (запускается на каждый push/PR) и `release.yml` (запускается на тег `v*`).

#### C/C++ Pure & Hybrid
- **Lint**: pre-commit проверки (clang-format, clang-tidy, cppcheck, commitlint)
- **Build**: сборка CMake Debug + Release пресетами
- **Test**: тесты GoogleTest через ctest
- **Benchmark**: запуск Google Benchmark бинарей (если есть в `benchmarks/`)
- **Coverage**: gcov + lcov — HTML отчёт + summary в GitHub Actions UI + coverage badge на GitHub Pages
- **Sanitize ASan**: AddressSanitizer + UBSan + LeakSanitizer — обнаружение ошибок памяти и UB
- **Sanitize MSan**: MemorySanitizer (Clang) — неинициализированная память
- **Sanitize TSan**: ThreadSanitizer — гонки данных и проблемы многопоточности
- **Valgrind**: `ctest -T memcheck` — детальный анализ памяти на весь набор тестов
- **Matrix**: тестирование на Python 3.10–3.13 (только hybrid)
- **Security**: Trivy — сканирование на CVE (HIGH/CRITICAL, блокирует merge)
- **Docs**: Doxygen (pure) или Doxygen + Sphinx/furo (hybrid) → GitHub Pages при пуше в `main`
- **Release**: на тег `v*` — git-cliff генерирует CHANGELOG, собирает артефакты, создаёт GitHub Release

#### Python Pure
- **Lint**: pre-commit проверки (ruff, pylint, mypy, commitlint)
- **Test**: pytest + coverage summary в GitHub Actions UI + комментарий с coverage в PR
- **Coverage badge**: публикуется на GitHub Pages при пуше в `main`
- **Matrix**: тестирование на Python 3.10–3.13
- **Security**: Trivy — сканирование на CVE (HIGH/CRITICAL, блокирует merge)
- **Docs**: Sphinx + furo → GitHub Pages (`main`) + ReadTheDocs (все ветки/теги)
- **Release**: на тег `v*` — git-cliff генерирует CHANGELOG, собирает wheel + sdist, создаёт GitHub Release

Все воркфлоу запускаются на **Arch Linux контейнерах** — для полного соответствия окружению разработки.

### Dependabot

В корне репозитория находится `.github/dependabot.yml` — он автоматически следит за актуальностью версий во всех шаблонах и предлагает обновления через PR. Покрывает:

- **GitHub Actions** — версии actions/checkout, upload-artifact и других
- **pre-commit хуки** — ревизии clang-format, ruff, mypy, pylint и других

Обновления проверяются еженедельно — никакого ручного отслеживания версий.

### AI-контекст для агентов

Каждый сгенерированный проект содержит файл `@PROJECT_NAME@.md` — единый источник правды с описанием архитектуры, стека технологий, инструкций по сборке и правил для AI-агентов. `CLAUDE.md`, `QWEN.md` и `AGENTS.md` являются симлинками на этот файл, поэтому Claude Code, Qwen Code и Cline автоматически читают один и тот же контекст.

---

## PlatformIO шаблоны

### Поддерживаемые платы

| Директория | Плата | Архитектура | Wokwi CI |
| --- | --- | --- | --- |
| `arduino-nano` | Arduino Nano | ATmega328P (AVR) | ✓ |
| `arduino-pro-micro` | Arduino Pro Micro | ATmega32U4 (AVR, USB HID) | ✓ |
| `esp32-devkit` | ESP32 DevKit V1 | Xtensa LX6, WiFi + BT | ✓ |
| `esp32-s2-saola` | ESP32-S2 Saola | Xtensa LX7, USB OTG | ✓ |
| `esp32-s3-devkitc` | ESP32-S3 DevKitC | Xtensa LX7, AI+IoT | ✓ |
| `esp32-c3-devkitm` | ESP32-C3 DevKitM | RISC-V, WiFi + BT | ✓ |
| `esp32-c6-devkitc` | ESP32-C6 DevKitC | RISC-V, WiFi 6 + Zigbee | ✓ |
| `esp32-h2-devkitm` | ESP32-H2 DevKitM | RISC-V, Zigbee + Thread | ✓ |
| `esp8266-wemos-d1-mini` | Wemos D1 Mini | ESP8266, WiFi | — |
| `rpi-pico` | Raspberry Pi Pico | RP2040, ARM Cortex-M0+ | ✓ |
| `stm32f411-blackpill` | STM32F411 Black Pill | Cortex-M4, 100 MHz | ✓ * |
| `stm32f103-bluepill` | STM32F103 Blue Pill | Cortex-M3, 72 MHz | ✓ |

> \* STM32F411: Wokwi не поддерживает BlackPill напрямую — `diagram.json` использует `board-st-nucleo-f411re` (тот же MCU STM32F411, другой пинаут). ESP8266: Wokwi не поддерживает — только сборка.

### Wokwi: симулятор без железа

Wokwi позволяет запускать прошивку в браузере или VS Code без физического устройства.

**Схема `diagram.json`:**
Нарисуй схему на [wokwi.com](https://wokwi.com), скачай `diagram.json` и положи в корень проекта. Wokwi CI и расширение VS Code используют один и тот же файл.

**Настройка в VS Code:**
1. Установи расширение **Wokwi Simulator**
2. Активируй лицензию (бесплатно для личных проектов) через `Ctrl+Shift+P` → "Wokwi: Request Free License"
3. Открой `diagram.json` в корне проекта — схема откроется в редакторе Wokwi
4. Нажми ▶ для запуска симуляции

**Настройка Wokwi CI (GitHub Actions):**
1. Получи токен на [wokwi.com/ci](https://wokwi.com/ci)
2. Добавь в GitHub Secrets: `Settings` → `Secrets and variables` → `Actions` → `New repository secret` → `WOKWI_CLI_TOKEN`
3. CI автоматически запустит симуляцию и проверит вывод в Serial

### Базовые команды

```bash
pio run                        # Сборка прошивки
pio run -t upload              # Сборка и загрузка на устройство
pio device monitor             # Открыть Serial Monitor
pio device monitor --baud 115200
pio test                       # Запуск юнит-тестов на устройстве
pio run --target size          # Статистика размера прошивки
pio check                      # Статический анализ кода
```

### Выбор фреймворка

По умолчанию все шаблоны используют `framework = arduino`. Это можно изменить в `platformio.ini`:

```ini
[env:esp32dev]
platform = espressif32
board    = esp32dev
framework = arduino      ; стандартный — богатая экосистема библиотек

; Альтернативы (раскомментировать нужное):
; framework = espidf     ; ESP-IDF — полный контроль, нативный SDK Espressif
; framework = arduino    ; можно совмещать с ESP-IDF компонентами
```

| Фреймворк | Платформа | Когда использовать |
| --- | --- | --- |
| `arduino` | Все | Максимум готовых библиотек, быстрый старт |
| `espidf` | ESP32 | Полный контроль, Bluetooth/WiFi stack, FreeRTOS |
| `arduino` (с ESP-IDF) | ESP32 | Библиотеки Arduino + ESP-IDF компоненты |
| `pico-sdk` | Raspberry Pi Pico | Прямой доступ к RP2040 SDK |
| `arduino` | Pico | Совместимость с Arduino экосистемой |

### Загрузка прошивки

Протокол загрузки указывается в `platformio.ini`:

```ini
; upload_protocol = esptool     ; ESP32/ESP8266 — USB UART (по умолчанию)
; upload_protocol = espota      ; ESP32/ESP8266 — OTA (по воздуху)
; upload_protocol = esp-prog    ; ESP32 — JTAG отладчик
; upload_protocol = stlink      ; STM32 — ST-Link программатор
; upload_protocol = picotool    ; Raspberry Pi Pico — USB (hold BOOTSEL)
; upload_protocol = arduino     ; Arduino AVR — через bootloader
; upload_protocol = usbasp      ; Arduino AVR — программатор USBasp
```

### CI/CD

- **Lint**: pre-commit проверки (clang-format, cppcheck, commitlint)
- **Build**: `pio run` — компиляция прошивки
- **Test**: `pio test` (если есть директория test)
- **Size**: `pio run --target size` — отчёт о размере прошивки
- **Static analysis**: `pio check --fail-on-defect high`
- **Wokwi CI**: симуляция прошивки в облаке (кроме ESP8266) — настройка в разделе [Wokwi](#wokwi-симулятор-без-железа) выше
- **Release**: на тег `v*` — загружает `.elf`/`.hex`/`.bin` в GitHub Release

Воркфлоу запускаются на **Arch Linux контейнерах** — для полного соответствия окружению разработки.

---

## Возможности и использование

### Тесты

#### C/C++ (GoogleTest)

```bash
# Сборка и запуск всех тестов
cmake --preset linux-debug && cmake --build --preset linux-debug
cd cmake-build-linux-debug && ctest --output-on-failure

# Запуск конкретного теста
ctest -R MyTest --output-on-failure

# Verbose вывод
ctest -V
```

Тесты находятся в `test/`. Каждый `*_test.cpp` автоматически подхватывается CMake.

#### Python (pytest)

```bash
# Запуск всех тестов
python -m pytest -v

# Конкретный файл или тест
python -m pytest tests/test_module.py::test_function -v

# С подробным выводом при падении
python -m pytest -v --tb=short
```

---

### Покрытие кода (Coverage)

#### C++ — lcov

```bash
# Сборка с покрытием
cmake --preset linux-coverage && cmake --build --preset linux-coverage

# Запуск тестов и генерация отчёта
cd cmake-build-linux-coverage
ctest --output-on-failure
lcov --capture --directory . --output-file coverage.info
lcov --remove coverage.info '/usr/*' '*/libraries/*' '*/test/*' --output-file coverage.info
genhtml coverage.info --output-directory coverage-html

# Открыть отчёт в браузере
xdg-open coverage-html/index.html
```

HTML-отчёт показывает покрытие по файлам, функциям и строкам. Зелёный — покрыто, красный — нет.

#### Python — pytest-cov

```bash
# Покрытие с выводом в терминал
python -m pytest --cov --cov-report=term

# HTML-отчёт
python -m pytest --cov --cov-report=html
xdg-open htmlcov/index.html

# Показывать непокрытые строки
python -m pytest --cov --cov-report=term-missing
```

#### Badges и PR-комментарии

После пуша в `main` GitHub Actions автоматически публикует coverage badge на GitHub Pages. При каждом PR в комментарии появляется текущий процент покрытия.

---

### Google Benchmark

Google Benchmark позволяет измерять производительность отдельных функций с наносекундной точностью.

```bash
# Сборка в Release (обязательно — Debug искажает результаты)
cmake --preset linux-release && cmake --build --preset linux-release

# Запуск всех бенчмарков
./cmake-build-linux-release/bench_example  # или название твоего бинаря

# Фильтрация по имени
./cmake-build-linux-release/bench_example --benchmark_filter=BM_MyFunction

# Вывод в JSON для последующего анализа
./cmake-build-linux-release/bench_example --benchmark_out=results.json --benchmark_out_format=json

# Сравнение двух запусков
benchmark_compare results_before.json results_after.json
```

Пример вывода:
```
Benchmark                Time        CPU      Iterations
--------------------------------------------------------
BM_VectorPushBack       45.2 ns    45.1 ns    15000000
BM_MapInsert           120.5 ns   120.3 ns     5800000
```

Бенчмарки находятся в `benchmarks/`. Добавляй новые по образцу `bench_example.cpp`.

---

### Санитайзеры

Санитайзеры — это инструменты компилятора, которые обнаруживают ошибки во время выполнения: переполнения буфера, гонки данных, утечки памяти, неопределённое поведение.

#### ASan + UBSan + LSan — ошибки памяти и UB

```bash
cmake --preset linux-asan && cmake --build --preset linux-asan
cd cmake-build-linux-asan && ctest --output-on-failure
```

Что ловит:
- **ASan** (AddressSanitizer) — выход за границы массива, use-after-free, double-free
- **UBSan** (UndefinedBehaviorSanitizer) — переполнение целых чисел, сдвиг на отрицательное число, нулевые указатели
- **LSan** (LeakSanitizer) — утечки памяти

#### MSan — неинициализированная память

```bash
cmake --preset linux-msan && cmake --build --preset linux-msan
cd cmake-build-linux-msan && ctest --output-on-failure
```

Ловит чтение из неинициализированной памяти. **Только Clang.**

#### TSan — гонки данных

```bash
cmake --preset linux-tsan && cmake --build --preset linux-tsan
cd cmake-build-linux-tsan && ctest --output-on-failure
```

Ловит data race в многопоточном коде.

> Санитайзеры нельзя комбинировать друг с другом — каждый запускается отдельно. В CI они идут параллельными джобами.

---

### Valgrind

Valgrind работает без перекомпиляции — анализирует уже собранный Debug-бинарь.

#### Memcheck — ошибки памяти

```bash
# Все тесты через ctest (режим CI и pre-commit)
tools/profiler/run-memcheck.sh

# Конкретный бинарь
tools/profiler/run-memcheck.sh my_binary
```

Что ловит: выход за границы массива, use-after-free, утечки памяти, некорректные системные вызовы.

#### Helgrind — гонки данных

```bash
# Все тесты
tools/profiler/run-helgrind.sh

# Конкретный бинарь
tools/profiler/run-helgrind.sh my_binary
```

Аналог TSan, но без перекомпиляции. Медленнее, зато не нужен специальный билд.

#### DRD — гонки данных (альтернатива)

```bash
tools/profiler/run-drd.sh          # все тесты
tools/profiler/run-drd.sh my_binary
```

Менее точен, чем Helgrind, но быстрее.

> **Когда что использовать:** Sanitizers — быстрее, удобнее в разработке. Valgrind — для финальной проверки или когда нет возможности перекомпилировать.

---

### Профилирование C++

#### Callgrind — граф вызовов и время CPU

```bash
tools/profiler/run-callgrind.sh my_binary
# Результат: profiles/callgrind.out
```

Визуализировать: загрузи `callgrind.out` на [speedscope.app](https://speedscope.app) — интерактивный flamegraph в браузере.

Показывает: какие функции потребляют больше всего CPU, граф вызовов, количество инструкций.

#### Cachegrind — промахи кэша

```bash
tools/profiler/run-cachegrind.sh my_binary
# Результат: profiles/cachegrind.out
```

Показывает: количество промахов L1/L2/L3 кэша, промахи предсказания ветвлений. Помогает оптимизировать доступ к памяти.

#### Massif — использование кучи

```bash
tools/profiler/run-massif.sh my_binary
# Результат: profiles/massif.out (с текстовым отчётом в stdout)
```

Показывает: рост и спад использования кучи во времени, пики аллокаций.

#### perf — системное профилирование

```bash
tools/profiler/run-perf.sh my_binary
```

Быстрый sampling profiler Linux. Показывает горячие точки с минимальным оверхедом.

---

### Профилирование Python (hybrid + python/pure)

#### cProfile — статистика вызовов функций

```bash
tools/profiler/profile-python.sh
# Результат: profiles/profile.prof — визуализировать: snakeviz profiles/profile.prof
```

Показывает: количество вызовов каждой функции, суммарное и среднее время. Визуализация через snakeviz открывает интерактивный граф в браузере.

#### tracemalloc — использование памяти

```bash
tools/profiler/profile-memory.sh
# Результат: profiles/memory_stats.txt
```

Показывает: топ-10 аллокаций памяти по строкам кода.

#### py-spy — sampling profiler без изменения кода

```bash
tools/profiler/profile-spy.sh
# Результат: profiles/pyspy.svg — открыть в браузере
```

Работает без изменений в коде, минимальный оверхед. SVG-flamegraph: открой в браузере, кликай по блокам для zoom.

---

### Документация

#### C/C++ Pure — Doxygen

```bash
# Генерация документации
doxygen Doxyfile

# Открыть в браузере
xdg-open docs/html/index.html
```

Документируй код через комментарии:
```cpp
/// @brief Вычисляет сумму двух чисел
/// @param a первое слагаемое
/// @param b второе слагаемое
/// @return сумма a и b
int add(int a, int b);
```

#### Hybrid & Python Pure — Sphinx

```bash
# Сборка документации
cd docs && make html

# Открыть в браузере
xdg-open docs/_build/html/index.html
```

Гибридный шаблон использует **Breathe** для импорта C++ API из Doxygen в Sphinx — документация C++ и Python собирается в единый сайт с темой **furo** (поддержка тёмной темы).

#### Публикация

- **GitHub Pages** — автоматически при каждом пуше в `main`
- **ReadTheDocs** — автоматически при каждом пуше (все ветки и теги, с версионированием)

Для подключения ReadTheDocs:
1. Подключи репозиторий на [readthedocs.org](https://readthedocs.org)
2. ReadTheDocs автоматически обнаружит `.readthedocs.yaml` и начнёт сборку при каждом пуше

---

## Лицензия

**MIT License** — Copyright © 2025–2026 Vais Vaisov

Свободно использовать, изменять и распространять.

---

## Участие в разработке

Мы рады любому вкладу! Прочитайте [CONTRIBUTING.md](.github/CONTRIBUTING.md) и открывайте issue или Pull Request.

---

<div align="center">

*IT Project Templates — от нуля до кода за минуты*

</div>
