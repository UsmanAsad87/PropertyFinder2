import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/repository/firestore_methods.dart';
import 'package:flutter_application_1/screens/home_screen/home_screen.dart';
import 'package:flutter_application_1/utils/utils.dart';
import 'package:image_picker/image_picker.dart';

class addProperty extends StatefulWidget {
  const addProperty({Key? key}) : super(key: key);

  @override
  State<addProperty> createState() => _addPropertyState();

}

class _addPropertyState extends State<addProperty> {
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
  final _form = GlobalKey<FormState>();
  var check=false;
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

  void createAd() async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadAd(
        _titleController.text.trim().toLowerCase(),
        _typeController.text.trim().toLowerCase(),
        _priceController.text,
        _areaController.text.trim().toLowerCase(),
        _cityController.text,
        _descriptionController.text,

        _purpose.text,
        _file!,
        _address.text,
      );
      if (res == 'success') {
        setState(() {
          _isLoading = false;
        });
        showSnackBar('Ad Posted!', context);
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
 Future<void> sub()async {
  var value= _form.currentState!.validate();
  if(value){
    setState(() {
      check=true;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add The Property'),
      ),
      body: _isLoading?Center(child: const CircularProgressIndicator()):
      SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            (_file == null)
                ? InkWell(
                    onTap: () async {
                      Uint8List file = await pickImage(ImageSource.gallery);
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
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blueAccent),
                            image: const DecorationImage(
                                image: AssetImage('assets/uploadImage.png'),
                                fit: BoxFit.contain)),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      height: 220,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blueAccent),
                          image: DecorationImage(
                              image: MemoryImage(_file!), fit: BoxFit.cover)),
                    ),
                  ),
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
                        padding: const EdgeInsets.only(left: 15, right: 15, top: 0),
                        child: TextFormField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Title',
                          ),

                          validator: (obj){

                            if(obj!.length==0){
                              return   "please enter some title";
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
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 0),
                  child: TextFormField(
                    controller: _typeController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Residential or Commercial',
                    ),
                 validator: (obj){

                   if(obj!.length==0){
                     return   "please enter something";
                   }
                   else  if(obj !="residential" && obj != "commercial" && obj !="residential " && obj != "commercial " &&obj !="Residential" && obj != "Commercial" && obj !="Residential " && obj != "Commercial "){
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
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 0),
                  child: TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Price',
                    ),
                 keyboardType: TextInputType.number,
                    validator: (obj){

                      if(obj!.length==0){
                        return   "please enter some price";
                      }
                    else if(obj.length<=3){
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
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 0),
                  child: TextFormField(
                    controller: _areaController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Area(Marla)',
                    ),
                  keyboardType: TextInputType.number,
                  validator: (obj){
                      if(obj!.length==0){
                        return "please enter some area";
                      }
                      else  if(obj != '4' && obj != '5' && obj != '8' ) {
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
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 0),
                  child: TextFormField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: 'City',
                    ),
                    validator: (obj){
                      if(obj!.length==0){
                        return "please enter city";
                      }
                      else if(obj.length<=3){
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
                        padding: const EdgeInsets.only(left: 15, right: 15, top: 0),
                        child: TextFormField(
                          controller: _address,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: 'address',
                          ),
                          validator: (obj){
                            if(obj!.length==0){
                              return "please enter city";
                            }
                            else if(obj.length<=3){
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
                  padding: EdgeInsets.only(left: 15, right: 15, top: 0),
                  child: TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Description',
                    ),
                    validator: (obj){
                       if(obj!.length==0){
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
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 0),
                  child: TextFormField(
                     controller: _purpose,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: 'sale or rent',
                    ),
                    validator: (obj){

                       if(obj!.length==0){
                      return   "please enter something";
                      }
                       else if(obj !="sale" && obj != "sale " && obj !="rent" && obj != "rent ")
                       {
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
                onPressed: () async{
                 await sub();
                  if(check)
                  {
                    createAd();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>homescreen()));
                  }

                  },
                style: ElevatedButton.styleFrom(
                    primary: Colors.blueAccent,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                    textStyle: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                child: const Text('Submit'),
              ),
            ),

          ],
        ),
      ),
    ])
      ));
  }
}
