import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/common/utils/video_call_imports.dart';
import 'package:flutter/foundation.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'dart:developer' as dev;
import 'package:web_browser_detect/web_browser_detect.dart';

class ConversationCallScreen extends StatefulWidget {
  final P2PSession _callSession;
  final bool _isIncoming;

  @override
  State<StatefulWidget> createState() {
    return _ConversationCallScreenState(_callSession, _isIncoming);
  }

  ConversationCallScreen(this._callSession, this._isIncoming);
}

class _ConversationCallScreenState extends State<ConversationCallScreen>
    implements RTCSessionStateCallback<P2PSession> {
  static const String TAG = "_ConversationCallScreenState";
  final P2PSession _callSession;
  final bool _isIncoming;
  bool _isCameraEnabled = true;
  bool _isSpeakerEnabled = Platform.isIOS ? false : true;
  bool _isMicMute = false;
  bool _isFrontCameraUsed = true;
  bool isOpponentConnected = false;
  bool _isOpponentConnected1 = false;
  final int _currentUserId = CubeChatConnection.instance.currentUser!.id!;

  MapEntry<int, RTCVideoRenderer>? primaryRenderer;
  Map<int, RTCVideoRenderer> minorRenderers = {};
  RTCVideoViewObjectFit primaryVideoFit =
      RTCVideoViewObjectFit.RTCVideoViewObjectFitCover;

  bool _isCalling = true;

  bool _enableScreenSharing;

  _ConversationCallScreenState(this._callSession, this._isIncoming)
    : _enableScreenSharing = !_callSession.startScreenSharing;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer();

  @override
  void initState() {
    super.initState();
    _initAlreadyReceivedStreams();
    dev.log("$_isOpponentConnected1", name: "_isOpponentConnected 53");
    _callSession.onLocalStreamReceived = _addLocalMediaStream;
    _callSession.onRemoteStreamReceived = _addRemoteMediaStream;
    _callSession.onSessionClosed = _onSessionClosed;
    _callSession.setSessionCallbacksListener(this);

    if (_isIncoming) {
      if (_callSession.state == RTCSessionState.RTC_SESSION_NEW) {
        _callSession.acceptCall();
      }
    } else {
      _callSession.startCall();
    }

    CallManager.instance.onMicMuted = (muted, sessionId) {
      setState(() {
        _isMicMute = muted;
        _callSession.setMicrophoneMute(_isMicMute);
      });
    };
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    stopBackgroundExecution();

    primaryRenderer?.value.srcObject = null;
    primaryRenderer?.value.dispose();

    minorRenderers.forEach((opponentId, renderer) {
      log("[dispose] dispose renderer for $opponentId", TAG);
      try {
        renderer.srcObject?.dispose();
        renderer.srcObject = null;
        renderer.dispose();
      } catch (e) {
        log('Error $e');
      }
    });

    await _stopWatchTimer.dispose();
  }

  Future<void> _addLocalMediaStream(MediaStream stream) async {
    log("_addLocalMediaStream, stream Id: ${stream.id}", TAG);

    _addMediaStream(_currentUserId, stream);
  }

  void _addRemoteMediaStream(session, int userId, MediaStream stream) {
    if (_isCalling) {
      setState(() {
        _isOpponentConnected1 = true;
        _isCalling = false;
        dev.log("$_isOpponentConnected1", name: "_isOpponentConnected 124");
      });
      _addMediaStream(userId, stream);
    }
  }

  Future<void> _removeMediaStream(callSession, int userId) async {
    log("_removeMediaStream for user $userId", TAG);
    var videoRenderer = minorRenderers[userId];
    if (videoRenderer == null) return;

    videoRenderer.srcObject = null;
    videoRenderer.dispose();

    setState(() {
      minorRenderers.remove(userId);
    });
  }

  Future<void> _addMediaStream(int userId, MediaStream stream) async {
    if (primaryRenderer == null) {
      primaryRenderer = MapEntry(userId, RTCVideoRenderer());
      await primaryRenderer!.value.initialize();

      setState(() {
        primaryRenderer?.value.srcObject = stream;
      });

      return;
    }

    if (minorRenderers[userId] == null) {
      minorRenderers[userId] = RTCVideoRenderer();
      await minorRenderers[userId]?.initialize();
    }

    setState(() {
      minorRenderers[userId]?.srcObject = stream;

      if (primaryRenderer?.key == _currentUserId ||
          primaryRenderer?.key == userId) {
        _replacePrimaryRenderer(userId);
      }
    });
  }

  void _replacePrimaryRenderer(int newPrimaryUser) {
    if (primaryRenderer?.key != newPrimaryUser) {
      minorRenderers.addEntries([primaryRenderer!]);
    }

    primaryRenderer = MapEntry(
      newPrimaryUser,
      minorRenderers.remove(newPrimaryUser)!,
    );
  }

  _onSessionClosed(session) {
    log("_onSessionClosed", TAG);

    _callSession.removeSessionCallbacksListener();

    Get.back();
  }

  Widget buildMinorVideoItem(int opponentId, RTCVideoRenderer renderer) {
    return Expanded(
      child: Stack(
        children: [
          RTCVideoView(
            renderer,
            objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
            mirror: false,
          ),
        ],
      ),
    );
  }

  List<Widget> renderStreamsGrid(Orientation orientation) {
    List<Widget> streamsExpanded = [];

    if (primaryRenderer != null) {
      streamsExpanded.add(
        Expanded(
          child: RTCVideoView(
            primaryRenderer!.value,
            objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
            mirror: true,
          ),
        ),
      );
    }

    if (CallManager.instance.remoteStreams.isNotEmpty) {
      minorRenderers.addEntries([
        ...CallManager.instance.remoteStreams.entries.map((mediaStreamEntry) {
          var videoRenderer = RTCVideoRenderer();
          videoRenderer.initialize().then((value) {
            videoRenderer.srcObject = mediaStreamEntry.value;
          });

          return MapEntry(mediaStreamEntry.key, videoRenderer);
        }),
      ]);
      CallManager.instance.remoteStreams.clear();
    }

    streamsExpanded.addAll(
      minorRenderers.entries
          .map((entry) => buildMinorVideoItem(entry.key, entry.value))
          .toList(),
    );

    if (streamsExpanded.length > 2) {
      List<Widget> rows = [];

      for (var i = 0; i < streamsExpanded.length; i += 2) {
        var chunkEndIndex = i + 2;

        if (streamsExpanded.length < chunkEndIndex) {
          chunkEndIndex = streamsExpanded.length;
        }

        var chunk = streamsExpanded.sublist(i, chunkEndIndex);

        rows.add(
          Expanded(
            child: orientation == Orientation.portrait
                ? Row(children: chunk)
                : Column(children: chunk),
          ),
        );
      }

      return rows;
    }

    return streamsExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: Scaffold(
        backgroundColor: AppColors.grey,
        body: Stack(
          fit: StackFit.loose,
          clipBehavior: Clip.none,
          children: [
            _isVideoCall()
                ? OrientationBuilder(
                    builder: (context, orientation) {
                      return _buildPrivateCallLayout(orientation);
                    },
                  )
                : Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: Text(
                            "audio_call".tr,
                            style: const TextStyle(
                              fontSize: 28,
                              fontFamily: AppFontStyleTextStrings.regular,
                            ),
                          ),
                        ),

                        // Padding(
                        //   padding: const EdgeInsets.only(bottom: 12),
                        //   child: Text(
                        //     "members".tr,
                        //     style: const TextStyle(
                        //       fontSize: 20,
                        //       fontStyle: FontStyle.italic,
                        //       fontFamily: AppFontStyleTextStrings.regular,
                        //     ),
                        //   ),
                        // ),
                        // Text(
                        //   _callSession.opponentsIds.join(", "),
                        //   style: const TextStyle(
                        //     fontSize: 20,
                        //     fontFamily: AppFontStyleTextStrings.regular,
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            _safeOpponentName(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontFamily: AppFontStyleTextStrings.regular,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            !_isVideoCall()
                ? const SizedBox()
                : AnimatedSwitcher(
                    duration: const Duration(milliseconds: 850),
                    child: _isCalling
                        ? _isIncoming
                              ? const SizedBox()
                              : Container(
                                  padding: const EdgeInsets.only(top: 90),
                                  height: Get.height,
                                  color: AppColors.BLACK,
                                  alignment: Alignment.topCenter,
                                  child: Column(
                                    children: [
                                      (StorageService.readData(
                                                    key: LocalStorageKeys
                                                        .callReceiverImage,
                                                  ) ==
                                                  AppImages.defaultDoctor ||
                                              StorageService.readData(
                                                    key: LocalStorageKeys
                                                        .callReceiverImage,
                                                  ) ==
                                                  AppImages.defaultUser)
                                          ? (StorageService.readData(
                                                              key: LocalStorageKeys
                                                                  .callReceiverImage,
                                                            ) ??
                                                            "")
                                                        .contains("png") ??
                                                    true
                                                ? Image.asset(
                                                    AppImages.defaultUser,
                                                    height: 100,
                                                    width: 100,
                                                  )
                                                : SvgPicture.asset(
                                                    AppImages.defaultDoctor,
                                                    height: 100,
                                                    width: 100,
                                                  )
                                          : Container(
                                              height: 100,
                                              width: 100,
                                              child: ClipOval(
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.cover,
                                                  imageUrl:
                                                      StorageService.readData(
                                                        key: LocalStorageKeys
                                                            .callReceiverImage,
                                                      ) ??
                                                      "",
                                                  placeholder: (context, url) {
                                                    return (StorageService.readData(
                                                                      key: LocalStorageKeys
                                                                          .callReceiverImage,
                                                                    ) ??
                                                                    "")
                                                                .contains(
                                                                  "png",
                                                                ) ??
                                                            true
                                                        ? Image.asset(
                                                            AppImages
                                                                .defaultUser,
                                                            height: 100,
                                                            width: 100,
                                                          )
                                                        : SvgPicture.asset(
                                                            AppImages
                                                                .defaultDoctor,
                                                            height: 100,
                                                            width: 100,
                                                          );
                                                  },
                                                ),
                                              ),
                                            ),
                                      const SizedBox(height: 30),
                                      AppTextWidgets.regularText(
                                        text:
                                            '${StorageService.readData(key: LocalStorageKeys.callReceiverName)}',
                                        color: AppColors.WHITE,
                                        size: 25,
                                      ),
                                      const SizedBox(height: 15),
                                      AppTextWidgets.regularText(
                                        text: 'ringing'.tr,
                                        color: AppColors.WHITE,
                                        size: 22,
                                      ),
                                    ],
                                  ),
                                )
                        : Align(
                            alignment: Alignment.topCenter,
                            child: StreamBuilder<int>(
                              stream: _stopWatchTimer.rawTime,
                              initialData: 0,
                              builder: (context, snap) {
                                final value = snap.data;
                                var houre = StopWatchTimer.getDisplayTimeHours(
                                  value!,
                                );
                                bool isHouShow = false;
                                if (houre != '00') {
                                  isHouShow = true;
                                }
                                final displayTime =
                                    StopWatchTimer.getDisplayTime(
                                      value,
                                      milliSecond: false,
                                      hours: isHouShow,
                                    );
                                return Container(
                                  margin: EdgeInsets.only(
                                    top:
                                        MediaQuery.of(context).padding.top + 20,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: AppColors.BLACK,
                                    ),
                                    child: AppTextWidgets.mediumText(
                                      text: "$displayTime",
                                      color: AppColors.WHITE,
                                      size: 18,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                  ),
            Align(alignment: Alignment.bottomCenter, child: _getActionsPanel()),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivateCallLayout(Orientation orientation) {
    return Container(
      child: Stack(
        children: [
          if (primaryRenderer != null) _buildPrimaryVideoView(orientation),
          if (minorRenderers.isNotEmpty)
            Align(
              alignment: Alignment.bottomRight,
              child: buildItems(
                minorRenderers,
                orientation == Orientation.portrait
                    ? MediaQuery.of(context).size.width
                    : MediaQuery.of(context).size.width / 4,
                orientation == Orientation.portrait
                    ? MediaQuery.of(context).size.height / 2
                    : MediaQuery.of(context).size.height / 2.5,
              ).first,
            ),
        ],
      ),
    );
  }

  List<Widget> renderGroupCallViews(Orientation orientation) {
    List<Widget> streamsExpanded = [];

    if (primaryRenderer != null) {
      streamsExpanded.add(
        Expanded(flex: 3, child: _buildPrimaryVideoView(orientation)),
      );
    }

    var itemHeight;
    var itemWidth;

    if (orientation == Orientation.portrait) {
      itemHeight = MediaQuery.of(context).size.height / 3 * 0.8;
      itemWidth = itemHeight / 3 * 4;
    } else {
      itemWidth = MediaQuery.of(context).size.width / 3 * 0.8;
      itemHeight = itemWidth / 4 * 3;
    }

    var minorItems = buildItems(minorRenderers, itemWidth, itemHeight);

    if (minorRenderers.isNotEmpty) {
      var membersList = Expanded(
        flex: 1,
        child: ListView(
          scrollDirection: orientation == Orientation.landscape
              ? Axis.vertical
              : Axis.horizontal,
          children: minorItems,
        ),
      );

      streamsExpanded.add(membersList);
    }

    return streamsExpanded;
  }

  List<Widget> buildItems(
    Map<int, RTCVideoRenderer> renderers,
    double itemWidth,
    double itemHeight,
  ) {
    return renderers.entries
        .map(
          (entry) => AbsorbPointer(
            child: Container(
              width: itemWidth,
              height: itemHeight,
              child: Stack(
                children: [
                  RTCVideoView(
                    entry.value,
                    objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                    mirror:
                        entry.key == _currentUserId &&
                        _isFrontCameraUsed &&
                        _enableScreenSharing,
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();
  }

  Widget _buildPrimaryVideoView(Orientation orientation) {
    return Stack(
      children: [
        Container(
          alignment: Alignment.topCenter,
          height: _isOpponentConnected1
              ? MediaQuery.of(context).size.height / 2
              : MediaQuery.of(context).size.height,
          child: RTCVideoView(
            primaryRenderer!.value,
            objectFit: primaryVideoFit,
            mirror:
                primaryRenderer!.key == _currentUserId &&
                _isFrontCameraUsed &&
                _enableScreenSharing,
          ),
        ),
      ],
    );
  }

  Widget _getActionsPanel() {
    return Container(
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 8,
        left: MediaQuery.of(context).padding.left + 8,
        right: MediaQuery.of(context).padding.right + 8,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Container(
          padding: const EdgeInsets.all(4),
          color: AppColors.BLACK26,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: FloatingActionButton(
                  elevation: 0,
                  heroTag: "Mute",
                  child: Icon(
                    _isMicMute ? Icons.mic_off : Icons.mic,
                    color: _isMicMute ? AppColors.grey : AppColors.WHITE,
                  ),
                  onPressed: () => _muteMic(),
                  backgroundColor: AppColors.BLACK38,
                ),
              ),
              Visibility(
                visible: _enableScreenSharing,
                child: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: FloatingActionButton(
                    elevation: 0,
                    heroTag: "ToggleCamera",
                    child: Icon(
                      _isVideoEnabled() ? Icons.videocam : Icons.videocam_off,
                      color: _isVideoEnabled()
                          ? AppColors.WHITE
                          : AppColors.grey,
                    ),
                    onPressed: () => _toggleCamera(),
                    backgroundColor: AppColors.BLACK38,
                  ),
                ),
              ),
              Visibility(
                visible: _enableScreenSharing,
                child: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: FloatingActionButton(
                    elevation: 0,
                    heroTag: 'Switch Camera',
                    child: Icon(
                      Icons.cameraswitch,
                      color: _isVideoEnabled()
                          ? AppColors.WHITE
                          : AppColors.grey,
                    ),
                    onPressed: () => _switchCamera(),
                    backgroundColor: AppColors.BLACK38,
                  ),
                ),
              ),
              Visibility(
                visible:
                    !(kIsWeb &&
                        (Browser().browserAgent == BrowserAgent.safari ||
                            Browser().browserAgent == BrowserAgent.firefox)),
                child: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: FloatingActionButton(
                    elevation: 0,
                    heroTag:
                        'Switch ${kIsWeb || WebRTC.platformIsDesktop ? 'Audio output' : 'Speakerphone'}',
                    child: Icon(
                      kIsWeb || WebRTC.platformIsDesktop
                          ? Icons.surround_sound
                          : _isSpeakerEnabled
                          ? Icons.volume_up
                          : Icons.volume_off,
                      color: _isSpeakerEnabled
                          ? AppColors.WHITE
                          : AppColors.grey,
                    ),
                    onPressed: () => _switchSpeaker(),
                    backgroundColor: AppColors.BLACK38,
                  ),
                ),
              ),
              const Expanded(child: SizedBox(), flex: 1),
              Padding(
                padding: const EdgeInsets.only(left: 0),
                child: FloatingActionButton(
                  child: const Icon(Icons.call_end, color: AppColors.WHITE),
                  backgroundColor: AppColors.RED,
                  onPressed: () => _endCall(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _endCall() async {
    await _stopWatchTimer.dispose();
    CallManager.instance.hungUp();
  }

  Future<bool> _onBackPressed(BuildContext context) {
    return Future.value(false);
  }

  _muteMic() {
    setState(() {
      _isMicMute = !_isMicMute;
      _callSession.setMicrophoneMute(_isMicMute);
      CallManager.instance.muteCall(_callSession.sessionId, _isMicMute);
    });
  }

  _switchCamera() {
    if (!_isVideoEnabled()) return;

    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      _callSession.switchCamera().then((isFrontCameraUsed) {
        setState(() {
          _isFrontCameraUsed = isFrontCameraUsed;
        });
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return FutureBuilder<List<MediaDeviceInfo>>(
            future: _callSession.getCameras(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return AlertDialog(
                  content: const Text('No cameras found'),
                  actions: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: Theme.of(context).textTheme.labelLarge,
                      ),
                      child: const Text('Ok'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              } else {
                return SimpleDialog(
                  title: const Text('Select camera'),
                  children: snapshot.data?.map((mediaDeviceInfo) {
                    return SimpleDialogOption(
                      onPressed: () {
                        Get.back(result: mediaDeviceInfo.deviceId);
                      },
                      child: Text(mediaDeviceInfo.label),
                    );
                  }).toList(),
                );
              }
            },
          );
        },
      ).then((deviceId) {
        log("onCameraSelected deviceId: $deviceId", TAG);
        if (deviceId != null) _callSession.switchCamera(deviceId: deviceId);
      });
    }
  }

  _toggleCamera() {
    if (!_isVideoCall()) return;

    setState(() {
      _isCameraEnabled = !_isCameraEnabled;
      _callSession.setVideoEnabled(_isCameraEnabled);
    });
  }

  bool _isVideoEnabled() {
    return _isVideoCall() && _isCameraEnabled;
  }

  String _safeOpponentName() {
    final dynamic storedName = StorageService.readData(
      key: LocalStorageKeys.callReceiverName,
    );

    final String name = storedName == null ? '' : storedName.toString().trim();

    if (name.isNotEmpty &&
        name.toLowerCase() != 'null' &&
        !RegExp(r'^\d+$').hasMatch(name)) {
      return name;
    }

    return _isIncoming ? 'Caller' : 'Doctor';
  }

  bool _isVideoCall() {
    return CallType.VIDEO_CALL == _callSession.callType;
  }

  _switchSpeaker() {
    if (kIsWeb || WebRTC.platformIsDesktop) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return FutureBuilder<List<MediaDeviceInfo>>(
            future: _callSession.getAudioOutputs(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return AlertDialog(
                  content: const Text('No Audio output devices found'),
                  actions: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: Theme.of(context).textTheme.labelLarge,
                      ),
                      child: const Text('Ok'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              } else {
                return SimpleDialog(
                  title: const Text('Select Audio output device'),
                  children: snapshot.data?.map((mediaDeviceInfo) {
                    return SimpleDialogOption(
                      onPressed: () {
                        Get.back(result: mediaDeviceInfo.deviceId);
                      },
                      child: Text(mediaDeviceInfo.label),
                    );
                  }).toList(),
                );
              }
            },
          );
        },
      ).then((deviceId) {
        log("onAudioOutputSelected deviceId: $deviceId", TAG);
        if (deviceId != null) {
          setState(() {
            if (kIsWeb) {
              primaryRenderer?.value.audioOutput(deviceId);
              minorRenderers.forEach((userId, renderer) {
                renderer.audioOutput(deviceId);
              });
            } else {}
          });
        }
      });
    } else {
      setState(() {
        _isSpeakerEnabled = !_isSpeakerEnabled;
        _callSession.enableSpeakerphone(_isSpeakerEnabled);
      });
    }
  }

  @override
  void onConnectedToUser(P2PSession session, int userId) {
    _stopWatchTimer.onExecute.add(StopWatchExecute.start);
    log("onConnectedToUser userId= $userId");
  }

  @override
  void onConnectionClosedForUser(P2PSession session, int userId) {
    log("onConnectionClosedForUser userId= $userId");
    _removeMediaStream(session, userId);
  }

  @override
  void onDisconnectedFromUser(P2PSession session, int userId) {
    log("onDisconnectedFromUser userId= $userId");
  }

  void _initAlreadyReceivedStreams() {
    if (CallManager.instance.remoteStreams.isNotEmpty) {
      minorRenderers.addEntries([
        ...CallManager.instance.remoteStreams.entries.map((mediaStreamEntry) {
          var videoRenderer = RTCVideoRenderer();
          videoRenderer.initialize().then((value) {
            videoRenderer.srcObject = mediaStreamEntry.value;
          });

          return MapEntry(mediaStreamEntry.key, videoRenderer);
        }),
      ]);
    }

    createLocalRenderer() {
      var renderer = MapEntry(_currentUserId, RTCVideoRenderer());
      renderer.value.initialize().then((value) {
        renderer.value.srcObject = CallManager.instance.localMediaStream;
      });

      return renderer;
    }

    if (CallManager.instance.localMediaStream != null) {
      if (minorRenderers.isNotEmpty) {
        var tempPrimaryRenderer = minorRenderers.entries.first;
        primaryRenderer = tempPrimaryRenderer;
        minorRenderers.remove(tempPrimaryRenderer.key);
        minorRenderers.addEntries([createLocalRenderer()]);
      } else {
        primaryRenderer = createLocalRenderer();
        // CallManager.instance.localMediaStream = null;
      }
    }
  }

  @override
  void onConnectingToUser(P2PSession session, int userId) {
    // TODO: implement onConnectingToUser
  }

  @override
  void onConnectionFailedWithUser(P2PSession session, int userId) {
    // TODO: implement onConnectionFailedWithUser
  }
}
