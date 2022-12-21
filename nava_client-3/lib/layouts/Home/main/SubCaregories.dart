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

import '../../../helpers/customs/CustomBackButton.dart';
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
        automaticallyImplyLeading: false,
        title: Text(widget.name,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
        leading: CustomBackButton(ctx: context),
      ),
      body: loading
          ? MyLoading()
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 3 / 2,
                crossAxisCount: 1,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              padding: EdgeInsets.all(20),
              physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              itemCount: subCategoriesModel.data.length,
              itemBuilder: (c, i) {
                return subCategoryItem(
                  id: subCategoriesModel.data[i].id,
                  img: subCategoriesModel.data[i].image,
                  title: subCategoriesModel.data[i].title,
                );
              }),
    );
  }

  Widget subCategoryItem({int id, img, title}) {
    return InkWell(
      onTap: () {
        // VisitorProvider visitorProvider =
        //     Provider.of<VisitorProvider>(context, listen: false);
        // visitorProvider.visitor
        //     ? LoadingDialog.showAuthDialog(context: context)
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (c) => SubCategoryDetails(
              id: id,
              categoryId: widget.id,
              name: title,
              img: img,
            ),
          ),
        );
      },
      child: Card(
        elevation: 0.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            Expanded(
              child: Image(
                image: NetworkImage(img),
                width: 20,
                color: MyColors.offPrimary,
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: MyColors.primary,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(5),
                ),
              ),
              child: Text(
                title,
                style: TextStyle(fontSize: 19, color: MyColors.offWhite),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool loading = true;
  SubCategoriesModel subCategoriesModel = SubCategoriesModel();
  Future getSubCategories() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final url = Uri.http(URL, "api/sub-categories");
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
