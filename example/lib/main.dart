import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:list_treeview/list_treeview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('TreeView'),
          onPressed: () {
            Navigator.push(context, CupertinoPageRoute(builder: (_) => const TreePage()));
          },
        ),
      ),
    );
  }
}

/// The data class that is bound to the child node
/// You must inherit from NodeData ！！！
/// You can customize any of your properties
class TreeNodeData extends NodeData {
  TreeNodeData({this.label, this.color}) : super();

  /// Other properties that you want to define
  final String? label;
  final Color? color;

  String? property1;
  String? property2;
  String? property3;

  ///...
}

class TreePage extends StatefulWidget {
  const TreePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TreePageState();
  }
}

class _TreePageState extends State<TreePage> with SingleTickerProviderStateMixin {
  TreeViewController? _controller;
  bool _isSuccess = false;
  // ignore: prefer_final_fields
  List<Color> _colors = [];
  @override
  void initState() {
    super.initState();

    ///The controller must be initialized when the treeView create
    _controller = TreeViewController();

    for (int i = 0; i < 100; i++) {
      _colors.add(randomColor());
    }

    ///Data may be requested asynchronously
    getData();
  }

  void getData() async {
    // ignore: avoid_print
    print('start get data');
    _isSuccess = false;
    await Future.delayed(const Duration(seconds: 2));

    var colors1 = TreeNodeData(label: 'Colors1');
    var color11 = TreeNodeData(label: 'rgb(0,139,69)', color: const Color.fromARGB(255, 0, 139, 69));
    var color12 = TreeNodeData(label: 'rgb(0,139,69)', color: const Color.fromARGB(255, 0, 191, 255));
    var color13 = TreeNodeData(label: 'rgb(0,139,69)', color: const Color.fromARGB(255, 255, 106, 106));
    var color14 = TreeNodeData(label: 'rgb(0,139,69)', color: const Color.fromARGB(255, 160, 32, 240));
    colors1.addChild(color11);
    colors1.addChild(color12);
    colors1.addChild(color13);
    colors1.addChild(color14);

    var colors2 = TreeNodeData(label: 'Colors2');
    var color21 = TreeNodeData(label: 'rgb(0,139,69)', color: const Color.fromARGB(255, 255, 64, 64));
    var color22 = TreeNodeData(label: 'rgb(0,139,69)', color: const Color.fromARGB(255, 28, 134, 238));
    var color23 = TreeNodeData(label: 'rgb(0,139,69)', color: const Color.fromARGB(255, 255, 106, 106));
    var color24 = TreeNodeData(label: 'rgb(0,139,69)', color: const Color.fromARGB(255, 205, 198, 115));
    colors2.addChild(color21);
    colors2.addChild(color22);
    colors2.addChild(color23);
    colors2.addChild(color24);

    /// set data
    _controller!.treeData([colors1]);
    // ignore: avoid_print
    print('set treeData suceess');

    setState(() {
      _isSuccess = true;
    });
  }

  @override
  // ignore: unnecessary_overrides
  void dispose() {
    super.dispose();
  }

  Color getColor(int level) {
    return _colors[level % _colors.length];
  }

  Color randomColor() {
    int r = Random.secure().nextInt(200);
    int g = Random.secure().nextInt(200);
    int b = Random.secure().nextInt(200);
    return Color.fromARGB(255, r, g, b);
  }

  /// Add
  void add(TreeNodeData dataNode) {
    /// create New node
//    DateTime time = DateTime.now();
//    int milliseconds = time.millisecondsSinceEpoch ~/ 1000;
    int r = Random.secure().nextInt(255);
    int g = Random.secure().nextInt(255);
    int b = Random.secure().nextInt(255);

    var newNode = TreeNodeData(label: 'rgb($r,$g,$b)', color: Color.fromARGB(255, r, g, b));

    _controller!.insertAtFront(dataNode, newNode);
//    _controller.insertAtRear(dataNode, newNode);
//    _controller.insertAtIndex(1, dataNode, newNode);
  }

  void delete(dynamic item) {
    _controller!.removeItem(item);
  }

  void select(dynamic item) {
    _controller!.selectItem(item);
  }

  void selectAllChild(dynamic item) {
    _controller!.selectAllChild(item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TreeView'),
      ),
      body: _isSuccess ? getBody() : getProgressView(),
    );
  }

  Widget getProgressView() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget getBody() {
    return ListTreeView(
      shrinkWrap: false,
      padding: const EdgeInsets.all(0),
      itemBuilder: (BuildContext context, NodeData data) {
        TreeNodeData item = data as TreeNodeData;
//              double width = MediaQuery.of(context).size.width;
        double offsetX = item.level * 16.0;
        return Container(
          height: 54,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.grey))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: offsetX),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: InkWell(
                          // ignore: deprecated_member_use
                          splashColor: Colors.amberAccent.withOpacity(1),
                          highlightColor: Colors.red,
                          onTap: () {
                            selectAllChild(item);
                          },
                          child: data.isSelected
                              ? const Icon(
                                  Icons.star,
                                  size: 30,
                                  color: Color(0xFFFF7F50),
                                )
                              : const Icon(
                                  Icons.star_border,
                                  size: 30,
                                  color: Color(0xFFFFDAB9),
                                ),
                        ),
                      ),
                      Text(
                        'level-${item.level}-${item.indexInParent}',
                        style: TextStyle(fontSize: 15, color: getColor(item.level)),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
//                          Text(
//                            '${item.label}',
//                            style: TextStyle(color: item.color),
//                          ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: item.isExpand,
                child: InkWell(
                  onTap: () {
                    add(item);
                  },
                  child: const Icon(
                    Icons.add,
                    size: 30,
                  ),
                ),
              )
            ],
          ),
        );
      },
      onTap: (NodeData data) {
        // ignore: avoid_print
        print('index = ${data.index}');
      },
      onLongPress: (data) {
        delete(data);
      },
      controller: _controller,
    );
  }
}
