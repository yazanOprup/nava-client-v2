import 'dart:io';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nava/helpers/constants/DioBase.dart';
import 'package:nava/helpers/constants/LoadingDialog.dart';
import 'package:nava/helpers/constants/MyColors.dart';
import 'package:nava/helpers/customs/AppBarFoot.dart';
import 'package:nava/helpers/customs/CustomButton.dart';
import 'package:nava/helpers/customs/LabelTextField.dart';
import 'package:nava/layouts/settings/contact_us/ContactUs.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:record_mp3/record_mp3.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/customs/CustomBackButton.dart';
import '../../../res.dart';
import '../../settings/contact_us/mainContactUs.dart';

class AddNotesAndImages extends StatefulWidget {
  final int id;

  const AddNotesAndImages({Key key, this.id}) : super(key: key);

  @override
  _AddNotesAndImagesState createState() => _AddNotesAndImagesState();
}

class _AddNotesAndImagesState extends State<AddNotesAndImages> {
  TextEditingController _notes = new TextEditingController();
  CountDownController _controller = CountDownController();
  int _duration = 120;
  Codec _codec = Codec.aacMP4;
  String _mPath = 'tau_file.mp4';
  String audioPath;
  FlutterSoundPlayer _mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder _mRecorder = FlutterSoundRecorder();
  bool _mPlayerIsInited = false;
  bool _mRecorderIsInited = false;
  bool _mplaybackReady = false;
  var finishUpload = 0;
  String statusText = "";
  bool isComplete = false;
  String recordFilePath;

  @override
  void initState() {
    _mPlayer.openAudioSession().then((value) {
      setState(() => _mPlayerIsInited = true);
    });
    // openTheRecorder().then((value) {
    //   setState(() => _mRecorderIsInited = true);
    // });
    super.initState();
  }

  @override
  void dispose() {
    _mPlayer.closeAudioSession();
    _mPlayer = null;
    // _mRecorder.closeAudioSession();
    // _mRecorder = null;
    super.dispose();
  }

  // void play() {
  //   if (recordFilePath != null && File(recordFilePath).existsSync()) {
  //     AudioPlayer audioPlayer = AudioPlayer();
  //     audioPlayer.play(recordFilePath, isLocal: true);
  //   }
  // }

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  void startRecord() async {
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      deleteFile();
      statusText = "Recording...";
      Directory storageDirectory = await getApplicationDocumentsDirectory();
      String sdPath = storageDirectory.path + "/record.mp3";
      setState(() {
        recordFilePath = sdPath;
      });
      print(recordFilePath);
      isComplete = false;
      // RecordMp3.instance.start(recordFilePath, (type) {
      //   statusText = "Record error--->$type";
      //   setState(() {});
      // });
    } else {
      statusText = "No microphone permission";
    }
    setState(() {});
  }

  Future<File> get _localFile async {
    final path = recordFilePath;
    return File('$path');
  }

  Future deleteFile() async {
    try {
      final file = await _localFile;
      print('deleted');
      await file.delete();
    } catch (e) {
      print(e.toString());
    }
  }

  void stopRecord() {
    // bool s = RecordMp3.instance.stop();
    // if (s) {
    //   statusText = "Record complete";
    //   isComplete = true;
    //   setState(() {});
    // }
  }

  // Future<void> openTheorder() async {
  //   if (!kIsWeb) {
  //     var status = await Permission.microphone.request();
  //     if (status != PermissionStatus.granted) {
  //       print("----------------- open 03 not granted -----------------");
  //       throw RecordingPermissionException('Microphone permission not granted');
  //     }
  //   }
  //   await _mRecorder.openAudioSession();
  //   if (!await _mRecorder.isEncoderSupported(_codec) && kIsWeb) {
  //     _codec = Codec.opusWebM;
  //     _mPath = 'tau_file.webm';
  //     if (!await _mRecorder.isEncoderSupported(_codec) && kIsWeb) {
  //       _mRecorderIsInited = true;
  //       return;
  //     }
  //   }
  //   _mRecorderIsInited = true;
  // }
  //
  // void record() {
  //   _mRecorder
  //       .startRecorder(
  //     toFile: _mPath,
  //     codec: _codec,
  //     audioSource: theSource,
  //   )
  //       .then((value) {
  //     setState(() {});
  //   });
  // }
  //
  // void stopRecorder() async {
  //   await _mRecorder.stopRecorder().then((value) {
  //     setState(() {
  //       audioPath = value;
  //       _mplaybackReady = true;
  //     });
  //   });
  // }

  void play() {
    _mPlayer
        .startPlayer(
            fromURI: recordFilePath,
            codec: kIsWeb ? Codec.opusWebM : Codec.aacADTS,
            whenFinished: () {
              setState(() {});
              print("--------------- $_mPath -------------");
              print(
                  "--------------- ${Codec.values} -------------=)))))))))))))))))))))))))");
            })
        .then((value) {
      setState(() {});
    });
  }

  void stopPlayer() {
    _mPlayer.stopPlayer().then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return finishUpload == 0
        ? WillPopScope(
            onWillPop: () async {
              deleteFile();
              Navigator.of(context).pop();
              return false;
            },
            child: Scaffold(
              //backgroundColor: MyColors.offWhite,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text(tr("addNotesAndImages"),
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
                leading: CustomBackButton(ctx: context),
              ),
              body: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextField(
                        controller: _notes,
                        minLines: 20,
                        maxLines: 25,
                        decoration: InputDecoration(
                          //contentPadding: EdgeInsets.zero,
                          hintText: tr("enterNotes"),
                          hintStyle: TextStyle(
                            color: MyColors.textSettings,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                              color: Color(0xffEEEEEE),
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            addItem(
                                title: imageFile != null
                                    ? tr("imageAdded")
                                    : tr("addImage"),
                                icon: Icons.camera_enhance,
                                onTap: () {
                                  _openImagePicker(context);
                                }),
                            Column(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.48,
                                  height: 65,
                                  decoration: BoxDecoration(
                                      color: MyColors.primary,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InkWell(
                                          onTap: () async {
                                            _controller.start();
                                            // record();
                                            startRecord();
                                          },
                                          child: Icon(
                                            Icons.mic,
                                            size: 30,
                                            color: _mRecorder.isRecording
                                                ? MyColors.red
                                                : MyColors.black,
                                          )),
                                      InkWell(
                                          onTap: () async {
                                            _controller.pause();
                                            // stopRecorder();
                                            stopRecord();
                                          },
                                          child: Icon(
                                            Icons.stop,
                                            size: 30,
                                            color: _mRecorder.isRecording
                                                ? MyColors.black
                                                : MyColors.black
                                                    .withOpacity(.4),
                                          )),
                                      CircularCountDownTimer(
                                        // Countdown duration in Seconds.
                                        duration: _duration,

                                        // Countdown initial elapsed Duration in Seconds.
                                        initialDuration: 0,

                                        // Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.
                                        controller: _controller,

                                        // Width of the Countdown Widget.
                                        width: 45,

                                        // Height of the Countdown Widget.
                                        height: 45,

                                        // Ring Color for Countdown Widget.
                                        ringColor: Colors.grey[300],

                                        // Ring Gradient for Countdown Widget.
                                        ringGradient: null,

                                        // Filling Color for Countdown Widget.
                                        fillColor: Colors.blueAccent,

                                        // Filling Gradient for Countdown Widget.
                                        fillGradient: null,

                                        // Background Color for Countdown Widget.
                                        backgroundColor: Colors.limeAccent,

                                        // Background Gradient for Countdown Widget.
                                        backgroundGradient: null,

                                        // Border Thickness of the Countdown Ring.
                                        strokeWidth: 8.0,

                                        // Begin and end contours with a flat edge and no extension.
                                        strokeCap: StrokeCap.round,

                                        // Text Style for Countdown Text.
                                        textStyle: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.blueAccent,
                                            fontWeight: FontWeight.bold),

                                        // Format for the Countdown Text.
                                        textFormat: CountdownTextFormat.S,

                                        // Handles Countdown Timer (true for Reverse Countdown (max to 0), false for Forward Countdown (0 to max)).
                                        isReverse: false,

                                        // Handles Animation Direction (true for Reverse Animation, false for Forward Animation).
                                        isReverseAnimation: false,

                                        // Handles visibility of the Countdown Text.
                                        isTimerTextShown: true,

                                        // Handles the timer start.
                                        autoStart: false,

                                        // This Callback will execute when the Countdown Starts.
                                        onStart: () {
                                          // Here, do whatever you want
                                          print('Countdown Started');
                                        },

                                        // This Callback will execute when the Countdown Ends.
                                        onComplete: () {
                                          // Here, do whatever you want
                                          stopRecord();
                                          print('Countdown Ended');
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                // SizedBox(
                                //   height: 5,
                                // ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    recordFilePath != null
                                        ? tr("voiceAdded")
                                        : tr("recordVoiceNote"),
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                            addItem(
                                title: videoFile != null
                                    ? tr("videoAdded")
                                    : tr("addVid"),
                                icon: Icons.videocam,
                                onTap: () {
                                  _openVideoPicker(context);
                                }),
                          ],
                        ),
                      ),
                      isComplete
                          ? InkWell(
                              onTap: () {
                                // if (_mPlayer.isPlaying) {
                                //   stopPlayer();
                                // } else {
                                //   play();
                                // }
                                play();
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                margin: EdgeInsets.only(top: 8),
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          _mPlayer.isPlaying
                                              ? Icons.pause
                                              : Icons.play_arrow,
                                          size: 30,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          child: Text(tr("playAudio")),
                                        ),
                                      ],
                                    ),

                                    // Row(
                                    //   children: [
                                    //     Icon(Icons.play_arrow),
                                    //     Text(tr("playAudio")),
                                    //   ],
                                    // ),
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                      Spacer(),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: () {
                              addNotes();
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                                primary: MyColors.primary,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                            child: isButtonPressed
                                ? CircularProgressIndicator.adaptive()
                                : Text(
                                    tr("continueOrder"),
                                    style: TextStyle(fontSize: 18),
                                  )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Uploading"),
              Card(
                elevation: 5,
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  finishUpload.toString() + "% / " + "100%",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          );
  }

  Widget addItem({String title, IconData icon, Function onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 65,
            height: 65,
            // decoration: BoxDecoration(
            //     //color: MyColors.greyWhite,
            //     borderRadius: BorderRadius.circular(50)),
            child: Icon(
              icon,
              size: 30,
            ),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }

  File imageFile;
  final picker = ImagePicker();
  Future getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
        Fluttertoast.showToast(msg: "تم الاضافة بنجاح");
      } else {
        print('No image selected.');
      }
    });
    Navigator.pop(context);
  }

  void _openImagePicker(BuildContext context) {
    print("-------------_openImagePicker");
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(10.0),
          child: CupertinoActionSheet(
            cancelButton: CupertinoButton(
              child: Text(tr("cancel"),
                  style: TextStyle(
                    fontSize: 18,
                  )),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: <Widget>[
              Center(
                  child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  tr("selectImg"),
                  style: TextStyle(
                    fontSize: 18,
                    color: MyColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )),
              TextButton(
                child: Text(
                  tr("fromCam"),
                ),
                onPressed: () {
                  getImage(ImageSource.camera);
                },
              ),
              TextButton(
                child: Text(tr("fromGallery")),
                onPressed: () {
                  getImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // String audioPath;
  // FilePickerResult filePickerResult;
  // getAudio() async {
  //   filePickerResult = await FilePicker.platform.pickFiles(
  //     type: FileType.audio,
  //   ).then((value) {
  //     setState(() {
  //       audioPath = value.names[0];
  //       // audioFile = value.files[0];
  //     });
  //     return value;
  //   });
  //   // String fileName = fil.path.split('/').last;
  // }

  File videoFile;
  final videoPicker = ImagePicker();
  Future getVideo(ImageSource source) async {
    final pickedFile = await videoPicker.pickVideo(source: source);
    setState(() {
      if (pickedFile != null) {
        videoFile = File(pickedFile.path);

        Fluttertoast.showToast(msg: "تم الاضافة بنجاح");
      } else {
        print('No image selected.');
      }
    });
    Navigator.pop(context);
  }

  void _openVideoPicker(BuildContext context) {
    print("-------------_openVideoPicker");
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(10.0),
          child: CupertinoActionSheet(
            cancelButton: CupertinoButton(
              child: Text(tr("cancel"),
                  style: TextStyle(
                    fontSize: 18,
                  )),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: <Widget>[
              Center(
                  child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  tr("selectImg"),
                  style: TextStyle(
                    fontSize: 18,
                    color: MyColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )),
              TextButton(
                child: Text(
                  tr("fromCam"),
                ),
                onPressed: () {
                  getVideo(ImageSource.camera);
                },
              ),
              TextButton(
                child: Text(tr("fromGallery")),
                onPressed: () {
                  getVideo(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  DioBase dioBase = DioBase();
  bool isButtonPressed = false;
  Future addNotes() async {
    print('function working now');
    setState(() {
      isButtonPressed = true;
    });
    LoadingDialog.showLoadingDialog();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print(preferences.getString("token"));
    Map<String, String> headers = {
      "Authorization": "Bearer ${preferences.getString("token")}"
    };

    FormData bodyData = FormData.fromMap({
      "lang": preferences.getString("lang"),
      "notes": _notes.text,
      "order_id": "${widget.id}",
      "image": imageFile == null
          ? null
          : MultipartFile.fromFileSync(imageFile.path,
              filename: "${imageFile.path.split('/').last}"),
      "audio": recordFilePath == null
          ? null
          : MultipartFile.fromFileSync(recordFilePath,
              filename: "${recordFilePath.split('/').last}"),
      "video": videoFile == null
          ? null
          : MultipartFile.fromFileSync(videoFile.path,
              filename: "${videoFile.path.split('/').last}"),
    });
    dioBase.post("addNotesAndImage", body: bodyData, headers: headers,
        progressImage: (start, end) {
      print(start);
      print(end);
      finishUpload = ((start / end) * 100).toInt();
      setState(() {});
    }).then((response) {
      finishUpload = 0;
      setState(() {
        isButtonPressed = false;
      });
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        if (response.data["key"] == "success") {
          deleteFile();
          Fluttertoast.showToast(msg: response.data["msg"]);
          showDialog(
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: Icon(
                    CupertinoIcons.checkmark_seal,
                    color: MyColors.primary,
                    size: 50,
                  ),
                  content: Column(
                    children: [
                      Text(
                        tr("cong"),
                        style: GoogleFonts.almarai(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(tr("notesAddedSuc"),
                          style: GoogleFonts.almarai(fontSize: 15)),
                    ],
                  ),
                  actions: [
                    CustomButton(
                        title: tr("continueOrder"),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        })
                  ],
                );
              });

          print("---------------------------------------successsuccess");
        } else {
          EasyLoading.dismiss();
          print("---------------------------------------else else");
          Fluttertoast.showToast(msg: response.data["msg"]);
        }
      } else {
        EasyLoading.dismiss();
        print(response.data["msg"]);
        Fluttertoast.showToast(
          msg: response.data["msg"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    });
  }
}
