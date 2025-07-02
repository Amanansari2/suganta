import 'package:get/get.dart';
import 'package:tytil_realty/views/wallet/wallet.dart';

import '../bindings/bottombar_bindings.dart';
import '../bindings/contact_developer_bindings.dart';
import '../bindings/contact_owner_binding.dart';
import '../bindings/contact_us_bindings.dart';
import '../bindings/editProfile_binding.dart';
import '../bindings/home_binding.dart';
import '../bindings/login_binding.dart';
import '../bindings/logout_binding.dart';
import '../bindings/post_commercial_edit_property_binding.dart';
import '../bindings/post_pg_edit_propert_binding.dart';
import '../bindings/post_project_edit_project_binding.dart';
import '../bindings/post_property_bindings.dart';
import '../bindings/post_residential_edit_property_binding.dart';
import '../bindings/privacy_policy_binding.dart';
import '../bindings/project_details_bindings.dart';
import '../bindings/property_details_binding.dart';
import '../bindings/register_binding.dart';
import '../bindings/search_bindings.dart';
import '../bindings/term_condition_binding.dart';
import '../bindings/update_credentials_binding.dart';
import '../views/activity/activity_view.dart';
import '../views/bottom_bar/bottom_bar_view.dart';
import '../views/drawer/agents_list/agents_details_view.dart';
import '../views/drawer/agents_list/agents_list_view.dart';
import '../views/drawer/contact_property/contact_property_view.dart';
import '../views/drawer/intresting_reads/interesting_reads_details_view.dart';
import '../views/drawer/intresting_reads/interesting_reads_view.dart';
import '../views/drawer/recent_activity/recent_activity_view.dart';
import '../views/drawer/responses/lead_details_view.dart';
import '../views/drawer/responses/responses_view.dart';
import '../views/drawer/terms_of_use/about_us_view.dart';
import '../views/drawer/terms_of_use/privacy_policy_view.dart';
import '../views/drawer/terms_of_use/terms_of_use_view.dart';
import '../views/drawer/viewed_property/viewed_property_view.dart';
import '../views/home/delete_listing_view.dart';
import '../views/home/home_view.dart';
import '../views/home/widget/commercial_post_property_edit_details.dart';
import '../views/home/widget/pg_post_property_edit_details.dart';
import '../views/home/widget/post_project_edit_image.dart';
import '../views/home/widget/project_post_project_edit_details.dart';
import '../views/home/widget/residential_post_property_edit_details.dart';
import '../views/home/widget/upload_update_pg_image.dart';
import '../views/login/forget_password_view.dart';
import '../views/login/login_view.dart';
import '../views/notification/notification_view.dart';
import '../views/onboard/onboard_view.dart';
import '../views/otp/otp_view.dart';
import '../views/popular_builders/popular_builders_view.dart';
import '../views/post_property/add_amenities_view.dart';
import '../views/post_property/add_photo_and_pricing_view.dart';
import '../views/post_property/add_property_details_view.dart';
import '../views/post_property/edit_property_details_view.dart';
import '../views/post_property/edit_property_view.dart';
import '../views/post_property/post_property_view.dart';
import '../views/post_property/show_property_details_view.dart';
import '../views/profile/Update_Credentials/update_credentials.dart';
import '../views/profile/community_settings/community_settings_view.dart';
import '../views/profile/contactUs/contactUs_view.dart';
import '../views/profile/edit_profile_view.dart';
import '../views/profile/languages/languages_view.dart';
import '../views/property_list/contact_developer_view.dart';
import '../views/property_list/contact_owner_view.dart';
import '../views/property_list/furnishing_details_view.dart';
import '../views/property_list/gallery_view.dart';
import '../views/property_list/project_details_view.dart';
import '../views/property_list/property_details_view.dart';
import '../views/property_list/property_list_view.dart';
import '../views/register/register_view.dart';
import '../views/reviews/add_reviews_for_broker_view.dart';
import '../views/reviews/add_reviews_for_property_view.dart';
import '../views/saved/saved_properties_view.dart';
import '../views/search/search_view.dart';
import '../views/splash/splash_view.dart';

class AppRoutes {
  static const String splashView = "/splash_view";
  static const String onboardView = "/onboard_view";
  static const String loginView = "/login_view";
  static const String forgotPasswordView = "/forgot_password_view";
  static const String otpView = "/otp_view";
  static const String registerView = "/register_view";
  static const String homeView = "/home_view";
  static const String bottomBarView = "/bottom_bar_view";
  static const String notificationView = "/notification_view";
  static const String searchView = "/search_view";
  static const String propertyListView = "/property_list_view";
  static const String propertyDetailsView = "/property_details_view";
  static const String projectDetailsView = "/project_details_view";
  static const String galleryView = "/gallery_view";
  static const String furnishingDetailsView = "/furnishing_details_view";
  static const String contactOwnerView = "/contact_owner_view";
  static const String contactDeveloperView = "/contact_developer_view";
  static const String postPropertyView = "/post_property_view";
  static const String addPropertyDetailsView = "/add_property_details_view";
  static const String addPhotosAndPricingView = "/add_photos_and_pricing_view";
  static const String addAmenitiesView = "/add_amenities_view";
  static const String showPropertyDetailsView = "/show_property_details_view";
  static const String editPropertyView = "/edit_property_view";
  static const String editPropertyDetailsView = "/edit_property_details_view";
  static const String popularBuildersView = "/popular_builders_view";
  static const String savedPropertiesView = "/saved_properties_view";
  static const String contactPropertyView = "/contact_property_view";
  static const String viewedPropertyView = "/viewed_property_view";
  static const String recentActivityView = "/recent_activity_view";
  static const String responsesView = "/responses_view";
  static const String leadDetailsView = "/lead_details_view";
  static const String editProfileView = "/edit_profile_view";
  static const String updateCredentialsView = "/update_credentials_view";
  static const String agentsListView = "/agents_list_view";
  static const String agentsDetailsView = "/agents_details_view";
  static const String addReviewsForBrokerView = "/add_reviews_for_broker_view";
  static const String addReviewsForPropertyView = "/add_reviews_for_property_view";
  static const String interestingReadsView = "/interesting_reads_view";
  static const String interestingReadsDetailsView = "/interesting_reads_details_view";
  static const String communitySettingsView = "/community_settings_view";
  static const String contactUsView = "/contactUS_view";
  static const String termsOfUseView = "/terms_of_use_view";
  static const String privacyPolicyView = "/privacy_policy_view";
  static const String aboutUsView = "/about_us_view";
  static const String languagesView = "/languages_view";
  static const String deleteListingView = "/delete_listing_view";
  static const String activityView = "/activity_view";
  static const String postPgPropertyEditDetails = "/post_pg_property_edit_details";
  static const String postResidentialPropertyEditDetails = "/post_residential_property_edit_details";
  static const String postCommercialPropertyEditDetails = "/post_commercial_property_edit_details";
  static const String postProjectEditDetails = "/post_project_edit_details";
  static const String postPgPropertyEditImage = "/post_pg_property_edit_image";
  static const String postProjectEditImage = "/post_project_edit_image";
  static const String wallet = "/walletView";


  static List<GetPage> pages = [
    GetPage(name: splashView, page: () => SplashView()),
    GetPage(name: onboardView, page: () => OnboardView()),
    GetPage(name: loginView, page: () => LoginView(),binding: LoginBinding()),
    GetPage(name: forgotPasswordView, page: () => ForgetPasswordView(),binding: LoginBinding()),
    GetPage(name: otpView, page: () => OtpView()),
    GetPage(name: registerView, page: () => RegisterView(), binding: RegisterBinding()),
    GetPage(name: homeView, page: () => HomeView(),binding: HomeBinding()
    ),
    GetPage(name: bottomBarView, page: () => BottomBarView(),
    bindings:[
      LogoutBinding(),
      BottomBarBindings(),
      HomeBinding()
    ]
    ),
    GetPage(name: notificationView, page: () => NotificationView()),
    GetPage(name: searchView, page: () => SearchView(), binding: SearchBindings()),
    GetPage(name: propertyListView, page: () => PropertyListView()),
    GetPage(name: propertyDetailsView, page: () => PropertyDetailsView(), binding: PropertyDetailsBinding()),
    GetPage(name: projectDetailsView, page: () => ProjectDetailsView(), binding: ProjectDetailsBinding()),
    GetPage(name: galleryView, page: () => GalleryView()),
    GetPage(name: furnishingDetailsView, page: () => FurnishingDetailsView()),
    GetPage(name: contactOwnerView, page: () => ContactOwnerView(), binding: ContactOwnerBindings()),
    GetPage(name: contactDeveloperView, page: () => ContactDeveloperView(), binding: ContactDeveloperBindings()),
    GetPage(name: postPropertyView, page: () => PostPropertyView(),binding: PostPropertyBindings()),
    GetPage(name: addPropertyDetailsView, page: () => AddPropertyDetailsView(), ),
    GetPage(name: addPhotosAndPricingView, page: () => AddPhotoAndPricingView()),
    GetPage(name: addAmenitiesView, page: () => AddAmenitiesView()),
    GetPage(name: showPropertyDetailsView, page: () => ShowPropertyDetailsView()),
    GetPage(name: editPropertyView, page: () => EditPropertyView()),
    GetPage(name: editPropertyDetailsView, page: () => EditPropertyDetailsView()),
    GetPage(name: popularBuildersView, page: () => PopularBuildersView()),
    GetPage(name: savedPropertiesView, page: () => SavedPropertiesView()),
    GetPage(name: contactPropertyView, page: () => ContactPropertyView(),),
    GetPage(name: viewedPropertyView, page: () => ViewedPropertyView()),
    GetPage(name: recentActivityView, page: () => RecentActivityView()),
    GetPage(name: responsesView, page: () => ResponsesView()),
    GetPage(name: leadDetailsView, page: () => const LeadDetailsView()),
    GetPage(name: editProfileView, page: () => EditProfileView(), binding:EditProfileBindings()),
    GetPage(name: updateCredentialsView, page: () => UpdateCredentials(), binding:UpdateCredentialsBindings()),
    GetPage(name: agentsListView, page: () => AgentsListView()),
    GetPage(name: agentsDetailsView, page: () => AgentsDetailsView()),
    GetPage(name: addReviewsForBrokerView, page: () => AddReviewsForBrokerView()),
    GetPage(name: addReviewsForPropertyView, page: () => AddReviewsForPropertyView()),
    GetPage(name: interestingReadsView, page: () => InterestingReadsView()),
    GetPage(name: interestingReadsDetailsView, page: () => InterestingReadsDetailsView()),
    GetPage(name: communitySettingsView, page: () => CommunitySettingsView()),
    GetPage(name: contactUsView, page: () => ContactUsView(), binding: ContactUsBindings()),
    GetPage(name: termsOfUseView, page: () =>  const TermsOfUseView(), binding: TermConditionBindings()),
    GetPage(name: privacyPolicyView, page: () =>  const PrivacyPolicyView(), binding: PrivacyPolicyBindings()),
    GetPage(name: aboutUsView, page: () => const AboutUsView()),
    GetPage(name: languagesView, page: () => LanguagesView()),
    GetPage(name: deleteListingView, page: () => DeleteListingView()),
    GetPage(name: activityView, page: () => ActivityView()),
    GetPage(name: postPgPropertyEditDetails, page: ()=> PostPGPropertyEditDetails(), binding:PostPgEditPropertyBinding() ),
    GetPage(name: postResidentialPropertyEditDetails, page: ()=>PostResidentialPropertyEditDetails() , binding: PostResidentialEditPropertyBinding()),
    GetPage(name: postCommercialPropertyEditDetails, page: ()=>PostCommercialPropertyEditDetails() , binding: PostCommercialEditPropertyBinding()),
    GetPage(name: postProjectEditDetails, page: ()=> ProjectPostProjectEditDetails(), binding: PostProjectEditProjectBinding() ),
    GetPage(name: postPgPropertyEditImage, page: ()=> PostPgPropertyEditImage(),binding: PostPgEditPropertyBinding()),
    GetPage(name: postProjectEditImage, page: ()=> PostProjectEditImage(),binding: PostProjectEditProjectBinding()),
    GetPage(name: wallet, page: ()=> WalletView(),),

  ];
}