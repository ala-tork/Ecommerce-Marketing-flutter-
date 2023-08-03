import 'dart:convert';
import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/products/ExpandableText.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/products/app_icon.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/products/iconandtextwidget.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/products/product.dart';
import 'package:ecommerceversiontwo/Pages/app_color.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';


class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  ProductDetailsScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    List<String> comments = [
      "Great product!",
      "I love it!",
      "Highly recommended.",
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background image
          Positioned(
            left: 0,
            right: 0,
            height: 350,
            child: product.imageBase64 != null
                ? Image.memory(
              base64Decode(product.imageBase64!),
              fit: BoxFit.cover,
            )
                : Container(),
          ),
          // Icons
          Positioned(
            top: 45,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppIcon(icon: Icons.arrow_back_ios),
                AppIcon(icon: Icons.shopping_cart_outlined),
              ],
            ),
          ),
          // Introduction
          Positioned(
            left: 0,
            right: 0,
            top: 300,
            bottom: 120,
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 15, right: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "${product.title}\n",
                              style: TextStyle(
                                color: Colors.indigo,
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Wrap(
                                children: List.generate(
                                  5,
                                      (index) => Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                    size: 12,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                "${product.price}TN",
                                style: TextStyle(color: Colors.black),
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Quantity: ${product.qty}",
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconAndTextWidget(
                                icon: Icons.circle_sharp,
                                text: "text",
                                TextColor: Colors.indigo,
                                iconColor: Colors.indigo,
                              ),
                              IconAndTextWidget(
                                icon: Icons.location_on,
                                text: "text",
                                TextColor: Colors.indigo,
                                iconColor: Colors.indigo,
                              ),
                              IconAndTextWidget(
                                icon: Icons.access_time_rounded,
                                text: "text",
                                TextColor: Colors.indigo,
                                iconColor: Colors.indigo,
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Description ",
                            style: TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 10),
                          ExpandableText(
                            text:
                            "Details: ${product.details}\nDescription: ${product.description}",
                          ),
                          SizedBox(height: 20),

                          if (product.videoBase64 != null)
                            Row(
                              children: [
                                Text(
                                  "Watch the video",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.play_arrow),
                                  color: Colors.red,
                                  iconSize: 30,
                                  onPressed: () async {
                                    await playVideo(context, product.videoBase64!);
                                  },
                                ),
                              ],
                            ),

                          SizedBox(height: 20),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20),
                              Text(
                                "Comments",
                                style: TextStyle(
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(height: 10),
                              // List of comments
                              ListView.builder(
                                shrinkWrap: true,

                                itemCount: comments.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.symmetric(vertical: 5),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColor.border,
                                    ),
                                    child: Text(
                                      comments[index],
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.indigo,
                                  onPrimary: Colors.white,
                                ),
                                child: Text("Add Comment"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 120,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                ),
                color: Colors.grey[300],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.remove,
                          color: Colors.black,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "0",
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          Icons.add,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.favorite_border,
                      color: Colors.black,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "${product.price}TN Add to cart",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColor.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> playVideo(BuildContext context, String videoBase64) async {
    final videoBytes = base64Decode(videoBase64);

    final tempDir = await getTemporaryDirectory();
    final tempVideoPath = '${tempDir.path}/temp_video.mp4';
    final tempVideoFile = File(tempVideoPath);

    await tempVideoFile.writeAsBytes(videoBytes);

    final videoController = VideoPlayerController.file(tempVideoFile);
    await videoController.initialize();

    final chewieController = ChewieController(
      videoPlayerController: videoController,
      autoPlay: true,
      looping: false,
      // Other customization options
    );
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Chewie(controller: chewieController),
        );
      },
    );

    chewieController.dispose();
    videoController.dispose();
  }
}
