import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @updatedPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Updated playlist'**
  String get updatedPlaylist;

  /// No description provided for @createdPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Created playlist'**
  String get createdPlaylist;

  /// No description provided for @songImported.
  ///
  /// In en, this message translates to:
  /// **'Song Imported'**
  String get songImported;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong!'**
  String get error;

  /// No description provided for @errorShort.
  ///
  /// In en, this message translates to:
  /// **'Error:'**
  String get errorShort;

  /// No description provided for @metadataInformation.
  ///
  /// In en, this message translates to:
  /// **'Metadata Information'**
  String get metadataInformation;

  /// No description provided for @editMetadata.
  ///
  /// In en, this message translates to:
  /// **'Edit Metadata'**
  String get editMetadata;

  /// No description provided for @lookupMetadata.
  ///
  /// In en, this message translates to:
  /// **'Lookup Metadata'**
  String get lookupMetadata;

  /// No description provided for @addToQueue.
  ///
  /// In en, this message translates to:
  /// **'Add to Queue'**
  String get addToQueue;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @playNow.
  ///
  /// In en, this message translates to:
  /// **'Play Now'**
  String get playNow;

  /// No description provided for @queueAll.
  ///
  /// In en, this message translates to:
  /// **'Queue All'**
  String get queueAll;

  /// No description provided for @queueAllNext.
  ///
  /// In en, this message translates to:
  /// **'Queue All Next'**
  String get queueAllNext;

  /// No description provided for @editPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Edit Playlist'**
  String get editPlaylist;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @searchEmpty.
  ///
  /// In en, this message translates to:
  /// **'Search cannot be empty!'**
  String get searchEmpty;

  /// No description provided for @searchError.
  ///
  /// In en, this message translates to:
  /// **'Error fetching search results'**
  String get searchError;

  /// No description provided for @noSearchResults.
  ///
  /// In en, this message translates to:
  /// **'There are no results for this search! :('**
  String get noSearchResults;

  /// No description provided for @releases.
  ///
  /// In en, this message translates to:
  /// **'Releases'**
  String get releases;

  /// No description provided for @recordings.
  ///
  /// In en, this message translates to:
  /// **'Recordings'**
  String get recordings;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @emptyTitleError.
  ///
  /// In en, this message translates to:
  /// **'title cannot be empty!'**
  String get emptyTitleError;

  /// No description provided for @titleMaxLengthError.
  ///
  /// In en, this message translates to:
  /// **'title should be less than'**
  String get titleMaxLengthError;

  /// No description provided for @selectedSongsIsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Use the + in the top right to add songs'**
  String get selectedSongsIsEmpty;

  /// No description provided for @increment.
  ///
  /// In en, this message translates to:
  /// **'Increment'**
  String get increment;

  /// No description provided for @confirmSelection.
  ///
  /// In en, this message translates to:
  /// **'Confirm Selection'**
  String get confirmSelection;

  /// No description provided for @addFiles.
  ///
  /// In en, this message translates to:
  /// **'Add Files'**
  String get addFiles;

  /// No description provided for @addFolder.
  ///
  /// In en, this message translates to:
  /// **'Add Folder'**
  String get addFolder;

  /// No description provided for @artist.
  ///
  /// In en, this message translates to:
  /// **'Artist'**
  String get artist;

  /// No description provided for @tag.
  ///
  /// In en, this message translates to:
  /// **'Tag'**
  String get tag;

  /// No description provided for @releaseTitle.
  ///
  /// In en, this message translates to:
  /// **'ReleaseTitle'**
  String get releaseTitle;

  /// No description provided for @searchResult.
  ///
  /// In en, this message translates to:
  /// **'Search Result'**
  String get searchResult;

  /// No description provided for @property.
  ///
  /// In en, this message translates to:
  /// **'Property'**
  String get property;

  /// No description provided for @value.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get value;

  /// No description provided for @trackName.
  ///
  /// In en, this message translates to:
  /// **'Track Name'**
  String get trackName;

  /// No description provided for @trackArtistNames.
  ///
  /// In en, this message translates to:
  /// **'Track Artist Names'**
  String get trackArtistNames;

  /// No description provided for @albumName.
  ///
  /// In en, this message translates to:
  /// **'Album Name'**
  String get albumName;

  /// No description provided for @albumArtistName.
  ///
  /// In en, this message translates to:
  /// **'Album Artist Name'**
  String get albumArtistName;

  /// No description provided for @trackDuration.
  ///
  /// In en, this message translates to:
  /// **'Track Duration'**
  String get trackDuration;

  /// No description provided for @bitrate.
  ///
  /// In en, this message translates to:
  /// **'Bitrate (bits/sec)'**
  String get bitrate;

  /// No description provided for @mimeType.
  ///
  /// In en, this message translates to:
  /// **'Mime Type'**
  String get mimeType;

  /// No description provided for @filePath.
  ///
  /// In en, this message translates to:
  /// **'File Path'**
  String get filePath;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @genre.
  ///
  /// In en, this message translates to:
  /// **'Genre'**
  String get genre;

  /// No description provided for @trackNumber.
  ///
  /// In en, this message translates to:
  /// **'Track Number'**
  String get trackNumber;

  /// No description provided for @diskNumber.
  ///
  /// In en, this message translates to:
  /// **'Disk Number'**
  String get diskNumber;

  /// No description provided for @authorName.
  ///
  /// In en, this message translates to:
  /// **'Author Name'**
  String get authorName;

  /// No description provided for @writerName.
  ///
  /// In en, this message translates to:
  /// **'Writer Name'**
  String get writerName;

  /// No description provided for @use.
  ///
  /// In en, this message translates to:
  /// **'Use'**
  String get use;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @filterSongs.
  ///
  /// In en, this message translates to:
  /// **'Filter songs...'**
  String get filterSongs;

  /// No description provided for @pickSongs.
  ///
  /// In en, this message translates to:
  /// **'Pick Songs'**
  String get pickSongs;

  /// No description provided for @filterPlaylists.
  ///
  /// In en, this message translates to:
  /// **'Filter playlists...'**
  String get filterPlaylists;

  /// No description provided for @pickPlaylists.
  ///
  /// In en, this message translates to:
  /// **'Pick Playlists'**
  String get pickPlaylists;

  /// No description provided for @savePlaylist.
  ///
  /// In en, this message translates to:
  /// **'Save the Playlist'**
  String get savePlaylist;

  /// No description provided for @uploadSongs.
  ///
  /// In en, this message translates to:
  /// **'Upload Songs'**
  String get uploadSongs;

  /// No description provided for @playbackSpeed.
  ///
  /// In en, this message translates to:
  /// **'Playback Speed'**
  String get playbackSpeed;

  /// No description provided for @metadataRefreshConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to do a full metadata refresh?'**
  String get metadataRefreshConfirm;

  /// No description provided for @refreshMetadata.
  ///
  /// In en, this message translates to:
  /// **'Refresh Metadata'**
  String get refreshMetadata;

  /// No description provided for @pathAlreadyExists1.
  ///
  /// In en, this message translates to:
  /// **'The path'**
  String get pathAlreadyExists1;

  /// No description provided for @pathAlreadyExists2.
  ///
  /// In en, this message translates to:
  /// **'already exists'**
  String get pathAlreadyExists2;

  /// No description provided for @exportedDatabase.
  ///
  /// In en, this message translates to:
  /// **'Exported Database to'**
  String get exportedDatabase;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @minPasswordLen.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters long.'**
  String get minPasswordLen;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailEmpty.
  ///
  /// In en, this message translates to:
  /// **'Email cannot be empty'**
  String get emailEmpty;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordEmpty.
  ///
  /// In en, this message translates to:
  /// **'Password cannot be empty'**
  String get passwordEmpty;

  /// No description provided for @noAlbums.
  ///
  /// In en, this message translates to:
  /// **'Nothing is here!\nHit the + in the top right to create an album.'**
  String get noAlbums;

  /// No description provided for @allSongsDownloaded.
  ///
  /// In en, this message translates to:
  /// **'All songs downloaded'**
  String get allSongsDownloaded;

  /// No description provided for @noSongs.
  ///
  /// In en, this message translates to:
  /// **'Nothing is here!\nHit the + in the top right to import music.'**
  String get noSongs;

  /// No description provided for @blacklistPageHelperText.
  ///
  /// In en, this message translates to:
  /// **'Files which are blocked from being imported will show up here.\nYou can add or delete them using the buttons in the top.'**
  String get blacklistPageHelperText;

  /// No description provided for @blacklistPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Blacklisted Files'**
  String get blacklistPageTitle;

  /// No description provided for @cannotPlaySongFile1.
  ///
  /// In en, this message translates to:
  /// **'Cannot play'**
  String get cannotPlaySongFile1;

  /// No description provided for @cannotPlaySongFile2.
  ///
  /// In en, this message translates to:
  /// **'because it does not exist!'**
  String get cannotPlaySongFile2;

  /// No description provided for @cannotPlayAudio.
  ///
  /// In en, this message translates to:
  /// **'Cannot play audio!'**
  String get cannotPlayAudio;

  /// No description provided for @externalFolderNull.
  ///
  /// In en, this message translates to:
  /// **'External storage folder is null!'**
  String get externalFolderNull;

  /// No description provided for @cannotCreateDownloadsFolder.
  ///
  /// In en, this message translates to:
  /// **'Cannot create downloads folder'**
  String get cannotCreateDownloadsFolder;

  /// No description provided for @downloadingSongs.
  ///
  /// In en, this message translates to:
  /// **'Downloading songs...'**
  String get downloadingSongs;

  /// No description provided for @couldNotWriteSongs.
  ///
  /// In en, this message translates to:
  /// **'Could not write to songs json metadata'**
  String get couldNotWriteSongs;

  /// No description provided for @noSongsToUpload.
  ///
  /// In en, this message translates to:
  /// **'There are no songs to upload!'**
  String get noSongsToUpload;

  /// No description provided for @uploadingSongs.
  ///
  /// In en, this message translates to:
  /// **'Uploading songs...'**
  String get uploadingSongs;

  /// No description provided for @songsUploaded.
  ///
  /// In en, this message translates to:
  /// **'All songs uploaded!'**
  String get songsUploaded;

  /// No description provided for @uploadingPlaylists.
  ///
  /// In en, this message translates to:
  /// **'Uploading playlists!'**
  String get uploadingPlaylists;

  /// No description provided for @playlistsUploaded.
  ///
  /// In en, this message translates to:
  /// **'All playlists uploaded!'**
  String get playlistsUploaded;

  /// No description provided for @noTemporaryDirectory.
  ///
  /// In en, this message translates to:
  /// **'Could not get a temporary directory!'**
  String get noTemporaryDirectory;

  /// No description provided for @checkingDirectories1.
  ///
  /// In en, this message translates to:
  /// **'Checking'**
  String get checkingDirectories1;

  /// No description provided for @checkingDirectories2.
  ///
  /// In en, this message translates to:
  /// **'watch directories...'**
  String get checkingDirectories2;

  /// No description provided for @songPathDoesNotExist1.
  ///
  /// In en, this message translates to:
  /// **'Song'**
  String get songPathDoesNotExist1;

  /// No description provided for @songPathDoesNotExist2.
  ///
  /// In en, this message translates to:
  /// **'does not exist, it will be removed from the app.'**
  String get songPathDoesNotExist2;

  /// No description provided for @cannotImportSongDoesNotExist.
  ///
  /// In en, this message translates to:
  /// **'Cannot import song because the file does not exist'**
  String get cannotImportSongDoesNotExist;

  /// No description provided for @dbError.
  ///
  /// In en, this message translates to:
  /// **'Cannot import song event though it was just imported!'**
  String get dbError;

  /// No description provided for @importingSongs1.
  ///
  /// In en, this message translates to:
  /// **'Importing'**
  String get importingSongs1;

  /// No description provided for @importingSongs2.
  ///
  /// In en, this message translates to:
  /// **'songs...'**
  String get importingSongs2;

  /// No description provided for @noFilesInFolder.
  ///
  /// In en, this message translates to:
  /// **'No files found in this folder!'**
  String get noFilesInFolder;

  /// No description provided for @noPermissionInDirectory.
  ///
  /// In en, this message translates to:
  /// **'No permission to list files in this directory!'**
  String get noPermissionInDirectory;

  /// No description provided for @emptyName.
  ///
  /// In en, this message translates to:
  /// **'Cannot create playlist with an empty name!'**
  String get emptyName;

  /// No description provided for @cannotEditPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Cannot edit playlist with an empty name or which does not exist!'**
  String get cannotEditPlaylist;

  /// No description provided for @deletePlaylist.
  ///
  /// In en, this message translates to:
  /// **'Delete Playlist'**
  String get deletePlaylist;

  /// No description provided for @confirmPlaylistDelete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this playlist?'**
  String get confirmPlaylistDelete;

  /// No description provided for @playlistRemoved1.
  ///
  /// In en, this message translates to:
  /// **'Playlist'**
  String get playlistRemoved1;

  /// No description provided for @playlistRemoved2.
  ///
  /// In en, this message translates to:
  /// **'has been removed from the app'**
  String get playlistRemoved2;

  /// No description provided for @shareFile.
  ///
  /// In en, this message translates to:
  /// **'Share File'**
  String get shareFile;

  /// No description provided for @shareTitle.
  ///
  /// In en, this message translates to:
  /// **'Share Title'**
  String get shareTitle;

  /// No description provided for @shareTitlePlus.
  ///
  /// In en, this message translates to:
  /// **'Share Title + More'**
  String get shareTitlePlus;

  /// No description provided for @sharePicture.
  ///
  /// In en, this message translates to:
  /// **'Share Picture'**
  String get sharePicture;

  /// No description provided for @shareAllSongs.
  ///
  /// In en, this message translates to:
  /// **'Share All Song Titles'**
  String get shareAllSongs;

  /// No description provided for @shareAllMore.
  ///
  /// In en, this message translates to:
  /// **'Share All Song Titles + More'**
  String get shareAllMore;

  /// No description provided for @removeQueue.
  ///
  /// In en, this message translates to:
  /// **'Remove From Queue'**
  String get removeQueue;

  /// No description provided for @removeSong.
  ///
  /// In en, this message translates to:
  /// **'Remove Song'**
  String get removeSong;

  /// No description provided for @removeAndBlock.
  ///
  /// In en, this message translates to:
  /// **'Remove and block from reimport'**
  String get removeAndBlock;

  /// No description provided for @titleAddedToQueue.
  ///
  /// In en, this message translates to:
  /// **'has been added to the queue'**
  String get titleAddedToQueue;

  /// No description provided for @songAddedToQueue.
  ///
  /// In en, this message translates to:
  /// **'added to the queue'**
  String get songAddedToQueue;

  /// No description provided for @confirmBlockSong.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to block this song from the app? It will be skipped when importing again. You can allow it again from the blacklist under settings.'**
  String get confirmBlockSong;

  /// No description provided for @block.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get block;

  /// No description provided for @keep.
  ///
  /// In en, this message translates to:
  /// **'Keep'**
  String get keep;

  /// No description provided for @confirmRemoveSong.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this song from the app?'**
  String get confirmRemoveSong;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @songRemoved1.
  ///
  /// In en, this message translates to:
  /// **'Song'**
  String get songRemoved1;

  /// No description provided for @songRemoved2.
  ///
  /// In en, this message translates to:
  /// **'has been removed from the app'**
  String get songRemoved2;

  /// No description provided for @metadataLookup.
  ///
  /// In en, this message translates to:
  /// **'Metadata Lookup'**
  String get metadataLookup;

  /// No description provided for @nA.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get nA;

  /// No description provided for @playlistTitle.
  ///
  /// In en, this message translates to:
  /// **'Playlist Title'**
  String get playlistTitle;

  /// No description provided for @createPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Create Playlist'**
  String get createPlaylist;

  /// No description provided for @gotSongs.
  ///
  /// In en, this message translates to:
  /// **'Got songs from picker:'**
  String get gotSongs;

  /// No description provided for @noStorage.
  ///
  /// In en, this message translates to:
  /// **'Cannot find any storage!'**
  String get noStorage;

  /// No description provided for @pickFiles.
  ///
  /// In en, this message translates to:
  /// **'Pick Files'**
  String get pickFiles;

  /// No description provided for @filterFilename.
  ///
  /// In en, this message translates to:
  /// **'Filter Filename'**
  String get filterFilename;

  /// No description provided for @cannotAccessDirectory1.
  ///
  /// In en, this message translates to:
  /// **'Cannot access'**
  String get cannotAccessDirectory1;

  /// No description provided for @cannotAccessDirectory2.
  ///
  /// In en, this message translates to:
  /// **'!! No permissions.'**
  String get cannotAccessDirectory2;

  /// No description provided for @releaseGroup.
  ///
  /// In en, this message translates to:
  /// **'Release Group'**
  String get releaseGroup;

  /// No description provided for @releaseDate.
  ///
  /// In en, this message translates to:
  /// **'Release Date'**
  String get releaseDate;

  /// No description provided for @trackCount.
  ///
  /// In en, this message translates to:
  /// **'Track Count'**
  String get trackCount;

  /// No description provided for @releaseCountry.
  ///
  /// In en, this message translates to:
  /// **'Release Country'**
  String get releaseCountry;

  /// No description provided for @releaseStatus.
  ///
  /// In en, this message translates to:
  /// **'Release Status'**
  String get releaseStatus;

  /// No description provided for @iD.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get iD;

  /// No description provided for @statusID.
  ///
  /// In en, this message translates to:
  /// **'Status ID'**
  String get statusID;

  /// No description provided for @packagingID.
  ///
  /// In en, this message translates to:
  /// **'Packaging ID'**
  String get packagingID;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @firstReleaseDate.
  ///
  /// In en, this message translates to:
  /// **'First Release Date'**
  String get firstReleaseDate;

  /// No description provided for @length.
  ///
  /// In en, this message translates to:
  /// **'Length'**
  String get length;

  /// No description provided for @filterName.
  ///
  /// In en, this message translates to:
  /// **'Filter Name...'**
  String get filterName;

  /// No description provided for @enterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get enterValidEmail;

  /// No description provided for @passwordLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters long.'**
  String get passwordLength;

  /// No description provided for @registrationSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Registration successful'**
  String get registrationSuccessful;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed. Error:'**
  String get registrationFailed;

  /// No description provided for @registration.
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get registration;

  /// No description provided for @signedIn.
  ///
  /// In en, this message translates to:
  /// **'Signed in:'**
  String get signedIn;

  /// No description provided for @advancedSettings.
  ///
  /// In en, this message translates to:
  /// **'Advanced Settings'**
  String get advancedSettings;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @songsPageLITrail.
  ///
  /// In en, this message translates to:
  /// **'Songs Page List Item Trails With'**
  String get songsPageLITrail;

  /// No description provided for @trailMenu.
  ///
  /// In en, this message translates to:
  /// **'Trail With Menu'**
  String get trailMenu;

  /// No description provided for @trailDuration.
  ///
  /// In en, this message translates to:
  /// **'Trail With Duration'**
  String get trailDuration;

  /// No description provided for @random.
  ///
  /// In en, this message translates to:
  /// **'Random'**
  String get random;

  /// No description provided for @playBarSwipeMode.
  ///
  /// In en, this message translates to:
  /// **'Currently Playing Bar Swipe Mode'**
  String get playBarSwipeMode;

  /// No description provided for @swipeStop.
  ///
  /// In en, this message translates to:
  /// **'Swipe to Stop'**
  String get swipeStop;

  /// No description provided for @swipeNext.
  ///
  /// In en, this message translates to:
  /// **'Swipe for Next / Previous'**
  String get swipeNext;

  /// No description provided for @queueMode.
  ///
  /// In en, this message translates to:
  /// **'Queue Fill Mode'**
  String get queueMode;

  /// No description provided for @playlistQueueMode.
  ///
  /// In en, this message translates to:
  /// **'Playlist Queue Fill Mode'**
  String get playlistQueueMode;

  /// No description provided for @fillRandom.
  ///
  /// In en, this message translates to:
  /// **'Fill With Random'**
  String get fillRandom;

  /// No description provided for @fillRandomArtistPriority.
  ///
  /// In en, this message translates to:
  /// **'Fill With Random Priority Same Artist'**
  String get fillRandomArtistPriority;

  /// No description provided for @neverFillQueue.
  ///
  /// In en, this message translates to:
  /// **'Never Fill Queue'**
  String get neverFillQueue;

  /// No description provided for @queueAlgorithm.
  ///
  /// In en, this message translates to:
  /// **'Queue Algorithm'**
  String get queueAlgorithm;

  /// No description provided for @queueAlgorithmRandom.
  ///
  /// In en, this message translates to:
  /// **'Random'**
  String get queueAlgorithmRandom;

  /// No description provided for @developer.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get developer;

  /// No description provided for @backupDatabase.
  ///
  /// In en, this message translates to:
  /// **'Backup Database'**
  String get backupDatabase;

  /// No description provided for @showSnackBar.
  ///
  /// In en, this message translates to:
  /// **'Show SnackBar'**
  String get showSnackBar;

  /// No description provided for @snackBarTest.
  ///
  /// In en, this message translates to:
  /// **'This is a snackbar'**
  String get snackBarTest;

  /// No description provided for @showErrorSnackBar.
  ///
  /// In en, this message translates to:
  /// **'Show Error SnackBar'**
  String get showErrorSnackBar;

  /// No description provided for @errorSnackBarTest.
  ///
  /// In en, this message translates to:
  /// **'This is an error'**
  String get errorSnackBarTest;

  /// No description provided for @incorrectPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password. Please try again.'**
  String get incorrectPassword;

  /// No description provided for @emailNotFound.
  ///
  /// In en, this message translates to:
  /// **'Email not found. Please check your email address.'**
  String get emailNotFound;

  /// No description provided for @signInError.
  ///
  /// In en, this message translates to:
  /// **'Sign-In Error:'**
  String get signInError;

  /// No description provided for @wrongPassword.
  ///
  /// In en, this message translates to:
  /// **'wrong-password'**
  String get wrongPassword;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'user-not-found'**
  String get userNotFound;

  /// No description provided for @albums.
  ///
  /// In en, this message translates to:
  /// **'Albums'**
  String get albums;

  /// No description provided for @artists.
  ///
  /// In en, this message translates to:
  /// **'Artists'**
  String get artists;

  /// No description provided for @albumsAppear.
  ///
  /// In en, this message translates to:
  /// **'Albums will appear as you import music!'**
  String get albumsAppear;

  /// No description provided for @artistsAppear.
  ///
  /// In en, this message translates to:
  /// **'Artists will appear as you import music!'**
  String get artistsAppear;

  /// No description provided for @blockingSongs.
  ///
  /// In en, this message translates to:
  /// **'Batch blocking songs...'**
  String get blockingSongs;

  /// No description provided for @blockingSongsFinished.
  ///
  /// In en, this message translates to:
  /// **'Batch blocking songs finished'**
  String get blockingSongsFinished;

  /// No description provided for @confirmRemoveFromBlacklist.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove these files from the blacklist?'**
  String get confirmRemoveFromBlacklist;

  /// No description provided for @removeThem.
  ///
  /// In en, this message translates to:
  /// **'Remove them'**
  String get removeThem;

  /// No description provided for @currentlyPlaying.
  ///
  /// In en, this message translates to:
  /// **'Currently Playing'**
  String get currentlyPlaying;

  /// No description provided for @addToPlaylist.
  ///
  /// In en, this message translates to:
  /// **'ADD TO PLAYLIST'**
  String get addToPlaylist;

  /// No description provided for @noImagePath.
  ///
  /// In en, this message translates to:
  /// **'No image path found.'**
  String get noImagePath;

  /// No description provided for @songs.
  ///
  /// In en, this message translates to:
  /// **'Songs'**
  String get songs;

  /// No description provided for @basicInfoTextWithSep.
  ///
  /// In en, this message translates to:
  /// **'songs'**
  String get basicInfoTextWithSep;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @queueEmpty.
  ///
  /// In en, this message translates to:
  /// **'The queue is empty!'**
  String get queueEmpty;

  /// No description provided for @watchDirectories.
  ///
  /// In en, this message translates to:
  /// **'Watch Directories'**
  String get watchDirectories;

  /// No description provided for @watchDirectoriesEmpty.
  ///
  /// In en, this message translates to:
  /// **'Watch directories will be checked when the app starts and automatically import music.'**
  String get watchDirectoriesEmpty;

  /// No description provided for @youtubeDownload.
  ///
  /// In en, this message translates to:
  /// **'YouTube Download'**
  String get youtubeDownload;

  /// No description provided for @youtubeURL.
  ///
  /// In en, this message translates to:
  /// **'YouTube URL'**
  String get youtubeURL;

  /// No description provided for @couldNotLoadImage404.
  ///
  /// In en, this message translates to:
  /// **'Could not load image 404'**
  String get couldNotLoadImage404;

  /// No description provided for @author.
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get author;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @dl.
  ///
  /// In en, this message translates to:
  /// **'DL'**
  String get dl;

  /// No description provided for @codec.
  ///
  /// In en, this message translates to:
  /// **'Codec'**
  String get codec;

  /// No description provided for @size.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get size;

  /// No description provided for @bitrateShort.
  ///
  /// In en, this message translates to:
  /// **'Bitrate'**
  String get bitrateShort;

  /// No description provided for @downloadError.
  ///
  /// In en, this message translates to:
  /// **'Error while downloading stream:'**
  String get downloadError;

  /// No description provided for @encodingError.
  ///
  /// In en, this message translates to:
  /// **'There was an error encoding the stream!'**
  String get encodingError;

  /// No description provided for @noThumbnail.
  ///
  /// In en, this message translates to:
  /// **'Could not find thumbnail for stream'**
  String get noThumbnail;

  /// No description provided for @errorFetchingVideo.
  ///
  /// In en, this message translates to:
  /// **'Error while fetching video!'**
  String get errorFetchingVideo;

  /// No description provided for @fetchingVideoInformation.
  ///
  /// In en, this message translates to:
  /// **'Fetching Video Information...'**
  String get fetchingVideoInformation;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @convertingAudio.
  ///
  /// In en, this message translates to:
  /// **'Converting Audio...'**
  String get convertingAudio;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @addMusic.
  ///
  /// In en, this message translates to:
  /// **'Add Music'**
  String get addMusic;

  /// No description provided for @blacklistSetting.
  ///
  /// In en, this message translates to:
  /// **'Blacklist Page Title'**
  String get blacklistSetting;

  /// No description provided for @syncWithFirebase.
  ///
  /// In en, this message translates to:
  /// **'Sync With Firebase'**
  String get syncWithFirebase;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @uploadToCloud.
  ///
  /// In en, this message translates to:
  /// **'Upload to Cloud Storage'**
  String get uploadToCloud;

  /// No description provided for @downloadFromCloud.
  ///
  /// In en, this message translates to:
  /// **'Download from Cloud'**
  String get downloadFromCloud;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @userLoggedOut.
  ///
  /// In en, this message translates to:
  /// **'User logged out successfully'**
  String get userLoggedOut;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @playlist.
  ///
  /// In en, this message translates to:
  /// **'Playlist'**
  String get playlist;

  /// No description provided for @playlists.
  ///
  /// In en, this message translates to:
  /// **'Playlists'**
  String get playlists;

  /// No description provided for @playlistEmpty.
  ///
  /// In en, this message translates to:
  /// **'Playlist is empty'**
  String get playlistEmpty;

  /// No description provided for @sortByID.
  ///
  /// In en, this message translates to:
  /// **'Sort by ID'**
  String get sortByID;

  /// No description provided for @sortByIDReverse.
  ///
  /// In en, this message translates to:
  /// **'Sort by ID Reverse'**
  String get sortByIDReverse;

  /// No description provided for @sortByTitle.
  ///
  /// In en, this message translates to:
  /// **'Sort by Title'**
  String get sortByTitle;

  /// No description provided for @sortByDuration.
  ///
  /// In en, this message translates to:
  /// **'Sort by Duration'**
  String get sortByDuration;

  /// No description provided for @sortByNumberOfTracks.
  ///
  /// In en, this message translates to:
  /// **'Sort by Number of Tracks'**
  String get sortByNumberOfTracks;

  /// No description provided for @sortByRandom.
  ///
  /// In en, this message translates to:
  /// **'Sort by Random'**
  String get sortByRandom;

  /// No description provided for @sortByArtist.
  ///
  /// In en, this message translates to:
  /// **'Sort by Artist'**
  String get sortByArtist;

  /// No description provided for @sortByAlbum.
  ///
  /// In en, this message translates to:
  /// **'Sort by Album'**
  String get sortByAlbum;

  /// No description provided for @noPlaylists.
  ///
  /// In en, this message translates to:
  /// **'No playlists'**
  String get noPlaylists;

  /// No description provided for @clickToCreate.
  ///
  /// In en, this message translates to:
  /// **'Click to create'**
  String get clickToCreate;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
