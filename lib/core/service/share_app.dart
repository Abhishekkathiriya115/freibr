import 'package:freibr/config/url.dart';
import 'package:share/share.dart';

class ShareAPP {
  static void shareProfile(String url) {
    Share.share('${url}');
  }

  static String buildProfileShareUrl(int profileID) {
    return '${UrlDto.siteUrl}profile/$profileID';
  }

  static String buildLiveConference(int ProfileId) {
    return '${UrlDto.siteUrl}room/${ProfileId}';
  }

  static String buildPostShareUrl(int profileID) {
    return '${UrlDto.siteUrl}post/$profileID';
  }
}
