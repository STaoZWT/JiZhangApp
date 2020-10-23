import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './const/common_color.dart';
import './service/app_info.dart';
import './service/shared_pref.dart';

class SetThemePage extends StatefulWidget {
  @override
  _SetThemePageState createState() => _SetThemePageState();
}

class _SetThemePageState extends State<SetThemePage> {

  String _colorKey;

  @override
  void initState() {
    super.initState();
    _initColorKey;
  }

  _initColorKey() async {
    _colorKey = await getColorKey();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }
        ),
        title: Text("设置主题颜色"),
      ),
      body: ListView(
        children: <Widget>[
          ExpansionTile(
            leading: Icon(Icons.color_lens),
            title: Text('主题'),
            initiallyExpanded: true,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: themeColorMap.keys.map((key) {
                    Color value = themeColorMap[key];
                    return InkWell(
                      onTap: () async {
                        setState(() {
                          _colorKey = key;
                        });
                        await setColorKey(key);
                        Provider.of<AppInfoProvider>(context, listen: false).setTheme(key);
                      },
                      child: Container(
                        width: 100,
                        height: 100,
                        color: value,
                        child: _colorKey == key ? Icon(Icons.done, color: Colors.white,) : null,
                      ),
                    );
                  }).toList(),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

}