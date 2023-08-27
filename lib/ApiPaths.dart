class ApiPaths{

  static const String baseUrl = 'https://10.0.2.2:7058';


  /**         IMAGE Paths             */
  final String ImagePath="${baseUrl}/Assets/images/";
  final String AddImageUrl ="${baseUrl}/api/ImagesControler";
  final String UpdateImagePath  = "${baseUrl}/api/ImagesControler?";
  final String DeleteImagePath = "${baseUrl}/api/ImagesControler?idAds=";
  final String GetAdsImageUrl = "${baseUrl}/api/ImagesControler?idAds=";
  final String GetDealsImageUrl ="${baseUrl}/api/ImagesControler/getAllDealsImages?idDeals=";
  final String UpdateDealsImages = "${baseUrl}/api/ImagesControler/updateDealsImages?idImage=";
  final String DeleteDealsImages = "${baseUrl}/api/ImagesControler/deleteDealsImages?idDeals=";
  final String DeleteImgeByIdUrl = "${baseUrl}/api/ImagesControler/IdImage?idImage=";
  final String GetPrizeImages  = "${baseUrl}/api/ImagesControler/getPrizeImage?idPrize=";
  final String UpdatePrizeImageUrl ="${baseUrl}/api/ImagesControler/updateTaskImage?idPrize=";
  final String DeletePrizeImageUrl = "${baseUrl}/api/ImagesControler/deletePrizeImages?idPrize=";

/**         Ads Paths             */
  final String DeleteAdsUrl ="${baseUrl}/api/Ads?id=";
final String CreateAdsUrl ="${baseUrl}/api/Ads/CreateAds";
final String UpdateAdsUrl ="${baseUrl}/api/Ads/";
final String GetFiltredAdsUrl ="${baseUrl}/api/Test/filtered";
final String GetAdsByIdUrl ="${baseUrl}/Ad/";
final String GetAdsByUserUrl ="${baseUrl}/api/Ads/ShowMoreByUser?iduser=";

/**             AdsFeatures                    */
final String CreateAdsFeatureUrl ="${baseUrl}/api/AdsFeatureControler";
final String GetAdsFeaturesByIdAdsUrl ="${baseUrl}/api/AdsFeatureControler?idAds=";
}