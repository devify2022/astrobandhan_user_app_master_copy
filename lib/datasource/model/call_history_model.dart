class CallHistoryModel {
  CallHistoryModel({
    this.id,
    this.userId,
    this.astrologerId,
    this.duration,
    this.startedAt,
    this.channelName,
    this.resourceId,
    this.sid,
    this.recordingUID,
    this.recordingToken,
    this.recordingData,
    this.totalAmount,
    this.recordingStarted,
    this.callType,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.intervalId,
    this.endedAt,
  });

  CallHistoryModel.fromJson(dynamic json) {
    id = json['_id'];
    userId = json['userId'] != null ? UserId.fromJson(json['userId']) : null;
    astrologerId = json['astrologerId'] != null ? AstrologerId.fromJson(json['astrologerId']) : null;
    duration = json['duration'];
    startedAt = json['startedAt'];
    channelName = json['channelName'];
    resourceId = json['resourceId'];
    sid = json['sid'];
    recordingUID = json['recordingUID'];
    recordingToken = json['recordingToken'];
    recordingData = json['recordingData'] != null ? RecordingData.fromJson(json['recordingData']) : null;
    totalAmount = json['totalAmount'];
    recordingStarted = json['recordingStarted'];
    callType = json['callType'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
    intervalId = json['intervalId'];
    endedAt = json['endedAt'];
  }

  String? id;
  UserId? userId;
  AstrologerId? astrologerId;
  num? duration;
  String? startedAt;
  String? channelName;
  String? resourceId;
  String? sid;
  String? recordingUID;
  String? recordingToken;
  RecordingData? recordingData;
  num? totalAmount;
  bool? recordingStarted;
  String? callType;
  String? createdAt;
  String? updatedAt;
  num? v;
  num? intervalId;
  String? endedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    if (userId != null) {
      map['userId'] = userId?.toJson();
    }
    if (astrologerId != null) {
      map['astrologerId'] = astrologerId?.toJson();
    }
    map['duration'] = duration;
    map['startedAt'] = startedAt;
    map['channelName'] = channelName;
    map['resourceId'] = resourceId;
    map['sid'] = sid;
    map['recordingUID'] = recordingUID;
    map['recordingToken'] = recordingToken;
    if (recordingData != null) {
      map['recordingData'] = recordingData?.toJson();
    }
    map['totalAmount'] = totalAmount;
    map['recordingStarted'] = recordingStarted;
    map['callType'] = callType;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = v;
    map['intervalId'] = intervalId;
    map['endedAt'] = endedAt;
    return map;
  }
}

class RecordingData {
  RecordingData({
    this.cname,
    this.uid,
    this.resourceId,
    this.sid,
    this.serverResponse,
  });

  RecordingData.fromJson(dynamic json) {
    cname = json['cname'];
    uid = json['uid'];
    resourceId = json['resourceId'];
    sid = json['sid'];
    serverResponse = json['serverResponse'] != null ? ServerResponse.fromJson(json['serverResponse']) : null;
  }

  String? cname;
  String? uid;
  String? resourceId;
  String? sid;
  ServerResponse? serverResponse;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['cname'] = cname;
    map['uid'] = uid;
    map['resourceId'] = resourceId;
    map['sid'] = sid;
    if (serverResponse != null) {
      map['serverResponse'] = serverResponse?.toJson();
    }
    return map;
  }
}

class ServerResponse {
  ServerResponse({
    this.fileList,
    this.fileListMode,
    this.uploadingStatus,
  });

  ServerResponse.fromJson(dynamic json) {
    if (json['fileList'] != null) {
      fileList = [];
      json['fileList'].forEach((v) {
        fileList?.add(FileList.fromJson(v));
      });
    }
    fileListMode = json['fileListMode'];
    uploadingStatus = json['uploadingStatus'];
  }

  List<FileList>? fileList;
  String? fileListMode;
  String? uploadingStatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (fileList != null) {
      map['fileList'] = fileList?.map((v) => v.toJson()).toList();
    }
    map['fileListMode'] = fileListMode;
    map['uploadingStatus'] = uploadingStatus;
    return map;
  }
}

class FileList {
  FileList({
    this.fileName,
    this.isPlayable,
    this.mixedAllUser,
    this.sliceStartTime,
    this.trackType,
    this.uid,
  });

  FileList.fromJson(dynamic json) {
    fileName = json['fileName'];
    isPlayable = json['isPlayable'];
    mixedAllUser = json['mixedAllUser'];
    sliceStartTime = json['sliceStartTime'];
    trackType = json['trackType'];
    uid = json['uid'];
  }

  String? fileName;
  bool? isPlayable;
  bool? mixedAllUser;
  num? sliceStartTime;
  String? trackType;
  String? uid;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['fileName'] = fileName;
    map['isPlayable'] = isPlayable;
    map['mixedAllUser'] = mixedAllUser;
    map['sliceStartTime'] = sliceStartTime;
    map['trackType'] = trackType;
    map['uid'] = uid;
    return map;
  }
}

class AstrologerId {
  AstrologerId({
    this.id,
    this.name,
    this.pricePerCallMinute,
    this.avatar,
  });

  AstrologerId.fromJson(dynamic json) {
    id = json['_id'];
    name = json['name'];
    pricePerCallMinute = json['pricePerCallMinute'];
    avatar = json['avatar'];
  }

  String? id;
  String? name;
  num? pricePerCallMinute;
  String? avatar;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['name'] = name;
    map['pricePerCallMinute'] = pricePerCallMinute;
    map['avatar'] = avatar;
    return map;
  }
}

class UserId {
  UserId({
    this.id,
    this.name,
    this.photo,
  });

  UserId.fromJson(dynamic json) {
    id = json['_id'];
    name = json['name'];
    photo = json['photo'];
  }

  String? id;
  String? name;
  String? photo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['name'] = name;
    map['photo'] = photo;
    return map;
  }
}
