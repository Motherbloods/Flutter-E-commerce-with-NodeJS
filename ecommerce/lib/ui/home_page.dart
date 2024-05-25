import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<IconData> myIcons = [
    Icons.phone_android,
    Icons.power,
    Icons.local_drink,
    Icons.menu,
  ];

  List<String> myIconNames = [
    'Isi Pulsa',
    'Isi Token Listrik',
    'Bayar PDAM',
    'Lainnya',
  ];

  void navigateToPage(BuildContext context, String pageName) {
    String routeName = pageName.replaceAll(' ', '_');
    Navigator.pushNamed(context, '/$routeName');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/searchpage');
          },
          child: Container(
            height: 35,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent, width: 1.4),
                borderRadius: BorderRadius.circular(10)),
            child: const Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  'Search Product . . .',
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
          ),
        ),
        actions: [
          GestureDetector(
            child: const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.shopping_cart,
                color: Colors.blueAccent,
              ),
            ),
            onTap: () {},
          )
        ],
      ),
      bottomNavigationBar: NavigationBar(
        height: 60,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.notifications), label: 'Notifikasi'),
          NavigationDestination(
              icon: Icon(Icons.account_circle), label: 'Profil'),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              //Layanan
              Container(
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: SizedBox(
                  height: 100.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(myIcons.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          navigateToPage(context, myIconNames[index]);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              margin: const EdgeInsets.all(5),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Icon(
                                  myIcons[index],
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 60, // Set a width to constrain the text
                              child: Text(
                                myIconNames[index],
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                                textAlign:
                                    TextAlign.center, // Center align the text
                                maxLines: 2, // Allow text to wrap to 2 lines
                                overflow:
                                    TextOverflow.ellipsis, // Handle overflow
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              //Rekomendasi
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft, // Align text to the left
                      child: Text(
                        'Recommendations',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 21,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    GridView.builder(
                      itemCount: 4,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        mainAxisExtent: 288,
                      ),
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 180,
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 50,
                                  spreadRadius: 7,
                                  offset: const Offset(0, 2),
                                )
                              ],
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white),
                          child: Column(
                            children: [
                              //gambar
                              Container(
                                height: 180,
                                padding: const EdgeInsets.all(8.0),
                                color: Colors.white,
                                child: Stack(
                                  children: [
                                    Image.network(
                                        'https://picsum.photos/id/1/600/700'),
                                    Positioned(
                                      top: 8,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.amber),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        child: const Text(
                                          '25%',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //detail
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Product Name',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Store',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 14),
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Icon(
                                          Icons.verified,
                                          color: Colors.blue,
                                          size: 14,
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Rp 100.000',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
