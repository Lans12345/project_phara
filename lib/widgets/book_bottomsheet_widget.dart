import 'package:flutter/material.dart';
import 'package:phara/utils/colors.dart';
import 'package:phara/widgets/text_widget.dart';

import 'button_widget.dart';

class BookBottomSheetWidget extends StatelessWidget {
  final destinationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      reverse: true,
      child: SizedBox(
        height: 500,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextBold(text: 'Driver', fontSize: 15, color: grey),
                  IconButton(
                    onPressed: (() {
                      Navigator.pop(context);
                    }),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Colors.red,
                      size: 32,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const CircleAvatar(
                    minRadius: 50,
                    maxRadius: 50,
                    backgroundImage: NetworkImage(
                        'https://i.pinimg.com/originals/45/e1/9c/45e19c74f5c293c27a7ec8aee6a92936.jpg'),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextBold(
                          text: 'Name: Lance Olana', fontSize: 15, color: grey),
                      TextRegular(
                          text: 'Vehicle: Sniper 150',
                          fontSize: 14,
                          color: grey),
                      TextRegular(
                          text: 'Rating: 3.5 ★',
                          fontSize: 14,
                          color: Colors.amber),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                color: grey,
              ),
              const SizedBox(
                height: 10,
              ),
              TextBold(text: 'Current Location', fontSize: 15, color: grey),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.my_location,
                    color: grey,
                    size: 32,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  TextBold(
                      text: 'Sample current location',
                      fontSize: 22,
                      color: grey),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  TextRegular(text: 'To:', fontSize: 18, color: grey),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    width: 250,
                    height: 42,
                    child: TextFormField(
                      controller: destinationController,
                      style: const TextStyle(
                          color: Colors.black, fontFamily: 'QRegular'),
                      decoration: InputDecoration(
                        suffixIcon: const Icon(
                          Icons.pin_drop_sharp,
                          color: Colors.red,
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1, color: Colors.black),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              TextRegular(text: 'Distance: 1.3km', fontSize: 15, color: grey),
              const SizedBox(
                height: 5,
              ),
              TextRegular(
                  text: 'Estimated time: 30mins', fontSize: 15, color: grey),
              const SizedBox(
                height: 5,
              ),
              TextRegular(text: 'Fare: ₱250.00', fontSize: 15, color: grey),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                color: grey,
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: ButtonWidget(
                    width: 250,
                    radius: 100,
                    opacity: 1,
                    color: Colors.green,
                    label: 'Book now',
                    onPressed: (() {
                      Navigator.pop(context);
                      showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: ((context) {
                            return SingleChildScrollView(
                              reverse: true,
                              child: SizedBox(
                                height: 520,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: TextBold(
                                            text: 'Current trip',
                                            fontSize: 24,
                                            color: grey),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: grey.withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
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
                                              text: 'Distance: 1.3km',
                                              fontSize: 16,
                                              color: grey),
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
                                              text: 'From: Sample location',
                                              fontSize: 16,
                                              color: grey),
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
                                              text: 'Fare: ₱200.00',
                                              fontSize: 16,
                                              color: grey),
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
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          for (int i = 0; i < 5; i++)
                                            const Icon(
                                              Icons.star_border_rounded,
                                              color: grey,
                                              size: 32,
                                            ),
                                        ],
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
                          }));
                    })),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
