import 'package:flutter/material.dart';
import 'package:my_test_app/CustomWidgets/light_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';
import 'package:my_test_app/Functions/Preferences/model_theme.dart';
import 'package:provider/provider.dart';

Map<String, bool> summaryDataFilter = {};

class SummaryPage extends StatefulWidget{
  final Map<String, List<String>> summaryData;
  late final List<ValueNotifier<bool>> itemVisibilities;
  final ValueNotifier<bool> allItemVisible = ValueNotifier(false);

  SummaryPage({super.key, required this.summaryData}){
    itemVisibilities = List.generate(summaryData.length, (index) => ValueNotifier(true));
  }
  @override
  _SummaryPage createState() => _SummaryPage();
}

class _SummaryPage extends State<SummaryPage>{
  void notifySwitch (){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
      builder: (context, ModelTheme themeNotifier, child) {
        return Scaffold(
          endDrawer: Drawer(
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              padding: EdgeInsets.zero,
              children: [
                Material(
                  color: LightColors.kDarkBlue,
                  child: InkWell(
                    child: Container(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top,
                        bottom: 24,
                        ),
                      child: const Column(
                        children: [
                          SizedBox(height: 12,),
                          Text(
                            'Summary Filter',
                            style: TextStyle(
                                fontSize: 28,
                                color: Colors.white
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ),
                CupertinoSwitchExample(titleKey: 'All', switchVal: widget.allItemVisible, enabled: ValueNotifier(false), notifySwitch: notifySwitch,),
                for (int i = 0; i < widget.itemVisibilities.length; i++)
                  CupertinoSwitchExample(titleKey: widget.summaryData.keys.toList()[i], switchVal: widget.itemVisibilities[i], enabled: widget.allItemVisible,),
                ],
              ),
            ),
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () {Navigator.pop(context);},
              ),
              title: Text(
                'Summary',
                style: TextStyle(
                  color: themeNotifier.isDark ? LightColors.kDarkYellow : LightColors.kDarkBlue,
                  fontSize: 25,
                ),
              ),
              backgroundColor: themeNotifier.isDark ? DarkColors.kDarkerGreen : LightColors.kDarkYellow,
            ),
            body: ListsWithCards(
              summaryData: widget.summaryData, 
              itemVisibility: widget.itemVisibilities,
              allVisible: widget.allItemVisible,
            ),
          );
      }
    );
  }
}

class ListsWithCards extends StatelessWidget {
  final Map<String, List<String>> summaryData;
  final List<ValueNotifier<bool>> itemVisibility;
  final ValueNotifier<bool> allVisible;

  const ListsWithCards({super.key, required this.summaryData, required this.itemVisibility, required this.allVisible});
  @override
  Widget build(BuildContext context) {
    // Build listData, titleData from Summary
    List<List<String>> listsData = [];
    List<String> titleData = [];

    summaryData.forEach( (title, value){
      listsData.add(value);
      titleData.add(title);
    });

    return ListView.builder(
      itemCount: listsData.length,
      itemBuilder: (context, index) {
        return MultiValueListenableBuilder(
          valueListenables: [
            itemVisibility[index],
            allVisible,
          ], 
          builder: (context, value, _) {
            return Visibility(
              visible: allVisible.value || itemVisibility[index].value,
              child: CardList(
                listData: listsData[index], 
                titleData: titleData[index],
              )
            );   
          });
      },
    );
  }
}

class CardList extends StatelessWidget {
  final List<String> listData;
  final String titleData;
  const CardList({super.key, required this.listData, required this.titleData,});

  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
      builder: (context, ModelTheme themeNotifier, child) {
        return Card(
          margin: const EdgeInsets.all(10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          color: themeNotifier.isDark ? DarkColors.kDarkGreen : Colors.grey[200],
          shadowColor: LightColors.kLightYellow2,
          elevation: 5,
          child: Column(
            children: [
              ListTile(
                title: Text(
                  titleData,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Divider(),
              ListView.builder(
                itemCount: listData.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(listData[index]),
                  );
                },
              ),
            ],
          ),
        );
      }
    ); 
  }
}

class CupertinoSwitchExample extends StatefulWidget {
  final String titleKey;
  final ValueNotifier<bool> switchVal;
  final ValueNotifier<bool> enabled;
  final Function? notifySwitch;
  const CupertinoSwitchExample({super.key, required this.titleKey, required this.switchVal, required this.enabled, this.notifySwitch});

  @override
  State<CupertinoSwitchExample> createState() => _CupertinoSwitchExampleState();
}

class _CupertinoSwitchExampleState extends State<CupertinoSwitchExample> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.enabled, 
      builder: (context, value, _){
        return SwitchListTile.adaptive(
          // This bool value toggles the switch.
          value: widget.switchVal.value,
          title: Text(widget.titleKey),
          activeColor: CupertinoColors.activeOrange,
          onChanged: !widget.enabled.value ? (bool? value) {
            // This is called when the user toggles the switch.
            setState(() {
              widget.switchVal.value = value ?? false;
              summaryDataFilter[widget.titleKey] = widget.switchVal.value;
              // widget.notifySwitch;
            });
          } : null,
        );
      },
    );
  }
}