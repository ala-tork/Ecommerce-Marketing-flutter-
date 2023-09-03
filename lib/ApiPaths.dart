class ApiPaths{

  static const String baseUrl = 'https://10.0.2.2:7058';


  /**         IMAGE Paths             */
  final String ImagePath="${baseUrl}/Assets/images/";
  final String UserImagePath="${baseUrl}/Assets/images/users/";
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
  final String GetProductImageUrl ="$baseUrl/api/ImagesControler/getAllProductImages?idProduct=";
  final String UpdateProductImage ="$baseUrl/api/ImagesControler/updateProductImages?idImage=";
  final String DeleteProductImageUrl ="$baseUrl/api/ImagesControler/deleteProductImages?idProduct=";

/**         Ads Paths             */
  final String DeleteAdsUrl ="${baseUrl}/api/Ads?id=";
final String CreateAdsUrl ="${baseUrl}/api/Ads/CreateAds";
final String UpdateAdsUrl ="${baseUrl}/api/Ads/";
final String GetFiltredAdsUrl ="${baseUrl}/api/Test/filtered";
final String GetAdsByIdUrl ="${baseUrl}/Ad/";
final String GetAdsByUserUrl ="${baseUrl}/api/Ads/ShowMoreByUser?iduser=";
final String GetFiltredViewAdsUrl ="${baseUrl}/api/Test/AdsWithLikeAndWishList?iduser=";
final String GetAdsUsreUrl ="${baseUrl}/api/Test/AdsByUserId?iduser=";

/**             AdsFeatures                    */
final String CreateAdsFeatureUrl ="${baseUrl}/api/AdsFeatureControler";
final String GetAdsFeaturesByIdAdsUrl ="${baseUrl}/api/AdsFeatureControler?idAds=";
final String DeleteAdsFeatureUrl ="$baseUrl/api/AdsFeatureControler?idAds=";
final String GetDealsFeaturesUrl ="$baseUrl/api/AdsFeatureControler/GetDealsFeatures?idDeals=";
final String DeleteDealsFeaturesUrl ="$baseUrl/api/AdsFeatureControler/DeleteDealstFeatures?idDeals=";
final String getProductFeaturesUrl ="$baseUrl/api/AdsFeatureControler/GetAllProductFeatures?idProduct=";
final String DeleteProductAdsFeatureUrl ="$baseUrl/api/AdsFeatureControler/DeleteProductFeatures?idProduct=";

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
final String GetUserDealsUrl ="$baseUrl/api/Test/DealsByUser?iduser=";

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

/**            Winner                  */
final String GetRandomWinnerUrl ="$baseUrl/api/Winners/RandomWinners";

/**           User                        */
final String GetUserByIdUrl = "$baseUrl/User/GetUserById?id=";
final String AddUserImage ="$baseUrl/User/AddImageUser?idUser=";
final String UpdateUserUrl ="$baseUrl/User/UpdateUser?id=";
final String UpdatePasswordUrl ="$baseUrl/User/update-password?currentPassword=";
/**             Setting              */
final String GetNbDiamondAds = "$baseUrl/api/Setting/nbDiamondAds";
  final String GetNbDiamondDeals = "$baseUrl/api/setting/nbDiamondDeals";
  final String GetNbDiamondProduct = "$baseUrl/api/setting/nbDiamondProduct";


  /**           Product                */
final String GetUserProductUrl ="$baseUrl/api/Test/ProdByUserId?iduser=";
  final String CreateProductUrl="$baseUrl/api/Product/CreateProduct";
  final String UpdateProductUrl ="$baseUrl/api/Product/product/";
  final String DeleteProductUrl ="$baseUrl/api/Product/product/";
  final String GetProductByIdUrl="$baseUrl/api/Product/product/";
  final String GetProductWithFilterUrl ="$baseUrl/api/Test/ProdWithLikeAndWishList?iduser=";


}