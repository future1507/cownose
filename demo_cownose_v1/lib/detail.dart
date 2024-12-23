import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/models/matchingdesciption.dart';
import 'package:my_app/provider/appdata.dart';
import 'package:my_app/showdata.dart';
import 'package:my_app/test.dart';
import 'package:provider/provider.dart';
import 'models/imgdesciption.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  MatchingDesciption? matchdesc;
  ImagesDesciption? imgdesc;
  String score = '';
  File? _imageFile;
  String? _imageUrl;
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _desccontroller = TextEditingController();

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);
    setState(() {
      if (pickedFile != null) _imageFile = File(pickedFile.path);
    });
  }

  Future<void> _uploadImage() async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dq0ncxrkp/upload');

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = 'hkunfxoe'
      ..files.add(await http.MultipartFile.fromPath('file', _imageFile!.path));
    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);
      final url = jsonMap['url'];
      _imageUrl = url;
      context.read<AppData>().cur_img = _imageUrl.toString();
      context.read<AppData>().notifyChange();
      putNosetest();
    }
  }

  void putNosetest() async {
    var data = {
      "id": context.read<AppData>().cur_id,
      "name": _namecontroller.text,
      "desc": _desccontroller.text,
      "img": context.read<AppData>().cur_img,
    };
    if (context.read<AppData>().cur_id == 0) () => data.remove("id");

    var result;
    result = await putorpost(data, result);
    if (result.statusCode == 200) {
      loadNosetest();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ShowdataPage()));
    }
  }

  Future<http.Response> putorpost(var data, var result) {
    if (data.length == 3) {
      result = http.post(Uri.parse('http://10.0.2.2:8080/api/nosetests'),
          body: jsonEncode(data),
          headers: {'Content-Type': 'application/json'});
    } else {
      result = http.put(Uri.parse('http://10.0.2.2:8080/api/nosetests'),
          body: jsonEncode(data),
          headers: {'Content-Type': 'application/json'});
    }
    return result;
  }

  Future<void> FeatureMatching() async {
    Uint8List? imageBytes = await _imageFile?.readAsBytes();
    String base64String = base64Encode(imageBytes!);

    var data = {
      "img_main": context.read<AppData>().cur_img,
      "img_compare": base64String
    };
    try {
      var response = await http.post(
          Uri.parse('http://10.0.2.2:5000/api/matching'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            'Connection': 'keep-alive',
          });
      //print(response.body);
      matchdesc = matchingDesciptionFromJson(response.body);
      score = '';
      score = matchdesc!.score.toString();
      showSimilarScore();
    } catch (e) {
      if (e is http.ClientException) {
        if (e.message == 'Connection closed while receiving data') {
          showSimilarScore();
        }
      }
    }
  }

  Future<void> loadImageDesciption() async {
    var response = await http
        .get(Uri.parse('http://10.0.2.2:5000/api/matching'), headers: {
      'Content-Type': 'application/json',
      'Connection': 'keep-alive',
    });
    imgdesc = imagesDesciptionFromJson(response.body);
  }

  void showSimilarScore() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("ผลลัพธ์"),
            content: score.isNotEmpty
                ? Text(
                    "ภาพทั้งสองมีความเหมือนกัน $score %",
                    softWrap: true,
                  )
                : const SizedBox(
                    height: 50,
                    width: 50,
                    child: Center(
                        child: CircularProgressIndicator(
                      color: Colors.pinkAccent,
                    ))),
            actions: [
              Center(
                child: SizedBox(
                  width: 100,
                  height: 50,
                  child: FloatingActionButton(
                    onPressed: () => Navigator.pop(context),
                    backgroundColor: Colors.green,
                    child: const Text(
                      "OK",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              score.isNotEmpty
                  ? TextButton(
                      onPressed: () async {
                        await loadImageDesciption();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const TestPage()));
                        context.read<AppData>().img1kp = imgdesc!.img1Kp;
                        context.read<AppData>().img2kp = imgdesc!.img2Kp;
                        context.read<AppData>().result = imgdesc!.result;
                        context.read<AppData>().matches =
                            matchdesc!.matches.toString();
                        context.read<AppData>().goodMatches =
                            matchdesc!.goodMatches.toString();
                        context.read<AppData>().score =
                            matchdesc!.score.toString();
                        context.read<AppData>().notifyChange();
                      },
                      child: const Text("ดูรายละเอียด"))
                  : Container(),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _namecontroller.text = context.read<AppData>().cur_name;
      _desccontroller.text = context.read<AppData>().cur_desc;

      context.read<AppData>().img1kp = '';
      context.read<AppData>().img2kp = '';
      context.read<AppData>().result = '';
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My App',
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.pinkAccent,
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            if (context.read<AppData>().cur_img != "null" ||
                context.read<AppData>().cur_img.isEmpty) ...[
              Image.network(context.watch<AppData>().cur_img),
              ElevatedButton(
                  onPressed: () {
                    if (_imageFile == null) {
                      _pickImage(ImageSource.gallery);
                    } else {
                      FeatureMatching();
                    }
                  },
                  child: _imageFile == null
                      ? const Text('เปรียบเทียบรูปภาพ')
                      : const Text('ดำเนินการ')),
            ],
            if (_imageFile == null &&
                context.read<AppData>().cur_img == "null") ...[
              ElevatedButton(
                  onPressed: () {
                    _pickImage(ImageSource.gallery);
                  },
                  child: const Text('อัปโหลดรูปภาพ')),
              ElevatedButton(
                  onPressed: () {
                    _pickImage(ImageSource.camera);
                  },
                  child: const Text('ถ่ายรูป')),
            ],
            if (_imageFile != null) ...[
              Center(child: Image.file(_imageFile!)),
            ],
            if (_imageFile == null ||
                context.read<AppData>().putstate == true) ...[
              Text(context.read<AppData>().cur_id.toString()),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _namecontroller,
                  enabled: context.read<AppData>().putstate,
                  decoration: const InputDecoration(
                    labelText: 'ชื่อ',
                    hintText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _desccontroller,
                  enabled: context.read<AppData>().putstate,
                  decoration: const InputDecoration(
                    labelText: 'รายละเอียด',
                    hintText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
            if (context.read<AppData>().putstate == true ||
                _imageFile != null) ...[
              ElevatedButton(
                  onPressed: () {
                    if (_imageFile != null) {
                      _uploadImage();
                    } else {
                      putNosetest();
                    }
                  },
                  child: const Text('บันทึก')),
            ],
            // if (_imageUrl != null) ...[
            //   Image.network(_imageUrl!),
            //   // Text("Cloudinary URL : $_imageUrl",
            //   //     style: const TextStyle(fontSize: 20)),
            //   const Padding(
            //       padding: EdgeInsets.only(left: 20, top: 60, bottom: 100)),
            // ]

          ],
        ),
      ),
    );
  }
}
