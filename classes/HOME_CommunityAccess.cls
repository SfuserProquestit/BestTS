/**
 * This class is responsible for generating the fastpass url. Acts as the controller
 * for the HOME_CommunityAccess VF page  
 *
 */
public with sharing class HOME_CommunityAccess {
    
    /*!!!!! DO NOT MODIFY THIS !!!! */
    private static String consumerKey = 'gd9yksgb9jmo';
    private static String consumerSecret = '1ycuarb1e6jen11zi2dl8nyub586bjbv';
    /* !!!! END !!!! */
    
    // oauth related constants
    private static String ENCODING_SCHEME = 'UTF-8'; 
    private static String OAUTH_CONSUMER_KEY = 'oauth_consumer_key';
    private static String OAUTH_VERSION_PARAM = 'oauth_version';
    private static String OAUTH_SIGNATURE_METHOD = 'oauth_signature_method';
    private static String OAUTH_TIMESTAMP = 'oauth_timestamp';
    private static String OAUTH_NONCE = 'oauth_nonce';
    private static String USER_EMAIL = 'email';
    private static String USER_ID = 'uid';
    private static String USER_NAME = 'name';
    private static String IS_SECURE = 'is_secure';
    // end of constants
    
   
    /**
     * Called by the VF page to generate the fastpass authentication URL
     */
    public String getUrl() { 
        String uid = UserInfo.getUserId();
        User usr = [select name, firstname, lastname, email from user where id=:uid];
        String uname = usr.name;
        String uemail = usr.email;   
        String fpUrl = getUrl(consumerKey, consumerSecret, uemail, uid,uname); 
        return fpUrl; 
    }
    
    public String getLinkUrl() {
        return 'https://www.' + 'servicemax.com/community.html'; 
    }
    
    public String getLinkLabel() {
        return System.label.HOME_TAG001;
    }
    
    public String getCommunityLoadMessage() {
        return System.label.HOME_TAG002;
    }
        
    private String getBaseUrl() {
        return  'https://community.servicemax.com' + '/fastpass';     
    }
    
    private String getUrl(String pConsumerKey, String pConsumerSecret, String pEmail, String pUserId, String pUserName) {
        
        String baseUrl = getBaseUrl(); 
        String nonce = generateNonce();
        String timeStamp = generateTimeStamp();      
        Map<String, String> params = getRequestParams(nonce, timeStamp, pEmail, pUserId, pUserName, '1.0','TRUE');
        
        String baseString = getBaseString(params);
        String signnature = buildSignature(baseString);
        System.debug('base string :' +baseString);    
        
        String url = baseUrl + '?' + getQueryParams(params) + '&oauth_signature=' + signnature;
        return url; 
    }
    
    private Map<String, String> getRequestParams(String pNonce, String timeStamp, String pEmail, String pUserId, String pUserName, String pOAuthVersion,String pSecure) {
        Map<String, String> parameters = new Map<String, String>();
        parameters.clear();
        parameters.put(OAUTH_CONSUMER_KEY,EncodingUtil.urlEncode(consumerKey, ENCODING_SCHEME));        
        parameters.put(OAUTH_VERSION_PARAM,EncodingUtil.urlEncode(pOAuthVersion, ENCODING_SCHEME));        
        parameters.put(OAUTH_SIGNATURE_METHOD,'HMAC-SHA1');
        parameters.put(OAUTH_TIMESTAMP,EncodingUtil.urlEncode(timestamp, ENCODING_SCHEME));
        parameters.put(OAUTH_NONCE,EncodingUtil.urlEncode(pNonce, ENCODING_SCHEME));
        parameters.put(USER_EMAIL,EncodingUtil.urlEncode(pEmail, ENCODING_SCHEME));
        parameters.put(USER_ID,EncodingUtil.urlEncode(pUserId, ENCODING_SCHEME));
        
        pUserName = EncodingUtil.urlEncode(pUserName, ENCODING_SCHEME);
        pUserName = pUserName.replace('+', '%20');
        parameters.put(USER_NAME,pUserName);
        
        parameters.put(IS_SECURE,EncodingUtil.urlEncode(pSecure, ENCODING_SCHEME));
        return parameters;
    }
    
    ////////////////////////////// UTILITIES ////////////////////////////////////////////////
    private String generateNonce() {
         return String.valueOf(Crypto.getRandomLong());
    }
    
    private String generateTimeStamp() {
        return String.valueOf(DateTime.now().getTime()/1000);
    }  
    ////////////////////////////// END - UTILITIES //////////////////////////////////////////
    
    
    ////////////////////////////// BASE STRING GENERATION //////////////////////////////////////////
    private String getBaseString(Map<String, String> parameters) {
    
        Map<String,String> p = parameters.clone();
     
        List<String> keys = new List<String>();
        keys.addAll(p.keySet());
        keys.sort();
        String s = keys.get(0)+'='+p.get(keys.get(0));
        for(Integer i=1;i<keys.size();i++) {
            s = s + '&' + keys.get(i)+'='+p.get(keys.get(i));
        }

        // According to OAuth spec, host string should be lowercased, but Google and LinkedIn
        // both expect that case is preserved.
        //return 'GET' + '&' + EncodingUtil.urlEncode(getBaseUrl(), ENCODING_SCHEME) + '&' + s;   
        return 'GET' + '&' + EncodingUtil.urlEncode(getBaseUrl(), ENCODING_SCHEME) + '&' + EncodingUtil.urlEncode(s, ENCODING_SCHEME); 
            
    }
    
    private String getQueryParams(Map<String, String> parameters) {
        List<String> keys = new List<String>();
        keys.addAll(parameters.keySet());
        keys.sort();
        String s = keys.get(0) + '=' + parameters.get(keys.get(0));
        for(Integer i=1;i<keys.size();i++) {
            s = s + '&' + keys.get(i) + '=' + parameters.get(keys.get(i));
        }
        return s;
    }   
    ////////////////////////////// END - BASE STRING GENERATION ////////////////////////////////////
    
    ////////////////////////////// SIGNATURE GENERATION /////////////////////////////////////////
    private String buildSignature(String baseString) {
    
        Blob sig = Crypto.generateMac('hmacSHA1', Blob.valueOf(baseString), 
                           Blob.valueOf(consumerSecret + '&' + ''));
            String signature = EncodingUtil.urlEncode(EncodingUtil.base64encode(sig), ENCODING_SCHEME);
            System.debug('signature = ' + signature);
        return signature;
    }
    ////////////////////////////// END - SIGNATURE GENERATION ///////////////////////////////////
    
    private String encodeString(String s) {
        String retStr = s.replace(' ', '__SVMX_TEMP_STRING_FOR_SPACE__');
        retStr = retStr.replace('+', '__SVMX_TEMP_STRING_FOR_SPACE__');
        retStr = EncodingUtil.urlEncode(retStr, ENCODING_SCHEME);
        retStr = retStr.replace('__SVMX_TEMP_STRING_FOR_SPACE__', '%20');
        return retStr;
    }
}