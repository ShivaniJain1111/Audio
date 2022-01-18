import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AudioFile extends StatefulWidget {
  final AudioPlayer advancedPlayer;
  final String audioPath;
  const AudioFile({Key? key,required this.advancedPlayer,required this.audioPath}) : super(key: key);

  @override
  _AudioFileState createState() => _AudioFileState();
}

class _AudioFileState extends State<AudioFile> {

  Duration _duration=new  Duration();
  Duration _position=new Duration();

  bool isPlaying=false;
  bool isPaused=false;
  bool isRepeat=false;
  Color color=Colors.black;
 late AudioPlayer advanced=new AudioPlayer();
 late AudioCache audioCache=new AudioCache(fixedPlayer: advanced);


  List<IconData> _icons=[
    Icons.play_circle_fill,
    Icons.pause_circle_filled,
  ];

@override
  void initState() {
    // TODO: implement initState
    super.initState();


    advanced.onDurationChanged.listen((d) {setState(() {
      _duration=d;
    });});
    advanced.onAudioPositionChanged.listen((p) {setState(() {
      _position=p;
    });});

    advanced.isLocalUrl(this.widget.audioPath);
    advanced.onPlayerCompletion.listen((event) {
      setState(() {
        _position = Duration(seconds: 0);
        if(isRepeat==true){
          isPlaying=true;
        }else{

          isPlaying=false;
          isRepeat=false;
        }
      });
    });
  }

  Widget btnStart()
  {

    return IconButton(
        padding: const EdgeInsets.only(bottom: 10),
        icon: isPlaying==false?Icon(_icons[0],size: 50,color: Colors.blue,):Icon(_icons[1],size: 50,color: Colors.blue,),
        onPressed: (){

          if(isPlaying==false) {

            audioCache.play(this.widget.audioPath);
            setState(() {
              isPlaying = true;
            });
          }else if(isPlaying==true)
            {
              advanced.pause();
              setState(() {
                isPlaying=false;
              });
            }
        },
    );
  }

  Widget btnFast() {

    return
      IconButton(
        icon:  Icon(Icons.fast_forward_rounded,
          size: 30,
          color: Colors.black,
        ),
        onPressed: () {
          advanced.seek(Duration(seconds: _position.inSeconds +5));

        },
      );
  }
  Widget btnSlow() {
    return IconButton(
      icon:   Icon(Icons.fast_rewind_rounded,
        size: 30,
        color: Colors.black,
      ),
      onPressed: () {
        advanced.seek(Duration(seconds: _position.inSeconds -5));
      },
    );
  }

  Widget btnLoop() {
    return IconButton(
        icon:  Icon(Icons.repeat,
          size: 30,
          color: Colors.black,
        ), onPressed: () {  },
    );
  }
  Widget btnRepeat() {
    return IconButton(
      icon: Icon(Icons.loop_rounded,
        size: 30,
        color:color,
      ),
      onPressed: (){
        if(isRepeat==false){
          advanced.setReleaseMode(ReleaseMode.LOOP);
          setState(() {
            isRepeat=true;
            color=Colors.blue;
          });
        }else if(isRepeat==true){
          advanced.setReleaseMode(ReleaseMode.RELEASE);
          color=Colors.black;
          isRepeat=false;
        }
      },
    );
  }

  Widget slider() {
    return Slider(
        activeColor: Colors.red,
        inactiveColor: Colors.grey,
        value: _position.inSeconds.toDouble(),
        min: 0.0,
        max: _duration.inSeconds.toDouble(),
        onChanged: (double value) {
          setState(() {
            changeToSecond(value.toInt());
            value = value;
          });});
  }

  void changeToSecond(int second){
    Duration newDuration = Duration(seconds: second);
    advanced.seek(newDuration);
  }

  Widget loadAsset()
  {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          btnRepeat(),
          btnSlow(),
          btnStart(),
          btnFast(),
          btnLoop()

        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
              padding:const EdgeInsets.only(left: 20,right: 20) ,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                 Text(_position.toString().split(".")[0],style: TextStyle(fontSize: 16),),
                 Text(_duration.toString().split(".")[0],style: TextStyle(fontSize: 16),)
              ],
            ),
          ),
          slider(),
          loadAsset(),

        ],
      ),
    );
  }
}
