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

/**                  BoostedSlideShow                     */
final String GetBostedSlideSHowUrl ="$baseUrl/api/BoostSlideShow";

/**                   Boost              */
final String GetBoostUrl ="$baseUrl/api/Boost";

/**                   Brands            */
final String GetAllBrands="$baseUrl/api/Brands";
final String GetBrandsUrl = "$baseUrl/api/Brands/";

/**                   Categories          */
final String GetAllCategoriesUrl ="$baseUrl/api/CategoriesControler/GetAllCategories";
final String GetCategoryByIdUrl ="$baseUrl/api/CategoriesControler/";

/**             City                    */
final String GetCityByIdUrl ="$baseUrl/api/CitiesControler/";

/**              Country                 */
final String GetAllCountriesUrl ="$baseUrl/api/CountryControler/Countrys";

/**              Deals                   */
final String CreateDealsUrl ="$baseUrl/api/Deals";
final String UpdateDealsUrl ="$baseUrl/api/Deals/";
final String GetFiltredDealUrl ="$baseUrl/api/Test/Dealsfilter";
final String DeleteDealUrl ="$baseUrl/api/Deals/";
final String GetDealByIdUrl ="$baseUrl/api/Deals/";
final String GetFiltredDealsUrl ="$baseUrl/api/Test/DealsWithLikeAndWishList?iduser=";
final String GetDealsByUserIdUrl ="$baseUrl/api/Deals/showmore/";

/**                Features                 */
final String GetFeaturesByCategoryIdUrl ="$baseUrl/api/FeaturesCategory/category/";

/**               FeaturesValues                  */
final String GetFeaturesValuesByfeatureIdUrl ="$baseUrl/api/FeatureValuesControler/GetFeatureValuesByFeature?idf=";

/**                 Like                        */
final String AddLikeUrl ="$baseUrl/api/Like";
final String DeleteLikeUrl ="$baseUrl/api/Like/";


/**             PRize                     */
final String GetPrizeByIdUrl ="$baseUrl/api/Prize/";
final String AddPrizeUrl ="$baseUrl/api/Prize";
final String DeletePrizeUrl ="$baseUrl/api/Prize/";
final String UpdatePrizeUrl ="$baseUrl/api/Prize?idprize=";

/**             wishlist                 */
final String AddToWishlistUrl ="$baseUrl/api/WishList/add";
final String  DeleteFromWishListUrl ="$baseUrl/api/WishList/";
final String GetWishListByUserIdUrl ="$baseUrl/api/WishList/GEtWishListByUser/";


}