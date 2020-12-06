import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_trip/dao/home_dao.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';
import 'package:flutter_trip/model/home_model.dart';
import 'package:flutter_trip/model/sales_box_model.dart';
import 'package:flutter_trip/widget/loading_container.dart';
import 'package:flutter_trip/widget/local_nav.dart';
import 'package:flutter_trip/widget/sales_box.dart';
import 'package:flutter_trip/widget/sub_nav.dart';
import 'package:flutter_trip/widget/webview.dart';
import 'package:flutter_trip/widget/grid_nav.dart';

const APPBAR_SCROLL_OFFSET = 200;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

    double appBarAlpha = 0;
List<CommonModel> localNavList = [];
    List<CommonModel> bannerList = [];
    List<CommonModel> subNavList = [];
    GridNavModel gridNav;
    SalesBoxModel salesBox;
    bool _loading = true;
    @override
    void initState() {
        super.initState();
        _loadData();
    }

    _loadData() async {
        try {
            HomeModel model = await HomeDao.fetch();
            setState(() {
                localNavList = model.localNavList;
                bannerList = model.bannerList;
                subNavList = model.subNavList;
                gridNav = model.gridNav;
                salesBox = model.salesBox;
                _loading = false;
            });
        } catch (e) {
            setState(() {
                _loading = false;
            });
            print(e);
        }
    }

    _onScroll(offset) {
        double alpha = offset / APPBAR_SCROLL_OFFSET;
        if (alpha >= 0 && alpha <= 1) {
            setState(() {
              appBarAlpha = alpha;
            });
        }
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: Color(0xfff2f2f2),
            body: LoadingContainer(
                isLoading: _loading,
                child: Stack(
                    children: [
                        MediaQuery.removePadding( // 移除 Scaffold 默认padding组件
                            removeTop: true,
                            context: context,
                            child: NotificationListener( // 事件监听
                                // ignore: missing_return
                                onNotification: (scrollNotification) {
                                    if (scrollNotification is ScrollNotification && 
                                        scrollNotification.depth == 0) {
                                        _onScroll(scrollNotification.metrics.pixels);
                                    }
                                },
                                child: ListView(
                                    children: [
                                        Container(
                                            height: 160,
                                            child: Swiper(
                                                itemCount: bannerList?.length ?? 0,
                                                autoplay: true,
                                                itemBuilder: (BuildContext context, int index) {
                                                    return GestureDetector(
                                                        onTap: () {
                                                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                                CommonModel model = bannerList[index];
                                                                return WebView(
                                                                    url: model.url,
                                                                    title: model.title,
                                                                    hideAppBar: model.hideAppBar,
                                                                );
                                                            }));
                                                        },
                                                        child: Image.network(
                                                            bannerList[index].icon,
                                                            fit: BoxFit.fill,
                                                        )
                                                    );
                                                },
                                                pagination: SwiperPagination(),
                                            ),

                                        ),
                                        Padding(
                                            padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
                                            child: LocalNav(localNavList: localNavList),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
                                            child: GridNav(gridNavModel: gridNav),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
                                            child: SubNav(subNavList: subNavList),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
                                            child: SalesBox(salesBox: salesBox),
                                        ),
                                    ],  
                                    
                                ),
                            ),
                        ),
                        Opacity(
                            opacity: appBarAlpha,
                            child: Container(
                                height: 70,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border(bottom: BorderSide(width: 1, color: Colors.grey[300]))
                                ),
                                child: Center(
                                    child: Text(
                                        '首页', 
                                        style: TextStyle(
                                            fontSize: 16,
                                            height: 70 / 18
                                        )
                                    ),
                                )
                            ),
                        )
                    
                    ],
                )
            )
        );
    }
}
