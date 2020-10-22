import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class AccountCardPage extends StatefulWidget {
  AccountCardPage({Key key, this.title}): super(key: key);

  final String title;

  @override
  _AccountCardPageState createState() => new _AccountCardPageState();
}

class _AccountCardPageState extends State<AccountCardPage> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
      ),
      body:  new Swiper(
        itemBuilder: (BuildContext context,int index){
          return new Image.network("http://via.placeholder.com/350x150",fit: BoxFit.fill,);
        },
        itemCount: 3,
        pagination: new SwiperPagination(),
        control: new SwiperControl(),
      ),
    );

  }

}