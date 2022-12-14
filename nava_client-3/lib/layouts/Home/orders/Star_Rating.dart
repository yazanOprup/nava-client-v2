import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../../../helpers/constants/MyColors.dart';
import 'SuccessfulOrder.dart';

class StarRating extends StatefulWidget {
  @override
  State<StarRating> createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  @override
  double rating = 0;
  String commentText;



  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 75),
        child: Column(
          children: [
            AppBar(
              backgroundColor: MyColors.primary,
              elevation: 0,
              title: Text(tr("تقييم الفني"),
                  style:
                  TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text(
            //   '?What do you think of the level of service',
            //   style: TextStyle(fontSize: 20),
            // ),
            // SizedBox(
            //   height: 20,
            // ),
            // SmoothStarRating(
            //   rating: rating,
            //   size: 45,
            //   filledIconData: Icons.star,
            //   halfFilledIconData: Icons.star_half,
            //   defaultIconData: Icons.star_border,
            //   starCount: 5,
            //   spacing: 2.0,
            //   onRated: (value) {
            //     setState(() {
            //       rating = value;
            //     });
            //   },
            // ),
            // Text(
            //   'You Have Selected : $rating Star',
            //   style: TextStyle(fontSize: 15),
            // ),
            // SizedBox(height: 20,),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 10.0),
            //   child: Container(height: 1.5, width: MediaQuery
            //       .of(context)
            //       .size
            //       .width, color: Colors.black),
            // ),
            // SizedBox(height: 20,),

            ElevatedButton(
                onPressed: () {
                  show();
                },
                child: Text('Send Rating'))
          ],
        ),
      ),
    );
  }

  void show() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return RatingDialog(
              title: Text(
                "قم بتقييم الفني ",
                textAlign: TextAlign.center,
              ),
              message: Text(
                'هل يوجد لديك ملاحظات',
                textAlign: TextAlign.center,
              ),
              image: Icon(
                Icons.star,
                size: 100,
                color:  Color(0xff2BC3F3),
              ),
              submitButtonText: 'Submit',
              onSubmitted: (response) {
                print("OnSubmitPressed rating = ${response.rating}");
                print('comment :${response.comment} ');

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SuccessfulOrder()));
              });
        });
  }
}
