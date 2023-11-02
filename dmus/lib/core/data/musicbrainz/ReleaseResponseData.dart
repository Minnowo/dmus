
import '../../Util.dart';

class ReleaseSearchResult {
  String? id;
  int? score;
  String? statusId;
  String? packagingId;
  int? count;
  String? title;
  String? status;
  String? packaging;
  List<ArtistCredit>? artistCredit;
  ReleaseGroup? releaseGroup;
  String? date;
  String? country;
  int? trackCount;
  List<Tag>? tags;

  ReleaseSearchResult({
    this.id,
    this.score,
    this.statusId,
    this.packagingId,
    this.count,
    this.title,
    this.status,
    this.packaging,
    this.artistCredit,
    this.releaseGroup,
    this.date,
    this.country,
    this.trackCount,
    this.tags,
  });

  factory ReleaseSearchResult.fromJson(Map<String, dynamic> json) {
    return ReleaseSearchResult(
      id: json['id'],
      score: json['score'],
      statusId: json['status-id'],
      packagingId: json['packaging-id'],
      count: json['count'],
      title: json['title'],
      status: json['status'],
      packaging: json['packaging'],
      artistCredit: (json['artist-credit'] as List?)
          ?.map((artistCredit) => ArtistCredit.fromJson(artistCredit))
          .toList(),
      releaseGroup: ReleaseGroup.fromJson(json['release-group']),
      date: json['date'],
      country: json['country'],
      trackCount: json['track-count'],
      tags: (json['tags'] as List?)
          ?.map((tag) => Tag.fromJson(tag))
          .toList(),
    );
  }
}

class ArtistCredit {
  String? name;
  Artist? artist;

  ArtistCredit({
    this.name,
    this.artist,
  });

  factory ArtistCredit.fromJson(Map<String, dynamic> json) {
    return ArtistCredit(
      name: json['name'],
      artist: json['artist'] != null ? Artist.fromJson(json['artist']) : null,
    );
  }

  @override
  String toString() {

    List<String> j = [];

    if(name != null) {
      j.add(name!);
    }

    if(artist?.sortName != null) {
      j.add("(${artist.toString()})");
    }

    return j.join(" ");
  }
}

class Artist {
  String? id;
  String? name;
  String? sortName;

  Artist({
    this.id,
    this.name,
    this.sortName,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'],
      name: json['name'],
      sortName: json['sort-name'],
    );
  }

  @override
  String toString() {
    return sortName ?? name ?? "N/A";
  }
}

class ReleaseGroup {
  String? id;
  String? typeId;
  String? primaryTypeId;
  String? title;
  String? primaryType;

  ReleaseGroup({
    this.id,
    this.typeId,
    this.primaryTypeId,
    this.title,
    this.primaryType,
  });

  factory ReleaseGroup.fromJson(Map<String, dynamic> json) {
    return ReleaseGroup(
      id: json['id'],
      typeId: json['type-id'],
      primaryTypeId: json['primary-type-id'],
      title: json['title'],
      primaryType: json['primary-type'],
    );
  }
}


class Tag {
  int? count;
  String? name;

  Tag({
    this.count,
    this.name,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      count: json['count'],
      name: json['name'],
    );
  }
}
