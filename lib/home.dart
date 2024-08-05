




import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:path/path.dart' as p;

class Home extends StatefulWidget{
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool isRecording=false, isPlaying=false;
  final AudioRecorder audioRecorder=AudioRecorder();
  final AudioPlayer audioPlayer=AudioPlayer();
  String? isRecordingPath;


  @override
  Widget build(BuildContext context) {








    // TODO: implement build
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [


          SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if(isRecordingPath!=null)MaterialButton(onPressed: () async {
                  if(audioPlayer.playing){
                    audioPlayer.stop();
                    setState(() {
                      isPlaying=false;
                    });
                  }else{

                    await audioPlayer.setFilePath(isRecordingPath!);
                    audioPlayer.play();
                    setState(() {
                      isPlaying=true;
                    });
                  }
                },
                child: Text(isPlaying==false?"Start Play":"Stop Play"),
                )else
                  Text('No recording found')
              ],
            ),

          )


        ],
      ),

      floatingActionButton: _recordButton(),
    );
  }

  Widget _recordButton(){
    return FloatingActionButton(
        onPressed: () async {

          if(isRecording){
            String? filePath = await audioRecorder.stop();

            if(filePath!=null){
              setState(() {
                isRecording=false;
                isRecordingPath=filePath;
              });
            }
          }else{
            if(await audioRecorder.hasPermission()){

              final Directory appDirectory=await getApplicationDocumentsDirectory();
              final String filePath= p.join(appDirectory.path,"recording.wav");
              await audioRecorder.start(const RecordConfig(), path: filePath);
              setState(() {
                isRecording=true;
                isRecordingPath=null;
              });
            }
          }



        },
      child: isRecording ==false? Icon(Icons.mic):Icon(Icons.stop),
    );
  }
}