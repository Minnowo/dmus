
import '../../Util.dart';


enum SearchResultType {
  release,
  recording
}


abstract class SearchResult {

  String? id;
  String? title;
  int? score;

  SearchResult({this.id, this.title, this.score});

  SearchResultType get searchResultType;
}

class ReleaseSearchResult extends SearchResult{
  String? statusId;
  String? packagingId;
  int? count;
  String? status;
  String? packaging;
  ReleaseGroup? releaseGroup;
  String? date;
  String? country;
  int? trackCount;
  List<ArtistCredit>? artistCredit;
  List<Tag>? tags;

  @override
  SearchResultType get searchResultType {
    return SearchResultType.release;
  }

  ReleaseSearchResult({
    super.id,
    super.score,
    this.statusId,
    this.packagingId,
    this.count,
    super.title,
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



class RecordingSearchResponse extends SearchResult{

  int? length;
  String? firstReleaseDate;
  List<ArtistCredit>? artistCredit;
  List<ReleaseSearchResult>? releases;

  @override
  SearchResultType get searchResultType {
    return SearchResultType.recording;
  }

  RecordingSearchResponse({
    super.id,
    super.score,
    super.title,
    this.length,
    this.artistCredit,
    this.firstReleaseDate,
    this.releases
  });

  factory RecordingSearchResponse.fromJson(Map<String, dynamic> json) {
    return RecordingSearchResponse(
      id: json['id'],
      score: json['score'],
      title: json['title'],
      length: json['length'],
      firstReleaseDate: json['first-release-date'],
      releases: (json['releases'] as List?)
          ?.map((e) => ReleaseSearchResult.fromJson(e))
          .toList(),
      artistCredit: (json['artist-credit'] as List?)
          ?.map((artistCredit) => ArtistCredit.fromJson(artistCredit))
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

  @override
  String toString() {
    return title ?? "N/A";
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

  @override
  String toString() {
    return name ?? "N/A";
  }
}
