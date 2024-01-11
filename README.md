# Money-and-Fame

A Flutter project designed to help users effectively manage and monitor budgetary allocations. This application serves as a versatile financial companion, providing users with a user-friendly interface to track and analyze spending habits among housemates, couples, or individuals. I adopt **a lot of** codes and take inspiration from many sources to quickly build the app to serve my purpose and personal usage. I just put it here for everyone if they find the app useful :purple_heart:!

## Getting Started
### Prerequisites
You'll need to install Flutter SDK on your computer before downloading this project.<br>
Link to Flutter in Github: https://github.com/flutter/flutter<br>
Link to Flutter's website: https://docs.flutter.dev/
### Installation
Create or go to your project folder. Paste `git clone https://github.com/DucAnh-Vu-Trinh/Money-and-Fame.git` to your terminal.
## Usage
### As developer
The lib/CustomWidgets folder has all the major Widgets in the app, aiming to make it easier for you to reuse the code.<br>
The lib/Functions contains some main functions that are used in the app, especially the summary_calculation file that has functions used in the summary_page.<br>
The app uses the provider and shared_preferences packages to handle switching between light and dark theme. Look here for more information: [Medium Page](https://medium.flutterdevs.com/implement-dark-mode-in-flutter-using-provider-158925112bf9).<br>
There are 3 pages (screens) in the app:
* welcome_page uses images from https://undraw.co.
* first_page use ListView.builder and Card Widgets to create a dynamic list of items (a list that can change in length)
* second_page utilizes a flutter template that I found here: [task-planner-app](https://github.com/TheAlphaApp/flutter-task-planner-app/tree/master) (BSD 3-Clause License, Copyright (c) 2020, Sourav Kumar Suman).
* summary_page also uses ListView.builder and Card Widgets to build a list of Card widgets. The item in the ListView can be filtered by the Switch Widget in the Drawer Widget using the Visibility Widget. **_ValueNotifier_** and **_ValueListenableBuilder_** are used to trigger the rebuilding of the UI when one of the Switch Widgets are toggled.
### As app user
The welcome screen will appear when first oppening the app.
## License
MIT License

Copyright (c) 2024 Duc Anh Vu Trinh
