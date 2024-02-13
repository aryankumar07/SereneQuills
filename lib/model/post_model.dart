// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/foundation.dart';

class Post {
  final String id;
  final String title;
  final String? link;
  final String? description;
  final String communityName;
  final String communityProfilePic;
  final List<String> upvotes;
  final List<String> downvotes;
  final int commentCount;
  final String Username;
  final String uid;
  final String type;
  final DateTime creationTime;
  final List<String> awards;

  Post({
    required this.id, 
    required this.title, 
    required this.link, 
    required this.description,
    required this.communityName, 
    required this.communityProfilePic, 
    required this.upvotes, 
    required this.downvotes, 
    required this.commentCount, 
    required this.Username, 
    required this.uid, 
    required this.type, 
    required this.creationTime, 
    required this.awards});

  Post copyWith({
    String? id,
    String? title,
    String? link,
    String? description,
    String? communityName,
    String? communityProfilePic,
    List<String>? upvotes,
    List<String>? downvotes,
    int? commentCount,
    String? Username,
    String? uid,
    String? type,
    DateTime? creationTime,
    List<String>? awards,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      link: link ?? this.link,
      description: description ?? this.description,
      communityName: communityName ?? this.communityName,
      communityProfilePic: communityProfilePic ?? this.communityProfilePic,
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
      commentCount: commentCount ?? this.commentCount,
      Username: Username ?? this.Username,
      uid: uid ?? this.uid,
      type: type ?? this.type,
      creationTime: creationTime ?? this.creationTime,
      awards: awards ?? this.awards,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'link': link,
      'description': description,
      'communityName': communityName,
      'communityProfilePic': communityProfilePic,
      'upvotes': upvotes,
      'downvotes': downvotes,
      'commentCount': commentCount,
      'Username': Username,
      'uid': uid,
      'type': type,
      'creationTime': creationTime.millisecondsSinceEpoch,
      'awards': awards,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      link: map['link'],
      description: map['description'],
      communityName: map['communityName'] ?? '',
      communityProfilePic: map['communityProfilePic'] ?? '',
      upvotes: List<String>.from(map['upvotes']),
      downvotes: List<String>.from(map['downvotes']),
      commentCount: map['commentCount'] ?? 0,
      Username: map['Username'] as String,
      uid: map['uid'] as String,
      type: map['type'] as String,
      creationTime: DateTime.fromMillisecondsSinceEpoch(map['creationTime']),
      awards: List<String>.from(map['awards'])
      );
  }


  @override
  String toString() {
    return 'Post(id: $id, title: $title, link: $link, description: $description, communityName: $communityName, communityProfilePic: $communityProfilePic, upvotes: $upvotes, downvotes: $downvotes, commentCount: $commentCount, Username: $Username, uid: $uid, type: $type, creationTime: $creationTime, awards: $awards)';
  }

  @override
  bool operator ==(covariant Post other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.title == title &&
      other.link == link &&
      other.description == description &&
      other.communityName == communityName &&
      other.communityProfilePic == communityProfilePic &&
      listEquals(other.upvotes, upvotes) &&
      listEquals(other.downvotes, downvotes) &&
      other.commentCount == commentCount &&
      other.Username == Username &&
      other.uid == uid &&
      other.type == type &&
      other.creationTime == creationTime &&
      listEquals(other.awards, awards);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      link.hashCode ^
      description.hashCode ^
      communityName.hashCode ^
      communityProfilePic.hashCode ^
      upvotes.hashCode ^
      downvotes.hashCode ^
      commentCount.hashCode ^
      Username.hashCode ^
      uid.hashCode ^
      type.hashCode ^
      creationTime.hashCode ^
      awards.hashCode;
  }
}
