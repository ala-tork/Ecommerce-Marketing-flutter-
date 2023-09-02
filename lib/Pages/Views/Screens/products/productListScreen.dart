import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ecommerceversiontwo/Pages/Views/Screens/MyAppBAr.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/products/product.dart';
import 'package:ecommerceversiontwo/Pages/Views/Screens/products/productDetailsScreen.dart';
import 'package:ecommerceversiontwo/Pages/Views/widgets/side_bar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> products = [];
  VideoPlayerController? _videoPlayerController;
  int _currentProductCount = 0;

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts({int page = 1, int pageSize = 3}) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:5055/api/Product/GetProduct?page=$page&pageSize=$pageSize'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final productList = List.from(jsonData);
      final newProducts = productList.map((item) => Product.fromJson(item)).toList();

      setState(() {
        products.addAll(newProducts);
        _currentProductCount += newProducts.length;
      });
    } else {
      print('Failed to fetch products. Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: SideBar(),
      appBar: MyAppBar(title: "Show Products",),

      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: products.length + 1,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                if (index == products.length) {
                  if (index < _currentProductCount) {
                    return Center(
                      child: CircularProgressIndicator(),
                    ); // Show a loading indicator while fetching more products
                  } else {
                    return Container(); // Empty container as the last item
                  }
                }

                final product = products[index];
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    color: Color(0xFFF0F8FF),
                    child: Container(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                '${product.id}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                'Price: ${product.price}\TN',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                              leading: Container(
                                width: 60,
                                height: 100,
                                child: product.imageBase64 != null
                                    ? Image.memory(
                                  base64Decode(product.imageBase64!),
                                  fit: BoxFit.cover,
                                )
                                    : Placeholder(
                                  child: Text("nothing"),
                                ),
                              ),
                            ),
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
                                    onPressed: () async {
                                      await playVideo(context, product.videoBase64!);
                                    },
                                  ),
                                ],
                              ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.indigo, // Set the background color to red
                              ),
                              child: Text('Show Details'),

                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailsScreen(product: product),
                                  ),
                                );                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.indigo, // Set the background color to red
            ),

            child: Text('Show More'),
            onPressed: () {
              fetchProducts(page: (_currentProductCount ~/ 3) + 1); // Load the next page of products
            },
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
