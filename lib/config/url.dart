class UrlDto {
  // static String siteUrl = "http://10.0.2.2:8000/";
  // static String apiUrl = "http://10.0.2.2:8000/api/";

  static String siteUrl = "https://freibr.com/";
  static String apiUrl = "https://freibr.com/api/";
  static String socketUrl = 'https://junction.freibr.com';
  static String conferenceUrl = 'https://meet.freibr.com';

  // static String awsMediaServerUrl =
  //     'https://freibr-media-server-production.s3.us-east-2.amazonaws.com/';
  //
  static String awsMediaServerUrl =
      'https://freibr-media-server-test.s3.us-east-2.amazonaws.com/';

  static String registerDevice = apiUrl + 'device/create';
  static String registerUser = apiUrl + 'users/create';
  static String updateProfile = apiUrl + 'profile/updateProfile';
  static String removeExpertise = apiUrl + 'profile/removeExpertise';
  static String createExpertise = apiUrl + 'profile/createExpertise';
  static String updateExpertise = apiUrl + 'profile/updateExpertise';
  static String getProfile = apiUrl + 'profile/getProfile';
  static String getOtherUserProfile = apiUrl + 'profile/getOtherUserProfile';

  static String loadCategories = apiUrl + 'categories';
  static String loadSubcategoriesWithParent = apiUrl + 'categories/';
  static String singleUploadProfileImageFile =
      apiUrl + 'singleUploadProfileImageFile';
  static String approveUser = apiUrl + 'users/approve';
  static String isExistEmail = apiUrl + 'users/isAlreadyRegisterEmail';
  static String isExistPhone = apiUrl + 'users/isAlreadyRegisterPhone';
  static String loginOrRegisterFacebook = apiUrl + 'users/login/facebook';
  static String changePassword = apiUrl + 'users/changePassword';
  static String userLogin = apiUrl + 'users/login';
  static String changeProfilePic = apiUrl + 'profile/changeProfilePic';
  static String changeRoomPic = apiUrl + 'profile/changeRoomPic';

  static String uploadPost = apiUrl + 'post/create';
  static String getTimelinePosts = apiUrl + 'post/getPaged';
  static String getTimelinePostsWithUser = apiUrl + 'post/getPagedPostsUser';
  static String setLikePost = apiUrl + 'post/setLike';
  static String setDislikePost = apiUrl + 'post/setDislike';
  static String getPostComments = apiUrl + 'post/comments';
  static String setComment = apiUrl + 'post/setComment';
  static String getTimelineUsers = apiUrl + 'timeline/users';
  static String getTimelineLiveUsers = apiUrl + 'timeline/getTimelineLiveUsers';
  static String getPagedFollowings = apiUrl + 'timeline/getPagedFollowings';
  static String getPagedFollowers = apiUrl + 'timeline/getPagedFollowers';
  static String getPagedFollowRequests =
      apiUrl + 'timeline/getPagedFollowRequests';
  static String closeLiveConference = apiUrl + 'timeline/closeLiveConference';

  static String setFollowUser = apiUrl + 'timeline/follow';
  static String followApproveReject = apiUrl + 'timeline/followApproveReject';
  static String goLive = apiUrl + 'timeline/goLive';
  static String getPagedGroupChats = apiUrl + 'timeline/getPagedGroupChats';
  static String getGroupMessages = apiUrl + 'timeline/getPagedGroupMessage';
  static String checkIsLive = apiUrl + 'timeline/checkIsLive';
  static String getPagedPersonalChatUser =
      apiUrl + 'timeline/getPagedPersonalChatUser';
  static String getPagedPersonalChat = apiUrl + 'timeline/getPagedPersonalChat';
  static String deletePersonalChatUser =
      apiUrl + 'timeline/deletePersonalChatUser';

  /* NOTIFICATION ROUTES*/
  static String sendNewRegisterOtp = apiUrl + 'notification/otp/register/new';
  static String verifyOtp = apiUrl + 'notification/otp/verify';
  static String isProfileCompleted = apiUrl + 'users/checkProfileIsRegistered';
  static String getPagedNotifications =
      apiUrl + 'notification/getPagedNotifications';

  static String noAvatarFound = siteUrl + 'uploads/no_user.png';

  /* CONFERENCE ROUTE */
  static String createRoom = apiUrl + 'room/createRoom';
  static String joinRoom = apiUrl + 'room/joinRoom';
  static String getPagedRooms = apiUrl + 'room/getPagedRooms';
  static String getPagedRoomMembers = apiUrl + 'room/getPagedRoomMembers';

  /* SEARCH ROUTE */
  static String getPagedUserProfiles = apiUrl + 'search/getPagedUserProfiles';
  static String getUserSearchLiveSessions =
      apiUrl + 'search/getPagedLiveSessions';
  static String getPagedLanguages = apiUrl + 'language/getPagedLanguages';

  /* TEST URL */
  static String uploadFileTest = apiUrl + 'test/uploadFileTest';

  /* GIG ROUTES*/
  static String getPagedGigs = apiUrl + 'gigs/getPagedGigs';
  static String saveGig = apiUrl + 'gigs/saveGig';
  static String editGig = apiUrl + 'gigs/editGig';
  static String saveGigCategories = apiUrl + 'gigs/saveGigCategories';
  static String saveGigFaq = apiUrl + 'gigs/saveGigFaq';
  static String saveGigAskedQuestion = apiUrl + 'gigs/saveGigAskedQuestion';
  static String saveGigPricing = apiUrl + 'gigs/saveGigPricing';
  static String saveGigTaxInformation = apiUrl + 'gigs/saveGigTaxInformation';
  static String saveGalleryFile = apiUrl + 'gigs/saveGalleryFile';
  static String saveMultipleGalleryFiles =
      apiUrl + 'gigs/saveMultipleGalleryFiles';
  static String removeGig = apiUrl + 'gigs/removeGig';
  static String removeGalleryFile = apiUrl + 'gigs/removeGalleryFile';
  static String removeFaq = apiUrl + 'gigs/removeFaq';
  static String removeGigAskedQuestion = apiUrl + 'gigs/removeGigAskedQuestion';
  static String removePricing = apiUrl + 'gigs/removePricing';
  static String createOffer = apiUrl + 'gigs/createOffer';
  static String removeOffer = apiUrl + 'gigs/removeOffer';
  static String removeMilestone = apiUrl + 'gigs/removeMilestone';
  static String removeCategory = apiUrl + 'gigs/removeCategory';

  /* OFFER ROUTES */
  static String savePaymentTransaction = apiUrl + 'logs/savePaymentTransaction';
  static String saveOfferLog = apiUrl + 'logs/saveOfferLog';
  static String getPagedPaymentHistory = apiUrl + 'logs/getPagedPaymentHistory';

  static String saveBankDetails = apiUrl + 'profile/add_account_details';
  static String getBankDetails = apiUrl + 'profile/get_account_details';

  /* REFRESH TOKEN */
  static String refreshToken = apiUrl + 'auth/refresh/';

  /* REFRESH TOKEN */
  static String allBlockUsers = apiUrl + 'timeline/all-block-users';
  static String blockUser = apiUrl + 'timeline/blockUser';
  static String unblockUser = apiUrl + 'timeline/unBlockUser';

  /* Post */
  static String postLike = apiUrl + 'post/setLike';
  static String postDislike = apiUrl + 'post/setDislike';
  static String postComments = apiUrl + 'post/comments';
  static String setPostComments = apiUrl + 'post/setComment';

  /* Change password */
  static String changeCurrentPassword = apiUrl + 'profile/change-password';

  static String bookmarkAdd = apiUrl + 'post/savepost';
  static String bookmarkRemove = apiUrl + 'post/deletesavepostbyusers';

  static String postList = apiUrl + 'post/postList';
  static String postDelete = apiUrl + 'post/delete';
  static String postUpdate = apiUrl + 'post/update';
  static String commentDelete = apiUrl + 'post/delete-comment';
}
