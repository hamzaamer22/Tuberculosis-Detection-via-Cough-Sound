import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:file_picker/file_picker.dart';
import 'tb_result_screen.dart';

class RecordingScreen extends StatefulWidget {
  @override
  _RecordingScreenState createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  final Record _recorder = Record();
  final AudioPlayer _player = AudioPlayer();
  Duration _duration = Duration.zero;
  Timer? _timer;
  bool isRecording = false;
  bool isPlaying = false;
  bool showRecordingOptions = false;
  String? _recordedFilePath;
  String? _uploadedFilePath;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) {
      throw Exception('Microphone permission not granted');
    }
  }

  Future<void> _startRecording() async {
    final tempDir = await getTemporaryDirectory();
    _recordedFilePath = '${tempDir.path}/temp_record.wav';

    await _recorder.start(
      path: _recordedFilePath,
      encoder: AudioEncoder.aacLc,
      bitRate: 96000,
      samplingRate: 16000,
    );

    setState(() {
      isRecording = true;
      showRecordingOptions = false;
      _uploadedFilePath = null;
      _duration = Duration.zero;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        _duration += Duration(seconds: 1);
      });
    });
  }

  Future<void> _stopRecording() async {
    await _recorder.stop();
    _timer?.cancel();
    setState(() {
      isRecording = false;
      showRecordingOptions = true;
    });
  }

  Future<void> _playRecording() async {
    final pathToPlay = _uploadedFilePath ?? _recordedFilePath;
    if (pathToPlay != null && File(pathToPlay).existsSync()) {
      setState(() {
        isPlaying = true;
      });

      await _player.play(DeviceFileSource(pathToPlay));
      _player.onPlayerComplete.listen((event) {
        setState(() {
          isPlaying = false;
        });
      });
    }
  }

  Future<void> _uploadAndDetectTB() async {
    final filePath = _uploadedFilePath ?? _recordedFilePath;
    if (filePath == null || !File(filePath).existsSync()) return;

    final uri = Uri.parse('https://modern-mammals-help.loca.lt/predict/multi-model');
    final request = http.MultipartRequest('POST', uri);

    request.files.add(await http.MultipartFile.fromPath(
      'audio_file',
      filePath,
      contentType: MediaType('audio', 'aac'), // override mime
    ));

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("Status code: ${response.statusCode}");
      print("Response is: ${response.body}");

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print("Decoded JSON: $json");

        final result = json['prediction'] is int
            ? (json['prediction'] as int).toDouble()
            : double.tryParse(json['prediction'].toString()) ?? 0.0;

        final tbDetected = result >= 0.5;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TBResultScreen(tbDetected: tbDetected),
          ),
        );
      } else {
        print('Upload failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Upload error: $e');
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null && result.files.single.path != null) {
      final filePath = result.files.single.path!;
      final duration = await _getAudioDuration(filePath);

      setState(() {
        _uploadedFilePath = filePath;
        _recordedFilePath = null;
        _duration = duration;
        showRecordingOptions = true;
      });
    }
  }

  Future<Duration> _getAudioDuration(String path) async {
    try {
      final tempPlayer = AudioPlayer();
      await tempPlayer.setSourceDeviceFile(path);
      return await tempPlayer.getDuration() ?? Duration.zero;
    } catch (e) {
      print("Failed to get duration: $e");
      return Duration.zero;
    }
  }

  void _retry() {
    _timer?.cancel();
    setState(() {
      _recordedFilePath = null;
      _uploadedFilePath = null;
      _duration = Duration.zero;
      showRecordingOptions = false;
      isPlaying = false;
    });
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

  @override
  void dispose() {
    _player.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fileSelected = _uploadedFilePath != null
        ? "Uploaded file"
        : _recordedFilePath != null
            ? "Recorded file"
            : "No file selected";

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/heart.png', width: 180, height: 180),
            SizedBox(height: 30),
            Text(
              formatDuration(_duration),
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(fileSelected, style: TextStyle(color: Colors.grey[400])),
            SizedBox(height: 30),
            if (!showRecordingOptions)
              Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isRecording ? Colors.red : Colors.blue,
                      minimumSize: Size(200, 50),
                    ),
                    onPressed: isRecording ? _stopRecording : _startRecording,
                    child: Text(
                      isRecording ? 'Stop Recording' : 'Start Recording',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      minimumSize: Size(200, 50),
                    ),
                    onPressed: _pickFile,
                    child: Text('Upload File',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ],
              ),
            if (showRecordingOptions) ...[
              buildOptionButton('Play Selected', Colors.blue, _playRecording),
              buildOptionButton('Retry', Colors.orange, _retry),
              buildOptionButton('Display Result', Colors.green, _uploadAndDetectTB),
            ],
          ],
        ),
      ),
    );
  }

  Widget buildOptionButton(String text, Color color, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          minimumSize: Size(200, 50),
        ),
        onPressed: onPressed,
        child: Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }
}
