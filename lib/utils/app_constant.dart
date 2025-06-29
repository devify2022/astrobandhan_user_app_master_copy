//constant key

import 'package:astrobandhan/datasource/model/others/language_model.dart';
import 'package:astrobandhan/helper/helper.dart';

class AppConstant {
  // API BASE URL

  static const String baseUrl = "http://192.168.31.157:8000/";

//   static const String baseUrl = "https://www.devifai.in/";

  static String boxFilterURI = '${baseUrl}poi/filter/mobile/geo';

  static String boxFilterLocationURI(String id) => '${baseUrl}box/$id/location';

  static String getAstrologerURI(int page, int size) =>
      'astrobandhan/v1/user/getAstrologer?page=$page&size=$size';

  static String getAstrologerByCategoryURI() =>
      'astrobandhan/v1/user/getAstrologer/by/category';
  static String getAstrologerAIURI =
      'astrobandhan/v1/user/get/all/ai/astrologers';

//created by me(Subho)

  static String getAstrologerById(String id) =>
      'astrobandhan/v1/astrologer/profile/$id'; //

  static String getUserDetails = 'astrobandhan/v1/user/get/userDetails';
  static String addReview = 'astrobandhan/v1/user/addreview';
  static String sendGift = 'astrobandhan/v1/user/send/gift';
  static String topAstrologers = 'astrobandhan/v1/user/get/top/astrologers';
  static String categoriesForAstrologer =
      'astrobandhan/v1/admin/get/astrologer/category';
  static String chatRooms = '${baseUrl}astrobandhan/v1/user/get/chatroom';

  //-------------------------------

//------------------------------for call
  static const String agoraTokenEndpoint =
      '${baseUrl}astrobandhan/v1/user/agora-token';
  static const String agoraAppId = '69779ffdb88442ecb348ae75b0b3963d';

//------------------------------

  // for Balance
  static String getBalanceHistoryURI =
      'astrobandhan/v1/user/get/balance/history';
  static String getCallHistoryURI = 'astrobandhan/v1/user/get/call/history';
  static String getChatHistoryURI =
      'astrobandhan/v1/user/get/chat/history/${loginUserModel.id}';

  static String getCurrentChatHistoryURI =
      '${baseUrl}astrobandhan/v1/user/get/chatHistory';
  static String addBalanceURI = 'astrobandhan/v1/user/add/balance';

  static const String astromallCategory = "astrobandhan/v1/productCategory";
  static const String getAllAstromallProduct =
      "astrobandhan/v1/product/filter/null/true";
  static const String astromallProductOrder =
      "astrobandhan/v1/order/createOrder";

  static const String homeActiveURI = 'home/GEO';
  static const String login = "astrobandhan/v1/user/login";
  static const String loginWithOtp = "astrobandhan/v1/user/send/otp";
  static const String otpValidation = "astrobandhan/v1/user/validate/loginotp";
  static const String updatePassword = "astrobandhan/v1/user/update/password";
  static const String verifyOTPURI = "auth/signup/verify-otp";
  static const String resendOTPURI = "auth/signup/resend-otp";
  static const String loginBySocial = "auth/social-login";

  static const String guestLogin = "auth/guest-login";
  static const String deleteAccount = "user/deactivate";
  static const String signup = "auth/signup/user";
  static const String geoLocationListCustomURI = "geo-location/filter";

  // test commit
  static String geoLocationListCustomByIDURI(int id) =>
      "geo-location/custom/$id";
  static const String forgotPasswordURI = "auth/forget-password";
  static const String forgotPasswordWhatsappURI = "auth/forget-password/otp";
  static const String resetPasswordWhatsappURI = "auth/reset-password/otp";
  static const String resetPasswordByEmailURI = "auth/reset-password";
  static const String refreshTokenURI = "auth/refresh-token";
  static const String changePassword = "user/change-password";
  static const String changeProfile = "user/account";
  static const String changeUserName = "user/name";
  static const String realEstateURI = "real-estate/listings";
  static const String realEstateId = "real-estate/";
  static const String realEstateSlug = "real-estate/slug/";
  static const String postPoiFilterMap = "poi/filter/mobile/geo";
  static const String beachFilterMap = "beach/filter-map";
  static const String reportsURI = "reports";
  static const String breviewsURI = "breviews";
  static const String beachWishListURI = "beachWishList";
  static const String beachWishListItemURI = "beachWishList/items";

  static String beachDetails(String slug) => "beach/slug/$slug";

  static String poiDetails(String id) => "poi/$id";

  static String establishmentTypeURI(int page) =>
      "establishment-type?page=$page&size=20";

  static const String realEstateMobileURI = "real-estate/mobile";
  static const String userNotificationURI = "user/change-notification";
  static const String userURI = "user/details";
  static const String statusSecurity = "user/2fa-status";
  static const String sendOtp = "user/2fa-active";
  static const String verifyWhatsapp = "user/2fa-active/verify";
  static const String clearDevicesPut = "user/2fa/clear-devices";
  static const String clearDevicesDelete = "user/2fa/clear-devices";

  static const String darkMode = "user/dark-mode?dark-mode=";
  static const String customerURI = "user/customer";
  static const String carURI = "car/mobile";
  static const String carPostURI = 'car';
  static const String carPostSlugURI = 'car/slug/';
  static const String categoryURI = "category";
  static const String unitsURI = "units";
  static const String currencyURI = "currency";
  static const String attributeURI = "attribute";
  static const String tagsURI = "tags";
  static const String tagsAssocited = "tags/associated/";
  static const String facilityURI = "facility";
  static const String featureURI = "feature/associated/";
  static const String makeURI = "make";
  static const String makeAssociatedURI = "make/associated";
  static const String carVariantsURI = "car-variant/carModelId/";

  static const String wbCategory = "wp-category";
  static const String wpCategoryAll = "wp-category/all";
  static var wbCategoryDetails = "posts/wp-category/";
  static var postSearch = "posts/search/";

  static const String carModelURI = "car-model";
  static const String carModelMakeId = "car-model/makeId/";
  static const String carVariantByCarModel = "car-variant/carModelId/";
  static const String carVariant = "car-variant/";

  static const String countriesURI = "countries";
  static const String citiesURI = "cities/country/";
  static const String photoUploadURI = 's3-storage/upload';
  static const String photoDelete = 's3-storage/delete/';
  static const String photoDeletePath = 's3-storage/deletePaths';
  static const String pdfUploadURI = 'user/CV';
  static const String realEstatePostURI = 'real-estate';
  static const String documentationTypeURI = 'documentation-type';
  static const String userLanguage = 'user/language?language=';
  static const String jobsMobileURI = 'jobs/mobile';
  static const String listingAllURI = 'listings/user?listingEnum=';
  static const String jobsURI = 'jobs';
  static const String jobsSlugURI = 'jobs/slug/';
  static const String applierURI = 'applier';
  static const String variousURI = 'various';
  static const String variousSlugURI = 'various/slug/';

  static const String publicationDetailsURI = 'publication';
  static const String publicationDetailsSlugURI = 'publication/slug/';

  static const String notesURI = 'notes';
  static const String wishListRealEstateURI = 'wishList/real-estate';
  static const String wishListType = 'wish-list?type=';
  static const String wishListClearByType = 'wish-list/clear/type/';
  static const String wishListByType = 'wish-list/by-type?type=';
  static const String wishListClearRealEstateURI =
      'wishList/clear/real-estate/itemIds?';
  static const String wishListJobURI = 'wishList/job';
  static const String wishListClearJobURI = 'wishList/clear/job/';
  static const String wishListCarURI = 'wishList/car';
  static const String wishListClearCarURI = 'wishList/clear/car/';
  static const String wishList = 'wishList/';
  static var addWish = Uri.parse("${baseUrl}wish-list?type=");

  static const String wishListClear = 'wishlist/delete/userItems?itemType=';
  static const String boatURI = 'boat';
  static const String companyMobileURI = 'company/mobile';
  static const String companyUser = 'company/user?';
  static const String companyDetail = 'company/';
  static const String homePageConfig =
      'homepage-config/default?ConfigType=HOME';

  // static var real_estate = Uri.parse(BaseUrl+"real-estate?");
  static var variousMobileURI = Uri.parse('${baseUrl}various/filter');
  static var publicationURI = Uri.parse('${baseUrl}publication/filter');

  static var listingDetails = Uri.parse("${baseUrl}listingsDetails/");
  static var realEstateFilter = Uri.parse("${baseUrl}real-estate/filter");
  static var realEstateFilter1 = "real-estate/filter";
  static var jobs = Uri.parse("${baseUrl}jobs?page=0&size=20");
  static var jobsApplier = Uri.parse("${baseUrl}applier");
  static var jobsFilter = Uri.parse("${baseUrl}jobs/filter");
  static var jobsFilterMap = Uri.parse("${baseUrl}jobs/filter/mobile-geo");

  static var getNotifications = Uri.parse("${baseUrl}fcmNotification/user");
  static var clearAllNotifications =
      Uri.parse("${baseUrl}fcmNotification/user/clear");
  static var deleteFcmNotification =
      Uri.parse("${baseUrl}fcmNotification/user?notificationIds=");

  static var car_listing = Uri.parse("${baseUrl}car?");
  static var car_listing_detail = Uri.parse("${baseUrl}car/");
  static var user_Home = Uri.parse("${baseUrl}user/home");
  static var user_Home_Selected = Uri.parse("${baseUrl}home/selected/filter");

  static var user_address_id = "user/address-id";
  static var user_nominatimSearch =
      Uri.parse("${baseUrl}userAddress/nominatimSearch");
  static var car_filter = Uri.parse("${baseUrl}car/filter");
  static var car_filterMobile = Uri.parse("${baseUrl}car/filter/mobile");

  static var hotels_filter = Uri.parse("${baseUrl}hotels/filter");
  static var hotel_details = Uri.parse("${baseUrl}hotels/");
  static var hotel_roomType = Uri.parse("${baseUrl}q-hotel/room-type/hotel/");
  static var hotels_amenities = Uri.parse("qhotels/amenities/associated");
  static var room_availability = Uri.parse(
      "https://www.digiweb-shpk.com:8443/qhotels/api/availability/hotel/");
  static var hotel_availability =
      Uri.parse("${baseUrl}q-hotel/availability/hotel/");

  static var boat_filter = Uri.parse("${baseUrl}boat/filter/");
  static var boat_map = Uri.parse("${baseUrl}boat/filter/mobile");
  static var boat = Uri.parse("${baseUrl}boat/");
  static var boatSlug = Uri.parse("${baseUrl}boat/slug/");

  static var wishListHideList = Uri.parse("${baseUrl}wish-list/hideList");
  static var postWishList = Uri.parse("${baseUrl}wishList/real-estate");
  static var real_est_polygon = Uri.parse("${baseUrl}real-estate/polygon");
  static var deleteWishList =
      Uri.parse("${baseUrl}wishList/clear/real-estate/");
  static var home = Uri.parse("${baseUrl}home/active");
  static var poiPlacesMobile = Uri.parse("${baseUrl}poi/places/mobile?");
  static var poiSearch = Uri.parse("${baseUrl}poi/search?search=");
  static var poiSlug = Uri.parse("${baseUrl}poi/slug/");
  static var poiSlugShort = Uri.parse("${baseUrl}poi/slug-short/");
  static var poiMenu = Uri.parse("${baseUrl}menu/");
  static var poiFoodMenu = Uri.parse("${baseUrl}food-category/poi/");
  static var foodProduct = Uri.parse("${baseUrl}food-products/");
  static var food = Uri.parse("${baseUrl}food-products/");
  static var toppingsCategory = Uri.parse("${baseUrl}toppings-category/poi/");
  static var toppingsCategoryAssociated =
      Uri.parse("${baseUrl}toppings-category/associated?ids=");

  //static var ordersUser = Uri.parse(baseUrl+"orders/user");
  static var poiFilter = Uri.parse("${baseUrl}poi/filter/");
  static var imagesUpload = Uri.parse("${baseUrl}s3-storage/upload");
  static var messages = Uri.parse("${baseUrl}message");
  static var getMessageUser = Uri.parse("${baseUrl}message/user");
  static var getMessagesFromId = Uri.parse("${baseUrl}message/");
  static var news = Uri.parse("${baseUrl}news");
  static var newsRelated = Uri.parse("${baseUrl}posts/tagIds");
  static var newsReport = Uri.parse("${baseUrl}news-report");
  static var reports = Uri.parse("${baseUrl}reports");

  static var poiTable = Uri.parse("${baseUrl}poi-tables/poi/");
  static var postById = Uri.parse("${baseUrl}posts/{id}?id=");
  static var orders = Uri.parse("${baseUrl}orders");
  static var ordersUser = Uri.parse("${baseUrl}orders/user");
  static var userAddress = Uri.parse("${baseUrl}user/address");
  static var userAddressList = Uri.parse("${baseUrl}user/address-list");

  // static var addAddressList = Uri.parse(baseUrl+"user/address");
  static var foodOrders = Uri.parse("${baseUrl}foodOrders");

  static var logout = Uri.parse("${baseUrl}auth/logout");

  // Shared Key
  static const String theme = 'theme';
  static const String light = 'light';
  static const String dark = 'dark';
  static const String token = 'token';
  static const String userInfo = 'userInfo';
  static const String refreshToken = 'refreshToken';
  static const String countryCode = 'country_code';
  static const String languageCode = 'language_code';
  static const String user = 'user';
  static const String userEmail = 'user_email';
  static const String userEmail2 = 'user_email2';
  static const String userPassword = 'user_password';
  static const String userID = 'userID';
  static const String phoneNumber = 'phoneNumber';
  static const String cartList = 'cart_list';
  static const String beachIDList = 'beachIDList';
  static const String getCart = 'cart/user/';
  static const String tablePoi = 'poi-tables/poi/';
  static const String tableBarcode = 'poi-tables/table-poi-details';

  static const String SEARCH_ADDRESS = 'search_address';
  static const String currencyName = 'currencyName';
  static const String currencySymbol = 'currencySymbol';
  static const String muteStatus = 'muteStatus';
  static const String variant = 'variant';
  static const String onBoardingStatus = 'onBoardingStatus';

  // order status
  static const String created = 'CREATED';
  static const String pickedUP = 'PICKED_UP';
  static const String forDelivery = 'FOR_DELIVERY';
  static const String waiting = 'WAITING';
  static const String confirmed = 'CONFIRMED';
  static const String packed = 'PACKED';
  static const String completed = 'COMPLETED';
  static const String RETURNED = 'RETURN';
  static const String canceled = 'CANCELED';
  static const String problematic = 'PROBLEMATIC';
  static const String rejected = 'REJECTED';
  static const String onHold = 'ON_HOLD';
  static const String deviceId = 'deviceId';

  static const String approved = 'APPROVED';
  static const String refused = 'REFUSED';

  // static List<LanguageModel> languages = [
  //   LanguageModel(imageUrl: 'assets/flags/al.svg', languageName: 'Albanian', countryCode: 'AL', languageCode: 'sq'),
  //   LanguageModel(imageUrl: 'assets/flags/gr.svg', languageName: 'Greece', countryCode: 'GR', languageCode: 'el'),
  //   LanguageModel(imageUrl: 'assets/flags/it.svg', languageName: 'Italy', countryCode: 'IT', languageCode: 'it'),
  //   LanguageModel(imageUrl: 'assets/flags/us.svg', languageName: 'English', countryCode: 'US', languageCode: 'en'),
  // ];
// LanguageModel(imageUrl: 'assets/flags/gr.png', languageName: 'Greece', countryCode: 'GR', languageCode: 'el'),

  static List<LanguageModel> languages = [
    LanguageModel(
        imageUrl: 'assets/flags/al.png',
        languageName: 'Albanian',
        countryCode: 'AL',
        languageCode: 'sq'),
    // LanguageModel(imageUrl: 'assets/flags/gr.png', languageName: 'Greece', countryCode: 'GR', languageCode: 'el'),
    LanguageModel(
        imageUrl: 'assets/flags/it.png',
        languageName: 'Italy',
        countryCode: 'IT',
        languageCode: 'it'),
    LanguageModel(
        imageUrl: 'assets/flags/us.png',
        languageName: 'English',
        countryCode: 'US',
        languageCode: 'en'),
  ];
}
