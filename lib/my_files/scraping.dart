import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';

// this class is for scraping the data
class Scraping extends StatefulWidget {
  const Scraping({Key? key}) : super(key: key);

  @override
  State<Scraping> createState() => _ScrapingState();
}

class _ScrapingState extends State<Scraping> {
  final TextEditingController searchcontroller = TextEditingController();

  late var titles;
  Stream<QuerySnapshot>? _reference;
  @override
  void initState() {
    deletedocs();
    getWebsiteData();

    // TODO: implement initState
    super.initState();
  }

  Future deletedocs() async {
    final instance = FirebaseFirestore.instance;
    final batch = instance.batch();
    var collection = instance.collection('ilaan');
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
    print("deleted");
  }

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Future uploaddata(
      final String areaName,
      final String location,
      final String onrent,
      final String onsale,
      final String estate,
      final String links) async {
    CollectionReference ref = _firebaseFirestore.collection("ilaan");
    try {
      return await ref.add({
        'areaName': areaName,
        'location': location,
        'onrent': onrent,
        'onsale': onsale,
        'estate': estate,
        'link': links
      }).then((value) {
        _reference = FirebaseFirestore.instance.collection('ilaan').snapshots();
        setState(() {});
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future getWebsiteData() async {
    final url = Uri.parse('https://www.ilaan.com/property-for-sale?q=Lahore');
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);
    titles = html
        .querySelectorAll(' div.float-start.col-8 > a > h2')
        .map((element) => element.innerHtml.trim())
        .toList();
    print('count : ${titles.length}');
    setState(() {
      titles = titles;
    });
    final links = html
        .querySelectorAll(' div.float-start.col-8 > a')
        .map((element) => 'https://www.ilaan.com/${element.attributes['href']}')
        .toList();
    print('url : ${links.toList()}');
    final location = html
        .querySelectorAll('  div > div.float-start.col-8 > p')
        .map((element) => element.innerHtml.trim())
        .toList();
    print('location : ${location.length}');

    final onsale = html
        .querySelectorAll(' div.float-start.col-8 > h3 > span')
        .map((element) => element.innerHtml.trim())
        .toList();
    print('onsale : ${onsale.length}');

    final rate = html
        .getElementsByClassName('pt-1 me-3 font-600 font-15 opacity-90 mb-0')
        .map((element) =>
            element.innerHtml.replaceAll(RegExp(r'[^0-9.A-Z]'), ''))
        .toList();
    print('rate : ${rate.toList()}');

    final estateadvisor = html
        .getElementsByClassName('font-11 font-500 opacity-60 mt-2 text-center')
        .map((element) => element.innerHtml.substring(0, 12))
        .toList();
    print('estateadvisor : ${estateadvisor.toList()}');

    setState(() {
      List.generate(titles.length, (index) {
        uploaddata(titles[index], location[index], rate[index], onsale[1],
            estateadvisor[index], links[index]);
      });
    });
  }

  Future<void> _launchUrl(String uri) async {
    if (!await launchUrl(Uri.parse(uri))) {
      throw 'Could not launch $uri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("ilaan.com"),
        ),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: searchcontroller,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  hintText: 'Search with location',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50))),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _reference,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text("Error");
                } else if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var data = snapshot.data!.docs[index];
                        var search = snapshot.data!.docs[index]['location'];

                        if (searchcontroller.text.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                                elevation: 0.6,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.15,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.25,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              image: const DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                      'https://ms.ilaan.com/mediaresources/propertyimage/160206/406x267/fc752c6f-4e7a-4bd5-b226-5aedbe56ddec_406_267.jpg'))),
                                        )),
                                    Expanded(
                                        flex: 2,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.red,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20)),
                                                      width: 100,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Icon(
                                                            Icons.home,
                                                            color: Colors.white,
                                                          ),
                                                          Text(
                                                            data["onsale"]
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                        child: Text(
                                                      data["estate"].toString(),
                                                      textDirection:
                                                          TextDirection.ltr,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ))
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                data["areaName"].toString(),
                                              ),
                                              ListTile(
                                                leading: const Icon(
                                                  Icons.location_on_outlined,
                                                ),
                                                title: Text(
                                                  data["location"].toString(),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      data["onrent"].toString(),
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              primary:
                                                                  Colors.green),
                                                      onPressed: (() async {
                                                        await _launchUrl(
                                                            data["link"]);
                                                      }),
                                                      child:
                                                          const Text("Details"))
                                                ],
                                              )
                                            ],
                                          ),
                                        )),
                                  ],
                                )

                                // ),
                                ),
                          );
                        } else if (search!
                            .toLowerCase()
                            .contains(searchcontroller.text.toLowerCase())) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                                elevation: 0.6,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.15,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.25,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              image: const DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                      'https://ms.ilaan.com/mediaresources/propertyimage/160206/406x267/fc752c6f-4e7a-4bd5-b226-5aedbe56ddec_406_267.jpg'))),
                                        )),
                                    Expanded(
                                        flex: 2,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.red,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20)),
                                                      width: 100,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Icon(
                                                            Icons.home,
                                                            color: Colors.white,
                                                          ),
                                                          Text(
                                                            data["onsale"]
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                        child: Text(
                                                      data["estate"].toString(),
                                                      textDirection:
                                                          TextDirection.ltr,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ))
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                data["areaName"].toString(),
                                              ),
                                              ListTile(
                                                leading: const Icon(
                                                  Icons.location_on_outlined,
                                                ),
                                                title: Text(
                                                  data["location"].toString(),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    data["onrent"].toString(),
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              primary:
                                                                  Colors.green),
                                                      onPressed: (() async {
                                                        await _launchUrl(
                                                            data["link"]);
                                                      }),
                                                      child:
                                                          const Text("Details"))
                                                ],
                                              )
                                            ],
                                          ),
                                        )),
                                  ],
                                )
                                // ListTile(
                                //   dense: true,
                                //   title: Text(scrap.areaName),
                                //   leading: Image.network(
                                //     'https://ms.ilaan.com/mediaresources/propertyimage/160206/406x267/fc752c6f-4e7a-4bd5-b226-5aedbe56ddec_406_267.jpg',
                                //     fit: BoxFit.cover,
                                //   ),
                                //   subtitle: Column(
                                //     mainAxisAlignment: MainAxisAlignment.center,
                                //     crossAxisAlignment: CrossAxisAlignment.center,
                                //     children: [Text(scrap.location)],
                                //   ),
                                // ),
                                ),
                          );
                        } else {
                          return Container();
                        }
                      }

                      //           Container(
                      //                 child: Column(
                      //                   children: [
                      // //to show the data on screen;
                      //                     //  showing  titles;
                      //                     Text(
                      //                       titles[index].toString(),
                      //                       style: const TextStyle(fontWeight: FontWeight.bold),
                      //                     ),
                      //                     Image.network(
                      //                         "https://www.graana.com/_next/image?url=https%3A%2F%2Fres.cloudinary.com%2Fgraanacom%2Fimage%2Fupload%2Fv1643183516%2Fxwxqlvcbqeylv53brbkl.jpg&w=1920&q=75") // Image.network("https://www.graana.com/"+articles[index].toString()),
                      //                   ],
                      //                 ),
                      //               )
                      );
                }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ]));
  }
}
