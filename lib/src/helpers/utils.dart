import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class Utils {
  static StreamTransformer transformer<T>(
          T Function(Map<String, dynamic> json) fromJson) =>
      StreamTransformer<QuerySnapshot, List<T>>.fromHandlers(
        handleData: (QuerySnapshot data, EventSink<List<T>> sink) {
          final snaps = data.docs.map((doc) => doc.data()).toList();
          final users = snaps.map((json) => fromJson(json)).toList();

          sink.add(users);
        },
      );

  static DateTime toDateTime(Timestamp value) {
    if (value == null) return null;

    return value.toDate();
  }

  static dynamic fromDateTimeToJson(DateTime date) {
    if (date == null) return null;

    return date.toUtc();
  }
}

const aboutUs =
    "Jade is an Artificial Intelligent system that offers rich support to users.\n Jade offers online assistance through a rich one on one interaction with users and it provides FIRST AID or Immediate relief to users having considered their symptoms. When cases are critical, the system refers users to an online Doctor who will have a conversation with the users beyond the help that the robot can offer";
const howItWorks =
    "Jade is a health Chatbot that coaches people through tough times to build resilience, by having text message conversations in the same way as a Therapist would\n Start a conversation with JADE by sending a message in response to the initial message displayed \n Much like a therapist, JADE gives a brief introduction and then works to understand your needs by simply asking HOW ARE YOU. JADE observes with care in order to deliver coping strategies and which adapt to the emotions and concerns of your condition";
const services =
    'JADE answers medical and health questions for users and Doctors instantly. The answers are provided by an intelligent robot that learns about medicine everyday as it interacts with the users. It also learn from your health record and medical history. \n The idea behind cognitive computing or artificial intelligence, is that our computer learns by doing, getting at its task better over time by crunching more medical information. That iterative process of ingesting more information is what makes JADE powerful in the medical field';

const support =
    "JADE is available 24/7 and accessible by any cell phone, from any location in the world";
