import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:my_app/detail.dart';
import 'package:my_app/models/nosetest.dart';
import 'package:my_app/provider/appdata.dart';
import 'package:provider/provider.dart';

class ShowdataPage extends StatefulWidget {
  const ShowdataPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ShowdataPageState();
  }
}

Future<List<Nosetest>> loadNosetest() async {
  //var url = Uri.parse('http://10.0.2.2:8080/api/nosetests');
  var url = Uri.parse('http://localhost:8080/api/nosetests');
  var response = await http.get(url,
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      });
  var decodedResponse = utf8.decode(response.bodyBytes);
  var nosetest = nosetestFromJson(decodedResponse);
  return nosetest;
}

class _ShowdataPageState extends State<ShowdataPage> {
  List<Nosetest> nosetest = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      nosetest = await loadNosetest();
      context.read<AppData>().cur_img = '';
      context.read<AppData>().notifyChange();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'My App',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: () {
                context.read<AppData>().putstate = true;
                context.read<AppData>().cur_id = 0;
                context.read<AppData>().cur_name = '';
                context.read<AppData>().cur_desc = '';
                context.read<AppData>().cur_img = 'null';
                context.read<AppData>().notifyChange();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DetailPage()));
              },
              icon: const Icon(Icons.add),
              color: Colors.white,
            )
          ],
        ),
        backgroundColor: Colors.pinkAccent,
      ),
      body: SingleChildScrollView(
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: nosetest.length,
                itemBuilder: (context, index) => ListTile(
                  onTap: () {
                    context.read<AppData>().putstate = false;
                    context.read<AppData>().cur_id = nosetest[index].id;
                    context.read<AppData>().cur_name = nosetest[index].name;
                    context.read<AppData>().cur_desc =
                        nosetest[index].desc.toString();
                    context.read<AppData>().cur_img =
                        nosetest[index].img.toString();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DetailPage()));
                  },
                  leading: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    child: nosetest[index].img != null
                        ? Image.network(
                            nosetest[index].img.toString(),
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                              return const Icon(Icons.image);
                            },
                          )
                        : const Icon(Icons.image),
                  ),
                  title: Text(nosetest[index].name),
                  subtitle: nosetest[index].desc != null
                      ? Text(nosetest[index].desc.toString())
                      : const Text(""),
                ),
                separatorBuilder: (context, index) {
                  return const Divider();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
