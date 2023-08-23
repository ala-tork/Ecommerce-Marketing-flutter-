class ApiPaths{

  final String MainUrl ="https://10.0.2.2:7058";


  /**         IMAGE Paths             */
  final String ImagePath="https://10.0.2.2:7058/Assets/images/";
  final String AddImageUrl ="https://10.0.2.2:7058/api/ImagesControler";
  final String UpdateImagePath  = "https://10.0.2.2:7058/api/ImagesControler?";
  final String DeleteImagePath = "https://10.0.2.2:7058/api/ImagesControler?idAds=";
  final String GetAdsImageUrl = "https://10.0.2.2:7058/api/ImagesControler?idAds=";
  final String GetDealsImageUrl ="https://10.0.2.2:7058/api/ImagesControler/getAllDealsImages?idDeals=";
  final String UpdateDealsImages = "https://10.0.2.2:7058/api/ImagesControler/updateDealsImages?idImage=";
  final String DeleteDealsImages = "https://10.0.2.2:7058/api/ImagesControler/deleteDealsImages?idDeals=";
  final String DeleteImgeByIdUrl = "https://10.0.2.2:7058/api/ImagesControler/IdImage?idImage=";
  final String GetPrizeImages  = "https://10.0.2.2:7058/api/ImagesControler/getPrizeImage?idPrize=";
  final String UpdatePrizeImageUrl ="https://10.0.2.2:7058/api/ImagesControler/updateTaskImage?idPrize=";
  final String DeletePrizeImageUrl = "https://10.0.2.2:7058/api/ImagesControler/deletePrizeImages?idPrize=";

/**         Ads Paths             */
  final String DeleteAdsUrl ="https://10.0.2.2:7058/api/Ads?id=";
final String CreateAdsUrl ="https://10.0.2.2:7058/api/Ads/CreateAds";
final String UpdateAdsUrl ="https://10.0.2.2:7058/api/Ads/";
final String GetFiltredAdsUrl ="https://10.0.2.2:7058/api/Test/filtered";
final String GetAdsByIdUrl ="https://10.0.2.2:7058/Ad/";
final String GetAdsByUserUrl ="https://10.0.2.2:7058/api/Ads/ShowMoreByUser?iduser=";

/**             AdsFeatures                    */
final String CreateAdsFeatureUrl ="https://10.0.2.2:7058/api/AdsFeatureControler";
final String GetAdsFeaturesByIdAdsUrl ="https://10.0.2.2:7058/api/AdsFeatureControler?idAds=";
}