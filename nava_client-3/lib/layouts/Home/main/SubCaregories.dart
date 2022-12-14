import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:nava/helpers/constants/LoadingDialog.dart';
import 'package:nava/helpers/constants/MyColors.dart';
import 'package:nava/helpers/constants/base.dart';
import 'package:nava/helpers/customs/AppBarFoot.dart';
import 'package:nava/helpers/customs/Loading.dart';
import 'package:nava/helpers/models/SubCategoriesModel.dart';
import 'package:nava/helpers/providers/visitor_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'SubCategoryDetails.dart';

class SubCategories extends StatefulWidget {
  final int id;
  final String name, img;

  const SubCategories({Key key, this.id, this.name, this.img})
      : super(key: key);

  @override
  _SubCategoriesState createState() => _SubCategoriesState();
}

class _SubCategoriesState extends State<SubCategories> {
  @override
  void initState() {
    getSubCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.primary,
        elevation: 0,
        title: Text(
          widget.name,
          style: TextStyle(fontSize: 18),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          Container(
            width: 50,
            height: 40,
            decoration: BoxDecoration(
              // border: Border.all(width: .5),
                borderRadius: BorderRadius.circular(5),
                image: DecorationImage(
                    image: NetworkImage(widget.img), fit: BoxFit.cover)),
            margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
            padding: const EdgeInsets.all(18),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppBarFoot(),
            Container(
              height: MediaQuery.of(context).size.height * .87,
              child: loading
                  ? MyLoading()
                  : ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  itemCount: subCategoriesModel.data.length,
                  itemBuilder: (c, i) {
                    return Column(
                      children: [
                        subCategoryItem(
                          id: subCategoriesModel.data[i].id,
                          img: subCategoriesModel.data[i].image,
                          title: subCategoriesModel.data[i].title,
                        ),
                        Divider(),
                      ],
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget subCategoryItem({int id, img, title}) {
    return InkWell(
      onTap: () {
        // VisitorProvider visitorProvider =
        //     Provider.of<VisitorProvider>(context, listen: false);
        // visitorProvider.visitor
        //     ? LoadingDialog.showAuthDialog(context: context)
        Navigator.of(context).push(MaterialPageRoute(
            builder: (c) => SubCategoryDetails(
                id: id, categoryId: widget.id, name: title, img: img)));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 75,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 70,
              height: 75,
              margin: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                  border: Border.all(width: .5),
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                      image: NetworkImage(img), fit: BoxFit.cover)),
            ),
            Text(title, style: TextStyle(fontSize: 18))
          ],
        ),
      ),
    );
  }

  bool loading = true;
  SubCategoriesModel subCategoriesModel = SubCategoriesModel();
  Future getSubCategories() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final url = Uri.https(URL, "api/sub-categories");
    try {
      final response = await http.post(
        url,
        headers: {"Authorization": "Bearer ${preferences.getString("token")}"},
        body: {
          "lang": preferences.getString("lang"),
          "category_id": widget.id.toString(),
        },
      ).timeout(Duration(seconds: 10), onTimeout: () {
        throw 'no internet please connect to internet';
      });
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        setState(() => loading = false);
        print(responseData);
        if (responseData["key"] == "success") {
          subCategoriesModel = SubCategoriesModel.fromJson(responseData);
        } else {
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e, t) {
      print("error $e");
      print("track $t");
    }
  }
}
