
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';
import 'package:flutter_trip/widget/webview.dart';

/// 网格卡片
class GridNav extends StatelessWidget {
    final GridNavModel gridNavModel;

    const GridNav({Key key, @required this.gridNavModel}) : super(key: key);
    
    @override
    Widget build(BuildContext context) {
        return PhysicalModel(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            clipBehavior: Clip.antiAlias,
            child:  Column(
                children: _gridNavItems(context),
            ),
        );
    }

    _gridNavItems(BuildContext context) {
        List<Widget> items = [];
        if (gridNavModel == null) return items;
        if (gridNavModel.hotel != null) {
            items.add(_gridNavItem(context, gridNavModel.hotel, true));
        }
        if (gridNavModel.flight != null) {
            items.add(_gridNavItem(context, gridNavModel.flight, false));
        }
        if (gridNavModel.travel != null) {
            items.add(_gridNavItem(context, gridNavModel.travel, false));
        }
        return items;
    }
    _gridNavItem(BuildContext context, GridNavItem gridNavItem, bool first) {
        List<Widget> items = [];
        items.add(_mainItem(context, gridNavItem.mainItem));
        items.add(_doubleItem(context, gridNavItem.item1, gridNavItem.item2));
        items.add(_doubleItem(context, gridNavItem.item3, gridNavItem.item4));
        List<Widget> expndItems = [];
        items.forEach((item) {
            expndItems.add(Expanded(child: item, flex: 1));
        });
        Color startColor = Color(int.parse('0xff' + gridNavItem.startColor));
        Color endColor = Color(int.parse('0xff' + gridNavItem.endColor));
        return Container(
            height: 88,
            margin: first ? null : EdgeInsets.only(top: 3),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [startColor, endColor]
                )
            ),
            child: Row(children: expndItems),
        );

    }
    _mainItem(BuildContext context, CommonModel model) {
        return _wrapGesture(
            context, 
            Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                    Image.network(model.icon, fit: BoxFit.contain, height: 88, width: 121, alignment:  AlignmentDirectional.bottomEnd),
                    Container(
                        margin: EdgeInsets.only(top: 11),
                        child: Text(model.title, style: TextStyle(fontSize: 14, color: Colors.white)),
                    )
                ],
            ),
            model
        );
    }
    _doubleItem(BuildContext context, CommonModel topItem, CommonModel bottomItem) {
        return Column(
            children: [
                Expanded(
                    child: _item(context, topItem, true)
                ),
                Expanded(
                    child: _item(context, topItem, false)
                )
            ],
        );
    }

    _item(BuildContext context, CommonModel item, bool first) {
        BorderSide borderSide = BorderSide(width: 0.8, color: Colors.white);
        return FractionallySizedBox(
            widthFactor: 1,
            child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        left: borderSide,
                        bottom: first ? borderSide : BorderSide.none
                    )
                ),
                child: _wrapGesture(
                    context,
                    Center(
                        child: Text(
                            item.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                    ),
                    item
                ),
            ),
        );
    }

    _wrapGesture(BuildContext context, Widget widget, CommonModel model) {
        return GestureDetector(
            onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                        return WebView(
                            title: model.title,
                            url: model.url,
                            statusBarColor: model.statusBarColor,
                            hideAppBar: model.hideAppBar,
                        );
                    })
                );
            },
            child: widget,
        );
    }
}