public class ProductItemDAO {
    public static List<ProductItem> getProductItemsByLocationIds(Set<Id> locationIds){
        return [SELECT  Id,
                        LocationId
                FROM ProductItem 
                WHERE LocationId IN :locationIds];
    }
}