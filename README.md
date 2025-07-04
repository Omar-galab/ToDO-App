# 📝 ToDo App

A clean and minimal Flutter ToDo app that helps users manage daily tasks efficiently with an intuitive UI and local data persistence. Built using Flutter, Cubit for state management, and Hive for local storage.

---

## ✨ Features

- ✅ Add, update, and delete tasks
- 🗓 Mark tasks as complete or incomplete
- 📦 Local storage with Hive (offline support)
- 🧭 Responsive UI for all screen sizes
- 🎨 Clean Architecture (Separation of concerns)
- ⚡ Fast performance and smooth animations

---

## 🧪 Screenshots

| Home Screen | Add Task | Task Completed |
|------------|----------|----------------|
| ![Home](screenshots/home.png) | ![Add](screenshots/add.png) | ![Done](screenshots/done.png) |

> *(Add screenshots to `/screenshots` folder and update these links)*

---

## 🔧 Tech Stack

- **Flutter** – UI Framework  
- **Dart** – Programming Language  
- **Cubit** – State Management  
- **Hive** – Lightweight key-value database  
- **Clean Architecture** – Maintainable project structure  

---
📂 Project Structure
```bash
lib/
│
├── features/
│   ├── todo/
│   │   ├── data/         # Hive models and local storage
│   │   ├── logic/        # Cubit and states
│   │   ├── presentation/ # Screens and widgets
│
├── core/
│   ├── utils/            # Helpers and constants
│
├── main.dart             # Entry point
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK
- Dart
- A modern code editor (e.g., VS Code)

### Installation

```bash
git clone https://github.com/Omar-galab/ToDO-App.git
cd ToDO-App
flutter pub get
flutter run



