public class Lightning_RunPricingImportJob {
	@AuraEnabled
    public static string runJob(){
        Database.executeBatch(new PricingImportJob(), 1);
        return 'success';
    }
}