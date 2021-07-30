import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProductDetailSheet extends StatelessWidget {
  String category = '';
  String title = '';
  String description = '';
  double price = 0;
  String image = '';

  final List<String> imgList = [];

  ProductDetailSheet(String category, String title, String description,
      double price, String image,
      {Key? key}) {
    //super(key: key);
    this.category = category;
    this.title = title;
    this.description = description;
    this.price = price;
    this.image = image;

    imgList.add(image);
    imgList.add(image);
    imgList.add(image);
  }

  List<Widget> imageSliders() {
    return imgList
        .map((item) => Container(
              child: Container(
                margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        Image.network(item, fit: BoxFit.contain, width: 1000.0),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 255, 255, 255),
                                  Color.fromARGB(0, 0, 0, 0)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: Text(
                              '#${imgList.indexOf(item)}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Material(
            color: Colors.transparent,
            child: Scaffold(
              backgroundColor: CupertinoTheme.of(context)
                  .scaffoldBackgroundColor
                  .withOpacity(0.95),
              extendBodyBehindAppBar: true,
              appBar: appBar(context),
              body: CustomScrollView(
                physics: ClampingScrollPhysics(),
                controller: ModalScrollController.of(context),
                slivers: <Widget>[
                  SliverSafeArea(
                    bottom: false,
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        children: [
                          CarouselSlider(
                            options: CarouselOptions(
                              aspectRatio: 2.0,
                              enlargeCenterPage: true,
                              enableInfiniteScroll: true,
                              scrollDirection: Axis.horizontal,
                              autoPlay: true,
                            ),
                            items: imageSliders(),
                          )
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Divider(height: 1),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                        padding: EdgeInsets.only(
                            top: 12, left: 12, bottom: 12, right: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text(
                              this.category.toString().toUpperCase(),
                              textAlign: TextAlign.start,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                            Text(this.title,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 22)),
                            Divider(),
                            Text(this.description,
                                style: TextStyle(
                                    color: Colors.grey[800], fontSize: 16))
                          ],
                        )),
                  ),
                  SliverSafeArea(
                    top: false,
                    sliver: SliverPadding(
                        padding: EdgeInsets.only(
                      bottom: 20,
                    )),
                  )
                ],
              ),
            )));
  }

  PreferredSizeWidget appBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size(double.infinity, 74),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            color: CupertinoTheme.of(context)
                .scaffoldBackgroundColor
                .withOpacity(0.8),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(width: 18),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            this.title,
                            style: CupertinoTheme.of(context)
                                .textTheme
                                .textStyle
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 4),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: <Widget>[
                                Text(
                                  this.category,
                                  style: CupertinoTheme.of(context)
                                      .textTheme
                                      .actionTextStyle
                                      .copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal),
                                ),
                                SizedBox(width: 2),
                                Icon(
                                  CupertinoIcons.right_chevron,
                                  size: 14,
                                  color:
                                      CupertinoTheme.of(context).primaryColor,
                                )
                              ]),
                        ],
                      )),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            margin: EdgeInsets.only(top: 14),
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              size: 24,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 14),
                    ],
                  ),
                ),
                Divider(height: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
