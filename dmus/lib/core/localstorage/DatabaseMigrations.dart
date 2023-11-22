
import 'package:sqflite/sqflite.dart';
import '../Util.dart';



/// Handles all database migrations from older to newer versions
///
/// Does not support downgrades, only upgrades
final class DatabaseMigrations {

  DatabaseMigrations._();

  /// Maps the database version to the migration
  static final Map<int, Function> _migrations = {
    1 : _migration_1
  };



  /// Runs the migrations to upgrade from the oldVersion to the newVersion
  ///
  /// Throws Exception if no migration exists for a version
  static Future<void> runMigrations(Database db, int oldVersion, int newVersion) async {

    logging.info("About to migrate database from version $oldVersion to $newVersion");
    
    int currentVersion = oldVersion;

    while(currentVersion < newVersion) {

      currentVersion++;

      logging.info("Running migration $currentVersion");

      if(!_migrations.containsKey(currentVersion)) {

        logging.severe("Cannot migrate database, no migration exists for version $currentVersion");

        throw Exception("Cannot migrate database, no migration exists for version $currentVersion");
      }

      var migration = _migrations[currentVersion];

      await migration?.call(db);
    }
  }


  /// Migration 1, handles creating the base database for the earlier version
  static Future<void> _migration_1(Database db) async {

    const String TBL_SONG = "tbl_song";
    const String TBL_ALBUM = "tbl_album";
    const String TBL_FMETADATA = "tbl_fmetadata";
    const String TBL_PLAYLIST = "tbl_playlist";
    const String TBL_WATCH_DIRECTORY = "tbl_watch_directory";
    const String TBL_ALBUM_SONG = "tbl_album_song";
    const String TBL_PLAYLIST_SONG = "tbl_playlist_song";
    const String TBL_LIKES = "tbl_likes";
    const String TBL_HISTORY = "tbl_history";

    await db.execute("PRAGMA foreign_keys = ON");

    const String SONG_ID = "song_id";

    logging.config("Creating $TBL_LIKES");

    await db.execute('''
    CREATE TABLE $TBL_LIKES (
        $SONG_ID INTEGER PRIMARY KEY,
        liked_at DATETIME DEFAULT CURRENT_TIMESTAMP 
    ) 
    ''');

    logging.config("Creating $TBL_HISTORY");

    await db.execute('''
    CREATE TABLE $TBL_HISTORY (
        $SONG_ID INTEGER,
        played_at DATETIME DEFAULT CURRENT_TIMESTAMP 
    ) 
    ''');

    logging.config("Creating $TBL_SONG");


    await db.execute('''
    CREATE TABLE $TBL_SONG (
        id INTEGER PRIMARY KEY,
        song_path VARCHAR UNIQUE NOT NULL
    ) 
    ''');

    logging.config("Creating $TBL_FMETADATA");

    await db.execute('''
    CREATE TABLE $TBL_FMETADATA (
        $SONG_ID INTEGER PRIMARY KEY,
        title VARCHAR,
        album VARCHAR,
        album_artist VARCHAR,
        track_artist VARCHAR,
        genre VARCHAR,
        mimetype VARCHAR,
        bitrate INTEGER,
        track_number INTEGER,
        disc_number INTEGER,
        year INTEGER,
        duration_ms INTEGER,
        art_cache_key BLOB,
        FOREIGN KEY ($SONG_ID) REFERENCES $TBL_SONG(id) ON DELETE CASCADE
    ) 
    ''');

    logging.config("Creating $TBL_ALBUM");

    await db.execute('''
    CREATE TABLE $TBL_ALBUM (
        id INTEGER PRIMARY KEY,
        title VARCHAR NOT NULL
    ) 
    ''');

    logging.config("Creating $TBL_PLAYLIST");

    await db.execute('''
    CREATE TABLE $TBL_PLAYLIST (
        id INTEGER PRIMARY KEY,
        title VARCHAR NOT NULL
    ) 
    ''');

    logging.config("Creating $TBL_WATCH_DIRECTORY");

    await db.execute('''
    CREATE TABLE $TBL_WATCH_DIRECTORY (
        directory_path VARCHAR PRIMARY KEY,
        check_interval INTEGER NOT NULL,
        is_recursive BOOLEAN NOT NULL
    ) 
    ''');

    logging.config("Creating $TBL_ALBUM_SONG");

    const String ALBUM_ID = "album_id";

    await db.execute('''
    CREATE TABLE $TBL_ALBUM_SONG (
        $ALBUM_ID INTEGER NOT NULL,
        $SONG_ID INTEGER NOT NULL,
        song_index INTEGER NOT NULL,
        FOREIGN KEY ($ALBUM_ID) REFERENCES $TBL_ALBUM(id) ON DELETE CASCADE,
        FOREIGN KEY ($SONG_ID) REFERENCES $TBL_SONG(id) ON DELETE CASCADE,
        CONSTRAINT ${ALBUM_ID}_fk FOREIGN KEY ($ALBUM_ID) REFERENCES $TBL_ALBUM(id),
        CONSTRAINT ${SONG_ID}_fk FOREIGN KEY ($SONG_ID) REFERENCES $TBL_SONG(id),
        PRIMARY KEY ($ALBUM_ID, $SONG_ID, song_index)
    ) 
    ''');

    logging.config("Creating $TBL_PLAYLIST_SONG");

    const String PLAYLIST_ID = "playlist_id";

    await db.execute('''
    CREATE TABLE $TBL_PLAYLIST_SONG (
        $PLAYLIST_ID INTEGER NOT NULL,
        $SONG_ID INTEGER NOT NULL,
        song_index INTEGER NOT NULL,
        FOREIGN KEY ($PLAYLIST_ID) REFERENCES $TBL_PLAYLIST(id) ON DELETE CASCADE,
        FOREIGN KEY ($SONG_ID) REFERENCES $TBL_SONG(id) ON DELETE CASCADE,
        CONSTRAINT ${PLAYLIST_ID}_fk FOREIGN KEY ($PLAYLIST_ID) REFERENCES $TBL_PLAYLIST(id),
        CONSTRAINT ${SONG_ID}_fk FOREIGN KEY ($SONG_ID) REFERENCES $TBL_SONG(id),
        PRIMARY KEY ($PLAYLIST_ID, $SONG_ID, song_index)
    ) 
    ''');
  }

}