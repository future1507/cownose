import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:my_app/provider/appdata.dart';
import 'package:provider/provider.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TestPageState();
  }
}

class _TestPageState extends State<TestPage> {
  Uint8List loadImage(String img) {
    var bytes = base64.decode(img);
    return bytes;
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
      body: ListView(
        children: [
          const Text(
              "1.นำภาพทั้ง 2 มาแปลงเป็นภาพระดับเท่า(grayscale) แล้วหาจุดคุณลักษณะ(Keypoints)"),
          Image.memory(loadImage(context.watch<AppData>().img1kp)),
          Image.memory(loadImage(context.watch<AppData>().img2kp)),
          const Text("2.จับคู่(Matcher) Keypoints ของภาพทั้งสอง"),
          Image.memory(loadImage(context.watch<AppData>().result)),
          const Text("3.คำนวณหาค่าความเหมือน จากสูตร"),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "ค่าความเหมือน  = จุดที่ทั้งสองภาพจับคู่ถูกต้อง/จำนวน Keypoint ของภาพหลัก*100",
              style: TextStyle(fontSize: 10),
            ),
          ),
          Text(
              "ดังนั้นภาพทั้งสองมีความเหมือนกัน คือ ${context.read<AppData>().goodMatches}/${context.read<AppData>().matches}*100 ="),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Container(
                color: Colors.greenAccent,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                  child: Text(
                    "${context.read<AppData>().score} %",
                    style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
