import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/repository/firestore_methods.dart';
import 'package:flutter_application_1/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class UpdatePropertyScreen extends StatefulWidget {
  const UpdatePropertyScreen({Key? key, this.ad}) : super(key: key);
  final ad;

  @override
  State<UpdatePropertyScreen> createState() => _UpdatePropertyScreenState();
}

class _UpdatePropertyScreenState extends State<UpdatePropertyScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _purpose = TextEditingController();

  Uint8List? _file;

  bool _isLoading = false;
  double imageHeight = 0;
  final _form = GlobalKey<FormState>();
  var check = false;
  bool firstTime=true;

  @override
  void initState() {
    imageDim();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _typeController.dispose();
    _priceController.dispose();
    _areaController.dispose();
    _cityController.dispose();
    _descriptionController.dispose();
    _address.dispose();

    _purpose.dispose();
    super.dispose();
  }

  Future<Size> _calculateImageDimension(String img) {
    Completer<Size> completer = Completer();
    Image image = Image.network(img);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo image, bool synchronousCall) {
          var myImage = image.image;
          Size size = Size(myImage.width.toDouble(), myImage.height.toDouble());
          completer.complete(size);
        },
      ),
    );
    return completer.future;
  }

  imageDim() async {
    _calculateImageDimension(widget.ad["adImageUrl"]).then((size) {
      double ratio = size.width / size.height;
      double tempHeight = 220;

      if (mounted) {
        if (ratio < 0.8) {
          tempHeight = MediaQuery.of(context).size.width / 0.8;
        } else if (ratio < 1.5) {
          tempHeight = MediaQuery.of(context).size.width / ratio;
        } else {
          tempHeight = MediaQuery.of(context).size.width / 1.5;
        }
        setState(() {
          imageHeight = tempHeight;
        });
      }
    });
  }

  void updateAd() async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().updateAd(
        _titleController.text.trim().toLowerCase(),
        _typeController.text.trim().toLowerCase(),
        _priceController.text,
        _areaController.text.trim().toLowerCase(),
        _cityController.text,
        _descriptionController.text,
        _purpose.text,
        _file,
        _address.text,
        widget.ad,
      );
      if (res == 'success') {
        setState(() {
          _isLoading = false;
        });
        showSnackBar('Ad Updated!', context);
        clearImage();
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(res, context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  void CreateAd() {
    print(_titleController.text);
    print(_typeController.text);
    print(_priceController.text);
    print(_descriptionController.text);
    print(_areaController.text);
    print(_cityController.text);
  }

  Future<void> sub() async {
    var value = _form.currentState!.validate();
    if (value) {
      setState(() {
        check = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.ad);
    if(firstTime){
      _titleController.text = widget.ad['title'];
      _typeController.text = widget.ad['resOrCom'];
      _priceController.text = widget.ad['price'];
      _descriptionController.text = widget.ad['description'];
      _areaController.text = widget.ad['area'];
      _cityController.text = widget.ad['city'];
      _purpose.text = widget.ad['purpose'];
      _address.text=widget.ad['address'];
      setState(() {
        firstTime=false;
      });
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Update The Property'),
        ),
        body: _isLoading
            ? Center(child: const CircularProgressIndicator())
            : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      (_file == null && (widget.ad["adImageUrl"] != null)
                          ? Container(
                              height: imageHeight + 30.h,
                              margin: EdgeInsets.all(15.h),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.blueAccent,
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(widget.ad["adImageUrl"]),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  SizedBox(
                                    height: imageHeight,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                  Positioned(
                                    bottom: 10.h,
                                    right: 10.w,
                                    child: InkWell(
                                      onTap: () async {
                                        Uint8List file = await pickImage(
                                            ImageSource.gallery);
                                        setState(() {
                                          _file = file;
                                        });
                                      },
                                      child: Center(
                                          child: Image.asset(
                                        'assets/uploadImage.png',
                                        height: 60.h,
                                        width: 60.w,
                                      )),
                                    ),
                                  )
                                ],
                              ),
                            )
                          : (_file == null)
                              ? InkWell(
                                  onTap: () async {
                                    Uint8List file =
                                        await pickImage(ImageSource.gallery);
                                    setState(() {
                                      _file = file;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Container(
                                      height: 220,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: Colors.blueAccent),
                                          image: const DecorationImage(
                                              image: AssetImage(
                                                  'assets/uploadImage.png'),
                                              fit: BoxFit.contain)),
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: 220,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                                color: Colors.blueAccent),
                                            image: DecorationImage(
                                                image: MemoryImage(_file!),
                                                fit: BoxFit.cover)),
                                      ),
                                      Positioned(
                                        bottom: 10.h,
                                        right: 10.w,
                                        child: InkWell(
                                          onTap: () async {
                                            Uint8List file = await pickImage(
                                                ImageSource.gallery);
                                            setState(() {
                                              _file = file;
                                            });
                                          },
                                          child: Center(
                                              child: Image.asset(
                                            'assets/uploadImage.png',
                                            height: 60.h,
                                            width: 60.w,
                                          )),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                      Form(
                        key: _form,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade100,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, top: 0),
                                  child: TextFormField(
                                    controller: _titleController,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      labelText: 'Title',
                                    ),
                                    validator: (obj) {
                                      if (obj!.length == 0) {
                                        return "please enter some title";
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade100,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, top: 0),
                                  child: TextFormField(
                                    controller: _typeController,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      labelText: 'Residential or Commercial',
                                    ),
                                    validator: (obj) {
                                      if (obj!.length == 0) {
                                        return "please enter something";
                                      } else if (obj != "residential" &&
                                          obj != "commercial" &&
                                          obj != "residential " &&
                                          obj != "commercial " &&
                                          obj != "Residential" &&
                                          obj != "Commercial" &&
                                          obj != "Residential " &&
                                          obj != "Commercial ") {
                                        return "please enter correct word";
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade100,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, top: 0),
                                  child: TextFormField(
                                    controller: _priceController,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      labelText: 'Price',
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (obj) {
                                      if (obj!.length == 0) {
                                        return "please enter some price";
                                      } else if (obj.length <= 3) {
                                        return "please enter more price";
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade100,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, top: 0),
                                  child: TextFormField(
                                    controller: _areaController,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      labelText: 'Area(Marla)',
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (obj) {
                                      if (obj!.length == 0) {
                                        return "please enter some area";
                                      } else if (obj != '4' &&
                                          obj != '5' &&
                                          obj != '8') {
                                        return "please enter 4, 5 or 8";
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade100,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, top: 0),
                                  child: TextFormField(
                                    controller: _cityController,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      labelText: 'City',
                                    ),
                                    validator: (obj) {
                                      if (obj!.length == 0) {
                                        return "please enter city";
                                      } else if (obj.length <= 3) {
                                        return "please enter more characters";
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade100,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, top: 0),
                                  child: TextFormField(
                                    controller: _address,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      labelText: 'address',
                                    ),
                                    validator: (obj) {
                                      if (obj!.length == 0) {
                                        return "please enter city";
                                      } else if (obj.length <= 3) {
                                        return "please enter more characters";
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(15),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade100,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 15, right: 15, top: 0),
                                  child: TextFormField(
                                    controller: _descriptionController,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      labelText: 'Description',
                                    ),
                                    validator: (obj) {
                                      if (obj!.length == 0) {
                                        return "please enter something";
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade100,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, top: 0),
                                  child: TextFormField(
                                    controller: _purpose,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      labelText: 'sale or rent',
                                    ),
                                    validator: (obj) {
                                      if (obj!.length == 0) {
                                        return "please enter something";
                                      } else if (obj != "sale" &&
                                          obj != "sale " &&
                                          obj != "rent" &&
                                          obj != "rent ") {
                                        return "please enter correct word";
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: ElevatedButton(
                                onPressed: () async {
                                  await sub();
                                  if (check) {
                                    updateAd();
                                    // Navigator.pushReplacement(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (_) => homescreen()));
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.blueAccent,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 5),
                                    textStyle: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                child: const Text('Submit'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ])));
  }
}
