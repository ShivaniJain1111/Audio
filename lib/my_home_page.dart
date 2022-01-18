import 'dart:convert';
import 'package:audio/app_colors..dart' as AppColors;
import 'package:audio/my_tabs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'detail_audio__page.dart';

class MyHomePage extends StatefulWidget {


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
                                              with SingleTickerProviderStateMixin {
   List? popularBooks;
  late ScrollController _scrollController;
  late TabController _tabController;

  ReadData() async {
    await DefaultAssetBundle.of(context)
        .loadString("json/popularBooks.json")
        .then((s) {
      setState(() {
        popularBooks = json.decode(s);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();
    ReadData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10, left: 20.0, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.menu),
                    Row(
                      children: [
                        Icon(Icons.search),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.notifications)
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: Text(
                      "Music",
                      style: TextStyle(fontSize: 30),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 180,
                child: Stack(
                  children: [
                    Positioned(
                        top: 0,
                        left: -20,
                        right: 0,
                        child: Container(
                          height: 180,
                          child: PageView.builder(
                              controller: PageController(viewportFraction: 0.8),
                              itemCount: popularBooks == null
                                  ? 0
                                  : popularBooks?.length,
                              itemBuilder: (_, i) {
                                return Container(
                                  height: 180,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            popularBooks?[i]["images"]),
                                        fit: BoxFit.fill,
                                      )),
                                );
                              }),
                        ))
                  ],
                ),
              ),
              Expanded(
                  child: NestedScrollView(
                    controller: _scrollController,
                    headerSliverBuilder: (BuildContext context, bool isScroll) {
                      return [
                        SliverAppBar(
                          pinned: true,
                          backgroundColor: AppColors.sliverBackground,
                          bottom: PreferredSize(
                            preferredSize: Size.fromHeight(50),
                            child: Container(
                              margin: const EdgeInsets.only(
                                  bottom: 20, left: 20),
                              child: TabBar(
                                indicatorPadding: const EdgeInsets.all(0),
                                indicatorSize: TabBarIndicatorSize.label,
                                labelPadding: const EdgeInsets.only(
                                  right: 3,
                                ),
                                controller: _tabController,
                                isScrollable: true,
                                indicator: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        blurRadius: 7,
                                        offset: Offset(0, 0),
                                      )
                                    ]),
                                tabs: [
                                  AppTabs(
                                      color: AppColors.menu1Color, text: "New"),
                                  AppTabs(
                                      color: AppColors.menu2Color,
                                      text: "Popular"),
                                  AppTabs(
                                      color: AppColors.menu3Color,
                                      text: "Trending"),
                                ],
                              ),
                            ),
                          ),
                        )
                      ];
                    },
                    body: TabBarView(
                      controller: _tabController,
                      children: [
                        ListView.builder(
                            itemCount: popularBooks == null ? 0 : popularBooks?.length,
                            itemBuilder: (_,i){
                              return
                                GestureDetector(
                                  onTap:(){
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context)=>DetailAudioPage(bookData: popularBooks,index:i)),
                                    );
                                  },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 20, right: 20, top: 10, bottom: 10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: AppColors.tabVarViewColor,
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 2,
                                            offset: Offset(0, 0),
                                            color: Colors.grey.withOpacity(0.2),
                                          )
                                        ]),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: Row(children: [
                                        Container(
                                          width: 90,
                                          height: 120,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(10),
                                              image: DecorationImage(
                                                image:
                                                NetworkImage(popularBooks?[i]["images"]),
                                              )),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [

                                            Text(
                                              popularBooks?[i]["title"],
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontFamily: "Avenir",
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              popularBooks?[i]["text"],
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: "Avenir",
                                                  color: AppColors
                                                      .subTitleText),
                                            ),

                                          ],
                                        )
                                      ]),
                                    ),
                                  ),
                                ),
                              );
                            }),
                        Material(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.grey,
                            ),
                            title: Text("Content"),
                          ),
                        ),
                        Material(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.grey,
                            ),
                            title: Text("Content"),
                          ),
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
