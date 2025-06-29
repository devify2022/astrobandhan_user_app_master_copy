import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:astrobandhan/provider/socket_provider.dart';

class CallScreen extends StatefulWidget {
  final String appId;
  final String channelName;
  final String token;
  final int uid;
  final String avatar;
  final String name;
  final String id;
  final SocketProvider socketProvider;

  const CallScreen({
    Key? key,
    required this.appId,
    required this.channelName,
    required this.token,
    required this.uid,
    required this.avatar,
    required this.name,
    required this.id,
    required this.socketProvider,
  }) : super(key: key);

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  late RtcEngine _engine;
  bool _isSpeakerEnabled = false;
  bool _isMuted = false;
  bool _isRinging = true;
  bool _isCallActive = false;
  bool _isCallEnded = false;
  bool _isEngineInitialized = false;
  bool _isRemoteUserJoined = false;
  Duration _callDuration = Duration.zero;
  Timer? _callTimer;
  late AudioPlayer _audioPlayer;
  final String _ringtonePath = 'phone/phone_ringing.mp3';

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _playRingtone();
    // Listen for the 'call_rejected_by_astrologer' event

    _requestPermissions().then((granted) {
      if (granted) {
        initAgora();
      } else {
        print("Microphone permission denied");
      }
    });
  }

  Future<bool> _requestPermissions() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  Future<void> initAgora() async {
    try {
      _engine = createAgoraRtcEngine();
      await _engine.initialize(RtcEngineContext(appId: widget.appId));
      await _engine.enableAudio();
      _isEngineInitialized = true;

      _engine.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (connection, elapsed) {
            setState(() => _isRinging = false);
            print("Local user ${connection.localUid} joined");
          },
          onUserJoined: (connection, remoteUid, elapsed) {
            print("Astrologer joined: $remoteUid");
            setState(() {
              _isRemoteUserJoined = true;
              _isCallActive = true;
            });
            _stopRingtone();
            _startCallTimer();
          },
          onUserOffline: (connection, remoteUid, reason) {
            print("Astrologer left: $remoteUid");
            _endCall();
          },
        ),
      );

      await _engine.joinChannel(
        token: widget.token,
        channelId: widget.channelName,
        uid: widget.uid,
        options: const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          publishMicrophoneTrack: true,
        ),
      );
    } catch (e) {
      print("Error initializing Agora: $e");
    }
  }

  void _startCallTimer() {
    _callTimer?.cancel();
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _callDuration += const Duration(seconds: 1);
      });
    });
  }

  void _toggleSpeaker() async {
    setState(() => _isSpeakerEnabled = !_isSpeakerEnabled);
    await _engine.setEnableSpeakerphone(_isSpeakerEnabled);
  }

  void _toggleMute() async {
    setState(() => _isMuted = !_isMuted);
    await _engine.muteLocalAudioStream(_isMuted);
  }

  void _endCall() async {
    _callTimer?.cancel();
    _stopRingtone();
    try {
      if (_isEngineInitialized) {
        await _engine.leaveChannel();
      }
      widget.socketProvider.socketService?.socket.emit('call_rejected', {
        'userId': widget.uid.toString(),
        'astrologerId': widget.id,
        'rejectedBy': "user",
      });

      setState(() {
        _isCallEnded = true;
        _isCallActive = false;
      });

      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) Navigator.pop(context);
      });
    } catch (e) {
      print('Error ending call: $e');
      if (mounted) Navigator.pop(context);
    }
  }

  void _playRingtone() async {
    await _audioPlayer.play(AssetSource(_ringtonePath), volume: 0.5);
  }

  void _stopRingtone() async {
    await _audioPlayer.stop();
  }

  @override
  void dispose() {
    _callTimer?.cancel();
    if (_isEngineInitialized) {
      _engine.leaveChannel();
      _engine.release();
    }
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: _isCallEnded
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.call_end, size: 50, color: Colors.red),
                  const SizedBox(height: 20),
                  const Text('Call Ended',
                      style: TextStyle(fontSize: 24, color: Colors.white)),
                  if (_callDuration.inSeconds > 0)
                    Text(
                      'Duration: ${_formatDuration(_callDuration)}',
                      style:
                          const TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                    ),
                    child: const Text('Back to Astrologer',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                Transform(
                  alignment: Alignment.center,
                  transform:
                      Matrix4.rotationZ(3.1416), // 180 degrees in radians
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.avatar),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.7),
                          BlendMode.darken,
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    const SizedBox(height: 60),
                    Text(
                      _isRinging
                          ? 'Calling Astrologer'
                          : _isRemoteUserJoined
                              ? 'Call Connected'
                              : 'Waiting for astrologer...',
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                    const SizedBox(height: 40),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _isRemoteUserJoined
                                    ? Colors.green
                                    : Colors.orange,
                                width: 3,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 80,
                              backgroundImage: NetworkImage(widget.avatar),
                              backgroundColor: Colors.grey[300],
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            widget.name,
                            style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 10),
                          !_isRemoteUserJoined
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.phone_in_talk,
                                        color: Colors.orange),
                                    SizedBox(width: 8),
                                    Text(
                                      'Connecting to astrologer...',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white70),
                                    ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    const Text(
                                      'Connected with astrologer',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.green),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      _formatDuration(_callDuration),
                                      style: const TextStyle(
                                          fontSize: 18, color: Colors.white70),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildCallControlButton(
                            icon: _isMuted ? Icons.mic_off : Icons.mic,
                            label: 'Mute',
                            color: _isMuted ? Colors.red : Colors.white,
                            onPressed: _toggleMute,
                          ),
                          _buildCallControlButton(
                            icon: _isSpeakerEnabled
                                ? Icons.volume_up
                                : Icons.volume_off,
                            label: 'Speaker',
                            color:
                                _isSpeakerEnabled ? Colors.green : Colors.white,
                            onPressed: _toggleSpeaker,
                          ),
                          Column(
                            children: [
                              FloatingActionButton(
                                onPressed: _endCall,
                                backgroundColor: Colors.red,
                                child: const Icon(Icons.call_end,
                                    color: Colors.white, size: 30),
                              ),
                              const SizedBox(height: 5),
                              const Text('End',
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildCallControlButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        IconButton(
            icon: Icon(icon, color: color, size: 30), onPressed: onPressed),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}
