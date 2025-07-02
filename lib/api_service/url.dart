import 'app_config.dart';

final String baseUrl = AppConfigs.baseUrl;
final String apiBaseUrl = AppConfigs.apiBaseUrl;
final String mediaUrl = AppConfigs.mediaUrl;

///////////         Post Request    /////////////////////
String initialCheckUrl = '${apiBaseUrl}check-user-token';
String signUpUrl = '${apiBaseUrl}register';
String loginUrl = '${apiBaseUrl}login';
String logoutUrl = '${apiBaseUrl}logout';
String forgotPasswordUrl = '${apiBaseUrl}forgot-password';
String contactUsUrl = '${apiBaseUrl}contact-us';
String contactOwnerLeadGenerateUrl = '${apiBaseUrl}leadgenerate';
String contactDeveloperLeadGenerateUrl = '${apiBaseUrl}project-leadgenerate';
String wishlistUrl = '${apiBaseUrl}wishlist';
String projectWishlistUrl = '${apiBaseUrl}project-wishlist';
String propertyMapDataUrl = '${apiBaseUrl}property-map-data';
String projectMapDataUrl = '${apiBaseUrl}project-map-data';

String propertyUploadImageUrl = '${apiBaseUrl}uploadimage-cloud';
String propertyDeleteImageUrl = '${apiBaseUrl}remove-multiple-property-image';
String projectUploadImageUrl = '${apiBaseUrl}projectimage-cloud';
String projectDeleteImageUrl = '${apiBaseUrl}remove-multiple-project-image';

String updateProfileUrl = '${apiBaseUrl}update-profile';
String updateCredentialsUrl = '${apiBaseUrl}update-profile-credential';

String similarPropertiesUrl = '${apiBaseUrl}similar-property';
String similarProjectsUrl = '${apiBaseUrl}project-similar';

String getPostPropertyListUrl = '${apiBaseUrl}property-list';
String getPostProjectListUrl = '${apiBaseUrl}project-list';

//Residential Section
String residentialAddStep1Url = '${apiBaseUrl}residential-post/step1';
String residentialAddStep2Url = '${apiBaseUrl}residential-post/step2';
String residentialAddStep3Url = '${apiBaseUrl}residential-post/step3';
String residentialEditAddStep1Url = '${apiBaseUrl}residential-update/step1';
String residentialEditAddStep2Url = '${apiBaseUrl}residential-update/step2';
String residentialEditAddStep3Url = '${apiBaseUrl}residential-update/step3';

//Commercial Section
String commercialAddStep1Url = '${apiBaseUrl}commercial-post/step1';
String commercialAddStep2Url = '${apiBaseUrl}commercial-post/step2';
String commercialAddStep3Url = '${apiBaseUrl}commercial-post/step3';
String commercialEditAddStep1Url = '${apiBaseUrl}commercial-update/step1';
String commercialEditAddStep2Url = '${apiBaseUrl}commercial-update/step2';
String commercialEditAddStep3Url = '${apiBaseUrl}commercial-update/step3';

//pg section
String pgAddStep1Url = '${apiBaseUrl}pgadd/step1';
String pgAddStep2Url = '${apiBaseUrl}pgadd/step2';
String pgAddStep3Url = '${apiBaseUrl}pgadd/step3';
String pgEditAddStep1Url = '${apiBaseUrl}updatepg/step1';
String pgEditAddStep2Url = '${apiBaseUrl}updatepg/step2';
String pgEditAddStep3Url = '${apiBaseUrl}updatepg/step3';

//project section

String projectAddStep1Url = '${apiBaseUrl}add-project/step1';
String projectAddStep2Url = '${apiBaseUrl}add-project/step2';
String projectAddStep3Url = '${apiBaseUrl}add-project/step3';
String projectEditAddStep1Url = '${apiBaseUrl}update-project/step1';
String projectEditAddStep2Url = '${apiBaseUrl}update-project/step2';
String projectEditAddStep3Url = '${apiBaseUrl}update-project/step3';



//-------------------------------------       Get Request   -------------------------------------------//

String getCityListUrl = '${apiBaseUrl}state-city';
String getStateCityListUrl = '${apiBaseUrl}get-state-city';

String getStateListUrl = '${apiBaseUrl}get-state';
String getAreaListUrl = '${apiBaseUrl}getarea';
String getWishlistStatusUrl = '${apiBaseUrl}wishlist-status';
String getProjectWishlistStatusUrl = '${apiBaseUrl}project-wishlist-status';
String getWishlistPropertyDataUrl = '${apiBaseUrl}get-wishlist';
String getProjectWishlistPropertyDataUrl = '${apiBaseUrl}project-get-wishlist';

String getUserProfileUrl = '${apiBaseUrl}get-user-profile';
String getTermConditionUrl = '${apiBaseUrl}page/terms-and-conditions';
String getPrivacyPolicyUrl = '${apiBaseUrl}page/privacy-policy';
String getSearchResultUrl = '${apiBaseUrl}home-search';
String getProjectSearchResultUrl = '${apiBaseUrl}project-search';
String getProjectDropDownUrl = '${apiBaseUrl}project-fields';
String getDetailSectionProjectDropDownUrl = '${apiBaseUrl}project-fields-type';
String getDetailSectionProjectAmenitiesUrl = '${apiBaseUrl}get-animinites';
String getWalletDetailsUrl = '${apiBaseUrl}get-wallet-balance';

//buy section
String getBuyPropertyFeatureUrl = '${apiBaseUrl}buy-property-list/feature';
String getBuyPropertyOwnerUrl = '${apiBaseUrl}buy-property-list/owner';
String getBuyPropertyPremiumUrl = '${apiBaseUrl}buy-property-list/premium';
String getBuyPropertyDelhiUrl = '${apiBaseUrl}buy-property-list/delhi';

//rent section
String getRentPropertyTopUrl = '${apiBaseUrl}rent-property-list/topproperty';
String getRentPropertyOwnerUrl = '${apiBaseUrl}rent-property-list/owner';

//pg section

String getPGPropertyCountUrl = '${apiBaseUrl}pg-property-list/pgcount';
String getPGPropertyFeatureUrl = '${apiBaseUrl}pg-property-list/featurepg';
String getPGPropertyTopRatedUrl = '${apiBaseUrl}pg-property-list/topratedpg';

//plot section
String getPlotPropertyInvestmentUrl = '${apiBaseUrl}plot-land/plotinvestment';
String getPlotPropertyFeatureUrl = '${apiBaseUrl}plot-land/plotfeature';
String getPlotPropertyOwnerUrl = '${apiBaseUrl}plot-land/plotowner';

//commercial section

String getCommercialPropertyOneStopCountUrl =
    '${apiBaseUrl}commercial-property-list/onestopcount';
String getCommercialPropertyShopShowRoomUrl =
    '${apiBaseUrl}commercial-property-list/shopnshroom';
String getCommercialPropertyOwnerUrl =
    '${apiBaseUrl}commercial-property-list/postedbyowner';
String getCommercialPropertyOfficeSpaceUrl =
    '${apiBaseUrl}commercial-property-list/officespace';

//residential section

String getResidentialPropertyOneStopDestinationUrl =
    '${apiBaseUrl}residential-property-list/onestopdestination';
String getResidentialPropertyTopPremiumUrl =
    '${apiBaseUrl}residential-property-list/toppremium';
String getResidentialPropertyOwnerUrl =
    '${apiBaseUrl}residential-property-list/postedbyowner';

//Project section
String getProjectPropertyFeatureUrl = '${apiBaseUrl}get-project-list/featured';
String getProjectPropertyDreamUrl =
    '${apiBaseUrl}get-project-list/dreamproperty';
