import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';
import 'package:flutter/material.dart';

class JitsiHelper {

  final JitsiMeet _jitsiMeet = JitsiMeet();

  Future<void> joinMeeting({
    required String meetId,
    required String email,
    required String name,
  }) async {
    var options = JitsiMeetConferenceOptions(
      userInfo: JitsiMeetUserInfo(displayName: name, email: email, avatar: null),
      room: meetId,
      featureFlags: {
        FeatureFlags.addPeopleEnabled: true,
        FeatureFlags.welcomePageEnabled: false,
        FeatureFlags.preJoinPageEnabled: false,
        FeatureFlags.unsafeRoomWarningEnabled: false,
        FeatureFlags.resolution: FeatureFlagVideoResolutions.resolution720p,
        FeatureFlags.audioFocusDisabled: true,
        FeatureFlags.audioMuteButtonEnabled: true,
        FeatureFlags.audioOnlyButtonEnabled: true,
        FeatureFlags.calenderEnabled: true,
        FeatureFlags.callIntegrationEnabled: true,
        FeatureFlags.carModeEnabled: true,
        FeatureFlags.closeCaptionsEnabled: true,
        FeatureFlags.conferenceTimerEnabled: true,
        FeatureFlags.chatEnabled: true,
        FeatureFlags.filmstripEnabled: true,
        FeatureFlags.fullScreenEnabled: true,
        FeatureFlags.helpButtonEnabled: true,
        FeatureFlags.inviteEnabled: true,
        FeatureFlags.androidScreenSharingEnabled: true,
        FeatureFlags.speakerStatsEnabled: true,
        FeatureFlags.kickOutEnabled: true,
        FeatureFlags.liveStreamingEnabled: true,
        FeatureFlags.lobbyModeEnabled: true,
        FeatureFlags.meetingNameEnabled: true,
        FeatureFlags.meetingPasswordEnabled: true,
        FeatureFlags.notificationEnabled: true,
        FeatureFlags.overflowMenuEnabled: true,
        FeatureFlags.pipEnabled: true,
        FeatureFlags.pipWhileScreenSharingEnabled: true,
        FeatureFlags.preJoinPageHideDisplayName: true,
        FeatureFlags.raiseHandEnabled: true,
        FeatureFlags.reactionsEnabled: true,
        FeatureFlags.recordingEnabled: true,
        FeatureFlags.replaceParticipant: true,
        FeatureFlags.securityOptionEnabled: true,
        FeatureFlags.serverUrlChangeEnabled: true,
        FeatureFlags.settingsEnabled: true,
        FeatureFlags.tileViewEnabled: true,
        FeatureFlags.videoMuteEnabled: true,
        FeatureFlags.videoShareEnabled: true,
        FeatureFlags.toolboxEnabled: true,
        FeatureFlags.iosRecordingEnabled: true,
        FeatureFlags.iosScreenSharingEnabled: true,
        FeatureFlags.toolboxAlwaysVisible: true,
      },
    );
    _jitsiMeet.join(options, _jitsiEventListener);
  }

  final JitsiMeetEventListener _jitsiEventListener = JitsiMeetEventListener(
    conferenceJoined: (url) {
      debugPrint("conferenceJoined: url: $url");
    },
    conferenceTerminated: (url, error) {
      debugPrint("conferenceTerminated: url: $url, error: $error");
    },
    conferenceWillJoin: (url) {
      debugPrint("conferenceWillJoin: url: $url");
    },
    participantJoined: (email, name, role, participantId) {
      debugPrint(
        "participantJoined: email: $email, name: $name, role: $role, participantId: $participantId",
      );
    },
    participantLeft: (participantId) {
      debugPrint("participantLeft: participantId: $participantId");
    },
    audioMutedChanged: (muted) {
      debugPrint("audioMutedChanged: isMuted: $muted");
    },
    videoMutedChanged: (muted) {
      debugPrint("videoMutedChanged: isMuted: $muted");
    },
    endpointTextMessageReceived: (senderId, message) {
      debugPrint("endpointTextMessageReceived: senderId: $senderId, message: $message");
    },
    screenShareToggled: (participantId, sharing) {
      debugPrint("screenShareToggled: participantId: $participantId, isSharing: $sharing");
    },
    chatMessageReceived: (senderId, message, isPrivate, timestamp) {
      debugPrint("chatMessageReceived: senderId: $senderId, message: $message, isPrivate: $isPrivate, timestamp: $timestamp");
    },
    chatToggled: (isOpen) => debugPrint("chatToggled: isOpen: $isOpen"),
    participantsInfoRetrieved: (participantsInfo) {
      debugPrint("participantsInfoRetrieved: participantsInfo: $participantsInfo, ");
    },
    readyToClose: () {
      debugPrint("readyToClose");
    },
  );
}