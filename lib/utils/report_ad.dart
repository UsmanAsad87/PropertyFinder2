import 'package:flutter/material.dart';
import 'package:flutter_application_1/repository/firestore_methods.dart';
import 'package:flutter_application_1/utils/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';


class ReportAdPage extends StatefulWidget {
  const ReportAdPage({
    Key? key, required this.adId,
  }) : super(key: key);
  final String adId;

  @override
  State<ReportAdPage> createState() => _ReportAdPageState();
}

class _ReportAdPageState extends State<ReportAdPage> {
  var _value;
  var _reason;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2.2,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6, bottom: 10),
            child: Container(
              height: 5,
              width: 80,
              decoration: BoxDecoration(
                  color: Color(0xffe6e6ea),
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
              tileColor: Color(0xFF252628),
              leading: Radio(
                fillColor: MaterialStateProperty.all(
                Color(0xFFFFFFFF),
                ),
                value: 1,
                groupValue: _value,
                onChanged: (value) {
                  setState(() {
                    _value = value;
                    _reason = 'Offensive Content';
                  });
                },
              ),
              title: Text(
                'Offensive Content',
                style:Theme.of(context).textTheme.subtitle2!.copyWith(fontSize: 16, color: Colors.white),
              )),
          ListTile(
              tileColor: Color(0xFF252628),
              leading: Radio(
                fillColor: MaterialStateProperty.all(Colors.white,
                ),
                value: 2,
                groupValue: _value,
                onChanged: (value) {
                  setState(() {
                    _value = value;
                    _reason = 'Scammer or spammer';
                  });
                },
              ),
              title: Text(
                'Scammer or spammer',
                style: Theme.of(context).textTheme.subtitle2!.copyWith(fontSize: 16, color: Colors.white),
              )),
          ListTile(
              tileColor:Color(0xFF252628),
              leading: Radio(
                fillColor: MaterialStateProperty.all(
                  Colors.white,
                ),
                value: 3,
                groupValue: _value,
                onChanged: (value) {
                  setState(() {
                    _value = value;
                    _reason = 'Duplicate Ad';
                  });
                },
              ),
              title: Text(
                'Duplicate Ad',
                style: Theme.of(context).textTheme.subtitle2!.copyWith(fontSize: 16, color: Colors.white),
              )),
          ListTile(
              tileColor: Color(0xFF252628),
              leading: Radio(
                fillColor: MaterialStateProperty.all(
                  Colors.white,
                ),
                value: 4,
                groupValue: _value,
                onChanged: (value) {
                  setState(() {
                    _value = value;
                    _reason = 'Others';
                  });
                },
              ),
              title: Text(
                'Others',
                style: Theme.of(context).textTheme.subtitle2!.copyWith(fontSize: 16, color: Colors.white),
              )),
          TextButton(
              onPressed: () async {
                String msg= await FirestoreMethods().reportAd(widget.adId,_reason);
                Fluttertoast.showToast(
                    msg: msg,  // message
                    toastLength: Toast.LENGTH_SHORT, // length
                    gravity: ToastGravity.CENTER,    // location
                );
                Navigator.pop(context);
              },
              child: Text('Submit',
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(fontSize: 14, color: Colors.white))),
        ],
      ),
    );
  }
}
