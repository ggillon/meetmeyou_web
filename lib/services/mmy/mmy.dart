import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meetmeyou_web/models/constants.dart';
import 'package:meetmeyou_web/models/contact.dart';
import 'package:meetmeyou_web/models/date_option.dart';
import 'package:meetmeyou_web/models/event_answer.dart';
import 'package:meetmeyou_web/models/profile.dart';
import 'package:meetmeyou_web/models/event.dart';
import 'package:meetmeyou_web/models/calendar_event.dart';
import 'package:meetmeyou_web/services/database/database.dart';
import 'dart:io';
import '../../models/discussion.dart';
import '../../models/discussion_message.dart';
import '../../models/mmy_notification.dart';
import '../../models/photo_album.dart';
import '../../models/search_result.dart';

import 'profile.dart' as profileLib;
import 'contact.dart' as contactLib;
import 'event.dart' as eventLib;
import 'event_answer.dart' as answerLib;
import 'package:meetmeyou_web/services/storage/storage.dart' as storageLib;


const USER_TYPE_NORMAL = "Normal User";
const USER_TYPE_PRO = "Pro User";
const USER_TYPE_ADMIN = "Admin User";

abstract class MMYEngine {

  /// DEBUG MESSAGE
  void debugMsg(String text, {Map? attachment});

  /// PROFILE ///

  /// Get the user profile or create new one
  Future<Profile> getUserProfile({bool user = true, String? uid});
  /// Update the user profile
  Future<Profile> updateProfile({String? firstName, String? lastName, String? email, String? countryCode, String? phoneNumber, String? photoUrl, String? homeAddress, String? about, Map? other, Map? parameters});
  /// Get the user profile or create new one, leveraging the Auth user info
  Future<Profile> createUserProfile();
  /// Checks if profile exists
  Future<bool> isNew();
  /// Update the profile Profile
  Future<Profile> updateProfilePicture(File file);

  /// CONTACT ///

  /// Get a contact, invitation or group from DB
  Future<Contact> getContact(String cid);

  /// EVENT ///
  /// Get a particular Event
  Future<Event> getEvent(String eid);
  /// Reply to event
  Future<void> replyToEvent(String eid, {required String response});

  ///  Reply to form to an event
  Future<EventAnswer> answerEventForm(String eid, {required Map answers});
  ///  Get reply to form to an event
  Future<EventAnswer> getAnswerEventForm(String eid, String uid);
  ///  Get reply to form to an event
  Future<List<EventAnswer>> getAnswersEventForm(String eid);


}

class MMY implements MMYEngine {
  /// Creates a MMYEngine class with access to features

  MMY(this._currentUser);
  final User _currentUser;

  @override
  void debugMsg(String text, {Map? attachment}) {
    final db = FirestoreDB(uid: _currentUser.uid);
    db.debugMsg(_currentUser.uid, text, attachment);
  }

  @override
  Future<Profile> getUserProfile({bool user = true, String? uid}) async{
    Profile profile = await profileLib.getUserProfile(_currentUser, user: user, uid: uid);
    profileLib.cleanUpDb(_currentUser); // perform db cleanUp at start
    return profile;
  }

  @override
  Future<Profile> updateProfile({String? firstName, String? lastName, String? email, String? countryCode, String? phoneNumber, String? photoUrl, String? homeAddress, String? about, Map? other, Map? parameters}) async {
    return profileLib.updateProfile(_currentUser, firstName: firstName, lastName: lastName, email: email, countryCode: countryCode, phoneNumber: phoneNumber, photoUrl: photoUrl, homeAddress: homeAddress, about: about, other: other, parameters: parameters);
  }

  @override
  Future<Profile> createUserProfile() {
    return profileLib.createProfileFromUser(_currentUser);
  }

  @override
  Future<bool> isNew() {
    return profileLib.isNewProfile(_currentUser);
  }

  @override
  Future<Profile> updateProfilePicture(File file) async {
   String photoURL = await storageLib.storeProfilePicture(file, uid: _currentUser.uid);
   return profileLib.updateProfile(_currentUser, photoUrl: photoURL);
  }

  @override
  Future<Contact> getContact(String cid) async {
     return contactLib.getContact(_currentUser, cid: cid);
  }

  @override
  Future<Event> getEvent(String eid) async {
    return await eventLib.getEvent(_currentUser, eid);
  }


  @override
  Future<Event> replyToEvent(String eid, {required String response}) async {
    contactLib.linkEvent(_currentUser, eid: eid);
    return await eventLib.updateInvitations(_currentUser, eid,
        eventLib.Invitations(CIDs: [_currentUser.uid], inviteStatus: response));
  }


  @override
  Future<EventAnswer> answerEventForm(String eid, {required Map answers}) async {
    return answerLib.answerEventForm(eid, _currentUser, answers);
  }

  @override
  Future<EventAnswer> getAnswerEventForm(String eid, String uid) async {
    return answerLib.getAnswerEventForm(_currentUser, eid, uid);
  }

  @override
  Future<List<EventAnswer>> getAnswersEventForm(String eid) {
    return answerLib.getAnswersEventForm(_currentUser, eid);
  }


}

