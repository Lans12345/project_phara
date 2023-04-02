import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:phara/widgets/text_widget.dart';

import '../utils/colors.dart';
import 'button_widget.dart';

class TrackBookingBottomSheetWidget extends StatelessWidget {
  const TrackBookingBottomSheetWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      reverse: true,
      child: SizedBox(
        height: 520,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child:
                    TextBold(text: 'Current trip', fontSize: 24, color: grey),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/images/rider.png',
                        height: 75,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  SizedBox(
                    width: 100,
                    child: Divider(
                      thickness: 5,
                      color: Colors.blue[900],
                    ),
                  ),
                  const Icon(
                    Icons.pin_drop_rounded,
                    color: Colors.red,
                    size: 58,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 40,
                child: ListTile(
                  leading: const Icon(
                    Icons.location_on_rounded,
                    color: Colors.red,
                  ),
                  title: TextRegular(
                      text: 'Distance: 1.3km', fontSize: 16, color: grey),
                ),
              ),
              SizedBox(
                height: 40,
                child: ListTile(
                  leading: const Icon(
                    Icons.my_location,
                    color: grey,
                  ),
                  title: TextRegular(
                      text: 'From: Sample location', fontSize: 16, color: grey),
                ),
              ),
              SizedBox(
                height: 40,
                child: ListTile(
                  leading: const Icon(
                    Icons.pin_drop_rounded,
                    color: Colors.red,
                  ),
                  title: TextRegular(
                      text: 'To: Sample destination',
                      fontSize: 16,
                      color: grey),
                ),
              ),
              SizedBox(
                height: 40,
                child: ListTile(
                  leading: const Icon(
                    Icons.payments_outlined,
                    color: grey,
                  ),
                  title: TextRegular(
                      text: 'Fare: ₱200.00', fontSize: 16, color: grey),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                color: Colors.grey,
                thickness: 1.5,
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: RatingBar.builder(
                  initialRating: 5,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) async {
                    // var collection =
                    //     FirebaseFirestore
                    //         .instance
                    //         .collection(
                    //             'Providers')
                    //         .where('id',
                    //             isEqualTo:
                    //                 data[
                    //                     'id']);

                    // var querySnapshot =
                    //     await collection
                    //         .get();

                    // for (var queryDocumentSnapshot
                    //     in querySnapshot
                    //         .docs) {
                    //   Map<String, dynamic>
                    //       data1 =
                    //       queryDocumentSnapshot
                    //           .data();

                    //   FirebaseFirestore
                    //       .instance
                    //       .collection(
                    //           'Providers')
                    //       .doc(data['id'])
                    //       .update({
                    //     'reviews': FieldValue
                    //         .arrayUnion([
                    //       FirebaseAuth
                    //           .instance
                    //           .currentUser!
                    //           .uid
                    //     ]),
                    //     'ratings': data1[
                    //             'ratings'] +
                    //         rating,
                    //     'nums':
                    //         data1['nums'] +
                    //             1,
                    //   });
                    // }

                    // addRatings(
                    //     name,
                    //     rating.toInt(),
                    //     data['id'],
                    //     profilePicture);

                    // Navigator.pop(context);

                    // print(rating);
                  },
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     for (int i = 0; i < 5; i++)
                //       const Icon(
                //         Icons.star_border_rounded,
                //         color: grey,
                //         size: 32,
                //       ),
                //   ],
                // ),
              ),
              const SizedBox(
                height: 10,
              ),
              ButtonWidget(
                radius: 100,
                opacity: 1,
                color: black,
                label: 'Add rating',
                onPressed: (() {}),
              ),
              const SizedBox(
                height: 15,
              ),
              ButtonWidget(
                radius: 100,
                opacity: 1,
                color: Colors.green,
                label: 'Confirm payment',
                onPressed: (() {}),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
