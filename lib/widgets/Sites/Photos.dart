import 'dart:html' as html;
import 'dart:typed_data';
import 'package:cross_file/cross_file.dart';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:verifplus_backoff/Tools/DbTools.dart';
import 'package:verifplus_backoff/Tools/Srv_InterMissions.dart';
import 'package:verifplus_backoff/Tools/Upload.dart';
import 'package:verifplus_backoff/widgetTools/gColors.dart';
import 'package:verifplus_backoff/widgetTools/toolbar.dart';

class Photos extends StatefulWidget {
  @override
  _PhotosState createState() => _PhotosState();
}

class _PhotosState extends State<Photos> {
  List<Uint8List> _images = [];
  int MaxImg = 5;
  int iSave = 0;
  bool isSave = false;

  InterMission wInterMission = InterMission.InterMissionInit();

  Future<void> _pickImage() async {
    final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((e) async {
      final files = uploadInput.files;
      if (files!.isEmpty) return;
      final reader = html.FileReader();
      reader.readAsArrayBuffer(files[0]);
      reader.onLoadEnd.listen((e) {
        setState(() {
          _images.add(reader.result as Uint8List);
        });
      });
    });
  }

  void _deleteImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  var spinkit = SpinKitRing(
    color: gColors.primary,
    size: 30.0,
    lineWidth: 4,
  );

  Future<void> Reload() async {
    if (wInterMission == DbTools.gInterMission) return;

    _images.clear();
    wInterMission = DbTools.gInterMission;
    for (int i = 0; i < 5; i++) {
      String wUserImg = "Intervention_${DbTools.gIntervention.InterventionId}_${DbTools.gInterMission.InterMissionId}_$i.jpg";

      try {
//        Uint8List? pic = await DbTools.networkImageToBase64(wUserImg);
        Uint8List? pic = await gColors.getImage(wUserImg);
        if (pic.length > 0) {
          print("pic ${pic.length}");
          _images.add(pic!);
        }
      } catch (e) {
        print("ERROR ${wUserImg}");
      }
    }

    return;
  }

  @override
  void initState() {
    super.initState();
//    Reload();
  }

  final List<XFile> _list = [];
  bool _dragging = false;

  @override
  Widget build(BuildContext context) {
    double wSize = 120;

    print("wInterMission ${wInterMission.InterMissionId} DbTools.gInterMission ${DbTools.gInterMission.InterMissionId}");

    return (wInterMission != DbTools.gInterMission)
        ? FutureBuilder<void>(
            future: Reload(),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                    height: wSize,
                    margin: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: gColors.primary, width: 1),
                      borderRadius: BorderRadius.circular(5),
                      shape: BoxShape.rectangle,
                      color: gColors.white,
                    ),
                    child: Center(child: spinkit));
              } else {
                return buildimage(context);
              }
            },
          )
        : buildimage(context);
  }

  Widget buildimage(BuildContext context) {
    double wSize = 120;

    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _images.isEmpty
            ? Container(
                height: wSize,
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                decoration: BoxDecoration(
                  border: Border.all(color: gColors.primary, width: 1),
                  borderRadius: BorderRadius.circular(5),
                  shape: BoxShape.rectangle,
                  color: gColors.white,
                ),
                child: Center(child: Text("Pas de photo")))
            : Container(
                decoration: BoxDecoration(
                  border: Border.all(color: gColors.primary, width: 1),
                  borderRadius: BorderRadius.circular(5),
                  shape: BoxShape.rectangle,
                  color: gColors.white,
                ),
                height: wSize,
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: ReorderableListView(
                  scrollDirection: Axis.horizontal,
                  onReorder: (int oldIndex, int newIndex) {
                    print("onReorder ${oldIndex} ${newIndex}");
                    setState(() {
                      final image = _images.removeAt(oldIndex);
                      if (newIndex < _images.length)
                        _images.insert(newIndex, image);
                      else
                        _images.add(image);
                    });
                  }, // We'll implement this in a bit.
                  children: List.generate(_images.length, (index) {
                    return Stack(
                      key: ValueKey(index),
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Image.memory(_images[index], width: wSize, height: wSize, fit: BoxFit.contain),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteImage(index),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            (isSave) ? Container(width: 0) : Container(padding: const EdgeInsets.fromLTRB(10, 0, 0, 0), child: CommonAppBar.SquareRoundPng(context, 30, 8, Colors.white, Colors.blue, "ico_Save", ToolsBarSave, tooltip: "Sauvegarder")),
            isSave ? Container(padding: const EdgeInsets.fromLTRB(10, 0, 0, 0), child: spinkit) : Container(),
            isSave ? Container(padding: const EdgeInsets.fromLTRB(10, 0, 0, 0), child: Text("Remplace ${iSave + 1} / ${_images.length}", style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold))) : Container(),
            Spacer(),
            (_images.length == MaxImg || isSave)
                ? Container()
                : Stack(
                    children: [
                      Container(
                        height: 30,
                        child: DropTarget(
                          onDragDone: (detail) async {
//                              _list.addAll(detail.files);
                              for (int i = 0; i < detail.files.length; i++) {
                                var file = detail.files[i];
                                print('onDragDone ${file.path} - ${file.name}');
                                Uint8List pic = await file.readAsBytes();
                                if (pic.length > 0) {
                                  print("pic ${pic.length}");
                                  if (_images.length < 5)
                                  _images.add(pic!);
                                }
                              }
                              setState(() {
                            });
                          },
                          onDragEntered: (detail) {
                            setState(() {
                              _dragging = true;
                            });
                          },
                          onDragExited: (detail) {
                            setState(() {
                              _dragging = false;
                            });
                          },
                          child: Container(
                            height: 200,
                            width: 200,
                            color: _dragging ? gColors.secondary : Colors.black26,
                            child: _list.isEmpty ? const Center(child: Text("Glisser fichiers ici")) : Text(""),
                          ),
                        ),
                      ),
                      CommonAppBar.SquareRoundPng(context, 30, 8, Colors.green, Colors.white, "ico_Add", _pickImage, tooltip: "Ajouter Interventions"),
                    ],
                  ),
            Spacer(),
            Container(width: 50, child: Text("${_images.length} / ${MaxImg}", style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold))),
          ],
        ),
        Container(
          height: 20,
        ),
        Container(
          height: 20,
        ),
      ],
    ));
  }


  //value {"success":1,"name":"Intervention_130_34_0.jpg","uploadfilename":"","is_uploaded_file":"Erreur Nom du fichier : ''."}
  //value {"success":1,"name":"Intervention_130_13_3.jpg","uploadfilename":"\/tmp\/phpjNUmcl","is_uploaded_file":"OK","size":100421,"werror":"Move  OK = '1'"}

  void ToolsBarSave() async {
    iSave = 0;
    setState(() {
      isSave = true;
    });

    for (int i = 0; i < 5; i++) {
      String wUserImg = "Intervention_${DbTools.gIntervention.InterventionId}_${DbTools.gInterMission.InterMissionId}_$i.jpg";
      await DbTools.removephoto_API_Post(wUserImg);
    }

    for (iSave = 0; iSave < _images.length; iSave++) {
      Uint8List wImage = _images[iSave];



      String wUserImg = "Intervention_${DbTools.gIntervention.InterventionId}_${DbTools.gInterMission.InterMissionId}_$iSave.jpg";
      await Upload.SaveFile(wUserImg, wImage);
      setState(() {});
    }

    setState(() {
      isSave = false;
    });
  }

  void ToolsBarAdd() async {}
}
