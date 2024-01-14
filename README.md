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
:heavy_check_mark: The _lib/CustomWidgets_ folder has all the major Widgets in the app, aiming to make it easier for you to reuse the code.<br>
:heavy_check_mark: The _lib/Functions_ contains some main functions used in the app, especially the summary_calculation file with functions used in the summary_page.<br>
:heavy_check_mark: The app uses the `provider` and `shared_preferences` packages to handle switching between light and dark theme. Look here for more information: [Medium Page](https://medium.flutterdevs.com/implement-dark-mode-in-flutter-using-provider-158925112bf9).<be>

There are 3 pages (screens) in the app:
* welcome_page uses images from https://undraw.co.
* first_page uses `ListView.builder` and `Card` Widgets to create a dynamic list of items (a list that can change in length)
* second_page utilizes a flutter template that I found here: [task-planner-app](https://github.com/TheAlphaApp/flutter-task-planner-app/tree/master) (BSD 3-Clause License, Copyright (c) 2020, Sourav Kumar Suman).
* summary_page also uses ListView.builder and Card Widgets to build a list of Card widgets. The item in the ListView can be filtered by the Switch Widget in the Drawer Widget using the Visibility Widget. **_ValueNotifier_** and **_ValueListenableBuilder_** are used to trigger the rebuilding of the UI when one of the Switch Widgets is toggled.

### As app user
The welcome screen will appear when first opening the app.
* Tap the "Create New" text if you want to create a new Budget file.
  - You can add more or fewer participants' names in your budget app with the :heavy_plus_sign: or :heavy_minus_sign: button. For example, if you have a trip with a friend of yours and want to keep track of how much you and your friend owe each other during the trip, the budget file will have two participants. Simply type your and your friend's names in the box.
  - Tap 'Done' when done. You will have a second chance to look at the names to notice any typos and tap 'Create Excel' if everything looks good.
  - You can tap the 'Drive' icon in the top-right corner to choose the created Excel file and start editing.
> [!NOTE]
> The created file is in Excel format, so you can also view or edit the file in the Excel software or upload it to Google Sheets.
* Tap the "Import Old File" if you want to edit your already created Budget file.
  - After adding the necessary information, tap "Add Entries" to add to the Budget file. You can tap "Delete Entries" if you want to delete the last entries you added.
  - Add a description of the entries in the 'Title' text box.
  - You can choose the date of the entries.
  - If you spend money, put your name in the 'Who Lost' text box.
  - If you earn money, put your name in the 'Who Gain' text box.
  - If you spend money for your friend (your friend owes you the money), put your name in the 'Who Lost' text box, and your friend's name in the 'Who Gain' text box.
  - Put the amount of money in the 'Amount' text box.
    
    > ⚠️
    > You have to save the Budget file again at the end after done adding or deleting every entry.

## License
MIT License

Copyright (c) 2024 Duc Anh Vu Trinh
